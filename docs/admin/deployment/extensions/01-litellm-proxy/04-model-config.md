---
id: model-config
sidebar_label: Model Configuration
sidebar_position: 5
title: Step 4 - LiteLLM Model Configuration
description: Configure LLM models and regions
---

# Step 4: LiteLLM Proxy Model Configuration

The core of the LiteLLM Proxy configuration is the model list, which defines the LLM models the proxy will manage. Sample configuration files are provided in the Helm chart for each major cloud provider.

## Configuration File Locations

- **AWS Bedrock**: `litellm/config/litellm-aws-config.yaml`
- **Azure OpenAI**: `litellm/config/litellm-azure-config.yaml`
- **Google Vertex AI**: `litellm/config/litellm-gcp-config.yaml`

## Regional Configuration Overview

The sample configurations specify default regions for accessing the models. The table below provides a summary.

| Provider         | Model                          | Default Region |
| ---------------- | ------------------------------ | -------------- |
| AWS Bedrock      | claude-3-5-sonnet              | us-west-2      |
| AWS Bedrock      | claude-3-5-sonnet-v2           | us-west-2      |
| AWS Bedrock      | claude-3-7                     | us-west-2      |
| AWS Bedrock      | claude-4-sonnet-1m             | us-west-2      |
| AWS Bedrock      | claude-4-sonnet                | us-west-2      |
| AWS Bedrock      | claude-4-sonnet                | eu-central-1   |
| AWS Bedrock      | claude-4-opus                  | us-west-2      |
| AWS Bedrock      | claude-4-1-opus                | us-west-2      |
| AWS Bedrock      | titan                          | us-west-2      |
| Google Vertex AI | gemini-2.0-flash               | us-central1    |
| Google Vertex AI | gemini-2.5-pro                 | us-central1    |
| Google Vertex AI | claude-sonnet-v2-vertex        | us-east5       |
| Google Vertex AI | claude-sonnet-3-7-vertex       | us-east5       |
| Google Vertex AI | text-embedding-005             | us-central1    |
| Azure OpenAI     | gpt-4o-2024-08-06              | eastus2        |
| Azure OpenAI     | gpt-4o-2024-11-20              | eastus2        |
| Azure OpenAI     | gpt-4o-mini                    | eastus2        |
| Azure OpenAI     | gpt-4.1                        | eastus2        |
| Azure OpenAI     | gpt-4.1-mini                   | eastus2        |
| Azure OpenAI     | gpt-5-2025-08-07               | eastus2        |
| Azure OpenAI     | gpt-5-mini-2025-08-07          | eastus2        |
| Azure OpenAI     | gpt-5-nano-2025-08-07          | eastus2        |
| Azure OpenAI     | gpt-4-vision                   | eastus2        |
| Azure OpenAI     | o3-mini                        | eastus2        |
| Azure OpenAI     | o1                             | eastus2        |
| Azure OpenAI     | o3-2025-04-16                  | eastus2        |
| Azure OpenAI     | o4-mini-2025-04-16             | eastus2        |
| Azure OpenAI     | codemie-text-embedding-ada-002 | eastus2        |

## Customizing Regions

You can customize the regions where your models are accessed by modifying the corresponding configuration files.

### AWS Bedrock

To use a different AWS region, modify the `aws_region_name` parameter in the model's configuration.

```yaml
model_list:
  - model_name: claude-4-sonnet
    litellm_params:
      aws_region_name: us-west-2 # Change this to your preferred region, e.g., "eu-central-1"
```

### Azure OpenAI

For Azure, the region is determined by the endpoint URL in the `api_base` parameter.

```yaml
model_list:
  - model_name: gpt-4o-2024-08-06
    litellm_params:
      model: azure/gpt-4o-2024-08-06
      api_base: https://your-resource.openai.azure.com/ # Your Azure OpenAI endpoint defines the region
      litellm_credential_name: default_azure_openai_credential
```

### Google Vertex AI

For Google Vertex AI, the method for region configuration depends on the model family:

#### Gemini Models

Region is set globally in the `litellm_settings` section.

```yaml
litellm_settings:
  vertex_project: os.environ/VERTEX_PROJECT
  vertex_location: 'us-central1' # Change this to your preferred region for Gemini models
```

#### Claude Models on Vertex AI

Region and project are specified directly in each model's configuration.

```yaml
model_list:
  - model_name: claude-sonnet-3-7-vertex
    litellm_params:
      model: vertex_ai/claude-3-7-sonnet
      vertex_ai_project: os.environ/VERTEX_PROJECT
      vertex_ai_location: 'us-east5' # Change this to your preferred region for this specific model
```

## Next Steps

Continue to [Deployment](./deployment).
