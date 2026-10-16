---
id: headroom-context-compression
title: Headroom Context Compression
sidebar_label: Headroom Context Compression
sidebar_position: 4
description: Enable Headroom context compression in CodeMie with the in-process SDK or a sidecar service to reduce LLM token usage
pagination_prev: admin/configuration/index
pagination_next: null
---

# Headroom Context Compression

## Overview

Headroom compresses the messages that CodeMie sends to the LLM on each model call, which reduces token usage and cost.
Compression is configured per assistant and per workflow by users. An administrator decides whether the capability is
available at all, and how the compression runs.

Assistants and workflows without Headroom settings behave exactly as before. When Headroom fails for any reason, the
original messages are sent to the model unchanged (the feature fails open).

### How It Works

1. **The administrator selects a mode.** The `HEADROOM_MODE` environment variable chooses where compression runs:
   - `off` (default) — Headroom is disabled. A blank value is treated as `off`.
   - `sdk` — the Headroom SDK runs inside the CodeMie API process.
   - `sidecar` — a separate Headroom container compresses messages over HTTP.
2. **The customer feature is enabled.** Compression takes effect only when the `features:headroom` customer feature is
   enabled. Without it, the Headroom controls, the token savings row in the chat, and the analytics section stay
   hidden, and stored Headroom settings are ignored at runtime.
