"""Sample KKBox data down to a fixed set of members, preserving joins.
Reads the big CSVs in chunks so it never blows up your RAM."""
import pandas as pd
import numpy as np
RAW = "data"
OUT = "data/sampled"
N_MEMBERS = 50_000
SEED = 42
CHUNK = 100000 # rows per chunk when streaming the big files

# 1) Pick the member sample from members_v3 (read only the id column first)
print("Reading member ids...")
member_ids = pd.read_csv(f"{RAW}/members_v3.csv", usecols=["msno"])["msno"]
rng = np.random.default_rng(SEED)
sample_ids = set(rng.choice(member_ids.unique(), 
                            size=min(N_MEMBERS, member_ids.nunique()), replace=False))
print(f"Sampled {len(sample_ids):,} members")

# 2) Write the sampled members table (full rows for the chosen ids)
print("Writing members...")
members = pd.read_csv(f"{RAW}/members_v3.csv")
members[members["msno"].isin(sample_ids)].to_csv(f"{OUT}/members.csv", index=False)

# 3) Stream-filter the big files chunk by chunk
def filter_big(infile, outfile):
    print(f"Filtering {infile} -> {outfile} ...")
    first = True
    kept = 0
    for chunk in pd.read_csv(f"{RAW}/{infile}", chunksize=CHUNK):
        keep = chunk[chunk["msno"].isin(sample_ids)]
        kept += len(keep)
        keep.to_csv(f"{OUT}/{outfile}", mode="w" if first else "a",
                    header=first, index=False)
        first = False
        print(f" ...{kept:,} rows kept so far")
    print(f" done: {kept:,} rows")
filter_big("transactions.csv", "transactions.csv")
filter_big("user_logs_v2.csv", "user_logs.csv")

# 4) train_v2 is small — load, filter, write
print("Writing labels...")
train = pd.read_csv(f"{RAW}/train_v2.csv")
train[train["msno"].isin(sample_ids)].to_csv(f"{OUT}/train.csv", index=False)

print("ALL DONE. Sampled files are in data/sampled/")