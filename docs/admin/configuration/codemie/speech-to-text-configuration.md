---
id: speech-to-text-configuration
sidebar_position: 7
title: Speech-to-Text Configuration
sidebar_label: Speech-to-Text
description: Configure speech-to-text (STT) models in AI/Run CodeMie, including models that come from LiteLLM Proxy
pagination_prev: admin/configuration/index
pagination_next: null
---

# Speech-to-Text Configuration

## Overview

Speech-to-text (STT) turns a voice recording into text. In AI/Run CodeMie, a user records a voice message in the chat input. CodeMie sends the audio to an STT model and puts the text in the input field.

CodeMie can use two sources of STT models:

- One model configured with the `STT_API_*` environment variables.
- Any number of models added to LiteLLM Proxy with the mode `audio_transcription`.

CodeMie finds the LiteLLM models by itself. You do not add them to a CodeMie configuration file. The voice recording flow in the UI does not change.

## How CodeMie Builds the Model List

CodeMie shows the same list of STT models to all users who are allowed to use them. The list depends on what you configured.

| Your deployment has                                | Models in the list                                   | Default model           |
| -------------------------------------------------- | ---------------------------------------------------- | ----------------------- |
| Only the `STT_API_*` variables                     | The environment model                                | The environment model   |
| `STT_API_*` variables and LiteLLM STT models       | The environment model first, then the LiteLLM models | The environment model   |
| Only LiteLLM STT models (no `STT_API_*` variables) | The LiteLLM models                                   | The first LiteLLM model |

If a LiteLLM model has the same name as the environment model, CodeMie uses the LiteLLM model.

Existing deployments that use only the `STT_API_*` variables need no change.

## Prerequisites

- To use LiteLLM STT models, set `LLM_PROXY_MODE=lite_llm`. In other modes, CodeMie lists only the environment model.
- A running [LiteLLM Proxy](../../../deployment/extensions/litellm-proxy/) that CodeMie can reach.
- A speech-to-text model that LiteLLM can call through the OpenAI-compatible `/audio/transcriptions` endpoint.

## Option 1: Configure One Model with Environment Variables

