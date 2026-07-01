{% docs __overview__ %}
# KKBox Subscription Analytics
This dbt project transforms raw KKBox music-streaming data into a tested,
documented **star schema** answering three business questions:
1. **Revenue** — how is MRR moving (new / expansion / contraction / churn)?
2. **Retention** — how do churn and tenure vary by plan, channel, and payment method?
3. **Engagement & churn** — does listening activity fall before a member leaves?
**Layers:** `staging` (clean) → `intermediate` (MRR & engagement logic) → `marts` (dims + facts).
Click the green circle (bottom-right) to explore the lineage graph.
{% enddocs %}