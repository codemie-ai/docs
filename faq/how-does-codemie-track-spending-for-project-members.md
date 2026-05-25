# How does CodeMie track spending for project members?

CodeMie runs a background **spend collector** job that periodically polls LiteLLM for usage data and records spend deltas per project and per member. On each run, the job calculates how much was spent since the last snapshot and appends it to a cumulative total.

When a budget's reset period elapses, LiteLLM clears the current-period spend counter. CodeMie detects this reset automatically and continues accumulating the cumulative total without resetting the historical record.

Per-member spend attribution is controlled by the `project_member_budget_tracking_enabled` flag per project. When enabled, both the project-level cap and each member's individual allocation are enforced. When disabled, only the project-level cap applies.

The spend collector runs on a configurable schedule (nightly by default, controlled by `LITELLM_SPEND_COLLECTOR_SCHEDULE`). Spend data may lag by up to one collection cycle.

## Sources

- [Project Budget Management — Spend Tracking](https://docs.codemie.ai/admin/configuration/codemie/project-budget-management#spend-tracking)
