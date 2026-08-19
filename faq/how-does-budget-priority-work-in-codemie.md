# How does budget priority work in CodeMie?

For each budget category (Platform, CLI, Premium Models), CodeMie applies the first matching
budget in the following priority order:

1. **Project budget** — if the user's project has a budget configured for that category
2. **Personal budget** — if a personal budget is explicitly assigned to the user for that category
3. **Default budget** — if neither project nor personal budget is assigned

**Project context** applies when the user belongs to a project that has at least one budget
configured. In that case, all requests are resolved within the project:

- If the project covers the resolved category → the project budget is used
- If the project does not cover the resolved category → falls back to the project's Platform budget
- If the project has no Platform budget either → personal or default Platform budget is used

If the project has no budgets configured at all, personal and default budgets apply normally.

**Key rules to remember:**

- The Platform budget is the universal fallback within a project. If a project has budgets for
  some categories but not others, uncovered categories fall back to the project's Platform budget
  — not to personal or default budgets.
- The only exception is a Premium-only project (no Platform budget): Platform and CLI requests
  fall back to personal/default Platform budget.
- If no budget exists for a category, requests for that category are blocked.
- When a project budget is active, the user's personal and default budgets are not charged.

## Sources

- [Budget Management — Budget Priority](https://codemie-ai.github.io/docs/user-guide/budget-management#budget-priority)
