---
id: routing-analytics
title: Routing Analytics
sidebar_label: Routing Analytics
sidebar_position: 2
pagination_prev: user-guide/analytics/analytics-overview
pagination_next: null
---

# Routing Analytics

Routing Analytics helps you understand which models handled routed requests, how much
routing cost, and how much it may have saved. It appears in the
[Analytics Dashboard](./index.md) when the `routingAnalytics` feature is enabled for your
instance. The figures are based on recorded routing calls, so they do not represent all
LLM usage.

## Viewing Routing Analytics

Open **Analytics** from the left navigation and find the **Routing Analytics** section.
Use the dashboard's time, user, and project filters to narrow the data you can access.
The section includes:

- **Routing Summary** — total original model cost, classifier cost, estimated maximum
  cost, potential savings, routed requests, unique sessions, and counts of classifier
  and heuristic decisions. One session can contain multiple routed requests.
- **Routers** — a chart showing how requests are distributed across router aliases.
- **Routing Activity** — request volume over time, stacked by routing tier (Simple,
  Medium, Reasoning, and Complex).
- **Routing Paths** — a table connecting each router alias to the model that served
  requests and its tier. Compare request counts, actual cost, estimated maximum cost,
  and potential savings for each path.

**Potential savings** compare actual model cost with the estimated maximum cost for the
same calls. They are estimates, not billing credits. Classifier cost is shown separately
from the cost of the models that handled the requests.

:::note About model switches
Session model counts are grouped by day and model. They do not show the number or order
of model changes within a day; avoid treating daily counts as a step-by-step switch
timeline.
:::

Routing Analytics requires the `routingAnalytics` customer feature. An administrator
can enable it independently of the routing mechanism. For routing setup, see
[Switchyard Auto-Routing](../../admin/configuration/codemie/ai-models-integration/switchyard-model-routing.md)
and [LiteLLM Native Auto-Routing setup](../../admin/configuration/codemie/ai-models-integration/litellm-native-auto-routing.md#step-1-define-the-router-model),
including the callback that exposes LiteLLM routing decisions to CodeMie.
