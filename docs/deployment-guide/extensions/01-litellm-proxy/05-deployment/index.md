---
id: deployment-overview
sidebar_label: Deployment
sidebar_position: 6
title: Step 5 - Deployment
description: Deploy LiteLLM Proxy using automated or manual methods
---

# Step 5: Deployment

Choose one of the following methods to deploy the LiteLLM Proxy. **Automated Deployment** is recommended for most users as it automates secret creation, Helm deployment, and integration configuration.

## Deployment Options

### Option A: Automated Deployment (Recommended)

The automated deployment script handles all deployment steps automatically, including:

- Kubernetes secret creation
- Helm repository configuration
- LiteLLM Proxy deployment
- Integration secret creation for CodeMie

For detailed instructions, see [Automated Deployment](./automated-deployment).

### Option B: Manual Deployment

Manual deployment gives you granular control over the deployment process and is recommended if you need to integrate it into custom automation pipelines.

For step-by-step manual deployment instructions, see [Manual Deployment](./manual-deployment).

## Next Steps

- For migration from DIAL Proxy, see [Migration Guide](../migration-guide)
- Return to [Extensions Overview](../../)
- Configure other extensions
