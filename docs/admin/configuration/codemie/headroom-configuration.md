---
id: headroom-configuration
title: Headroom Context Compression Configuration
sidebar_label: Headroom Context Compression
sidebar_position: 6
pagination_prev: admin/configuration/index
pagination_next: null
---

# Headroom Context Compression Configuration

Headroom compresses the messages that AI/Run CodeMie sends to the model on every model call of an assistant or a workflow node, which reduces token usage. Assistant owners turn it on per assistant, and workflow authors can override it per workflow or per node. For the user-facing behavior, see [Context Compression (Headroom)](../../../user-guide/assistants/context-compression.md).

This page describes what has to be deployed and configured on the platform side before users can turn the feature on.

## How It Works

1. An assistant or a workflow node with an enabled Headroom configuration is about to call the model.
2. The CodeMie API sends the messages to the Headroom compressor and waits for the result, at most `HEADROOM_TIMEOUT_SECONDS`.
3. The compressed messages go to the model. Only user messages and tool results are compressed; system prompts and earlier assistant replies always reach the model unchanged.
4. When tokens were saved, the saving is recorded with the conversation or workflow execution, emitted as the `headroom_compaction_usage` metric and shown in Analytics.

The compressor fails open: if it is unavailable, times out or returns an error, the original messages go to the model unchanged. A broken Headroom deployment never breaks a conversation, but it also silently stops saving tokens.

## Enablement Requirements

Compression runs only when **both** of the following are true:

| Requirement      | Where                                | Value                                                   |
| ---------------- | ------------------------------------ | ------------------------------------------------------- |
| Compression mode | `HEADROOM_MODE` on the `codemie-api` | `sidecar` or `sdk`. The default `off` disables Headroom |
| Feature flag     | `customer-config.yaml`               | `features:headroom` component with `enabled: true`      |

