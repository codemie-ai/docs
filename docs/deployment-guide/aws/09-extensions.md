---
sidebar_position: 9
title: Extensions (Optional)
description: Optional extensions and additional features for AI/Run CodeMie
---

# AI/Run CodeMie Extensions (Optional)

## Overview

This section covers optional extensions that can be installed to enhance AI/Run CodeMie functionality.

## LiteLLM Proxy

LiteLLM Proxy provides load balancing and high availability for LLM requests.

### Prerequisites

- AI/Run CodeMie version 2.0.0 or higher
- Infrastructure requirements based on your LLM provider:
  - **AWS Bedrock**: IAM Role with Bedrock access (IRSA recommended)
  - **Azure OpenAI**: Entra ID Application or API key
  - **GCP Vertex AI**: GCP Service Account with Vertex AI access
- PostgreSQL database instance
- Sufficient cluster resources

### System Requirements

| Component                  | CPU             | Memory              | Storage  |
| -------------------------- | --------------- | ------------------- | -------- |
| LiteLLM Proxy (2 replicas) | 1/1 per replica | 2Gi/2Gi per replica | -        |
| Redis                      | 0.1             | 128Mi               | 2Gi      |
| PostgreSQL                 | Managed service |                     | Included |

### Installation Overview

1. Configure infrastructure access (IAM roles, service accounts)
2. Deploy LiteLLM Proxy using Helm charts
3. Configure AI/Run CodeMie to use LiteLLM Proxy
4. Verify proxy functionality

For detailed installation instructions, refer to the LiteLLM Proxy documentation in the codemie-helm-charts repository.

## AI/Run CodeMie Assistants Evaluation

Tool for evaluating and benchmarking AI assistant performance.

### Features

- Automated assistant testing
- Performance metrics collection
- Comparative analysis
- Report generation

### Prerequisites

- AI/Run CodeMie deployment
- Access to test datasets
- Evaluation criteria defined

## AI Code Explorer (AICE)

Advanced code analysis and exploration tool.

### Features

- Deep code analysis
- Dependency visualization
- Code quality metrics
- Search and navigation enhancement

### Installation

Installation instructions available in the extensions documentation.

## Angular Upgrade Assistant

Specialized assistant for Angular application upgrades.

### Features

- Version compatibility analysis
- Migration path planning
- Code transformation suggestions
- Dependency updates

### Use Cases

- Angular version upgrades
- Migration to modern Angular features
- Breaking change identification
- Best practices application

## Salesforce DevForce AI

AI-powered development assistant for Salesforce.

### Features

- Apex code generation
- SOQL query assistance
- Metadata analysis
- Best practices guidance

### Prerequisites

- Salesforce org access
- API credentials configured
- Salesforce metadata accessible

### Installation

Refer to the Salesforce DevForce AI documentation for detailed setup instructions.

## Enabling Extensions

Extensions are typically enabled through configuration in the `codemie-api` values file:

```yaml
extraObjects:
  - apiVersion: v1
    kind: ConfigMap
    metadata:
      name: codemie-custom-customer-config
    data:
      customer-config.yaml: |
        ---
        preconfigured_assistants:
          - id: "extension-name"
            settings:
              enabled: true
```

After configuration:

1. Update the Helm release
2. Restart the deployment
3. Verify extension availability in UI

## Extension Management

### Enabling an Extension

1. Edit `codemie-api/values-aws.yaml`
2. Set `enabled: true` for the extension
3. Apply configuration
4. Restart CodeMie deployment

### Disabling an Extension

1. Edit `codemie-api/values-aws.yaml`
2. Set `enabled: false` for the extension
3. Apply configuration
4. Restart CodeMie deployment

## Support and Documentation

For detailed documentation on specific extensions:

1. Check the extension-specific documentation in the codemie-helm-charts repository
2. Review the extension README files
3. Contact AI/Run CodeMie support for assistance

## Next Steps

- [FAQ](../faq.md) - Frequently asked questions
- Review individual extension documentation for detailed setup guides
