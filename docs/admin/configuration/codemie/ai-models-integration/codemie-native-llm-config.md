---
id: codemie-native-llm-config
sidebar_position: 1
title: CodeMie Native LLM Config
description: Configure AI models using CodeMie's native provider integration
pagination_next: null
---

# CodeMie Native LLM Config

## Native Integration Configuration

This section covers configuring models using CodeMie's native provider integration.

Native integration uses environment-specific YAML configuration files to define available models:

- **Configuration Path**: `/app/config/llms/` in CodeMie API container
- **File Naming Pattern**: `llm-<MODELS_ENV>-config.yaml`
- **Environment Variable**: `MODELS_ENV` determines which config file to load

**Example**: `MODELS_ENV=production` → loads `llm-production-config.yaml`

For detailed parameter descriptions, see the [LLM Model Configuration Reference](../api-configuration#llm-model-configuration).

### Reference Configurations

<details>
<summary><strong>AWS Bedrock Configuration Example</strong></summary>

```yaml
# Configuration file for managing multiple LLM and embedding models
llm_models:
  - base_name: "claude-3-5-sonnet"
    deployment_name: "anthropic.claude-3-5-sonnet-20240620-v1:0"
    label: "Bedrock Claude 3.5 Sonnet"
    multimodal: true
    enabled: true
    provider: "aws_bedrock"
    max_output_tokens: 4096
    cost:
      input: 0.000003
      output: 0.000015

  - base_name: "claude-3-5-sonnet-v2"
    deployment_name: "us.anthropic.claude-3-5-sonnet-20241022-v2:0"
    label: "Bedrock Claude 3.5 Sonnet v2 20241022"
    multimodal: true
    enabled: true
    provider: "aws_bedrock"
    max_output_tokens: 8192
    cost:
      input: 0.000003
      output: 0.000015
      cache_read_input_token_cost: 0.0000003

  - base_name: "claude-3-7"
    deployment_name: "us.anthropic.claude-3-7-sonnet-20250219-v1:0"
    label: "Bedrock Claude 3.7 Sonnet v1"
    multimodal: true
    enabled: true
    provider: "aws_bedrock"
    max_output_tokens: 8192
    cost:
      input: 0.000003
      output: 0.000015
      cache_read_input_token_cost: 0.0000003

  - base_name: "claude-4-sonnet"
    deployment_name: "us.anthropic.claude-sonnet-4-20250514-v1:0"
    label: "Bedrock Claude 4 Sonnet"
    multimodal: true
    enabled: true
    provider: "aws_bedrock"
    max_output_tokens: 32000
    cost:
      input: 0.000003
      output: 0.000015
      cache_read_input_token_cost: 0.0000003

  - base_name: "claude-4-sonnet-1m"
    deployment_name: "us.anthropic.claude-sonnet-4-20250514-v1:0"
    label: "Bedrock Claude 4 Sonnet Long Context"
    multimodal: true
    enabled: true
    provider: "aws_bedrock"
    max_output_tokens: 32000
    cost:
      input: 0.000003
      output: 0.000015
      cache_read_input_token_cost: 0.0000003
    configuration:
      client_headers:
        anthropic_beta:
          - context-1m-2025-08-07

  - base_name: "claude-4-5-haiku"
    deployment_name: "us.anthropic.claude-haiku-4-5-20251001-v1:0"
    label: "Bedrock Claude 4.5 Haiku"
    multimodal: true
    enabled: true
    provider: "aws_bedrock"
    max_output_tokens: 64000
    cost:
      input: 0.000001
      output: 0.000005
      cache_read_input_token_cost: 0.0000003

  - base_name: "claude-4-5-sonnet"
    deployment_name: "us.anthropic.claude-sonnet-4-5-20250929-v1:0"
    label: "Bedrock Claude 4.5 Sonnet"
    multimodal: true
    enabled: true
    default_for_categories: [global]
    provider: "aws_bedrock"
    max_output_tokens: 64000
    cost:
      input: 0.000003
      output: 0.000015
      cache_read_input_token_cost: 0.0000003

  - base_name: "us.meta.llama4-maverick-17b-instruct-v1:0"
    deployment_name: "us.meta.llama4-maverick-17b-instruct-v1:0"
    label: "LLaMa Maverick Instruct 17B"
    multimodal: false
    react_agent: false
    enabled: true
    provider: "aws_bedrock"
    max_output_tokens: 8192
    features:
      streaming: false
      tools: true
    cost:
      input: 0.00000024
      output: 0.00000097
      cache_read_input_token_cost: 0.00000024

  - base_name: "claude-4-opus"
    deployment_name: "us.anthropic.claude-opus-4-20250514-v1:0"
    label: "Bedrock Claude 4 Opus"
    multimodal: true
    enabled: true
    provider: "aws_bedrock"
    max_output_tokens: 32000
    cost:
      input: 0.000015
      output: 0.000075
      cache_read_input_token_cost: 0.0000015

  - base_name: "claude-4-1-opus"
    deployment_name: "us.anthropic.claude-opus-4-1-20250805-v1:0"
    label: "Bedrock Claude 4.1 Opus v1"
    multimodal: true
    enabled: true
    provider: "aws_bedrock"
    max_output_tokens: 32000
    cost:
      input: 0.000015
      output: 0.000075
      cache_read_input_token_cost: 0.0000015

  - base_name: "claude-opus-4-5-20251101"
    deployment_name: "us.anthropic.claude-opus-4-5-20251101-v1:0"
    label: "Bedrock Claude Opus 4.5"
    multimodal: true
    enabled: true
    provider: "aws_bedrock"
    max_output_tokens: 64000
    cost:
      input: 0.000005
      output: 0.000025
      cache_read_input_token_cost: 0.0000005

embeddings_models:
  - base_name: "titan"
    deployment_name: "amazon.titan-embed-text-v2:0"
    label: "Titan Embed Text v2.0"
    enabled: true
    default_for_categories: [global]
    provider: "aws_bedrock"
    cost:
      input: 0.0000002
      output: 0
```

</details>

<details>
<summary><strong>Azure OpenAI Configuration Example</strong></summary>

```yaml
# Configuration file for managing multiple LLM and embedding models
# Keep it up to date as some models can be deprecated
# https://learn.microsoft.com/en-us/azure/ai-services/openai/concepts/model-retirements
llm_models:

  - base_name: "gpt-4o-2024-08-06"
    deployment_name: "gpt-4o-2024-08-06"
    label: "GPT-4o 2024-08-06"
    multimodal: true
    enabled: true
    provider: "azure_openai"
    max_output_tokens: 16383
    cost:
      input: 0.0000025
      output: 0.00001
      cache_read_input_token_cost: 0.00000125

  - base_name: "gpt-4o-2024-11-20"
    deployment_name: "gpt-4o-2024-11-20"
    label: "GPT-4o 2024-11-20"
    multimodal: true
    default_for_categories: [global]
    enabled: true
    provider: "azure_openai"
    max_output_tokens: 16383
    cost:
      input: 0.0000025
      output: 0.00001
      cache_read_input_token_cost: 0.00000125

  - base_name: "gpt-4o-mini"
    deployment_name: "gpt-4o-mini-2024-07-18"
    label: "GPT-4o-mini-2024-07-18"
    multimodal: true
    enabled: true
    provider: "azure_openai"
    max_output_tokens: 16383
    cost:
      input: 0.000000165
      output: 0.00000066
      cache_read_input_token_cost: 0.000000075

  - base_name: "gpt-4.1"
    deployment_name: "gpt-4.1-2025-04-14"
    label: "GPT-4.1 2025-04-14"
    multimodal: true
    enabled: true
    provider: "azure_openai"
    max_output_tokens: 32768
    features:
      max_tokens: false
    cost:
      input: 0.000002
      output: 0.000008
      input_cost_per_token_batches: 0.000001
      output_cost_per_token_batches: 0.000004
      cache_read_input_token_cost: 0.0000005

  - base_name: "gpt-4.1-mini"
    deployment_name: "gpt-4.1-mini-2025-04-14"
    label: "GPT-4.1 mini 2025-04-14"
    multimodal: true
    enabled: true
    provider: "azure_openai"
    max_output_tokens: 32768
    features:
      max_tokens: false
    cost:
      input: 0.0000004
      output: 0.0000016
      input_cost_per_token_batches: 0.0000002
      output_cost_per_token_batches: 0.0000008
      cache_read_input_token_cost: 0.0000001

  - base_name: "gpt-5-2025-08-07"
    deployment_name: "gpt-5-2025-08-07"
    label: "GPT-5 2025-08-07"
    multimodal: true
    enabled: true
    provider: "azure_openai"
    max_output_tokens: 128000
    features:
      max_tokens: false
      temperature: false
    cost:
      input: 0.00000125
      output: 0.000010
      cache_read_input_token_cost: 0.000000125

  - base_name: "gpt-5-mini-2025-08-07"
    deployment_name: "gpt-5-mini-2025-08-07"
    label: "GPT-5 Mini 2025-08-07"
    multimodal: true
    enabled: true
    provider: "azure_openai"
    max_output_tokens: 128000
    features:
      max_tokens: false
      temperature: false
    cost:
      input: 0.00000025
      output: 0.000002
      cache_read_input_token_cost: 0.000000025

  - base_name: "gpt-5-nano-2025-08-07"
    deployment_name: "gpt-5-nano-2025-08-07"
    label: "GPT-5 Nano 2025-08-07"
    multimodal: true
    enabled: true
    provider: "azure_openai"
    max_output_tokens: 128000
    features:
      max_tokens: false
      temperature: false
    cost:
      input: 0.00000005
      output: 0.0000004
      cache_read_input_token_cost: 0.000000005

  - base_name: "gpt-4-vision"
    deployment_name: "gpt-4-vision-preview"
    multimodal: false
    enabled: false
    provider: "azure_openai"
    cost:
      input: 0.00001
      output: 0.00003

  - base_name: "o3-mini"
    deployment_name: "o3-mini-2025-01-31"
    label: "o3 Mini 2025-01-31"
    multimodal: false
    react_agent: false
    enabled: true
    provider: "azure_openai"
    max_output_tokens: 16383
    features:
      streaming: false
      tools: true
      temperature: false
      parallel_tool_calls: false
      system_prompt: false
      max_tokens: false
    cost:
      input: 0.0000011
      output: 0.0000044
      cache_read_input_token_cost: 0.00000055

  - base_name: "o1"
    deployment_name: "o1-2024-12-17"
    label: "o1 2024-12-17"
    multimodal: false
    react_agent: false
    enabled: true
    provider: "azure_openai"
    max_output_tokens: 16383
    features:
      streaming: false
      tools: true
      temperature: false
      parallel_tool_calls: false
      system_prompt: false
      max_tokens: false
    cost:
      input: 0.000015
      output: 0.00006
      cache_read_input_token_cost: 0.0000075

  - base_name: "o3-2025-04-16"
    deployment_name: "o3-2025-04-16"
    label: "o3 2025-04-16"
    multimodal: true
    react_agent: false
    enabled: true
    provider: "azure_openai"
    max_output_tokens: 100000
    features:
      streaming: true
      tools: true
      temperature: false
      parallel_tool_calls: false
      system_prompt: false
      max_tokens: false
      reasoning: true
    cost:
      input: 0.00001
      output: 0.00004
      cache_read_input_token_cost: 0.0000025

  - base_name: "o4-mini-2025-04-16"
    deployment_name: "o4-mini-2025-04-16"
    label: "o4-mini 2025-04-16"
    multimodal: true
    react_agent: false
    enabled: true
    provider: "azure_openai"
    max_output_tokens: 100000
    features:
      streaming: true
      tools: true
      temperature: false
      parallel_tool_calls: false
      system_prompt: false
      max_tokens: false
      reasoning: true
    cost:
      input: 0.0000011
      output: 0.0000044
      cache_read_input_token_cost: 0.000000275

embeddings_models:
  - base_name: "ada-002"
    deployment_name: "text-embedding-ada-002"
    label: "Text Embedding Ada"
    enabled: true
    default_for_categories: [global]
    provider: "azure_openai"
    cost:
      input: 0.0000001
      output: 0
```

</details>

<details>
<summary><strong>Google Vertex AI Configuration Example</strong></summary>

```yaml
# Configuration file for managing multiple LLM and embedding models
llm_models:
# Ref. https://cloud.google.com/vertex-ai/generative-ai/pricing#token-based-pricing
  - base_name: "gemini-2.0-flash"
    deployment_name: "gemini-2.0-flash-001"
    label: "Gemini 2.0 Flash"
    multimodal: true
    enabled: true
    provider: "google_vertexai"
    max_output_tokens: 8192
    cost:
      input: 0.00000015
      output: 0.0000006
      cache_read_input_token_cost: 0.0000000375

  - base_name: "gemini-2.5-flash"
    deployment_name: "gemini-2.5-flash"
    label: "Gemini 2.5 Flash"
    multimodal: true
    enabled: true
    provider: "google_vertexai"
    max_output_tokens: 65535
    cost:
      input: 0.00000030
      output: 0.0000025
      cache_read_input_token_cost: 0.000000075

  - base_name: "gemini-2.5-pro"
    deployment_name: "gemini-2.5-pro"
    label: "Gemini 2.5 Pro"
    multimodal: true
    enabled: true
    default_for_categories: [global]
    provider: "google_vertexai"
    max_output_tokens: 65535
    cost:
      input: 0.00000125
      output: 0.00001
      cache_read_input_token_cost: 0.000000313

  - base_name: "claude-sonnet-v2-vertex"
    deployment_name: "claude-3-5-sonnet-v2"
    label: "VertexAI Claude Sonnet 3.5 v2"
    multimodal: false
    enabled: true
    default: false
    provider: "google_vertexai"
    max_output_tokens: 8192
    cost:
      input: 0.000003
      output: 0.000015
      cache_read_input_token_cost: 0.0000003

  - base_name: "claude-sonnet-3-7-vertex"
    deployment_name: "claude-3-7-sonnet"
    label: "VertexAI Claude Sonnet 3.7"
    multimodal: false
    enabled: true
    default: false
    provider: "google_vertexai"
    max_output_tokens: 8192
    cost:
      input: 0.000003
      output: 0.000015
      cache_read_input_token_cost: 0.0000003

embeddings_models:

  - base_name: "gecko"
    deployment_name: "text-embedding-005"
    label: "Text Embedding Gecko"
    enabled: true
    default_for_categories: [global]
    provider: "google_vertexai"
    cost:
      input: 0.0000001
      output: 0
```

</details>

### Configuration Steps

#### Step 1: Create Model Configuration File

Create a custom model configuration YAML file with your LLM and embedding models:

```yaml
llm_models:
  - base_name: "gpt-4o-2024-11-20"
    deployment_name: "gpt-4o-2024-11-20"
    label: "GPT-4o (Nov 2024)"
    multimodal: true
    enabled: true
    provider: "azure_openai"
    default_for_categories: [global]
    max_output_tokens: 16383
    cost:
      input: 0.0000025
      output: 0.00001
      cache_read_input_token_cost: 0.00000125

  - base_name: "gpt-4o-mini"
    deployment_name: "gpt-4o-mini-2024-07-18"
    label: "GPT-4o Mini (Jul 2024)"
    multimodal: true
    enabled: true
    provider: "azure_openai"
    max_output_tokens: 16383
    cost:
      input: 0.000000165
      output: 0.00000066
      cache_read_input_token_cost: 0.000000075

  - base_name: "claude-4-sonnet"
    deployment_name: "anthropic.claude-4-sonnet-v1"
    label: "Claude 4 Sonnet"
    multimodal: false
    enabled: true
    provider: "aws_bedrock"
    cost:
      input: 0.000003
      output: 0.000015

embeddings_models:
  - base_name: "ada-002"
    deployment_name: "text-embedding-ada-002"
    label: "Text Embedding Ada 002"
    enabled: true
    provider: "azure_openai"
    default_for_categories: [global]
    cost:
      input: 0.0000001
      output: 0
```

#### Step 2: Update Helm Values

This step creates a Kubernetes ConfigMap with your model configuration and mounts it as a file inside the CodeMie API container.

Edit `codemie-helm-charts/codemie-api/values.yaml`:

```yaml
# Set environment variable to load custom config
extraEnv:
  - name: MODELS_ENV
    value: production  # Replace with your environment name (e.g., production, staging, dev)
  - name: LLM_PROXY_MODE
    value: internal    # Use native provider integration

# Mount custom config file into the container
# This mounts the ConfigMap as a file at: /app/config/llms/llm-production-config.yaml
extraVolumeMounts: |
  - name: codemie-llm-config          # Reference to volume defined below
    mountPath: /app/config/llms/llm-production-config.yaml  # Full path inside container
    subPath: llm-production-config.yaml  # Key name from ConfigMap data

# Define volume that references the ConfigMap
extraVolumes: |
  - name: codemie-llm-config          # Volume name (referenced in extraVolumeMounts)
    configMap:
      name: codemie-llm-config        # Name of the ConfigMap (defined in extraObjects)

# Create ConfigMap with model configuration
# The ConfigMap stores your YAML configuration and makes it available to mount
extraObjects:
  - apiVersion: v1
    kind: ConfigMap
    metadata:
      name: codemie-llm-config        # ConfigMap name (referenced in extraVolumes)
    data:
      llm-production-config.yaml: |   # Key name (referenced in subPath)
        # Paste your model configuration here
        llm_models:
          - base_name: "gpt-4o-2024-11-20"
            # ... (model config from Step 1)
```

**How it works:**

1. **ConfigMap Creation**: `extraObjects` creates a ConfigMap named `codemie-llm-config` containing your model configuration
2. **Volume Definition**: `extraVolumes` defines a volume that references the ConfigMap
3. **Volume Mount**: `extraVolumeMounts` mounts the ConfigMap as a file at `/app/config/llms/llm-production-config.yaml` inside the container
4. **File Loading**: CodeMie API reads the file based on the pattern `/app/config/llms/llm-<MODELS_ENV>-config.yaml`

**Important**: The file name in `mountPath` must match the pattern `llm-<MODELS_ENV>-config.yaml` where `<MODELS_ENV>` is the value of the `MODELS_ENV` environment variable. For example:

- `MODELS_ENV=production` → loads `/app/config/llms/llm-production-config.yaml`
- `MODELS_ENV=staging` → loads `/app/config/llms/llm-staging-config.yaml`

#### Step 3: Deploy Configuration

Before deploying, authenticate with the AI/Run CodeMie Helm registry:

```bash
export GOOGLE_APPLICATION_CREDENTIALS=key.json
gcloud auth application-default print-access-token | helm registry login -u oauth2accesstoken --password-stdin europe-west3-docker.pkg.dev
```

Then deploy using one of the following methods:

**Option A: Using Automated Script (Recommended)**

```bash
# Replace x.y.z with your version (e.g., 2.2.5)
bash helm-charts.sh --cloud <aws|azure|gcp> --version x.y.z --mode update
```

**Option B: Manual Helm Upgrade**

```bash
# Replace x.y.z with your version (e.g., 2.2.5)
helm upgrade --install codemie-api \
  oci://europe-west3-docker.pkg.dev/or2-msq-epmd-edp-anthos-t1iylu/helm-charts/codemie \
  --version x.y.z \
  --namespace "codemie" \
  -f "./codemie-api/values-<aws|azure|gcp>.yaml" \
  --wait --timeout 600s
```

:::info Full Deployment Guide
For detailed deployment instructions, troubleshooting, and additional options, see the [Update AI/Run CodeMie](../../../update/codemie/update-version) documentation.
:::

#### Step 4: Verify Models

Check that models are loaded successfully:

```bash
# View API logs
kubectl logs -n codemie deployment/codemie-api | grep "LLMConfig initiated"

# Expected output:
# LLMConfig initiated. Config=llm-production-config.yaml. LLMModels=[...]. EmbeddingModels=[...]
```

### Configuration Parameters Reference

For detailed parameter descriptions, model categories, features, and embedding model configuration, see the [LLM Model Configuration Reference](../api-configuration#llm-model-configuration).

## Useful Resources

### Model Information and Pricing

- **[LiteLLM Models Database](https://models.litellm.ai/)**: Comprehensive database of AI models with pricing information across all providers
- **[Azure AI Model Catalog](https://ai.azure.com/explore/models)**: Browse Azure OpenAI and Azure AI models, capabilities, and specifications
- **[AWS Bedrock Model Catalog](https://console.aws.amazon.com/bedrock/home/#/model-catalog)**: AWS Bedrock foundation models catalog with details and availability
- **[Google Vertex AI Generative AI Documentation](https://docs.cloud.google.com/vertex-ai/generative-ai/docs/)**: Google Vertex AI models documentation and capabilities

### Provider Documentation

- **Azure OpenAI**:
  - [Service Documentation](https://learn.microsoft.com/en-us/azure/ai-services/openai/)
  - [Pricing Calculator](https://azure.microsoft.com/en-us/pricing/details/cognitive-services/openai-service/)
  - [Quota Management](https://learn.microsoft.com/en-us/azure/ai-services/openai/quotas-limits)

- **AWS Bedrock**:
  - [Service Documentation](https://docs.aws.amazon.com/bedrock/)
  - [Pricing Details](https://aws.amazon.com/bedrock/pricing/)
  - [Model Availability](https://docs.aws.amazon.com/bedrock/latest/userguide/models-regions.html)

- **Google Vertex AI**:
  - [Generative AI on Vertex AI](https://cloud.google.com/vertex-ai/docs/generative-ai/learn/overview)
  - [Model Garden](https://cloud.google.com/model-garden)
  - [Pricing](https://cloud.google.com/vertex-ai/pricing)
