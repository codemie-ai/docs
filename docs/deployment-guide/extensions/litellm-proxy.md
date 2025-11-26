---
id: litellm-proxy
sidebar_position: 2
title: LiteLLM Proxy
description: Load balancing and high availability for LLM requests
---

# LiteLLM Proxy

LiteLLM Proxy provides load balancing and high availability for LLM requests.

## Prerequisites

- AI/Run CodeMie version 2.0.0 or higher
- Infrastructure requirements based on your LLM provider:
  - **AWS Bedrock**: IAM Role with Bedrock access (IRSA recommended)
  - **Azure OpenAI**: Entra ID Application or API key
  - **GCP Vertex AI**: GCP Service Account with Vertex AI access
- PostgreSQL database instance
- Sufficient cluster resources

## System Requirements

| Component                  | CPU             | Memory              | Storage  |
| -------------------------- | --------------- | ------------------- | -------- |
| LiteLLM Proxy (2 replicas) | 1/1 per replica | 2Gi/2Gi per replica | -        |
| Redis                      | 0.1             | 128Mi               | 2Gi      |
| PostgreSQL                 | Managed service |                     | Included |

## Features

- Load balancing across multiple LLM providers
- High availability with automatic failover
- Request rate limiting and quota management
- Caching for improved performance
- Logging and monitoring

## Installation Overview

1. Configure infrastructure access (IAM roles, service accounts)
2. Deploy LiteLLM Proxy using Helm charts
3. Configure AI/Run CodeMie to use LiteLLM Proxy
4. Verify proxy functionality

For detailed installation instructions, refer to the LiteLLM Proxy documentation in the codemie-helm-charts repository.

## Configuration

### Basic Configuration

```yaml
litellm:
  enabled: true
  replicas: 2
  resources:
    requests:
      cpu: 1
      memory: 2Gi
    limits:
      cpu: 1
      memory: 2Gi
```

### Provider Configuration

Configure multiple LLM providers for load balancing:

```yaml
litellm:
  providers:
    - name: bedrock
      region: us-east-1
      weight: 50
    - name: azure
      endpoint: https://your-resource.openai.azure.com
      weight: 50
```

## Troubleshooting

### Proxy Not Responding

- Check pod logs for errors
- Verify network connectivity to LLM providers
- Ensure credentials are properly configured

### High Latency

- Review Redis cache configuration
- Check provider response times
- Consider adjusting load balancing weights

## Next Steps

- Return to [Extensions Overview](./)
- Configure other extensions
