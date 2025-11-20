---
id: extensions-overview
sidebar_position: 1
title: Extensions (Optional)
description: Optional extensions and additional features for AI/Run CodeMie
---

# AI/Run CodeMie Extensions (Optional)

## Overview

This section covers optional extensions that can be installed to enhance AI/Run CodeMie functionality.

## Available Extensions

### [LiteLLM Proxy](./litellm-proxy)

Load balancing and high availability for LLM requests.

### [Assistants Evaluation](./assistants-evaluation)

Tool for evaluating and benchmarking AI assistant performance.

### [AI Code Explorer (AICE)](./ai-code-explorer)

Advanced code analysis and exploration tool.

### [Angular Upgrade Assistant](./angular-upgrade-assistant)

Specialized assistant for Angular application upgrades.

### [Salesforce DevForce AI](./salesforce-devforce-ai)

AI-powered development assistant for Salesforce.

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

- Explore individual extension pages for detailed setup guides
- [FAQ](../../faq) - Frequently asked questions
