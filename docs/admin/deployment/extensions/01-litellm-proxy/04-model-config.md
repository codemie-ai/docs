---
id: model-config
sidebar_label: Model Configuration
sidebar_position: 5
title: Step 4 - LiteLLM Model Configuration
description: Configure LLM models and regions
pagination_prev: admin/deployment/extensions/litellm-proxy/litellm-proxy-overview
pagination_next: null
---

# Step 4: LiteLLM Proxy Model Configuration

The core of the LiteLLM Proxy configuration is the model list, which defines the LLM models the proxy will manage. Sample configuration files are provided in the Helm chart for each major cloud provider.

## Configuration File Locations

- **AWS Bedrock**: `litellm/config/litellm-aws-config.yaml`
- **Azure OpenAI**: `litellm/config/litellm-azure-config.yaml`
- **Google Vertex AI**: `litellm/config/litellm-gcp-config.yaml`

## Model Configuration

For detailed model configuration examples and provider-specific settings, see [LiteLLM Model Configuration](../../../configuration/extensions/litellm-proxy/model-configuration).

## Next Steps

Continue to [Deployment](./deployment).
