---
id: observability-overview
title: Observability Overview
sidebar_label: Observability
sidebar_position: 1
pagination_prev: admin/configuration/index
pagination_next: null
---

This guide covers the observability stack for AI/Run CodeMie — the tools and configuration
options that give administrators visibility into platform health, application logs, and AI
model usage.

## Observability Stack

AI/Run CodeMie uses two complementary observability layers:

| Layer                   | Tools                             | Purpose                                                      |
| ----------------------- | --------------------------------- | ------------------------------------------------------------ |
| **Infrastructure logs** | Fluent Bit, Elasticsearch, Kibana | Collect, store, and visualize application and service logs   |
| **AI traces & metrics** | Langfuse                          | Track LLM requests, latency, costs, and conversation metrics |

---

## Infrastructure Logging

### Log Collection — Fluent Bit

Fluent Bit runs as a DaemonSet on every cluster node and forwards container logs to
Elasticsearch. It is deployed as part of the observability components during platform
installation.

### Log Storage — Elasticsearch

Application logs and conversation metrics are stored in Elasticsearch. Application and
conversation indexes are controlled by environment variables in your CodeMie API
deployment:

| Variable                      | Default                 | Description                          |
| ----------------------------- | ----------------------- | ------------------------------------ |
| `ELASTIC_LOGS_INDEX`          | `logs-codemie-infra*`   | Index for application and API logs   |
| `CONVERSATIONS_METRICS_INDEX` | `codemie-conversations` | Index for conversation-level metrics |

### Quarterly User Metrics Indexes

When metrics index rotation is enabled, user and usage metrics are written through the
`codemie_metrics_logs_write` alias. The alias points to one quarterly index at a time:

```text
codemie_metrics_logs-YYYY-qN
```

For example, `codemie_metrics_logs-2026-q3` stores metrics for the third quarter of 2026. Analytics queries use `codemie_metrics_logs*`, which includes the legacy
`codemie_metrics_logs` index and all quarterly indexes.

Rotation is disabled by default. To enable it, bootstrap the write alias, configure
Fluent Bit to use the alias, and set `METRICS_ROTATION_ENABLED=true`. See
[Metrics Index Rotation](./metrics-index-rotation) for the complete configuration
procedure and [Metrics Index Rotation Update](../../update/3rd-party-components/elasticsearch/metrics-index-rotation) for
migrating an existing deployment.

### Log Visualization — Kibana

Kibana provides a pre-configured dashboard for browsing CodeMie logs and conversation
metrics. Access it at the Kibana URL exposed by your deployment.

### Log Level

Control the verbosity of application logs via the `LOG_LEVEL` environment variable in your
CodeMie API configuration:

| Value     | Description                                           |
| --------- | ----------------------------------------------------- |
| `DEBUG`   | Maximum verbosity — includes request/response details |
| `INFO`    | Standard operational events (default)                 |
| `WARNING` | Warnings and errors only                              |
| `ERROR`   | Errors only                                           |

---

## AI Traces & Metrics — Langfuse

:::info Prerequisite: Assistants Evaluation extension
Langfuse is deployed as part of the optional
[Assistants Evaluation](../../deployment/extensions/assistants-evaluation/index.md)
extension. You must deploy this extension before configuring Langfuse environment
variables or enabling trace collection.
:::

Langfuse captures detailed traces for every LLM call made through the platform. This
enables per-request inspection of prompts, completions, latency, and token usage.

### Configuration

Langfuse integration is configured via environment variables in the CodeMie API deployment:

| Variable                                  | Description                                            |
| ----------------------------------------- | ------------------------------------------------------ |
| `LANGFUSE_TRACES`                         | Enable or disable trace collection (`true` / `false`)  |
| `LANGFUSE_PUBLIC_KEY`                     | Langfuse project public key                            |
| `LANGFUSE_SECRET_KEY`                     | Langfuse project secret key                            |
| `LANGFUSE_HOST`                           | URL of your Langfuse instance                          |
| `LANGFUSE_BLOCKED_INSTRUMENTATION_SCOPES` | Comma-separated list of scopes to exclude from tracing |

### What Langfuse Tracks

- LLM request and response content
- Token usage and estimated cost per request
- Latency by model and endpoint
- Conversation-level aggregations

### Cost and Prompt Caching

When a model uses prompt caching, CodeMie sends each Langfuse generation its token usage and a
cost breakdown by token type. The cost lines are the same figures CodeMie uses for spend
tracking, so the Langfuse total of a request matches its CodeMie spend.

| Cost line              | What it covers                                             |
| ---------------------- | ---------------------------------------------------------- |
| `input`                | Input tokens not served from or written to the cache       |
| `input_cache_read`     | Input tokens read from the provider's prompt cache         |
| `input_cache_creation` | Input tokens written to the provider's prompt cache        |
| `output`               | Output tokens                                              |
| `output_reasoning`     | Reasoning tokens, when the LiteLLM proxy reports them      |
| `tool_usage`           | Provider tool charges, when the LiteLLM proxy reports them |
| `total`                | Cost of the request                                        |

Where the figures come from depends on how the model is called:

| Call path                                       | Source of the cost                                                                                                                                                         |
| ----------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| LiteLLM proxy, non-streaming                    | Cost lines as returned by the proxy in its response cost headers                                                                                                           |
| LiteLLM proxy, streaming                        | The proxy's total cost of the request. It is split into cost lines in proportion to each token type's price in the model's `cost` configuration                            |
| Direct provider call, without the LiteLLM proxy | Calculated by CodeMie from the token counts and the model's `cost` configuration in the [LLM configuration](../codemie/ai-models-integration/codemie-native-llm-config.md) |

A response served from the CodeMie or LiteLLM response cache is recorded with a total cost of `0`.

#### Reading the cost breakdown

- **Only `total` is shown.** On a streaming LiteLLM request, CodeMie splits the total only when
  the model's `cost` configuration has a price for every token type the request used. Add the
  missing price (for example `cache_creation_input_token_cost`) to get the cost lines. On a
  non-streaming request the cost lines are the ones the proxy returns.
- **No cost is shown, only tokens.** On a direct provider call, the model has no `cost`
  configuration. Langfuse then prices the tokens with its own model definitions, if it has one for
  the model.
- **Cache writes have tokens but no `input_cache_creation` cost.** The model's `cost`
  configuration has no `cache_creation_input_token_cost`, so cache writes are not charged
  separately. Set it for models that support prompt caching, as in the Bedrock Claude entries of the
  reference configuration.
- **Direct Anthropic API calls** (`provider: anthropic`). Cache writes appear as
  `input_cache_creation` tokens, and their cost is included in the `input` line, as in CodeMie
  spend.

---

## Related Configuration

- [API Configuration](../codemie/api-configuration.md) — full reference for all observability
  environment variables
- [Observability Components Deployment](../../deployment/platform-deployment/manual/kubernetes/observability) —
  install Fluent Bit, Elasticsearch, and Kibana on your cluster
