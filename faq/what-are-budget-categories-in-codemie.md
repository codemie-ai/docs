# What are budget categories in CodeMie?

Budget categories control which type of usage a predefined budget applies to. Each entry in
`budgets-config.yaml` must specify a `budget_category` from the following values:

| Category         | Description                         |
| ---------------- | ----------------------------------- |
| `platform`       | Default web/API usage for end users |
| `cli`            | CodeMie CLI proxy spending          |
| `premium_models` | Costly model spending via CLI       |

For example, to set separate limits for CLI usage and premium models, add entries with
`budget_category: cli` and `budget_category: premium_models` to your `budgets-config.yaml`
alongside the required `platform` entry.

## Sources

- [Budget Configuration](https://codemie-ai.github.io/docs/admin/configuration/extensions/litellm-proxy/budget-configuration)
