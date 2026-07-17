# What HTTP headers does CodeMie add to outbound LLM requests?

CodeMie injects two metadata headers into every outbound LLM API request for supported
providers:

- **`X-CodeMie-Version`** — the platform version string from the `APP_VERSION` environment
  variable. Always present.
- **`X-CodeMie-Project`** — the name of the active project context at request time. Omitted
  when no project is set.

These headers are added for Azure OpenAI / DIAL, Google Vertex AI, and Anthropic (direct)
provider paths. AWS Bedrock and the LiteLLM proxy path are excluded — Bedrock does not
support custom HTTP request headers, and LiteLLM receives project context via the
`x-litellm-tags` header instead.

## Sources

- [LLM Request Tagging](https://docs.codemie.ai/admin/configuration/observability/request-tagging)
