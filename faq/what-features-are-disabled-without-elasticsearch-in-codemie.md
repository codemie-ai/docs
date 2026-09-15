# What features are disabled in CodeMie when Elasticsearch is not available?

When `RETRIEVAL_BACKEND=none` (used in [standalone deployments](https://docs.codemie.ai/admin/deployment/standalone/overview)), the following are disabled or degraded:

1. **Data Sources and Knowledge Bases** — navigation, routes, and API endpoints for creating and managing data sources are unavailable.
2. **LLM/Embedding Providers admin pages** — hidden in Settings → Administration.
3. **Assistant context selector** — the Data Sources option is removed from assistant context configuration.
4. **Integrations** — the `datasource` resource type cannot be selected when configuring integration credentials.
5. **Code context and knowledge base tools** — tool calls requiring indexed content return an unavailable error.
6. **Preconfigured assistant retrieval contexts** — skipped entirely, avoiding any Elasticsearch calls at startup.
7. **Workflow code-index search** — workflow steps that query indexed code raise an error.
8. **Admin Log Lookup** (`POST /v1/logs`) — returns `503` unless separately re-enabled with `ADMIN_LOG_LOOKUP_ENABLED=true`.

Everything else — chat, assistants, workflows, integrations, direct tool access to external systems — continues to work normally. Analytics Insights/CLI Insights tabs are gated separately by whether the `codemie-enterprise` package is installed, independent of the retrieval backend.

## Sources

- [Standalone Deployment](https://docs.codemie.ai/admin/deployment/standalone/overview)
- [Customer Feature Configuration](https://docs.codemie.ai/admin/configuration/codemie/customer-feature-configuration)
