# Which LLM providers receive the X-CodeMie-Version and X-CodeMie-Project headers?

The `X-CodeMie-Version` and `X-CodeMie-Project` request headers are injected for three
provider paths:

| Provider            | Headers injected                                          |
| ------------------- | --------------------------------------------------------- |
| Azure OpenAI / DIAL | Yes                                                       |
| Google Vertex AI    | Yes                                                       |
| Anthropic (direct)  | Yes                                                       |
| AWS Bedrock         | No — Bedrock does not support custom HTTP request headers |
| LiteLLM proxy       | No — project context is sent via `x-litellm-tags` instead |

No configuration is required to enable this behavior — header injection is always active
for the supported paths and derives its values from the `APP_VERSION` environment variable
and the active request's project context.

## Sources

- [LLM Request Tagging](https://docs.codemie.ai/admin/configuration/observability/request-tagging)
