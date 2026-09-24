---
id: litellm-native-auto-routing
title: LiteLLM Native Auto-Routing
sidebar_label: LiteLLM Native Auto-Routing
sidebar_position: 3
description: Set up LiteLLM-native complexity routers and expose their routing decisions to CodeMie
pagination_prev: admin/configuration/codemie/ai-models-integration/ai-models-integration-overview
pagination_next: null
---

import EnterpriseFeature from '@site/src/components/EnterpriseFeature';

# LiteLLM Native Auto-Routing

<EnterpriseFeature />

## Overview

LiteLLM has its own [auto-routing](https://docs.litellm.ai/docs/proxy/auto_routing) feature.
A LiteLLM router is a model alias that picks a real model for each request, for example a
cheaper model for simple prompts and a stronger model for complex ones.

This is an alternative to [Switchyard Auto-Routing](./switchyard-model-routing.md), which
routes requests on the CodeMie side before they reach LiteLLM. Here, the routing decision is
made inside the LiteLLM proxy instead. The two mechanisms are independent: a model is routed by
LiteLLM or by Switchyard, never both.

### How It Works

1. **LiteLLM routes the request.** The router alias sends each request to one of your
   configured models.
2. **A callback reports the decision.** A small LiteLLM callback adds the routing decision to
   the response headers.
3. **CodeMie records it.** CodeMie reads those headers and shows routing costs and savings in
   [Routing Analytics](../../../../user-guide/analytics/routing-analytics.md).

### Prerequisites

- A running [LiteLLM proxy](../../extensions/litellm-proxy/model-configuration.md) connected to
  CodeMie, version **1.99.2 or later**.
- At least two models already configured in the proxy's `model_list` (for example, a fast model
  and a capable model).
- To see routing data in the Analytics Dashboard, the `routingAnalytics` customer feature must be
  enabled.

## Step 1: Define the Router Model

Add a router entry to `model_list` in the LiteLLM proxy `config.yaml`. Replace `example-fast`
and `example-capable` with the names of models that already exist in your proxy:

```yaml
model_list:
  - model_name: example-router
    litellm_params:
      model: auto_router/complexity_router
      drop_params: true
      complexity_router_config:
        tiers:
          SIMPLE: [example-fast]
          MEDIUM: [example-fast]
          COMPLEX: [example-capable]
          REASONING: [example-capable]
        classifier_type: llm
        classifier_llm_config:
          model: example-fast
          timeout_ms: 2000
    model_info:
      id: example-router
      label: 'Example Router'
      # Capabilities: describe what the routed models support
      supports_native_streaming: true
      supports_function_calling: true
      supports_system_messages: true
      supported_openai_params: ['temperature', 'max_tokens', 'top_p', 'stream', 'tools', 'parallel_tool_calls']
      supports_vision: true
      litellm_provider: bedrock_converse
      top_p: true
      # Router declaration and configuration read by CodeMie
      litellm_router:
        is_router: true
        counterfactual_model: example-capable
        strategy: classifier
        classifier_model: example-fast
        tiers:
          simple:
            model: example-fast
            label: 'Example Fast Model'
          medium:
            model: example-fast
            label: 'Example Fast Model'
          complex:
            model: example-capable
            label: 'Example Capable Model'
          reasoning:
            model: example-capable
            label: 'Example Capable Model'
```

The entry has two parts:

- **`litellm_params`** tells LiteLLM how to route. It is standard LiteLLM configuration.
- **`model_info`** tells CodeMie what the router alias is: its capabilities, and that it is a
  router. It does not change how LiteLLM routes.

### Routing Settings (`litellm_params`)

| Field                            | Purpose                                                                                               |
| -------------------------------- | ----------------------------------------------------------------------------------------------------- |
| `model_name`                     | The router alias that users select in CodeMie.                                                        |
| `litellm_params.model`           | Must be `auto_router/complexity_router` to use LiteLLM's complexity router.                           |
| `complexity_router_config.tiers` | Which model serves each complexity tier: `SIMPLE`, `MEDIUM`, `COMPLEX`, and `REASONING`.              |
| `classifier_llm_config.model`    | The model LiteLLM uses to assess request complexity. A fast, low-cost model is usually a good choice. |