3. **Users configure compression.** Assistant authors and workflow authors turn compression on and choose a strategy.
   See [Create Assistant](../../../user-guide/assistants/create-assistant.md#context-compression-headroom) and
   [Workflow Configuration Reference](../../../user-guide/workflows/configuration/configuration-reference.md).
4. **Each model call is compressed.** Settings are resolved for each field in the order node, workflow, assistant.
   The first value that is set wins.

The mode is read once per process, so a change to `HEADROOM_MODE` requires a restart of the CodeMie API.

### What Is Compressed

- User messages, when **Compress user input** is on.
- Tool results and earlier assistant replies fed back into the context, when **Compress tool outputs** is on.

### What Is Not Compressed

- System messages.
- Attached files and images.
- Messages that contain content blocks other than plain text.
- Requests handled by unsupported agent types: AI Tools agents, Bedrock, and remote A2A agents.

### Prerequisites

- The CodeMie API version that includes Headroom support, with its database migrations applied before the new
  version starts.
- For `sdk` mode: a CodeMie API image built with the Headroom SDK (see [SDK Mode](#sdk-mode)).
- For `sidecar` mode: a running Headroom sidecar container reachable from the CodeMie API (see
  [Sidecar Mode](#sidecar-mode)).

## Choosing a Mode

| Aspect                  | `sidecar`                                       | `sdk`                                                      |
| ----------------------- | ----------------------------------------------- | ---------------------------------------------------------- |
| Where compression runs  | Separate `headroom` container, called over HTTP | Inside the CodeMie API process                             |
| Backend image           | No change                                       | Built with the `INSTALL_HEADROOM_SDK` build argument       |
| Extra service to run    | Yes                                             | No                                                         |
| Prose compression model | Included in the sidecar image                   | Requires the ML variant and a cached or downloadable model |

## SDK Mode

In `sdk` mode the Headroom package is installed in the CodeMie API image and called in the API process. The package is
imported lazily on first use, and only in this mode.

### Build the Image

The `INSTALL_HEADROOM_SDK` build argument of the CodeMie API Dockerfile selects the installed variant:

| Value            | Result                                                                                  |
| ---------------- | --------------------------------------------------------------------------------------- |
| `false` or empty | No Headroom SDK (default).                                                              |
| `true`           | Installs the `headroom-sdk` extra. Structured content (JSON, logs, code) is compressed. |
| `ml`             | Installs the `headroom-sdk-ml` extra. Adds the Kompress ML model support for prose.     |

Any other value fails the image build. For example:

```bash
docker build --build-arg INSTALL_HEADROOM_SDK=ml -t codemie-api .
```

With `HEADROOM_MODE=sdk` and an image built with `INSTALL_HEADROOM_SDK=false`, the CodeMie API logs one error the first
time the mode is resolved and then sends every request uncompressed.

### Kompress Model

Free-form text, such as user messages and assistant replies, is compressed by the Kompress ML model. Without it, only
structured content is reduced, and the `aggressive` strategy behaves exactly like `balanced`.

In `sdk` mode, the model needs the `ml` variant of the image (about 770 MiB of additional memory in the API process)
and one of the following:

- A model that is already cached in the image or on a mounted volume.
- `HEADROOM_SDK_ALLOW_MODEL_DOWNLOAD=true`, which allows the SDK to download the model from Hugging Face on first use.
  The default is `false`.

In an air-gapped deployment, pre-load the model into the image or a volume and keep the default
`HEADROOM_SDK_ALLOW_MODEL_DOWNLOAD=false`. Without Kompress, one warning is logged at first use.

:::note
SDK mode sets `HEADROOM_BEACON=off`, `DO_NOT_TRACK=1`, and `HEADROOM_CCR_BACKEND=memory` in the API process and
overrides different inherited values with a warning. A preset `HEADROOM_OFFLINE=1` is kept and prevents the model
download.
:::

## Sidecar Mode

In `sidecar` mode, a separate Headroom container compresses messages. No Headroom package is installed in the CodeMie
API image.

### Sidecar Requirements

- The Headroom sidecar container image, listening on port `8787`.
- A bearer token in the `HEADROOM_PROXY_TOKEN` environment variable. The value must be identical for the sidecar and
  for the CodeMie API.
- `HEADROOM_OFFLINE=0` in the sidecar, so that it can download the Kompress model from Hugging Face on first start.
  With `HEADROOM_OFFLINE=1` the sidecar logs `Kompress model not ready; requests will not be compressed`, and
  `aggressive` behaves like `balanced`. In an air-gapped deployment, pre-load the model into the sidecar image or a
  volume.
- About 2 GiB of memory for the container, since the Kompress model needs about 770 MiB.
- `HEADROOM_LOSSLESS=1` in the sidecar to use the `lossless` strategy.
- Access from the CodeMie API over an internal network only. The sidecar port is not published outside the cluster or
  the Docker network.

### CodeMie API Settings

Set the following on the CodeMie API:

```yaml
HEADROOM_MODE: sidecar
HEADROOM_SIDECAR_URL: http://headroom:8787
HEADROOM_PROXY_TOKEN: <shared-token>
```

`HEADROOM_SIDECAR_URL` defaults to `http://headroom:8787`; set it only when the sidecar is reachable at another
address. Store `HEADROOM_PROXY_TOKEN` as a secret.

## Strategies

Users select one of three strategies for an assistant, a workflow, or a workflow node.

| Strategy             | Behavior                                                                           | Provider prompt cache         |
| -------------------- | ---------------------------------------------------------------------------------- | ----------------------------- |
| `lossless`           | Deterministic, no information loss. Requires `HEADROOM_LOSSLESS=1` in the sidecar. | Safe                          |
| `balanced` (default) | Shortens older messages and long tool results. Some detail may be lost.            | Can lower provider cache hits |
| `aggressive`         | Shortens more than `balanced`. More detail may be lost.                            | Can lower provider cache hits |

`balanced` and `aggressive` rewrite older history, which can reduce provider prompt-cache hits. `lossless` is the
better choice when the cache hit rate matters more than the size reduction.

The `HEADROOM_AGGRESSIVE_TARGET_RATIO` setting controls how much content `aggressive` keeps (default `0.2`). Increase
the value when the output is too degraded. The setting applies only where the ML compressor runs.

## Step 1: Configure the Environment Variables

Set the variables from the [Headroom (Context Compression)](./api-configuration.md) section of the API configuration
reference: `HEADROOM_MODE`, `HEADROOM_SDK_ALLOW_MODEL_DOWNLOAD`, `HEADROOM_SIDECAR_URL`, `HEADROOM_PROXY_TOKEN`,
`HEADROOM_TIMEOUT_SECONDS`, `HEADROOM_MIN_TOKENS`, and `HEADROOM_AGGRESSIVE_TARGET_RATIO`. Restart the CodeMie API
after a change.

## Step 2: Enable the Customer Feature

Add the `features:headroom` component to the `components` list of `customer-config.yaml`:

```yaml
components:
  - id: 'features:headroom'
    settings:
      enabled: true
      name: 'Headroom'
      description: 'Compress large tool outputs and context with Headroom (sdk or sidecar) to reduce token usage'
```

The feature is disabled by default, and a missing entry counts as disabled. See
[Customer Feature Configuration](./customer-feature-configuration.md) for how components are configured.

## Verify the Setup

1. Open an assistant with a long conversation or large tool results and enable **Enable context compression** in the
   assistant settings.
2. Send a request that produces a large context, such as a tool call that returns a long output. Compression is
   skipped for contexts smaller than `HEADROOM_MIN_TOKENS` (default `1000`).
3. Open the **Usage details** overlay in the chat header. When tokens were saved, a **Tokens saved (Headroom)** row
   appears.

Aggregated savings by strategy and over time are shown in
[Context Compression (Headroom) Analytics](../../../user-guide/analytics/headroom-analytics.md).

If the row never appears, check that `HEADROOM_MODE` is not `off`, that `features:headroom` is enabled, that the
process was restarted after the change, and that the logs contain no Headroom errors.