The feature flag also controls the UI: the Headroom settings on the assistant form, the workflow and node settings and the **Context Compression** section of Analytics are hidden while the flag is off. See [Customer Feature Configuration — Headroom](./customer-feature-configuration.md#headroom).

A configuration that users saved earlier is kept while either requirement is not met, and it is ignored at runtime.

## Compression Modes

`HEADROOM_MODE` selects where compression runs. A deployment runs one mode at a time. The value is read once per process, so a change takes effect after the `codemie-api` pods restart.

| Mode            | Where compression runs                                           | Extra requirements                                                                        |
| --------------- | ---------------------------------------------------------------- | ----------------------------------------------------------------------------------------- |
| `off` (default) | Nowhere                                                          | None                                                                                      |
| `sidecar`       | A separate Headroom container, called over HTTP (`/v1/compress`) | The Headroom sidecar must be deployed and reachable from `codemie-api`                    |
| `sdk`           | Inside the `codemie-api` process, in a worker thread             | A `codemie-api` image built with the Headroom SDK. The standard image does not include it |

Both modes accept the same strategies and report savings the same way. Compression works with and without LiteLLM.

:::tip Recommended mode
Use `sidecar`. It keeps the Headroom package and the ML model out of the API process and does not require a custom API image.
:::

## Sidecar Mode

### Sidecar Requirements

The sidecar is the Headroom server image. Deploy it either as an additional container in the `codemie-api` pod or as a separate service, with the deployment tooling used for the rest of the platform. The requirements below apply in both cases; the examples use plain Kubernetes manifests and can be translated to any Helm chart, Kustomize overlay or other tooling.

| Item            | Value                                                                                                                        |
| --------------- | ---------------------------------------------------------------------------------------------------------------------------- |
| Image           | `ghcr.io/headroomlabs-ai/headroom:0.40.0`. Mirror it to the internal registry if `ghcr.io` is not reachable from the cluster |
| Port            | `8787` (HTTP). Do not expose it outside the cluster                                                                          |
| Readiness probe | `GET /readyz` on port `8787`                                                                                                 |
| Memory          | About 770 MiB for the Kompress model. Set a limit of at least 2 GiB                                                          |
| Outbound access | HuggingFace, on first start, to download the Kompress model. See [Kompress Model](#kompress-model)                           |

Set the following environment variables on the sidecar container:

| Variable                         | Value     | Purpose                                                                                      |
| -------------------------------- | --------- | -------------------------------------------------------------------------------------------- |
| `HEADROOM_HOST`                  | `0.0.0.0` | The image listens on `127.0.0.1` by default; the API must be able to reach it                |
| `HEADROOM_COMPRESS_ALLOW_REMOTE` | `1`       | `/v1/compress` accepts only loopback callers otherwise                                       |
| `HEADROOM_PROXY_TOKEN`           | secret    | Bearer token. Must be equal to the value on `codemie-api`. See [Access Token](#access-token) |
| `HEADROOM_LOSSLESS`              | `1`       | Required for the `lossless` strategy                                                         |
| `HEADROOM_SKIP_UPSTREAM_CHECK`   | `1`       | Keeps the readiness probe from calling `api.anthropic.com`                                   |
| `HEADROOM_OFFLINE`               | `0`       | Allows the Kompress model download. Set `1` only when the model is pre-loaded                |
| `HEADROOM_BEACON`                | `off`     | Disables Headroom telemetry                                                                  |
| `DO_NOT_TRACK`                   | `1`       | Disables Headroom telemetry                                                                  |

Example container definition:

```yaml
- name: headroom
  image: ghcr.io/headroomlabs-ai/headroom:0.40.0
  ports:
    - containerPort: 8787
  env:
    - name: HEADROOM_HOST
      value: '0.0.0.0'
    - name: HEADROOM_COMPRESS_ALLOW_REMOTE
      value: '1'
    - name: HEADROOM_LOSSLESS
      value: '1'
    - name: HEADROOM_SKIP_UPSTREAM_CHECK
      value: '1'
    - name: HEADROOM_OFFLINE
      value: '0'
    - name: HEADROOM_BEACON
      value: 'off'
    - name: DO_NOT_TRACK
      value: '1'
    - name: HEADROOM_PROXY_TOKEN
      valueFrom:
        secretKeyRef:
          name: codemie-headroom
          key: HEADROOM_PROXY_TOKEN
  readinessProbe:
    httpGet:
      path: /readyz
      port: 8787
  resources:
    limits:
      memory: 2Gi
```

### Access Token

The sidecar requires a bearer token from every non-loopback caller. Without a token it refuses to listen on `0.0.0.0` and the container exits. The same value must be set on the sidecar and on `codemie-api`.

Generate a value and store it in a Kubernetes secret:

```bash
kubectl create secret generic codemie-headroom \
  --namespace codemie \
  --from-literal=HEADROOM_PROXY_TOKEN="$(openssl rand -hex 32)"
```

:::warning Create the secret first
A `secretKeyRef` that points to a missing secret prevents the pods from starting. Create the secret before the containers that reference it.
:::

### API Settings for Sidecar Mode

Set the mode, the sidecar URL and the token as environment variables of the `codemie-api` container:

```yaml
env:
  - name: HEADROOM_MODE
    value: 'sidecar'
  - name: HEADROOM_SIDECAR_URL
    value: 'http://localhost:8787' # a container in the same pod; use the service URL for a separate service
  - name: HEADROOM_PROXY_TOKEN
    valueFrom:
      secretKeyRef:
        name: codemie-headroom
        key: HEADROOM_PROXY_TOKEN
```

## SDK Mode

In SDK mode the `headroom-ai` package runs inside the `codemie-api` process, and no sidecar is needed. The standard `codemie-api` image does not contain the package. Build a custom image with the `INSTALL_HEADROOM_SDK` build argument:

| `INSTALL_HEADROOM_SDK` | Result                                                                                            |
| ---------------------- | ------------------------------------------------------------------------------------------------- |
| `false` (default)      | No Headroom SDK                                                                                   |
| `true`                 | Headroom SDK without Kompress. Only structured content (JSON, logs, code) is compressed           |
| `ml`                   | Headroom SDK with Kompress. Adds `transformers`, `onnxruntime` and `huggingface-hub` to the image |

```bash
docker build --build-arg INSTALL_HEADROOM_SDK=ml -t codemie-api:headroom .
```

Any other value fails the image build. With `HEADROOM_MODE=sdk` on an image without the SDK, the API logs one error and every request goes to the model uncompressed.

With `ml`, the Kompress model needs about 770 MiB of additional memory in every `codemie-api` pod. The model is downloaded only when `HEADROOM_SDK_ALLOW_MODEL_DOWNLOAD=true` or when it is already cached in the pod.

Environment variables of the `codemie-api` container:

```yaml
env:
  - name: HEADROOM_MODE
    value: 'sdk'
  - name: HEADROOM_SDK_ALLOW_MODEL_DOWNLOAD
    value: 'true'
```

SDK mode forces `HEADROOM_BEACON=off`, `DO_NOT_TRACK=1` and `HEADROOM_CCR_BACKEND=memory` in the API process and logs a warning if a different value was inherited. A `HEADROOM_OFFLINE` value set on the pod is kept, so `HEADROOM_OFFLINE=1` prevents the model download.

## Kompress Model

Free-form text such as user messages and prose in tool results is compressed by the Kompress ML model (`chopratejas/kompress-v2-base`). Without the model, only structured content (JSON, logs, code) is reduced, and the `aggressive` strategy behaves exactly like `balanced`.

- **Sidecar**: the model is downloaded from HuggingFace on first start when `HEADROOM_OFFLINE=0`. With `HEADROOM_OFFLINE=1` the sidecar logs `Kompress model not ready; requests will not be compressed`.
- **SDK**: the model is available only with the `ml` image and either a cached model or `HEADROOM_SDK_ALLOW_MODEL_DOWNLOAD=true`. Without it, the API logs one warning on first use.
- **Air-gapped deployments**: pre-load the model into the image or into a mounted volume and set `HEADROOM_OFFLINE=1`.

## Environment Variables Reference

Variables of the `codemie-api` service:

| Variable                            | Type    | Default                 | Description                                                                                     |
| ----------------------------------- | ------- | ----------------------- | ----------------------------------------------------------------------------------------------- |
| `HEADROOM_MODE`                     | string  | `off`                   | `off`, `sdk` or `sidecar`. Case-insensitive; an empty value counts as `off`. Requires a restart |
| `HEADROOM_SIDECAR_URL`              | string  | `http://localhost:8787` | Base URL of the sidecar. The default points to a container in the same pod                      |
| `HEADROOM_PROXY_TOKEN`              | string  | empty                   | Bearer token for the sidecar. Secret; must be equal to the sidecar value                        |
| `HEADROOM_TIMEOUT_SECONDS`          | integer | `10`                    | Maximum time a model call waits for compression before the original messages are sent           |
| `HEADROOM_MIN_TOKENS`               | integer | `1000`                  | Messages below this size are not compressed                                                     |
| `HEADROOM_AGGRESSIVE_TARGET_RATIO`  | float   | `0.2`                   | Fraction of tokens kept by the `aggressive` strategy. Has an effect only where Kompress runs    |
| `HEADROOM_SDK_ALLOW_MODEL_DOWNLOAD` | boolean | `false`                 | SDK mode only: allow the API process to download the Kompress model                             |

The compression call blocks every model call of a configured assistant for up to `HEADROOM_TIMEOUT_SECONDS`. Keep the value low; a slow compressor adds latency to every answer.

`aggressive` is very lossy at the default ratio: in a test, a 121-token paragraph came back as 37 tokens of fragments, against 99 tokens with `balanced`. Raise `HEADROOM_AGGRESSIVE_TARGET_RATIO` if users report degraded answers.

## Rollout Checklist

1. Run the database migrations of the release before the new `codemie-api` version starts. Revision `d5241114c3dd` adds a nullable `headroom_config` column to the `assistants` and `workflows` tables.
2. Choose the mode:
   - **Sidecar**: create the `HEADROOM_PROXY_TOKEN` secret and deploy the sidecar as described in [Sidecar Requirements](#sidecar-requirements).
   - **SDK**: build and deploy a `codemie-api` image with `INSTALL_HEADROOM_SDK=true` or `ml`.
3. Set `HEADROOM_MODE` and the related variables on `codemie-api` and restart the pods.
4. Add the `features:headroom` component to `customer-config.yaml` with `enabled: true`.
5. Verify: enable compression on a test assistant, send a message with a large tool output, and check that the chat usage details show **Tokens saved (Headroom)**.

## Troubleshooting

| Symptom                                                                 | Cause and solution                                                                                     |
| ----------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------ |
| Headroom settings are not visible in the UI                             | `features:headroom` is missing or disabled in `customer-config.yaml`                                   |
| Settings are visible, but no tokens are saved                           | `HEADROOM_MODE` is `off`, or the pods were not restarted after the change                              |
| The sidecar container exits on start                                    | `HEADROOM_PROXY_TOKEN` is not set on the sidecar                                                       |
| API logs show authentication errors from the sidecar                    | `HEADROOM_PROXY_TOKEN` differs between the sidecar and `codemie-api`                                   |
| Only JSON, logs and code are compressed; `aggressive` equals `balanced` | The Kompress model is not loaded. Check outbound access to HuggingFace or pre-load the model           |
| SDK mode saves nothing and the API logs an import error                 | The `codemie-api` image was built without `INSTALL_HEADROOM_SDK`                                       |
| Answers became slower                                                   | Compression takes most of `HEADROOM_TIMEOUT_SECONDS`. Check the sidecar resources or lower the timeout |

## Limitations

- Compression applies to LangGraph assistants and workflow nodes. It does not apply to AWS Bedrock agents, remote A2A assistants or structured-output calls.
- Only text content is compressed. Messages with images, attached files or prompt-cache markers keep their original content.
- The `balanced` and `aggressive` strategies rewrite older history, which can lower the LLM provider's prompt-cache hit rate. `lossless` keeps prompt caching intact.
- Headroom settings are not versioned with the assistant: changing them does not create a new assistant version.
