# How do I track spending for premium models separately in CodeMie?

CodeMie supports optional separate budget tracking for costly models (such as Claude Opus or OpenAI o1). When enabled, requests to premium models are attributed to a dedicated LiteLLM customer identity derived from the user's email (e.g., `john@company.com_codemie_premium_models`), allowing independent spend limits and reporting.

To set it up:

1. Add a `premium_models` budget entry to your `budgets-config.yaml` via Helm and configure the desired spending limits.
2. Set the `LITELLM_PREMIUM_MODELS_ALIASES` environment variable to a JSON array of model name substrings that qualify as premium (e.g., `'["opus", "o1"]'`).

When the feature is active, the `/spending` endpoint returns a `premium_current_spending` field in addition to the standard spending data. If `LITELLM_PREMIUM_MODELS_ALIASES` is set to an empty array (`'[]'`), premium model tracking is disabled and all spending uses the default platform budget.

## Sources

- [LiteLLM Budget Configuration](https://codemie-ai.github.io/docs/admin/configuration/extensions/litellm-proxy/budget-configuration)
- [API Configuration Reference](https://codemie-ai.github.io/docs/admin/configuration/codemie/api-configuration)