Set these variables for the CodeMie API. For the full list of parameters, see the [STT section of API Configuration](./api-configuration.md#speech-to-text-stt).

| Parameter                 | Description                            |
| ------------------------- | -------------------------------------- |
| `STT_API_URL`             | Endpoint of the STT service            |
| `STT_API_KEY`             | Authentication key for the STT service |
| `STT_API_DEPLOYMENT_NAME` | Deployment name, for Azure OpenAI      |
| `STT_MODEL_NAME`          | Model name, for example `whisper-1`    |

If the `STT_API_*` variables are incomplete and no LiteLLM STT model exists, CodeMie returns HTTP 503 with the message "Speech recognition is not configured".

## Option 2: Add a Model in LiteLLM Proxy

Add the model to `model_list` in the LiteLLM Proxy `config.yaml`. Set `model_info.mode` to `audio_transcription`. CodeMie lists the model after the next model refresh. CodeMie does not show these models as chat models.

```yaml
model_list:
  - model_name: example-stt
    litellm_params:
      model: openai/whisper-1
      api_key: os.environ/EXAMPLE_STT_API_KEY
    model_info:
      mode: audio_transcription
      label: 'Example STT'
      stt_config:
        default_language: 'de'
        forward_request_headers: ['x-conversation-id', 'x-conversation-trace-id']
        response_headers: ['x-transaction-id', 'x-file-uri']
        response_body_fields: []
        request_timeout_seconds: 120
```

:::warning Realtime models
CodeMie does not support the mode `realtime`. That mode is for streaming over a websocket. CodeMie does not list models with this mode. A model for file transcription must have the mode `audio_transcription`.
:::

For the other fields of a LiteLLM model entry, see [LiteLLM Model Configuration](../extensions/litellm-proxy/model-configuration.md).

### The `stt_config` Key

`stt_config` is optional. It goes in the `model_info` of the model in the LiteLLM Proxy `config.yaml`. It is not a CodeMie environment variable. It applies only to LiteLLM models. The environment model has no `stt_config`.

| Field                     | Type            | Default | Description                                                                           |
| ------------------------- | --------------- | ------- | ------------------------------------------------------------------------------------- |
| `default_language`        | string          | none    | Default language of this model. The request language wins. Example: `de`              |
| `forward_request_headers` | list of strings | `[]`    | Headers of the incoming CodeMie request that CodeMie sends to the AI Gateway          |
| `response_headers`        | list of strings | `[]`    | Provider response headers that CodeMie returns to the caller and records in Langfuse  |
| `response_body_fields`    | list of strings | `[]`    | Extra top-level fields of the provider response body that CodeMie returns and records |
| `request_timeout_seconds` | number          | `300`   | Timeout for a call to this model. The value must be greater than 0                    |

If `stt_config` is invalid, CodeMie writes a message to the log and ignores it. The model stays in the list.

### Header and Field Matching

The three lists use the same matching rules:

- CodeMie ignores letter case in names.
- A name that ends with `*` matches every name that starts with the same text. For example, `x-provider-*` matches `x-provider-id`.
- A pattern that is only `*` is not allowed. CodeMie ignores it and writes a warning to the log.

LiteLLM passes provider headers with the prefix `llm_provider-`. CodeMie removes this prefix before it matches the names. Write the names in `response_headers` without the prefix.

CodeMie never forwards these request headers. No list can override this:

- Headers in `FORWARDED_HEADERS_BLOCKLIST`. The default value is `authorization,cookie,set-cookie,x-api-key,x-auth-token,x-internal-secret,x-internal-token`.
- Headers that only apply to one network hop, for example `host` and `content-length`.

The same rules block provider response headers. CodeMie also drops a header whose value HTTP cannot carry.

A model forwards only the headers that its `forward_request_headers` list names. For this reason, CodeMie does not send `x-userinfo` unless it is in `forward_request_headers`.

To block more header names in all models, add them to `FORWARDED_HEADERS_BLOCKLIST`.

:::note
The AI Gateway must pass client headers on to the provider. This is a LiteLLM setting. If the provider needs the headers, make sure that this setting is on in the LiteLLM configuration.
:::

### How CodeMie Chooses the Language

CodeMie chooses the language in this order:

1. The `language` field of the request.
2. The `default_language` of the model.
3. No language. The model detects the language.

The environment model has no `default_language`. It gets a language only from the request.

## Verify the Configuration

1. Call `GET /v1/audio_transcription_models` with a valid user token.
2. Make sure that the response lists the expected model. The environment model is first.
3. Call `GET /v1/user/data`. Make sure that `stt_support` is `true`. If at least one STT model is available to the user, this value is `true`.
4. Record a voice message in the chat input. Make sure that the text appears in the input field.

## API Reference

### List STT Models

`GET /v1/audio_transcription_models`

The response is a list of models that the user can use. Use the `base_name` of a model as the `model` value in the next call.

### Transcribe Audio

`POST /v1/speech-recognition`

Send a `multipart/form-data` request.

| Form field        | Required | Description                                                                                   |
| ----------------- | -------- | --------------------------------------------------------------------------------------------- |
| `file`            | Yes      | The audio file                                                                                |
| `model`           | No       | The `base_name` of an STT model. The default is the first model in the list                   |
| `language`        | No       | Language hint as an ISO-639-1 code, for example `en`                                          |
| `conversation_id` | No       | ID of the conversation. CodeMie uses it to group the STT trace with other conversation traces |

CodeMie accepts these audio formats: `.flac`, `.mp3`, `.mp4`, `.mpeg`, `.mpga`, `.m4a`, `.ogg`, `.wav` and `.webm`. CodeMie names the file from the real audio format. If it cannot find the format, it uses `audio.wav`.

```bash
curl -X POST "<codemie-api-url>/v1/speech-recognition" \
  -H "Authorization: Bearer <token>" \
  -F "file=@recording.webm" \
  -F "model=example-stt" \
  -F "language=de"
```

The transcribed text is in the `message` field of the response. CodeMie returns the response headers that match `response_headers` as HTTP response headers. CodeMie also returns the matched headers and body fields in the `data` field.

### Errors

| HTTP status | Cause                                                                                          |
| ----------- | ---------------------------------------------------------------------------------------------- |
| 400         | The `model` value is unknown or not allowed for the user, or the provider rejected the request |
| 413         | The audio file is too large for the provider                                                   |
| 429         | The provider rate limit is reached                                                             |
| 503         | The provider is not available, or CodeMie has no STT model configured                          |
| 504         | The call timed out. See `request_timeout_seconds`                                              |
| 502         | Any other provider or gateway error                                                            |

The provider message is in the `details` field of the error.

## Observability

Each STT call creates a trace named `Audio Transcription` in Langfuse. The trace has one generation named `stt.transcribe`. If Phoenix is the active provider, CodeMie records the same data in Phoenix. If observability is off, STT works as before.

The generation records:

- The model and the language.
- The name and size of the audio file.
- The transcript.
- The usage that the provider returns, as tokens or audio seconds.
- On a failed call, the error text.

The trace records the CodeMie user ID, the tag `stt`, and the transcript. It also records the forwarded request headers, and the matched response headers and body fields.

CodeMie never sends the audio content to the observability tool.

## Troubleshooting

| Problem                                         | Solution                                                                                                 |
| ----------------------------------------------- | -------------------------------------------------------------------------------------------------------- |
| LiteLLM STT model is missing from the list      | Make sure that `LLM_PROXY_MODE` is `lite_llm`. Make sure that `model_info.mode` is `audio_transcription` |
| HTTP 503 "Speech recognition is not configured" | Set all `STT_API_*` variables, or add a LiteLLM STT model                                                |
| HTTP 400 for a model name                       | Use a `base_name` from `GET /v1/audio_transcription_models`                                              |
| HTTP 504 for long audio                         | Increase `request_timeout_seconds` in the `stt_config` of the model                                      |
| Provider headers are missing in the response    | Make sure that the names in `response_headers` match. Write them without the `llm_provider-` prefix      |
| The provider does not receive a header          | Make sure that the name is in `forward_request_headers` and not in `FORWARDED_HEADERS_BLOCKLIST`         |
| The transcript is in the wrong language         | Send the `language` field, or set `default_language` in the `stt_config` of the model                    |
