---
id: ai-models-integration
title: AI Models Integration and Configuration
sidebar_label: AI Models Integration
sidebar_position: 7
---

# AI Models Integration and Configuration

## Managing LLM and Embedding Models

AI/Run CodeMie provides a way to configure LLM and embedding models from different cloud providers. Configuration file can be found by path: `config/llms`.

The `MODELS_ENV` is used to specify the environment for the models. For example, `MODELS_ENV=dial` will use the models from the `config/llms/llm-dial-config.yaml` file (Pattern: `llm-<MODELS_ENV>-config.yaml`).

### Example: Providing Custom LLM Configuration

1. Go to the `codemie-helm-charts/codemie-api/values.yaml` file

2. Fill the following values to create and mount custom configmap to AI/Run pod:

```yaml
extraEnv:
  - name: MODELS_ENV
    value: <project-name>

extraVolumeMounts: |
  ...
  - name: codemie-llm-customer-config
    mountPath: /app/config/llms/llm-<project-name>-config.yaml
    subPath: llm-<project-name>-config.yaml
  ...

extraVolumes: |
  ...
  - name: codemie-llm-customer-config
    configMap:
      name: codemie-llm-customer-config
  ...

extraObjects:
  - apiVersion: v1
    kind: ConfigMap
    metadata:
      name: codemie-llm-customer-config
    data:
      llm-<project-name>-config.yaml: |
        llm_models:
          - base_name: "gpt-4o-2024-08-06"
            deployment_name: "gpt-4o-2024-08-06"
            label: "GPT-4o 2024-08-06"
            multimodal: true
            enabled: true
            default: true
            provider: "azure_openai"
            cost:
              input: 0.0000025
              output: 0.000011

        embeddings_models:
          - base_name: "ada-002"
            deployment_name: "text-embedding-ada-002"
            label: "Text Embedding Ada"
            enabled: true
            default: true
            provider: "azure_openai"
            cost:
              input: 0.0000001
              output: 0
```

## AWS Bedrock Models (optional)

:::note Required
**Required in case of using Anthropic Claude models**
:::

### Overview

This section describes the process of enabling AWS Bedrock models in AWS account.

### Steps to Enable Bedrock Models

**1. Access AWS Bedrock Console**

1. Sign in to the AWS Management Console
2. Navigate to the AWS Bedrock service
3. Select "Model access" from the left navigation panel

**2. Request Model Access**

1. In the Model access page, you'll see available foundation models grouped by providers
2. Common providers include:
   - Anthropic (Claude models)
   - Amazon
3. For each model you want to enable:
   - Locate the model in the list
   - Check the checkbox next to the model name
   - Click "Request model access"

**3. Verify Model Access**

1. After requesting access, the status will initially show as "Pending"
2. Wait for the status to change to "Access granted"
3. This typically takes only a few minutes
4. Refresh the page to see updated status

**4. Region-Specific Configuration**

- Note that model access needs to be enabled separately for each AWS region
- Repeat the process for additional regions if needed

## Azure OpenAI Models (optional)

:::note Required
**Required in case of using Azure OpenAI models such as GPT-4o, etc.**
:::

### Overview

This section describes the process of enabling Azure AI models in Azure account.

### Steps to Enable Azure AI Models

1. **Create Cognitive Account Resource**
   - Navigate to [Azure Portal](https://portal.azure.com)
   - Search for "Azure OpenAI" and click "Create"
   - Fill in the required details:
     - Subscription
     - Resource group
     - Region
     - Name
     - Pricing tier (typically S0)
     - Network: "All networks" type
   - Click "Review + create" and then "Create"

2. **Configure API Access**
   - Once deployment is complete, go to the resource
   - Navigate to "Keys and Endpoint" section
   - Note down:
     - Key 1 or Key 2
     - Endpoint URL
     - Resource location

3. **Deploy AI Model**
   - Go to Cognitive Account
   - In "Overview" tab, click "Go to Azure AI Foundry portal"
   - In the left menu, navigate to "shared resources" → "Deployments"
   - Click "Deploy model" → "Deploy base model"
   - Search and select desired model
   - Click "Confirm"
   - Configure deployment settings:
     - Deployment name: `[your-deployment-name]`
     - Deployment type:
       - Standard
       - Global Standard
     - Model version: Select appropriate version
     - Tokens per Minute Rate Limit:
       - Set to maximum value if deploying single instance in region
       - Adjust based on quota requirements for multiple deployments
       - Reference "Quota" menu in left navigation for detailed limits
     - Review settings and click "Deploy"
