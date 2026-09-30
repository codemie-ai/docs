# How do I set a budget for a project in CodeMie?

Project budgets are managed by Maintainers through **Settings → Administration → Projects Management**.

1. Select the project to budget.
2. In the **Budgets** section, click **Create Budget**.
3. Enter a **Name**, a **Reset Period** (for example, `Monthly (30d)`), and a **Total Budget ($)**.
4. CodeMie splits the total across the three categories using a default 30% Platform / 60% CLI / 10% Premium Models weighting. Drag the **DISTRIBUTION** bar or edit the per-category **Hard Limit** fields to rebalance, and set a **Soft Limit** per category for a warning threshold.
5. Click **Create Budget**.

One dialog creates budgets for all three categories at once — there is no longer a separate form per category. Each project can have at most one budget per category. Once created, the **Create Budget** button becomes a **Manage Budget** dropdown for later edits and rebalancing.

CodeMie distributes the budget across active project members and syncs the allocation with LiteLLM for enforcement.

## Sources

- [Project Budgets](https://docs.codemie.ai/user-guide/budget-management/project-budgets)
