---
id: switchyard-model-routing
title: Switchyard Auto-Routing
sidebar_label: Switchyard Auto-Routing
sidebar_position: 2
description: Configure Switchyard tier-based LLM auto-routing between a capable and an efficient model
pagination_prev: admin/configuration/codemie/ai-models-integration/ai-models-integration-overview
pagination_next: null
---

import EnterpriseFeature from '@site/src/components/EnterpriseFeature';

# Switchyard Auto-Routing

<EnterpriseFeature />

## Overview

Switchyard is a per-call routing layer that decides, request by request, whether to send an
LLM call to a **capable** (higher-quality, higher-cost) model or an **efficient**
(lower-cost) model from the same family. The decision is made before the call is sent, using
either lightweight heuristics or a small classifier call — no manual model switching is
required.

Switchyard integrates with both request paths CodeMie exposes to models:

- The HTTP proxy path (`v1/messages`, `v1/chat/completions`)
- The LangGraph-based agent execution path used internally by assistants and workflows

Routing is opt-in per model: a capable model only becomes routable once at least one
Switchyard router entry is declared on it in the model configuration YAML (see
[Configuring Routers per Model](#configuring-routers-per-model)). This applies whether the
model is declared through
[CodeMie Native LLM Config](./codemie-native-llm-config.md) or synced from a LiteLLM proxy —
the `switchyard` field is recognized on any model entry in the resolved model catalog.

## Enabling Switchyard

Switchyard is disabled platform-wide by default, independent of any per-model YAML
configuration. `SWITCHYARD_ENABLED` must be set to `true` for any router to take effect.

| Parameter                     | Type           | Default                     | Description                                                                                                                  |
| ----------------------------- | -------------- | --------------------------- | ---------------------------------------------------------------------------------------------------------------------------- |
| `SWITCHYARD_ENABLED`          | boolean        | `false`                     | Master switch for Switchyard routing. When `false`, every router is disabled regardless of YAML configuration.               |
| `SWITCHYARD_CLASSIFIER_MODEL` | string \| null | `"gpt-5.6-luna-2026-07-09"` | Global default classifier model used by routers in `classifier` mode. Overridable per router with `tuning.classifier_model`. |

These parameters are also listed in the
[CodeMie API Configuration Reference](../api-configuration.md#switchyard-auto-routing).

## Routing Modes

Each router entry operates in exactly one mode:

| Mode         | How the decision is made                                                                                               | Extra LLM calls                        |
| ------------ | ---------------------------------------------------------------------------------------------------------------------- | -------------------------------------- |
| `signal`     | Heuristics derived from the current request itself (for example, the presence and type of tool calls) decide the tier. | None                                   |
| `classifier` | A lightweight call to the configured classifier model assesses request complexity before deciding the tier.            | One classifier call per routed request |

`signal` mode adds no latency or cost of its own. `classifier` mode trades a small amount of
extra latency and cost for a more informed routing decision; the classifier call's tokens and
cost are tracked separately and exposed via response headers (see
[Response Headers](#response-headers)).

## Configuring Routers per Model

Switchyard routers are declared on the **capable** model's entry in the `llm_models` list of
the model configuration YAML. Each entry in that model's `switchyard` list fully describes one
router — its own identity, the efficient model it falls back to, its mode, and optional
tuning:

```yaml
llm_models:
  - base_name: "claude-sonnet-4-6"
    deployment_name: "us.anthropic.claude-sonnet-4-6"
    label: "Bedrock Claude Sonnet 4.6"
    provider: "aws_bedrock"
    # ... other model fields
    switchyard:
      - base_name: "claude-sonnet-4-6-switchyard-claude-4-5-haiku-signal"
        label: "SY Signal Sonnet/Haiku"
        efficient: "claude-4-5-haiku"
        mode: signal
      - base_name: "claude-sonnet-4-6-switchyard-claude-4-5-haiku-classifier"
        label: "SY Classifier Sonnet/Haiku"
        efficient: "claude-4-5-haiku"
        mode: classifier

  - base_name: "claude-4-5-haiku"
    deployment_name: "us.anthropic.claude-haiku-4-5-20251001-v1:0"
    label: "Bedrock Claude 4.5 Haiku"
    provider: "aws_bedrock"
    # ... other model fields
```

### Router Fields

| Field       | Type                     | Required | Description                                                                                                                       |
| ----------- | ------------------------ | -------- | --------------------------------------------------------------------------------------------------------------------------------- |
| `base_name` | string                   | Yes      | Identifier for this router itself. Must be unique across every model and router in the catalog.                                   |
| `label`     | string \| null           | No       | Display name shown in the model dropdown for this router. Falls back to `base_name` when omitted.                                 |
| `efficient` | string                   | Yes      | `base_name` of an existing, cheaper model from the same family to route to when the router selects the efficient tier.            |
| `mode`      | `signal` \| `classifier` | Yes      | Routing mode for this entry (see [Routing Modes](#routing-modes)).                                                                |
| `tuning`    | object                   | No       | Per-router override of the tuning parameters described in [Tuning Parameters](#tuning-parameters). Falls back to global defaults. |

Because each entry is fully self-describing, one capable model can have multiple routers —
for example, one `signal` and one `classifier` router against the same efficient model, as
shown above — without any naming collisions.

### Validation Rules

Router definitions are validated both when the configuration is loaded and again at runtime
against the live model catalog (as defense-in-depth against configuration drift). A router
entry is rejected, and its generation skipped with a logged error, when any of the following
is true:

- Its `base_name` collides with a real model's `base_name`.
- Its `base_name` collides with another generated router's `base_name`.
- Its `efficient` value does not reference an existing model.
- Either the capable model or the `efficient` model is itself a Switchyard-generated router, or
  is declared as a router by the separate, alternative
  [LiteLLM Native Auto-Routing](./litellm-native-auto-routing.md) mechanism — this prevents a
  Switchyard router from being chained to another router.

## Tuning Parameters

Each router falls back to a set of default tuning parameters unless overridden with a
`tuning` block on the entry:

| Parameter                   | Type           | Default | Description                                                                                               |
| --------------------------- | -------------- | ------- | --------------------------------------------------------------------------------------------------------- |
| `recent_window`             | integer        | `3`     | Number of recent conversation turns considered when evaluating routing signals.                           |
| `classifier_base_threshold` | float          | `0.65`  | Baseline confidence threshold used by the classifier's escalation logic.                                  |
| `classifier_threshold_step` | float          | `0.15`  | Step size by which the classifier's effective threshold is adjusted based on recent conversation history. |
| `signal_threshold`          | float          | `0.0`   | Confidence threshold applied when `mode: signal`. Ignored for `classifier` routers.                       |
| `classifier_threshold`      | float          | `0.5`   | Confidence threshold applied when `mode: classifier`. Ignored for `signal` routers.                       |
| `classifier_model`          | string \| null | `null`  | Overrides `SWITCHYARD_CLASSIFIER_MODEL` for this router. Only relevant when `mode: classifier`.           |

Only the threshold matching a router's own `mode` is applied — a `signal` router uses
`signal_threshold`, a `classifier` router uses `classifier_threshold`.

## Effect on Model Selection

Each valid router entry adds a corresponding virtual model to the CodeMie model catalog,
shown in the LLM model dropdown (see
[LLM Model Selector](../../../../user-guide/assistants/chat-input-settings.md#llm-model-selector))
using the router's `label`. Selecting this virtual model routes every subsequent call in the
conversation through that router — CodeMie decides per call whether to serve the request with
the capable or the efficient model, rather than sending every call to a single fixed model.

:::tip
Because `label` is fully admin-controlled for each router entry, giving routers a consistent,
recognizable prefix (for example `SY`) makes them easy to identify in the model dropdown.
:::

## Response Headers

For requests served through the HTTP proxy path, Switchyard exposes routing metadata as
response headers — useful for cost tracking and observability at the client or gateway level:

| Header                                               | Description                                                                     |
| ---------------------------------------------------- | ------------------------------------------------------------------------------- |
| `x-codemie-routed-model`                             | The model that actually served the request (capable or efficient).              |
| `x-codemie-requested-model`                          | The router `base_name` the client requested.                                    |
| `x-codemie-routing-tier`                             | The tier selected: `capable` or `efficient`.                                    |
| `x-codemie-routing-classifier-model`                 | The classifier model used, if `mode: classifier` fired for this request.        |
| `x-codemie-routing-classifier-input-tokens`          | Input tokens consumed by the classifier call.                                   |
| `x-codemie-routing-classifier-output-tokens`         | Output tokens produced by the classifier call.                                  |
| `x-codemie-routing-classifier-cached-tokens`         | Cached input tokens used by the classifier call, if applicable.                 |
| `x-codemie-routing-classifier-cache-creation-tokens` | Tokens spent creating a new cache entry for the classifier call, if applicable. |
| `x-codemie-routing-classifier-cost-usd`              | Estimated cost in USD of the classifier call.                                   |

The `classifier-*` headers are only populated for requests routed by a `classifier`-mode
router; they are absent for `signal`-mode routing, which makes no extra LLM call.

For routing costs, estimated savings, and model distribution in the Analytics Dashboard,
see [Routing Analytics](../../../../user-guide/analytics/routing-analytics.md). Its
`routingAnalytics` customer feature flag is separate from `SWITCHYARD_ENABLED`.

## Related: LiteLLM Native Auto-Routing

Switchyard is one of two **separate, alternative** routing mechanisms CodeMie recognizes — the
other is LiteLLM's own native auto-routing, configured entirely on the LiteLLM proxy side. A
given model is resolved by at most one of them; they are not layers of the same feature and
are not configured together. See
[LiteLLM Native Auto-Routing](./litellm-native-auto-routing.md) for how CodeMie recognizes a
LiteLLM-side auto-router and why that recognition matters for Switchyard's own validation.
