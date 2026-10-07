# Are Data Sources and Analytics available without Elasticsearch or ClickHouse?

Data Sources, Knowledge Bases, and code indexing all depend on the Elasticsearch-backed
retrieval layer. When the backend's `RETRIEVAL_BACKEND` setting is `none` — the default for
CodeMie Standalone, which does not include an Elasticsearch container — these three features are
disabled, regardless of what `customer-config.yaml` specifies. The admin log lookup endpoint
relies on the same connection and should also be disabled (`ADMIN_LOG_LOOKUP_ENABLED=false`) in
that mode, or it returns an error.

The Analytics Dashboard is different: it is available to every authenticated user and is not
gated by the retrieval backend or by an Enterprise Edition license. On a deployment without
Elasticsearch or ClickHouse, the dashboard still loads and simply shows an empty state instead of
usage data. CLI Analytics specifically requires ClickHouse and an OpenTelemetry Collector; in
CodeMie Standalone these are only started with the optional `standalone-analytics` Compose
profile.

## Sources

- [CodeMie Standalone Deployment Guide](https://docs.codemie.ai/admin/deployment/standalone/overview)
- [API Configuration Reference](https://docs.codemie.ai/admin/configuration/codemie/api-configuration)
- [CodeMie Customer Feature Configuration](https://docs.codemie.ai/admin/configuration/codemie/customer-feature-configuration)
- [Analytics Dashboard](https://docs.codemie.ai/user-guide/analytics/analytics-overview)
