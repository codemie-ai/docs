# What are budget categories in CodeMie?

Budget categories control which type of usage a budget applies to. There are three independent
categories:

| Category         | When Applied                                                                                                                |
| ---------------- | --------------------------------------------------------------------------------------------------------------------------- |
| `platform`       | Non-premium requests from the browser UI, workflows, API, and similar sources                                               |
| `cli`            | Non-premium requests from CLI agents (codemie-code, codemie-claude, codemie-codex) and desktop applications in Gateway mode |
| `premium_models` | All premium-model requests, regardless of source (UI or CLI)                                                                |

Only one budget is charged per request. If no budget exists for a category, requests for that
category are blocked. Configuring a Platform budget does not automatically cover CLI or premium
model requests — each category must be configured separately.

For predefined (default) budgets, add entries with `budget_category: cli` and
`budget_category: premium_models` to `budgets-config.yaml` alongside the required `platform`
entry. Premium models are defined in the `LITELLM_PREMIUM_MODELS_ALIASES` environment variable.

## Sources

- [Budget Management](https://codemie-ai.github.io/docs/user-guide/budget-management)
- [Budget Configuration](https://codemie-ai.github.io/docs/admin/configuration/extensions/litellm-proxy/budget-configuration)
