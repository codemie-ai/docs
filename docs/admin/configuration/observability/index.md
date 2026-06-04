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

Application logs and conversation metrics are stored in Elasticsearch under two indexes
controlled by environment variables in your CodeMie API deployment:

| Variable                      | Default                 | Description                          |
| ----------------------------- | ----------------------- | ------------------------------------ |
| `ELASTIC_LOGS_INDEX`          | `logs-codemie-infra*`   | Index for application and API logs   |
| `CONVERSATIONS_METRICS_INDEX` | `codemie-conversations` | Index for conversation-level metrics |

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

---

## Related Configuration

- [API Configuration](../codemie/api-configuration.md) — full reference for all observability
  environment variables
- [Observability Components Deployment](../../deployment/aws/kubernetes/components-deployment/manual-deployment/observability.md) —
  install Fluent Bit, Elasticsearch, and Kibana on your cluster
