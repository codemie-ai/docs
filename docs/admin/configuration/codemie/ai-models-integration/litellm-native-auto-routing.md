---
id: litellm-native-auto-routing
title: LiteLLM Native Auto-Routing
sidebar_label: LiteLLM Native Auto-Routing
sidebar_position: 3
description: Declare a LiteLLM-native auto-router model so CodeMie does not treat it as a regular deployment
pagination_prev: admin/configuration/codemie/ai-models-integration/ai-models-integration-overview
pagination_next: null
---

import EnterpriseFeature from '@site/src/components/EnterpriseFeature';

# LiteLLM Native Auto-Routing

<EnterpriseFeature />

## Overview

LiteLLM offers its own
[native auto-routing](https://docs.litellm.ai/docs/proxy/auto_routing) feature, configured
entirely on the LiteLLM proxy side, independent of CodeMie. This is a **separate, alternative**
routing mechanism from CodeMie's own
[Switchyard Auto-Routing](./switchyard-model-routing.md) — the two are not layers of the same
feature, are not configured together, and a given model is resolved by at most one of them.
This page only covers how CodeMie recognizes that a model is a LiteLLM-side auto-router; the
routing behavior itself is entirely defined and executed by LiteLLM.

## Why This Declaration Is Needed

When a `model_name` in LiteLLM's catalog is itself configured as a native auto-router, it looks
identical to a real deployment from CodeMie's side — LiteLLM's API gives no reliable signal
(no distinguishing ID, same namespace as ordinary models) that this particular entry is a
router rather than a concrete deployment.

To avoid CodeMie treating a LiteLLM auto-router as a normal deployable model, the corresponding
model entry in CodeMie's model configuration must declare `litellm_router`, mirroring what is
already configured on the LiteLLM proxy side for that same `model_name`.

## Declaring a LiteLLM Auto-Router

`litellm_router` is declared directly in LiteLLM's own proxy `config.yaml`, in the same
`model_info` block as the model's other CodeMie-recognized fields (see
[LiteLLM Model Configuration](../../extensions/litellm-proxy/model-configuration.md#model-configuration-structure)
for the full `model_info` reference):

```yaml
model_list:
  - model_name: my-litellm-auto-router
    litellm_params:
      model: azure/my-litellm-auto-router
    model_info:
      id: my-litellm-auto-router
      label: 'My LiteLLM Auto-Router'
      litellm_router: {}
```

An empty `litellm_router: {}` object is sufficient — it declares the model as a router using
the field's default value.

| Field       | Type    | Default | Description                                                                                     |
| ----------- | ------- | ------- | ----------------------------------------------------------------------------------------------- |
| `is_router` | boolean | `true`  | Declares that this model's `model_name` is itself a LiteLLM auto-router, not a real deployment. |

:::note Two unrelated `is_router` concepts
`litellm_router.is_router` declares that a `model_name` **is itself** a LiteLLM-side
auto-router. It is unrelated to the `is_router` flag CodeMie's API returns on
Switchyard-generated router models for client picker logic — despite the shared field name, the
two describe different things at different layers of the system.
:::

## Effect on Switchyard Validation

Declaring `litellm_router` on a model is what allows Switchyard's own validation to detect and
reject "router-on-router" configurations — a Switchyard router whose capable or efficient model
is itself a LiteLLM auto-router. See
[Switchyard Auto-Routing: Validation Rules](./switchyard-model-routing.md#validation-rules) for
the full set of rejected configurations. Outside of that safety check, `litellm_router` has no
other relationship to Switchyard.
