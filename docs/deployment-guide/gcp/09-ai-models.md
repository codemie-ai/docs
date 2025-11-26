---
id: ai-models
title: AI Models Integration and Configuration
sidebar_label: AI Models Integration
sidebar_position: 9
---

# AI Models Integration and Configuration

## Managing LLM and Embedding Models

AI/Run CodeMie provides a way to configure LLM and embedding models from different cloud providers. Configuration file can be found by path in container: [`config/LLMs`](https://gitbud.epam.com/epm-cdme/codemie/-/tree/main/config/LLMs?ref_type=heads).

The `MODELS_ENV` is used to specify the environment for the models. For example, `MODELS_ENV=dial` will use the models from the `config/LLMs/llm-dial-config.yaml` file (Pattern: `llm-<MODELS_ENV>-config.yaml`).

### Example of Providing LLM and Embedding Models for Custom Environment

1. Go to the `codemie-helm-charts/codemie-api/values.yaml` file

2. Fill the following values to create and mount custom configmap to AI/Run pod:

```yaml
extraObjects:
  - apiVersion: v1
    kind: ConfigMap
    metadata:
      name: llm-custom-config
      namespace: codemie
    data:
      llm-custom-config.yaml: |
        # Your LLM configuration here
        models:
          - id: "model-id"
            name: "Model Name"
            provider: "provider-name"
            # Additional model configuration...

extraVolumes:
  - name: llm-custom-config
    configMap:
      name: llm-custom-config

extraVolumeMounts:
  - name: llm-custom-config
    mountPath: /app/config/LLMs/llm-custom-config.yaml
    subPath: llm-custom-config.yaml

env:
  - name: MODELS_ENV
    value: 'custom'
```

3. Update the deployment:

```bash
helm upgrade --install codemie-api oci://europe-west3-docker.pkg.dev/or2-msq-epmd-edp-anthos-t1iylu/helm-charts/codemie \
--version x.y.z \
--namespace "codemie" \
-f "./codemie-api/values-gcp.yaml" \
--wait --timeout 600s
```

## AWS Bedrock Models (Optional)

:::note
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

## Azure OpenAI Models (Optional)

:::note
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
   - In the left menu, navigate to "shared resources" -> "Deployments"
   - Click "Deploy model" -> "Deploy base model"
   - Search and select the desired model (e.g., GPT-4o)
   - Configure deployment settings:
     - Deployment name
     - Model version
     - Deployment type
     - Tokens per minute rate limit
   - Click "Deploy"

4. **Verify Deployment**
   - Wait for the deployment to complete
   - Check the deployment status in the Deployments page
   - Note the deployment name for configuration in AI/Run CodeMie

5. **Configure in AI/Run CodeMie**
   - Update your LLM configuration with Azure OpenAI credentials
   - Include endpoint URL, API key, and deployment name
   - Test the connection to ensure proper configuration
