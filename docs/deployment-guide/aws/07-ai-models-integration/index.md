---
id: ai-models-overview
sidebar_position: 1
title: AI Models Integration
description: Configure LLM and embedding models
---

# AI Models Integration and Configuration

## Overview

AI/Run CodeMie supports LLM and embedding models from various cloud providers. This section guides you through configuring models for your deployment.

## Model Providers

### [AWS Bedrock Models](./aws-bedrock) (Optional)

Configure Amazon Bedrock LLMs and embedding models for AWS-native integration.

### [Azure OpenAI Models](./azure-openai) (Optional)

Configure Azure OpenAI Service for LLM and embedding models.

## Managing LLM and Embedding Models

AI/Run CodeMie provides a way to configure LLM and embedding models from different cloud providers. Configuration files can be found in the container at path: [`config/llms`](https://gitbud.epam.com/epm-cdme/codemie/-/tree/main/config/llms).

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

- Configure [AWS Bedrock Models](./aws-bedrock) for AWS integration
- Configure [Azure OpenAI Models](./azure-openai) for Azure integration
- Or proceed to [Updates](../update) to learn about update procedures
