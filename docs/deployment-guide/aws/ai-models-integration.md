---
id: ai-models-integration
sidebar_position: 7
title: AI Models Integration
description: Configure LLM and embedding models
---

# AI Models Integration and Configuration

## Managing LLM and Embedding Models

AI/Run CodeMie provides a way to configure LLM and embedding models from different cloud providers. Configuration files can be found in the container at path: `config/llms`.

The `MODELS_ENV` environment variable specifies the environment for the models. For example, `MODELS_ENV=dial` will use models from the `config/llms/llm-dial-config.yaml` file.

**Pattern:** `llm-<MODELS_ENV>-config.yaml`

## Custom LLM Configuration

To provide LLM and embedding models for a custom environment:

1. Navigate to `codemie-helm-charts/codemie-api/values.yaml`

2. Configure custom ConfigMap to mount to AI/Run pod:

```yaml
extraObjects:
  - apiVersion: v1
    kind: ConfigMap
    metadata:
      name: codemie-llm-config
    data:
      llm-custom-config.yaml: |
        ---
        # Your LLM configuration here
```

3. Update the deployment to set `MODELS_ENV=custom`

## AWS Bedrock Models

### Prerequisites

- Activated region in AWS where [AWS Bedrock Models](https://docs.aws.amazon.com/bedrock/latest/userguide/models-regions.html) are available
- Activated desired LLMs and embedding models in your AWS account
- IAM role with Bedrock access configured (created during infrastructure deployment)

### Configuration Example

```yaml
models:
  bedrock:
    provider: aws_bedrock
    region: us-east-1
    models:
      - model_id: anthropic.claude-3-5-sonnet-20241022-v2:0
        name: 'Claude 3.5 Sonnet'
        type: chat
        max_tokens: 200000
      - model_id: amazon.titan-embed-text-v2:0
        name: 'Titan Embeddings G1 - Text'
        type: embedding
```

:::info
AI/Run CodeMie uses IRSA (IAM Roles for Service Accounts) for secure access to Bedrock services without managing API keys.
:::

## Azure OpenAI Models (Optional)

### Prerequisites

- Azure OpenAI service deployed
- API endpoint and credentials
- Model deployments created

### Configuration Example

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

## Model Configuration Parameters

### Chat Models

| Parameter                      | Description                  | Required |
| ------------------------------ | ---------------------------- | -------- |
| `model_id` / `deployment_name` | Model identifier             | Yes      |
| `name`                         | Display name                 | Yes      |
| `type`                         | Model type (chat, embedding) | Yes      |
| `max_tokens`                   | Maximum context window       | No       |
| `temperature`                  | Default temperature          | No       |
| `top_p`                        | Default top_p value          | No       |

### Embedding Models

| Parameter                      | Description         | Required |
| ------------------------------ | ------------------- | -------- |
| `model_id` / `deployment_name` | Model identifier    | Yes      |
| `name`                         | Display name        | Yes      |
| `type`                         | Must be "embedding" | Yes      |
| `dimensions`                   | Vector dimensions   | No       |

## Applying Configuration

After modifying the LLM configuration:

1. Update the Helm release:

   ```bash
   helm upgrade codemie-api \
     oci://europe-west3-docker.pkg.dev/or2-msq-epmd-edp-anthos-t1iylu/helm-charts/codemie \
     --version x.y.z \
     --namespace codemie \
     -f ./codemie-api/values-aws.yaml
   ```

2. Restart the deployment:

   ```bash
   kubectl rollout restart deployment/codemie -n codemie
   ```

3. Verify models are available in the AI/Run CodeMie UI

## Testing Models

After configuration:

1. Log in to AI/Run CodeMie UI
2. Create or open a project
3. Create a new assistant
4. Verify configured models appear in the model selection dropdown
5. Test model functionality with sample prompts

## Troubleshooting

### Models Not Appearing

- Verify ConfigMap is properly mounted
- Check `MODELS_ENV` environment variable
- Review pod logs for configuration errors
- Ensure API credentials are valid

### Authentication Errors

- For AWS Bedrock: Verify IRSA role permissions
- For Azure OpenAI: Check API key validity and endpoint accessibility
- Review network connectivity to model providers

## Next Steps

- [Update AI/Run CodeMie](./08-update.md) - Learn about update procedures
- [Extensions](./09-extensions.md) - Explore optional extensions
