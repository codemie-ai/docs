# How do I track spending for premium models separately in CodeMie?

CodeMie supports a dedicated budget category for costly models (such as Claude Opus).
When configured, **all** premium model requests are charged to this category — regardless of whether
the request originates from the browser UI, CLI agents, or desktop applications. This allows
independent spend limits and reporting for premium models across all access channels.

To set it up:

1. Add a `premium_models` budget entry to `budgets-config.yaml` via Helm and configure the desired spending limits.
2. Set the `LITELLM_PREMIUM_MODELS_ALIASES` environment variable to a JSON array of model name substrings that qualify as premium (e.g., `'["opus"]'`).

When the feature is active, premium model requests are attributed to a dedicated LiteLLM customer
identity derived from the user's email (e.g., `john@company.com_codemie_premium_models`).
If `LITELLM_PREMIUM_MODELS_ALIASES` is set to an empty array (`'[]'`), premium model tracking is
disabled and all spending uses the default platform budget.

## Sources

- [LiteLLM Budget Configuration](https://codemie-ai.github.io/docs/admin/configuration/extensions/litellm-proxy/budget-configuration)
- [API Configuration Reference](https://codemie-ai.github.io/docs/admin/configuration/codemie/api-configuration)
