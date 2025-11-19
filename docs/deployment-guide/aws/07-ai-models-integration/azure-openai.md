---
id: azure-openai
sidebar_position: 3
title: Azure OpenAI Models (Optional)
description: Configure Azure OpenAI Service models
---

# Azure OpenAI Models (Optional)

## Prerequisites

- Azure OpenAI service deployed
- API endpoint and credentials
- Model deployments created

## Configuration Example

```yaml
models:
  azure_openai:
    provider: azure_openai
    api_base: https://your-resource.openai.azure.com
    api_version: '2024-02-01'
    models:
      - deployment_name: gpt-4
        model_name: 'GPT-4'
        type: chat
      - deployment_name: text-embedding-ada-002
        model_name: 'Ada Embeddings'
        type: embedding
```

## Available Models

### Chat Models

- **GPT-4** - Latest GPT-4 model
- **GPT-4 Turbo** - Optimized GPT-4 variant
- **GPT-3.5 Turbo** - Fast and efficient model

### Embedding Models

- **text-embedding-ada-002** - Standard embedding model
- **text-embedding-3-small** - Compact embedding model
- **text-embedding-3-large** - High-dimensional embedding model

## Configuration Steps

1. Create Azure OpenAI resource in Azure Portal

2. Deploy desired models in your Azure OpenAI resource

3. Obtain API endpoint and key

4. Navigate to `codemie-helm-charts/codemie-api/values-aws.yaml`

5. Add Azure OpenAI configuration:

```yaml
extraObjects:
  - apiVersion: v1
    kind: ConfigMap
    metadata:
      name: codemie-llm-config
    data:
      llm-azure-config.yaml: |
        models:
          azure_openai:
            provider: azure_openai
            api_base: https://your-resource.openai.azure.com
            api_version: '2024-02-01'
            models:
              - deployment_name: gpt-4
                model_name: 'GPT-4'
                type: chat

  - apiVersion: v1
    kind: Secret
    metadata:
      name: azure-openai-credentials
    type: Opaque
    stringData:
      api-key: your-api-key-here
```

6. Set `MODELS_ENV=azure` in the deployment

7. Apply the configuration following the steps in [AI Models Integration](./#applying-configuration)

## Authentication Options

### Option 1: API Key (Simple)

Store API key in Kubernetes secret:

```bash
kubectl create secret generic azure-openai-credentials \
  --from-literal=api-key=your-api-key-here \
  --namespace codemie
```

### Option 2: Managed Identity (Recommended)

Use Azure AD Managed Identity for enhanced security:

1. Enable system-assigned managed identity for AKS
2. Grant identity access to Azure OpenAI resource
3. Configure pod identity in deployment

## Troubleshooting

### Authentication Errors

- Verify API key is correct and not expired
- Check API endpoint URL format
- Ensure managed identity has proper role assignments

### Rate Limiting

- Review Azure OpenAI quota limits
- Consider implementing request throttling
- Use multiple deployment instances for load balancing

### Models Not Available

- Confirm model deployments exist in Azure OpenAI resource
- Verify deployment names match configuration
- Check API version compatibility

## Next Steps

- Return to [AI Models Integration](./) for additional configuration options
- Proceed to [Updates](../update) to learn about update procedures
