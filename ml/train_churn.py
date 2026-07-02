import matplotlib
matplotlib.use("Agg")

import pandas as pd
import numpy as np
import pandas_gbq
from google.cloud import bigquery
from sklearn.model_selection import train_test_split
from sklearn.calibration import CalibratedClassifierCV
from sklearn.frozen import FrozenEstimator
from sklearn.metrics import roc_auc_score, brier_score_loss
from xgboost import XGBClassifier
import shap
import matplotlib.pyplot as plt

PROJECT = "kkbox-analytics"   # <-- your real Project ID

# 1) Load the feature mart from BigQuery
client = bigquery.Client(project=PROJECT)
df = client.query(
    f"SELECT * FROM `{PROJECT}.dbt_dev_marts.fct_member_features`"
).to_dataframe()
print(f"Loaded {len(df):,} labeled members")

# 2) Prepare X and y
y = df["is_churn"].astype(int)
X = df.drop(columns=["is_churn", "member_id"])

# one-hot the one categorical; everything else is numeric
X = pd.get_dummies(X, columns=["registration_channel"], dummy_na=True)
X = X.fillna(0)

# XGBoost rejects feature names containing [, ], or < — sanitize defensively
X.columns = (
    X.columns.astype(str)
    .str.replace(r"[\[\]<]", "_", regex=True)
)

# 3) Three-way split: train the model / calibrate it / evaluate it, on
#    three DISJOINT slices so no step "peeks" at data used by an earlier step.
#    60% train, 20% calibration, 20% test.
X_train, X_temp, y_train, y_temp = train_test_split(
    X, y, test_size=0.4, random_state=42, stratify=y
)
X_calib, X_test, y_calib, y_test = train_test_split(
    X_temp, y_temp, test_size=0.5, random_state=42, stratify=y_temp
)
print(f"Train: {len(X_train):,}  Calibration: {len(X_calib):,}  Test: {len(X_test):,}")

# 4) Train XGBoost on the training slice only (handle class imbalance)
spw = (y_train == 0).sum() / max((y_train == 1).sum(), 1)
model = XGBClassifier(
    n_estimators=300, max_depth=4, learning_rate=0.05,
    subsample=0.8, colsample_bytree=0.8,
    scale_pos_weight=spw, eval_metric="logloss", random_state=42,
)
model.fit(X_train, y_train)

# 5) Evaluate BEFORE calibration, on the untouched test slice
proba_raw = model.predict_proba(X_test)[:, 1]
auc = roc_auc_score(y_test, proba_raw)
brier_raw = brier_score_loss(y_test, proba_raw)
print(f"ROC-AUC (test):              {auc:.3f}")
print(f"Brier (uncalibrated, test):  {brier_raw:.4f}")

# 6) Calibrate on the SEPARATE calibration slice (never seen by the model),
#    using FrozenEstimator so the already-fitted model is treated as fixed
#    and only the calibration map is learned. This replaces the deprecated
#    CalibratedClassifierCV(model, cv="prefit").
calibrated = CalibratedClassifierCV(FrozenEstimator(model), method="isotonic")
calibrated.fit(X_calib, y_calib)

# 7) Evaluate AFTER calibration, on the same untouched test slice
proba_cal = calibrated.predict_proba(X_test)[:, 1]
brier_cal = brier_score_loss(y_test, proba_cal)
print(f"Brier (calibrated, test):    {brier_cal:.4f}")
print(f"Brier improvement:           {(brier_raw - brier_cal) / brier_raw * 100:.1f}%")

# 8) Explain with SHAP (uses the raw tree model, trained on X_train)
explainer = shap.TreeExplainer(model)
shap_values = explainer.shap_values(X_test)
shap.summary_plot(shap_values, X_test, show=False, max_display=12)
plt.tight_layout()
plt.savefig("ml/shap_summary.png", dpi=150, bbox_inches="tight")
plt.close()
print("Saved ml/shap_summary.png")

# 9) Score ALL members and write back to BigQuery
all_scores = calibrated.predict_proba(X)[:, 1]
out = pd.DataFrame({"member_id": df["member_id"], "churn_risk": all_scores})
pandas_gbq.to_gbq(
    out,
    destination_table="dbt_dev_marts.member_churn_scores",
    project_id=PROJECT,
    if_exists="replace",
)
print("Wrote churn risk scores to dbt_dev_marts.member_churn_scores")