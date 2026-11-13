# How do I see the combined budget of a cost center in CodeMie?

Open **Settings → Administration → Cost centers management** and select the cost center. The **Budget rollup** card shows the combined **Total budget**, **Spend**, and **% used** across all linked projects, followed by one card each for **Platform**, **CLI**, and **Premium Models** with the per-category distribution.

The card is read-only and calculated from the linked projects each time the page loads — a cost center has no budget of its own. A project without a budget in a category contributes zero to it. A cost center with no linked projects shows `No projects linked`.

The card requires the Maintainer or Admin role and is shown only when the budget management UI is enabled (`viteEnableBudgetManagement`). Budgets are summed only when they share a reset period; if linked projects use different periods, **Total budget** shows `Not summed: different reset periods`.

## Sources

- [Chargeback and Cost Centers — Budget Rollup](https://docs.codemie.ai/user-guide/budget-management/chargeback-cost-centers#budget-rollup)
- [Project Budget Management](https://docs.codemie.ai/admin/configuration/codemie/project-budget-management)
