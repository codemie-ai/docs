---
id: model-configuration
title: LiteLLM Model Configuration
sidebar_label: Model Configuration
sidebar_position: 2
pagination_prev: admin/configuration/extensions/litellm-proxy/budget-configuration
pagination_next: admin/configuration/extensions/litellm-proxy/spend-logs-retention
---

# LiteLLM Model Configuration

## Overview

This guide explains how to add and configure AI models in LiteLLM Proxy for AI/Run CodeMie. LiteLLM acts as a unified gateway to multiple LLM providers.

See the official LiteLLM documentation for [supported providers and models](https://docs.litellm.ai/docs/providers).

## LiteLLM Proxy Config Structure

LiteLLM Proxy uses a `config.yaml` file to define model configurations and other settings.

:::note
In AI/Run CodeMie, this configuration is managed through Helm chart values that generate the underlying LiteLLM config.
:::

The `config.yaml` file contains five main sections:

- **`model_list`**: Array of model routing configurations
- **`litellm_settings`**: Module-level LiteLLM settings
- **`general_settings`**: Global proxy settings (authentication, alerting, etc.)
- **`router_settings`**: Load balancing and routing behavior
- **`credential_list`**: Authentication credentials for different providers

<details>
<summary><strong>Example: Config Structure</strong></summary>

```yaml
model_list:
  - model_name: fake-model-endpoint
    litellm_params:
      model: fake-model-name
    model_info:
      id: fake-model-unique-id
      base_model: fake-base-model-id
      label: "Fake Model Name for Testing"

litellm_settings:
  drop_params: True

general_settings:
  master_key: sk-1234

router_settings:
  fallbacks:
    - claude-sonnet-4-6: ["claude-4-5-sonnet"]

credential_list:
  - credential_name: default_aws_credential
    aws_access_key_id: os.environ/AWS_ACCESS_KEY_ID
    aws_secret_access_key: os.environ/AWS_SECRET_ACCESS_KEY
```

</details>

## Model Configuration Structure

Each model entry in the `model_list` array consists of three main sections:

**`model_name`**

- The model name users specify when making API calls to LiteLLM

  <details>
  <summary><strong>Example: Basic Configuration</strong></summary>

  ```yaml
  model_list:
    - model_name: claude-sonnet-4-5-20250929
      # ... additional configuration fields

    - model_name: claude-sonnet-4-6
    # ... additional configuration fields
  ```

  </details>

- Multiple entries can share the same `model_name` for load balancing

  <details>
  <summary><strong>Example: Load Balancing Configuration</strong></summary>

  ```yaml
  model_list:
    - model_name: claude-sonnet-4-5-20250929
      model_info:
        id: claude-sonnet-4-5-20250929-unique-id-0
      # ... additional configuration fields

    - model_name: claude-sonnet-4-5-20250929
      model_info:
        id: claude-sonnet-4-5-20250929-unique-id-1
      # ... additional configuration fields
  ```

  </details>

**`litellm_params`**

- **`model`**: Backend provider model identifier

  <details>
  <summary><strong>Example: Model Identifiers</strong></summary>

  ```yaml
  model_list:
    - model_name: claude-sonnet-4-5-20250929
      litellm_params:
        model: bedrock/us.anthropic.claude-sonnet-4-5-20250929-v1:0
      # ... additional configuration fields

    - model_name: gpt-5-2025-08-07
      litellm_params:
        model: azure/gpt-5-2025-08-07
      # ... additional configuration fields

    - model_name: gemini-3-pro
      litellm_params:
        model: vertex_ai/gemini-3-pro-preview
      # ... additional configuration fields
  ```

  </details>

- **`litellm_credential_name`**: Reference to authentication credentials configured in secrets

  <details>
  <summary><strong>Example: Credentials Configuration</strong></summary>

  ```yaml
  model_list:
    - model_name: claude-sonnet-4-5-20250929
      litellm_params:
        model: bedrock/us.anthropic.claude-sonnet-4-5-20250929-v1:0
        litellm_credential_name: default_aws_bedrock_credential
      # ... additional configuration fields

    - model_name: gpt-5-2025-08-07
      litellm_params:
        model: azure/gpt-5-2025-08-07
        litellm_credential_name: default_azure_openai_credential
      # ... additional configuration fields

  credential_list:
    - credential_name: default_aws_bedrock_credential
      credential_values:
        aws_access_key_id: os.environ/AWS_ACCESS_KEY_ID
        aws_secret_access_key: os.environ/AWS_SECRET_ACCESS_KEY

    - credential_name: default_azure_openai_credential
      credential_values:
        tenant_id: os.environ/AZURE_TENANT_ID
        client_id: os.environ/AZURE_CLIENT_ID
        client_secret: os.environ/AZURE_CLIENT_SECRET
  ```

  </details>

**`model_info`**

- **`id`**: Unique identifier for the specific model instance
- **`base_model`**: Base model identifier to retrieve defaults from [LiteLLM models database](https://models.litellm.ai/)
- **`label`**: Human-readable display name shown in CodeMie UI
- **`forbidden_for_web`**: (Optional) Set to `true` to hide this model from CodeMie UI
- **`default_for_categories`**: Array of categories for default model selection.

  Available categories:

  | Category | Description                     |
  | -------- | ------------------------------- |
  | `global` | Default model for all tasks     |
  | `code`   | Default model for code tasks    |
  | `chat`   | Default model for conversations |

  :::warning Required defaults
  At least one **chat** model and one **embedding** model must have the `global` category assigned.
  :::

  <details>
  <summary><strong>Examples: Default Models</strong></summary>

  ```yaml
  # Note: When using load balancing with multiple entries of the same model_name,
  # all entries must have the default_for_categories field

  # Default chat model
  - model_name: gpt-4.1
    model_info:
      default_for_categories: [global]
    # ... additional configuration fields

  # Default code model
  - model_name: claude-4-5-sonnet
    model_info:
      default_for_categories: [code]
    # ... additional configuration fields

  # Default embedding model
  - model_name: codemie-text-embedding-ada-002
    model_info:
      default_for_categories: [global]
    # ... additional configuration fields
  ```

  </details>

## Model Configuration Examples

This guide provides tested and verified model configurations currently used in AI/Run CodeMie production. While not all steps for adding new models are covered (refer to the [official LiteLLM documentation](https://docs.litellm.ai/) for comprehensive setup instructions), working examples from the production environment are shared and can be adapted for any deployment.

:::tip
All configuration examples below have been validated and are actively used in CodeMie. They can be used as templates when adding similar models to the environment.
:::

## Models Reference

Configuration examples for these models can be found in the provider-specific sections below.

### AWS Bedrock Models

| Model Name                                      | Description                  |
| ----------------------------------------------- | ---------------------------- |
| [`claude-4-sonnet`](#claude-sonnet-4)           | Claude 4 Sonnet              |
| [`claude-4-sonnet-1m`](#claude-sonnet-4)        | Claude 4 Sonnet (1M context) |
| [`claude-4-5-sonnet`](#claude-sonnet-45)        | Claude 4.5 Sonnet            |
| [`claude-sonnet-4-6`](#claude-sonnet-46)        | Claude Sonnet 4.6            |
| [`claude-opus-4-5-20251101`](#claude-opus-45)   | Claude Opus 4.5              |
| [`claude-opus-4-6-20260205`](#claude-opus-46)   | Claude Opus 4.6              |
| [`claude-haiku-4-5-20251001`](#claude-haiku-45) | Claude Haiku 4.5             |
| [`amazon.titan-embed-text-v2:0`](#amazon-titan) | Amazon Titan Embeddings      |

### Azure OpenAI Models

| Model Name                                                  | Description            |
| ----------------------------------------------------------- | ---------------------- |
| [`gpt-4.1`](#gpt-41)                                        | GPT-4.1                |
| [`gpt-4.1-mini`](#gpt-41-mini)                              | GPT-4.1 mini           |
| [`gpt-5-2025-08-07`](#gpt-5)                                | GPT-5                  |
| [`gpt-5-mini-2025-08-07`](#gpt-5-mini)                      | GPT-5 mini             |
| [`gpt-5-nano-2025-08-07`](#gpt-5-nano)                      | GPT-5 nano             |
| [`gpt-5-1-codex-2025-11-13`](#gpt-51-codex)                 | GPT-5.1 Codex          |
| [`gpt-5-2-2025-12-11`](#gpt-52)                             | GPT-5.2                |
| [`o1`](#o1)                                                 | o1                     |
| [`o3-mini`](#o3-mini)                                       | o3 mini                |
| [`o3-2025-04-16`](#o3)                                      | o3                     |
| [`o4-mini-2025-04-16`](#o4-mini)                            | o4 mini                |
| [`codemie-text-embedding-ada-002`](#text-embedding-ada-002) | Text Embedding Ada-002 |

### Vertex AI Models

| Model Name                                        | Description       |
| ------------------------------------------------- | ----------------- |
| [`claude-4-5-sonnet-vertex`](#claude-sonnet-45-1) | Claude 4.5 Sonnet |
| [`gemini-2.0-flash`](#gemini-20-flash)            | Gemini 2.0 Flash  |
| [`gemini-2.5-flash`](#gemini-25-flash)            | Gemini 2.5 Flash  |
| [`gemini-2.5-pro`](#gemini-25-pro)                | Gemini 2.5 Pro    |
| [`gemini-3-flash`](#gemini-3-flash)               | Gemini 3 Flash    |
| [`gemini-3-pro`](#gemini-3-pro)                   | Gemini 3 Pro      |
| [`text-embedding-005`](#embeddings-for-text)      | Text Embedding    |

## AWS Bedrock Provider Examples

### Claude Sonnet

#### Claude Sonnet 4

<details>
<summary><strong>Claude Sonnet 4</strong></summary>

```yaml
# US Region
- model_name: claude-4-sonnet
  litellm_params:
    model: bedrock/us.anthropic.claude-sonnet-4-20250514-v1:0
    litellm_credential_name: default_aws_bedrock_credential
    aws_region_name: us-west-2
  model_info:
    id: claude-4-sonnet-us-west-2
    base_model: us.anthropic.claude-sonnet-4-20250514-v1:0
    label: "Bedrock Claude 4 Sonnet"

# EU Region
- model_name: claude-4-sonnet
  litellm_params:
    model: bedrock/eu.anthropic.claude-sonnet-4-20250514-v1:0
    litellm_credential_name: default_aws_bedrock_credential
    aws_region_name: eu-central-1
  model_info:
    id: claude-4-sonnet-eu-central-1
    base_model: eu.anthropic.claude-sonnet-4-20250514-v1:0
    label: "Bedrock Claude 4 Sonnet"
```

</details>

<details>
<summary><strong>Claude Sonnet 4 with 1M context window</strong></summary>

```yaml
- model_name: claude-4-sonnet-1m
  litellm_params:
    model: bedrock/us.anthropic.claude-sonnet-4-20250514-v1:0
    litellm_credential_name: default_aws_bedrock_credential
    aws_region_name: us-west-2
    extra_headers:
      anthropic-beta: "context-1m-2025-08-07"
  model_info:
    id: claude-4-sonnet-1m-us-west-2
    base_model: us.anthropic.claude-sonnet-4-20250514-v1:0
    label: "Bedrock Claude 4 Sonnet 1M"
```

</details>

#### Claude Sonnet 4.5

<details>
<summary><strong>Claude 4.5 Sonnet</strong></summary>

```yaml
# US Region
- model_name: claude-4-5-sonnet
  litellm_params:
    model: bedrock/us.anthropic.claude-sonnet-4-5-20250929-v1:0
    litellm_credential_name: default_aws_bedrock_credential
    aws_region_name: us-west-2
  model_info:
    id: claude-4-5-sonnet-us-west-2
    base_model: us.anthropic.claude-sonnet-4-5-20250929-v1:0
    label: "Bedrock Claude 4.5 Sonnet"

# EU Region
- model_name: claude-4-5-sonnet
  litellm_params:
    model: bedrock/eu.anthropic.claude-sonnet-4-5-20250929-v1:0
    litellm_credential_name: default_aws_bedrock_credential
    aws_region_name: eu-central-1
  model_info:
    id: claude-4-5-sonnet-eu-central-1
    base_model: eu.anthropic.claude-sonnet-4-5-20250929-v1:0
    label: "Bedrock Claude 4.5 Sonnet"

# Global routing
- model_name: claude-4-5-sonnet
  litellm_params:
    model: bedrock/global.anthropic.claude-sonnet-4-5-20250929-v1:0
    litellm_credential_name: default_aws_bedrock_credential
    aws_region_name: us-west-2
  model_info:
    id: claude-4-5-sonnet-global-us-west-2
    base_model: global.anthropic.claude-sonnet-4-5-20250929-v1:0
    label: "Bedrock Claude 4.5 Sonnet"
```

</details>

#### Claude Sonnet 4.6

<details>
<summary><strong>Claude Sonnet 4.6</strong></summary>

```yaml
# US Region
- model_name: claude-sonnet-4-6
  litellm_params:
    model: bedrock/us.anthropic.claude-sonnet-4-6
    litellm_credential_name: default_aws_bedrock_credential
    aws_region_name: us-east-1
  model_info:
    id: claude-sonnet-4-6-us-east-1
    base_model: us.anthropic.claude-sonnet-4-6
    label: "Bedrock Claude Sonnet 4.6"
```

</details>

### Claude Haiku

#### Claude Haiku 4.5

<details>
<summary><strong>Claude Haiku 4.5</strong></summary>

```yaml
# US Region
- model_name: claude-haiku-4-5-20251001
  litellm_params:
    model: bedrock/converse/us.anthropic.claude-haiku-4-5-20251001-v1:0
    litellm_credential_name: default_aws_bedrock_credential
    aws_region_name: us-west-2
  model_info:
    id: claude-4-5-haiku-us-west-2
    base_model: us.anthropic.claude-haiku-4-5-20251001-v1:0
    label: "Bedrock Claude Haiku 4.5"

# EU Region
- model_name: claude-haiku-4-5-20251001
  litellm_params:
    model: bedrock/converse/eu.anthropic.claude-haiku-4-5-20251001-v1:0
    litellm_credential_name: default_aws_bedrock_credential
    aws_region_name: eu-central-1
  model_info:
    id: claude-4-5-haiku-eu-central-1
    base_model: eu.anthropic.claude-haiku-4-5-20251001-v1:0
    label: "Bedrock Claude Haiku 4.5"
```

</details>

### Claude Opus

#### Claude Opus 4.5

<details>
<summary><strong>Claude Opus 4.5</strong></summary>

```yaml
# US Region
- model_name: claude-opus-4-5-20251101
  litellm_params:
    model: bedrock/us.anthropic.claude-opus-4-5-20251101-v1:0
    litellm_credential_name: default_aws_bedrock_credential
    aws_region_name: us-west-2
  model_info:
    id: claude-opus-4-5-20251101-us-west-2
    base_model: us.anthropic.claude-opus-4-5-20251101-v1:0
    label: "Bedrock Claude Opus 4.5"

# EU Region
- model_name: claude-opus-4-5-20251101
  litellm_params:
    model: bedrock/eu.anthropic.claude-opus-4-5-20251101-v1:0
    litellm_credential_name: default_aws_bedrock_credential
    aws_region_name: eu-central-1
  model_info:
    id: claude-opus-4-5-20251101-eu-central-1
    base_model: anthropic.claude-opus-4-5-20251101-v1:0
    label: "Bedrock Claude Opus 4.5"
```

</details>

#### Claude Opus 4.6

<details>
<summary><strong>Claude Opus 4.6</strong></summary>

```yaml
# US Region
- model_name: claude-opus-4-6-20260205
  litellm_params:
    model: bedrock/us.anthropic.claude-opus-4-6-v1
    litellm_credential_name: default_aws_bedrock_credential
    aws_region_name: us-west-2
  model_info:
    id: claude-opus-4-6-20260205-us-west-2
    base_model: us.anthropic.claude-opus-4-6-v1
    label: "Bedrock Claude Opus 4.6"

# EU Region
- model_name: claude-opus-4-6-20260205
  litellm_params:
    model: bedrock/eu.anthropic.claude-opus-4-6-v1
    litellm_credential_name: default_aws_bedrock_credential
    aws_region_name: eu-central-1
  model_info:
    id: claude-opus-4-6-20260205-eu-central-1
    base_model: eu.anthropic.claude-opus-4-6-v1
    label: "Bedrock Claude Opus 4.6"
```

</details>

### Amazon Titan

<details>
<summary><strong>Amazon Titan</strong></summary>

```yaml
# US Region
- model_name: amazon.titan-embed-text-v2:0
  litellm_params:
    model: bedrock/amazon.titan-embed-text-v2:0
    litellm_credential_name: default_aws_bedrock_credential
    aws_region_name: us-west-2
  model_info:
    id: titan-us-west-2
    base_model: amazon.titan-embed-text-v2:0
    label: "Titan Embed Text v2.0"

# EU Region
- model_name: amazon.titan-embed-text-v2:0
  litellm_params:
    model: bedrock/amazon.titan-embed-text-v2:0
    litellm_credential_name: default_aws_bedrock_credential
    aws_region_name: eu-central-1
  model_info:
    id: titan-eu-central-1
    base_model: amazon.titan-embed-text-v2:0
    label: "Titan Embed Text v2.0"
```

</details>

## Azure OpenAI Provider Examples

### GPT-4.1

#### GPT-4.1

<details>
<summary><strong>GPT-4.1</strong></summary>

```yaml
# US Region
- model_name: gpt-4.1
  litellm_params:
    model: azure/gpt-4.1-2025-04-14
    api_base: https://api-base-eastus-0.openai.azure.com/
    litellm_credential_name: default_azure_openai_credential
  model_info:
    id: gpt-4.1-eastus-0
    base_model: azure/gpt-4.1-2025-04-14
    label: "GPT-4.1 2025-04-14"

# EU Region
- model_name: gpt-4.1
  litellm_params:
    model: azure/gpt-4.1-2025-04-14
    api_base: https://api-base-eastus-0.openai.azure.com/
    litellm_credential_name: default_azure_openai_credential
  model_info:
    id: gpt-4.1-swedencentral-0
    base_model: azure/gpt-4.1-2025-04-14
    label: "GPT-4.1 2025-04-14"
```

</details>

#### GPT-4.1 Mini

<details>
<summary><strong>GPT-4.1 Mini</strong></summary>

```yaml
- model_name: gpt-4.1-mini
  litellm_params:
    model: azure/gpt-4.1-mini-2025-04-14
    api_base: https://api-base-swedencentral-0.openai.azure.com/
    litellm_credential_name: default_azure_openai_credential
  model_info:
    id: gpt-4.1-mini-swedencentral-0
    base_model: azure/gpt-4.1-mini-2025-04-14
    label: "GPT-4.1 mini 2025-04-14"
```

</details>

### GPT-5

#### GPT-5

<details>
<summary><strong>GPT-5</strong></summary>

```yaml
# US Region
- model_name: gpt-5-2025-08-07
  litellm_params:
    model: azure/gpt-5-2025-08-07
    api_base: https://api-base-eastus-0.openai.azure.com/
    litellm_credential_name: default_azure_openai_credential
  model_info:
    id: gpt-5-2025-08-07-eastus-0
    base_model: azure/gpt-5-2025-08-07
    label: "GPT-5 2025-08-07"
    top_p: false

# EU Region
- model_name: gpt-5-2025-08-07
  litellm_params:
    model: azure/gpt-5-2025-08-07
    api_base: https://api-base-swedencentral-0.openai.azure.com/
    litellm_credential_name: default_azure_openai_credential
  model_info:
    id: gpt-5-2025-08-07-swedencentral-0
    base_model: azure/gpt-5-2025-08-07
    label: "GPT-5 2025-08-07"
    top_p: false
```

</details>

#### GPT-5 Mini

<details>
<summary><strong>GPT-5 Mini</strong></summary>

```yaml
# US Region
- model_name: gpt-5-mini-2025-08-07
  litellm_params:
    model: azure/gpt-5-mini-2025-08-07
    api_base: https://api-base-eastus2-0.openai.azure.com/
    litellm_credential_name: default_azure_openai_credential
  model_info:
    id: gpt-5-mini-2025-08-07-eastus2-0
    base_model: azure/gpt-5-mini-2025-08-07
    label: "GPT-5 Mini 2025-08-07"
    top_p: false

# EU Region
- model_name: gpt-5-mini-2025-08-07
  litellm_params:
    model: azure/gpt-5-mini-2025-08-07
    api_base: https://api-base-swedencentral-0.openai.azure.com/
    litellm_credential_name: default_azure_openai_credential
  model_info:
    id: gpt-5-mini-2025-08-07-swedencentral-0
    base_model: azure/gpt-5-mini-2025-08-07
    label: "GPT-5 Mini 2025-08-07"
    top_p: false
```

</details>

#### GPT-5 Nano

<details>
<summary><strong>GPT-5 Nano</strong></summary>

```yaml
# US Region
- model_name: gpt-5-nano-2025-08-07
  litellm_params:
    model: azure/gpt-5-nano-2025-08-07
    api_base: https://api-base-eastus2-0.openai.azure.com/
    litellm_credential_name: default_azure_openai_credential
  model_info:
    id: gpt-5-nano-2025-08-07-eastus2-0
    base_model: azure/gpt-5-nano-2025-08-07
    label: "GPT-5 Nano 2025-08-07"
    top_p: false

# EU Region
- model_name: gpt-5-nano-2025-08-07
  litellm_params:
    model: azure/gpt-5-nano-2025-08-07
    api_base: https://api-base-swedencentral-0.openai.azure.com/
    litellm_credential_name: default_azure_openai_credential
  model_info:
    id: gpt-5-nano-2025-08-07-swedencentral-0
    base_model: azure/gpt-5-nano-2025-08-07
    label: "GPT-5 Nano 2025-08-07"
    top_p: false
```

</details>

#### GPT-5.1 Codex

<details>
<summary><strong>GPT-5.1 Codex</strong></summary>

```yaml
# US Region
- model_name: gpt-5-1-codex-2025-11-13
  litellm_params:
    model: azure/gpt-5.1-codex-2025-11-13
    api_base: https://api-base-eastus2-0.openai.azure.com/
    litellm_credential_name: default_azure_openai_credential
  model_info:
    id: gpt-5-1-codex-2025-11-13-eastus2-0
    base_model: azure/gpt-5.1-codex-2025-11-13
    label: "GPT-5.1 Codex 2025-11-13"
    forbidden_for_web: true

# EU Region
- model_name: gpt-5-1-codex-2025-11-13
  litellm_params:
    model: azure/gpt-5.1-codex-2025-11-13
    api_base: https://api-base-swedencentral-0.openai.azure.com/
    litellm_credential_name: default_azure_openai_credential
  model_info:
    id: gpt-5-1-codex-2025-11-13-swedencentral-0
    base_model: azure/gpt-5.1-codex-2025-11-13
    label: "GPT-5.1 Codex 2025-11-13"
    forbidden_for_web: true
```

</details>

#### GPT-5.2

<details>
<summary><strong>GPT-5.2</strong></summary>

```yaml
# US Region
- model_name: gpt-5-2-2025-12-11
  litellm_params:
    model: azure/codemie-gpt-5.2-2025-12-11
    api_base: https://api-base-eastus2-0.openai.azure.com/
    litellm_credential_name: default_azure_openai_credential
  model_info:
    id: gpt-5-2-2025-12-11-eastus2-0
    base_model: azure/gpt-5.2-2025-12-11
    label: "GPT-5.2 2025-12-11"

# EU Region
- model_name: gpt-5-2-2025-12-11
  litellm_params:
    model: azure/codemie-gpt-5.2-2025-12-11
    api_base: https://api-base-swedencentral-0.openai.azure.com/
    litellm_credential_name: default_azure_openai_credential
  model_info:
    id: gpt-5-2-2025-12-11-swedencentral-0
    base_model: azure/gpt-5.2-2025-12-11
    label: "GPT-5.2 2025-12-11"
```

</details>

### o1

<details>
<summary><strong>o1</strong></summary>

```yaml
- model_name: o1
  litellm_params:
    model: azure/o1-2024-12-17
    api_base: https://api-base-swedencentral-0.openai.azure.com/
    litellm_credential_name: default_azure_openai_credential
    api_version: 2024-12-01-preview
  model_info:
    id: o1-swedencentral-0-eu
    base_model: azure/eu/o1-2024-12-17
    label: "o1 2024-12-17"
    supports_native_streaming: false
```

</details>

### o3

<details>
<summary><strong>o3</strong></summary>

```yaml
- model_name: o3-2025-04-16
  litellm_params:
    model: azure/o3-2025-04-16
    api_base: https://api-base-swedencentral-0.openai.azure.com/
    litellm_credential_name: default_azure_openai_credential
    api_version: 2024-12-01-preview
  model_info:
    id: o3-2025-04-16-swedencentral-0-eu
    base_model: azure/o3-2025-04-16
    label: "o3 2025-04-16"
    supports_native_streaming: false
```

</details>

### o3-Mini

<details>
<summary><strong>o3-Mini</strong></summary>

```yaml
- model_name: o3-mini
  litellm_params:
    model: azure/o3-mini-2025-01-31
    api_base: https://api-base-swedencentral-0.openai.azure.com/
    litellm_credential_name: default_azure_openai_credential
    api_version: 2024-12-01-preview
  model_info:
    id: o3-mini-swedencentral-0-eu
    base_model: azure/eu/o3-mini-2025-01-31
    label: "o3 Mini 2025-01-31"
    supports_native_streaming: false
```

</details>

### o4-Mini

<details>
<summary><strong>o4-Mini</strong></summary>

```yaml
- model_name: o4-mini-2025-04-16
  litellm_params:
    model: azure/o4-mini-2025-04-16
    api_base: https://api-base-swedencentral-0.openai.azure.com/
    litellm_credential_name: default_azure_openai_credential
    api_version: 2024-12-01-preview
  model_info:
    id: o4-mini-2025-04-16-swedencentral-0-eu
    base_model: azure/o4-mini-2025-04-16
    label: "o4-mini 2025-04-16"
    supports_native_streaming: false
```

</details>

### Text-embedding-ada-002

<details>
<summary><strong>Text-embedding-ada-002</strong></summary>

```yaml
# US Region
- model_name: codemie-text-embedding-ada-002
  litellm_params:
    model: azure/text-embedding-ada-002
    api_base: https://api-base-eastus-0.openai.azure.com/
    litellm_credential_name: default_azure_openai_credential
  model_info:
    id: ada-002-eastus-0
    base_model: azure/text-embedding-ada-002
    label: "Text Embedding Ada"
    mode: embedding

# EU Region
- model_name: codemie-text-embedding-ada-002
  litellm_params:
    model: azure/codemie-text-embedding-ada-002
    api_base: https://api-base-swedencentral-0.openai.azure.com/
    litellm_credential_name: default_azure_openai_credential
  model_info:
    id: ada-002-swedencentral-0
    base_model: azure/text-embedding-ada-002
    label: "Text Embedding Ada"
    mode: embedding
```

</details>

## Google Vertex AI Provider Examples

### Gemini

:::info Gemini Region Configuration
For Gemini models, `vertex_project` and `vertex_location` can be set in two ways:

- **Globally** in `litellm_settings` — applies to all Gemini models at once:

  ```yaml
  litellm_settings:
    vertex_project: os.environ/VERTEX_PROJECT
    vertex_location: "us-central1"
  ```

- **Per model** in `litellm_params` — overrides the global value for a specific entry:

  ```yaml
  - model_name: gemini-3-flash
    litellm_params:
      model: vertex_ai/gemini-3-flash-preview
      vertex_location: "global"
  ```

The `litellm_settings` approach is recommended when all Gemini models share the same project and region.
:::

#### Gemini 2.0 Flash

<details>
<summary><strong>Gemini 2.0 Flash</strong></summary>

```yaml
- model_name: gemini-2.0-flash
  litellm_params:
    model: vertex_ai/gemini-2.0-flash-001
  model_info:
    id: gemini-2.0-flash-us-central1
    base_model: gemini-2.0-flash-001
    label: "Gemini 2.0 Flash"
```

</details>

#### Gemini 2.5 Flash

<details>
<summary><strong>Gemini 2.5 Flash</strong></summary>

```yaml
- model_name: gemini-2.5-flash
  litellm_params:
    model: vertex_ai/gemini-2.5-flash
  model_info:
    id: gemini-2.5-flash-us-central1
    base_model: gemini-2.5-flash
    label: "Gemini 2.5 Flash"
```

</details>

#### Gemini 3 Flash

<details>
<summary><strong>Gemini 3 Flash</strong></summary>

```yaml
- model_name: gemini-3-flash
  litellm_params:
    model: vertex_ai/gemini-3-flash-preview
    vertex_location: "global"
  model_info:
    id: gemini-3-flash-preview-global
    base_model: gemini-3-flash-preview
    label: "Gemini 3 Flash"
```

</details>

#### Gemini 2.5 Pro

<details>
<summary><strong>Gemini 2.5 Pro</strong></summary>

```yaml
# US Region
- model_name: gemini-2.5-pro
  litellm_params:
    model: vertex_ai/gemini-2.5-pro
  model_info:
    id: gemini-2.5-pro-us-central1
    base_model: gemini-2.5-pro
    label: "Gemini 2.5 Pro"

# EU Region
- model_name: gemini-2.5-pro
  litellm_params:
    model: vertex_ai/gemini-2.5-pro
    vertex_location: "europe-west1"
  model_info:
    id: gemini-2.5-pro-europe-west1
    base_model: gemini-2.5-pro
    label: "Gemini 2.5 Pro"
```

</details>

#### Gemini 3 Pro

<details>
<summary><strong>Gemini 3 Pro</strong></summary>

```yaml
- model_name: gemini-3-pro
  litellm_params:
    model: vertex_ai/gemini-3-pro-preview
    vertex_location: "global"
  model_info:
    id: gemini-3-pro-preview-global
    base_model: gemini-3-pro-preview
    label: "Gemini 3 Pro"
```

</details>

### Claude Sonnet 4.5

:::info Claude on Vertex AI: Required Parameters
Claude models on Vertex AI **require** two parameters specified per model entry:

- `vertex_ai_project` — your GCP project ID (e.g. `os.environ/VERTEX_PROJECT`)
- `vertex_ai_location` — the region where the model is deployed (e.g. `"europe-west1"`, `"us-east5"`)

:::

<details>
<summary><strong>Claude Sonnet 4.5</strong></summary>

```yaml
- model_name: claude-4-5-sonnet-vertex
  litellm_params:
    model: vertex_ai/claude-sonnet-4-5
    vertex_ai_project: os.environ/VERTEX_PROJECT
    vertex_ai_location: "europe-west1"
  model_info:
    id: claude-4-5-sonnet-europe-west1-vertex-ai
    base_model: vertex_ai/claude-sonnet-4-5@20250929
    label: "VertexAI Claude Sonnet 4.5"

- model_name: claude-4-5-sonnet-vertex
  litellm_params:
    model: vertex_ai/claude-sonnet-4-5
    vertex_ai_project: os.environ/VERTEX_PROJECT
    vertex_ai_location: "us-east5"
  model_info:
    id: claude-4-5-sonnet-us-east5-vertex-ai
    base_model: vertex_ai/claude-sonnet-4-5@20250929
    label: "VertexAI Claude Sonnet 4.5"
```

</details>

### Embeddings for Text

<details>
<summary><strong>Embeddings for Text</strong></summary>

```yaml
- model_name: text-embedding-005
  litellm_params:
    model: vertex_ai/text-embedding-005
    project: os.environ/VERTEX_PROJECT
    location: us-central1
  model_info:
    id: gecko
    base_model: text-embedding-005
    label: "Text Embedding Gecko"
```

</details>

## See Also

- [LiteLLM Proxy Installation Guide](../../../deployment/extensions/litellm-proxy/)
- [Authentication Secrets](../../../deployment/extensions/litellm-proxy/auth-secrets)
- [Budget Configuration](./budget-configuration)
- [LiteLLM Official Documentation](https://docs.litellm.ai/)