For all complexity router options, see the
[LiteLLM auto-routing documentation](https://docs.litellm.ai/docs/proxy/auto_routing).

### Capabilities (`model_info`)

A router alias is not a single model, so CodeMie cannot learn its capabilities from an
underlying model. Set them explicitly. Otherwise CodeMie uses defaults, which may, for
example, disable tool calling or streaming for the router.

Describe what **all** models in the router's tiers support: any of them may serve a request.

| Field                       | Purpose                                                                                               |
| --------------------------- | ----------------------------------------------------------------------------------------------------- |
| `id`                        | A unique ID, as for any other LiteLLM model entry.                                                    |
| `label`                     | The name shown in the CodeMie model list.                                                             |
| `supports_native_streaming` | Whether responses can be streamed.                                                                    |
| `supports_function_calling` | Whether the models support tool calling.                                                              |
| `supports_system_messages`  | Whether the models accept system prompts.                                                             |
| `supported_openai_params`   | Request parameters the models accept, such as `temperature`, `max_tokens`, and `parallel_tool_calls`. |
| `supports_vision`           | Whether the models accept images.                                                                     |
| `litellm_provider`          | The provider of the routed models, for example `bedrock_converse` or `azure`.                         |
| `top_p`                     | Whether the `top_p` parameter can be sent.                                                            |

See [LiteLLM Model Configuration](../../extensions/litellm-proxy/model-configuration.md#model-configuration-structure)
for details on these fields.

### Router Declaration (`model_info.litellm_router`)

| Field                  | Purpose                                                                                                               |
| ---------------------- | --------------------------------------------------------------------------------------------------------------------- |
| `is_router`            | Marks the alias as a router. Defaults to `true`.                                                                      |
| `counterfactual_model` | The model to compare costs against when calculating savings. Usually the most capable model in the router's tiers.    |
| `strategy`             | How the router decides, for example `classifier`. Shown to users.                                                     |
| `classifier_model`     | The classifier model. Shown to users.                                                                                 |
| `tiers`                | The model that serves each tier (`simple`, `medium`, `complex`, `reasoning`), with a display `label`. Shown to users. |

`strategy`, `classifier_model`, and `tiers` are informational: CodeMie shows them on the
**Models** help page (`/help/models`) so users can see how the router works. They do not
affect routing. Keep them in sync with `complexity_router_config` so that users see the real
configuration.

:::info Why CodeMie needs `litellm_router`
To CodeMie, a LiteLLM router alias looks exactly like a regular model. LiteLLM's API does not
say which aliases are routers. Without `litellm_router`, CodeMie treats the alias as a normal
model: it cannot attribute routing analytics to it, and Switchyard cannot detect
[router-on-router configurations](./switchyard-model-routing.md#validation-rules).
:::

## Step 2: Add the Routing Callback

### Why the Callback Is Needed

LiteLLM keeps its routing decision inside the proxy. It does not include the chosen model or
tier in the response that CodeMie receives. Without this information, CodeMie cannot tell which
model served a request, so routing analytics stay empty.

The callback runs inside the LiteLLM proxy and copies the routing decision into response
headers. Routing itself works without the callback; only the reporting to CodeMie depends on
it.

### Create the Callback File

Save the following code as `litellm_custom_callbacks.py`:

```python
# Copyright 2026 EPAM Systems, Inc. ("EPAM")
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

import contextlib
import json
from urllib.parse import quote

from litellm.integrations.custom_logger import CustomLogger

# Routing decision fields and the response headers CodeMie reads.
FIELD_TO_HEADER = {
    "tier": "x-litellm-router-tier",
    "cause": "x-litellm-router-cause",
    "routed_model": "x-litellm-router-routed-model",
    "classifier_model": "x-litellm-router-classifier-model",
    "router_model_name": "x-litellm-router-model-name",
    "router_type": "x-litellm-router-type",
}
SAFE_CHARS = " " + "".join(chr(c) for c in range(0x21, 0x7F) if chr(c) != "%")


def encode(value: str) -> str:
    return quote(value, safe=SAFE_CHARS)


def get_routing_decision(data: dict) -> dict | None:
    for key in ("litellm_metadata", "metadata"):
        metadata = data.get(key)
        if isinstance(metadata, dict):
            decision = metadata.get("routing_decision")
            if isinstance(decision, dict) and decision:
                return decision
    return None


def get_model_group(deployment_id: object) -> str | None:
    if not isinstance(deployment_id, str) or not deployment_id:
        return None
    from litellm.proxy.proxy_server import llm_router

    if llm_router is None:
        return None
    deployment = llm_router.get_deployment(model_id=deployment_id)
    model_name = getattr(deployment, "model_name", None)
    return model_name if isinstance(model_name, str) and model_name else None


class AutorouterCallback(CustomLogger):
    async def async_post_call_response_headers_hook(
        self, data, user_api_key_dict, response, request_headers=None, litellm_call_info=None
    ):
        # Never fail the request because of reporting.
        headers: dict[str, str] = {}
        with contextlib.suppress(Exception):
            decision = get_routing_decision(data)
            if decision:
                for field, header in FIELD_TO_HEADER.items():
                    value = decision.get(field)
                    if isinstance(value, str):
                        headers[header] = encode(value)

                score = decision.get("score")
                if isinstance(score, (int, float)) and not isinstance(score, bool):
                    headers["x-litellm-router-score"] = f"{float(score):.6g}"

                signals = decision.get("signals")
                if signals is not None:
                    headers["x-litellm-router-signals"] = encode(json.dumps(signals))

                baseline = get_model_group(decision.get("savings_baseline_deployment_id"))
                if baseline:
                    headers["x-litellm-router-savings-baseline-model-group"] = encode(baseline)

        with contextlib.suppress(Exception):
            caching = getattr(data.get("litellm_logging_obj"), "caching_details", None)
            if caching and caching.get("cache_hit") is True:
                headers["x-litellm-cache-hit"] = "true"

        return headers or None


autorouter_callback_instance = AutorouterCallback()
```

The callback adds these headers to routed responses:

| Header                                          | Meaning                                                                           |
| ----------------------------------------------- | --------------------------------------------------------------------------------- |
| `x-litellm-router-tier`                         | The complexity tier LiteLLM selected.                                             |
| `x-litellm-router-routed-model`                 | The model that actually served the request.                                       |
| `x-litellm-router-model-name`                   | The router alias that was requested.                                              |
| `x-litellm-router-cause`                        | How the decision was made, for example by the classifier or by a heuristic.       |
| `x-litellm-router-score`                        | The complexity score behind the decision.                                         |
| `x-litellm-router-signals`                      | Additional decision signals, as JSON.                                             |
| `x-litellm-router-classifier-model`             | The classifier model, when one was used.                                          |
| `x-litellm-router-type`                         | The router type.                                                                  |
| `x-litellm-router-savings-baseline-model-group` | The model LiteLLM used as the savings baseline. Overrides `counterfactual_model`. |
| `x-litellm-cache-hit`                           | `true` when the whole response came from the LiteLLM cache.                       |

LiteLLM adds `x-litellm-classifier-cost` on its own, so the callback does not set it.

## Step 3: Register the Callback

LiteLLM loads `litellm_custom_callbacks` as a Python module from the directory that contains
the proxy `config.yaml`. Place the file there, then reference it in `litellm_settings.callbacks`.

### Kubernetes/Helm

With the `litellm-helm` chart, the proxy reads its configuration from `/etc/litellm/config.yaml`.
Store the callback in a ConfigMap and mount it into the same directory. Add the following to
your `litellm/values-<cloud>.yaml`:

```yaml
litellm-helm:
  # ... additional configuration fields
  proxy_config:
    litellm_settings:
      # Keep any callbacks you already have
      callbacks:
        - 'litellm_custom_callbacks.autorouter_callback_instance'

  extraResources:
    - apiVersion: v1
      kind: ConfigMap
      metadata:
        name: litellm-custom-callbacks
      data:
        litellm_custom_callbacks.py: |
          # Copyright 2026 EPAM Systems, Inc. ("EPAM")
          # ... paste the full contents of litellm_custom_callbacks.py from Step 2,
          # indented under this key

  volumes:
    - name: litellm-custom-callbacks
      configMap:
        name: litellm-custom-callbacks

  volumeMounts:
    - name: litellm-custom-callbacks
      readOnly: true
      mountPath: /etc/litellm/litellm_custom_callbacks.py
      subPath: litellm_custom_callbacks.py
```

- `extraResources` creates the ConfigMap together with the chart, so the callback is versioned
  with the rest of the proxy configuration.
- `subPath` mounts only the single file, so the chart-managed `config.yaml` in `/etc/litellm/`
  stays in place.
- If you already define `volumes` or `volumeMounts`, add these entries to the existing lists.

Apply the change with your usual `helm upgrade` command. Because the ConfigMap is mounted with
`subPath`, Kubernetes does not refresh the file in running pods: restart the LiteLLM deployment
whenever you change the callback code.

### Other Deployments

1. Copy `litellm_custom_callbacks.py` into the directory that contains the proxy `config.yaml`
   (for Docker Compose, mount it as a volume next to the mounted `config.yaml`).
2. Register the callback in the proxy `config.yaml`. Keep any callbacks you already have:

   ```yaml
   litellm_settings:
     callbacks:
       - 'litellm_custom_callbacks.autorouter_callback_instance'
   ```

3. Restart the LiteLLM proxy.

## Step 4: Verify the Setup

Send a request to the router alias and check the response headers. Replace `<litellm-url>`
and `<litellm-key>` with your proxy URL and API key:

```bash
curl -i '<litellm-url>/v1/chat/completions' \
  -H 'Authorization: Bearer <litellm-key>' \
  -H 'Content-Type: application/json' \
  -d '{"model": "example-router", "messages": [{"role": "user", "content": "Hello"}]}'
```

The setup works when:

- The response includes `x-litellm-router-tier` and `x-litellm-router-routed-model`.
- The router alias appears in the CodeMie model list.
- After you use the router in CodeMie, its requests appear in
  [Routing Analytics](../../../../user-guide/analytics/routing-analytics.md).

If the routing headers are missing, check that the proxy runs LiteLLM 1.99.2 or later, that the
proxy logs show the callback module was imported, and that the router alias uses
`auto_router/complexity_router`.

## Using the Router

Once configured, the router alias is available wherever users choose a model — in the web
interface and in the CLI. Users select it like any other model; LiteLLM then picks the serving
model for each request.

- **Web:** select the router's `label` in the
  [LLM model selector](../../../../user-guide/assistants/chat-input-settings.md#llm-model-selector)
  of a chat.
- **CLI:** pass the router's `model_name` to the
  [CodeMie CLI](../../../../user-guide/codemie-cli/index.md), for example
  `codemie-code --model example-router`.

Requests from both are recorded in
[Routing Analytics](../../../../user-guide/analytics/routing-analytics.md).

## Reference: `litellm_router` Fields

`litellm_router` goes in the model's `model_info` block. See
[LiteLLM Model Configuration](../../extensions/litellm-proxy/model-configuration.md#model-configuration-structure)
for the other `model_info` fields.

| Field                  | Type           | Default | Description                                                                                                                     |
| ---------------------- | -------------- | ------- | ------------------------------------------------------------------------------------------------------------------------------- |
| `is_router`            | boolean        | `true`  | Marks this `model_name` as a LiteLLM router rather than a regular model.                                                        |
| `counterfactual_model` | string or null | `null`  | Model used to estimate savings when LiteLLM does not send a savings baseline. Without either, savings are not calculated.       |
| `strategy`             | string         | —       | Informational. How the router decides, for example `classifier`. Shown on `/help/models`.                                       |
| `classifier_model`     | string         | —       | Informational. The model that classifies requests. Shown on `/help/models`.                                                     |
| `tiers`                | object         | —       | Informational. Maps `simple`, `medium`, `complex`, and `reasoning` to a `model` and a display `label`. Shown on `/help/models`. |

:::note Two unrelated `is_router` fields
`litellm_router.is_router` marks a LiteLLM router alias. It is unrelated to the `is_router`
field that CodeMie's API returns for Switchyard routers in the model list.
:::

## Relationship with Switchyard

Declaring `litellm_router` lets Switchyard reject configurations that chain one router to
another, for example a Switchyard router whose capable or efficient model is a LiteLLM
router. See [Switchyard Auto-Routing: Validation Rules](./switchyard-model-routing.md#validation-rules).
Otherwise, LiteLLM routers and Switchyard are independent.
