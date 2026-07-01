{% docs member_id %}
The unique identifier for a KKBox member (originally the hashed `msno`).
This is the join key shared across every table in the project.
{% enddocs %}
{% docs mrr %}
**Monthly Recurring Revenue** for one member in one month. Computed as the
monthly-equivalent price of the member's governing (latest covering) plan.
This is a documented approximation of true billing — see README for assumptions.
{% enddocs %}
{% docs movement_type %}
How a member's MRR changed versus the prior month:
**new**, **expansion**, **contraction**, **churn**, **reactivation**, or **retained**.
{% enddocs %}