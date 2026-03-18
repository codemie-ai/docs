# How do I track spending for premium models separately in CodeMie?

CodeMie supports optional separate budget tracking for costly models (such as Claude Opus or OpenAI o1). When enabled, requests to premium models are attributed to a dedicated LiteLLM customer identity derived from the user's email and a configurable budget name (e.g., `john@company.com_premium_models`), allowing independent spend limits and reporting.

To set it up:

1. Create a dedicated budget in the LiteLLM UI with a name such as `premium_models` and configure the desired spending limits.
2. Set the following environment variables in the CodeMie API:
   - `LITELLM_PREMIUM_MODELS_BUDGET_NAME` — the budget name created above (e.g., `premium_models`)
   - `LITELLM_PREMIUM_MODELS_ALIASES` — comma-separated model name substrings that qualify as premium (e.g., `opus,o1`)

When the feature is active, the `/spending` endpoint returns a `premium_current_spending` field in addition to the standard spending data. If `LITELLM_PREMIUM_MODELS_BUDGET_NAME` is empty or not set, all budget logic uses the standard behavior without any changes.

## Sources

- [LiteLLM Budget Configuration](https://codemie-ai.github.io/docs/admin/configuration/extensions/litellm-proxy/budget-configuration)
- [API Configuration Reference](https://codemie-ai.github.io/docs/admin/configuration/codemie/api-configuration)
