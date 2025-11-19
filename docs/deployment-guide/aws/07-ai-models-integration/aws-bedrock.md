---
id: aws-bedrock
sidebar_position: 2
title: AWS Bedrock Models (Optional)
description: Configure AWS Bedrock LLMs and embedding models
---

# AWS Bedrock Models (Optional)

## Prerequisites

- Activated region in AWS where [AWS Bedrock Models](https://docs.aws.amazon.com/bedrock/latest/userguide/models-regions.html) are available
- Activated desired LLMs and embedding models in your AWS account
- IAM role with Bedrock access configured (created during infrastructure deployment)

## Configuration Example

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

## Available Models

### Chat Models

- **Claude 3.5 Sonnet** - `anthropic.claude-3-5-sonnet-20241022-v2:0`
- **Claude 3 Opus** - `anthropic.claude-3-opus-20240229-v1:0`
- **Claude 3 Haiku** - `anthropic.claude-3-haiku-20240307-v1:0`
- **Llama 3.2** - `meta.llama3-2-*`

### Embedding Models

- **Titan Embeddings G1 - Text** - `amazon.titan-embed-text-v2:0`
- **Titan Embeddings V2** - `amazon.titan-embed-text-v2:0`

## Configuration Steps

1. Navigate to `codemie-helm-charts/codemie-api/values-aws.yaml`

2. Add Bedrock configuration to the ConfigMap:

```yaml
extraObjects:
  - apiVersion: v1
    kind: ConfigMap
    metadata:
      name: codemie-llm-config
    data:
      llm-aws-config.yaml: |
        models:
          bedrock:
            provider: aws_bedrock
            region: us-east-1
            models:
              - model_id: anthropic.claude-3-5-sonnet-20241022-v2:0
                name: 'Claude 3.5 Sonnet'
                type: chat
                max_tokens: 200000
```

3. Set `MODELS_ENV=aws` in the deployment

4. Apply the configuration following the steps in [AI Models Integration](./#applying-configuration)

## Troubleshooting

### Access Denied Errors

- Verify IAM role has `bedrock:InvokeModel` permission
- Check that IRSA is properly configured for the codemie service account
- Ensure models are enabled in your AWS account region

### Models Not Available

- Confirm models are activated in your AWS Bedrock console
- Verify the region matches where models are activated
- Check model ID format matches AWS Bedrock documentation

## Next Steps

- Return to [AI Models Integration](./) for additional configuration options
- Proceed to [Updates](../update) to learn about update procedures
