---
id: deployment-overview
title: Deployment
sidebar_label: Deployment
sidebar_position: 4
description: Deploy Langfuse using automated or manual methods
---

# Deployment

Choose one of the following methods to deploy Langfuse. **Automated Deployment** is recommended for most users as it automates secret creation, Helm deployment, and integration configuration.

## Deployment Options

### Automated Deployment (Recommended)

The automated deployment script handles all deployment steps automatically, including:

- Kubernetes secret creation
- Helm repository configuration
- Langfuse deployment
- Integration secret creation for CodeMie

For detailed instructions, see [Automated Deployment](./automated-deployment).

### Manual Deployment

Manual deployment gives you granular control over the deployment process and is recommended if you need to integrate it into custom automation pipelines.

For step-by-step manual deployment instructions, see [Manual Deployment](./manual-deployment).
