---
id: extensions
title: AI/Run CodeMie Extensions
sidebar_label: Extensions
sidebar_position: 9
---

# AI/Run CodeMie Extensions (Optional)

## LiteLLM Proxy

LiteLLM Proxy is an optional extension that provides load balancing and high availability for your LLM requests across multiple cloud providers.

### Overview

This comprehensive guide explains how to install and configure LiteLLM Proxy using Helm, with both automated and manual deployment methods.

### Infrastructure Requirements

Before deploying LiteLLM Proxy, ensure you have the following infrastructure components in place:

- If you are using **AWS Bedrock** LLM models:
  - Option 1 (Recommended for EKS): IAM Role with access to Bedrock services for use with IRSA (IAM Roles for Service Accounts)
  - Option 2: AWS User with access to Bedrock services

- If you are using **Azure OpenAI** LLM models:
  - Option 1 (Recommended): Azure Entra ID Application with access to Azure OpenAI services
  - Option 2: Direct API key authentication

- If you are using **GCP Vertex AI** LLM models:
  - GCP Service Account with access to Vertex AI

- PostgreSQL database instance
- Sufficient cluster resources for LiteLLM Proxy components

:::warning Minimum Version Requirement
Minimal supported version of AI/Run CodeMie for use with LiteLLM Proxy is 2.0.0. Make sure you've updated your CodeMie installation before proceeding.
:::

### Access to Repositories

- [codemie-helm-charts](https://gitbud.epam.com/epm-cdme/codemie-helm-charts)

### System Requirements

| Component                  | CPU (Limits/Requests) | Memory (Limits/Requests) | Storage   |
| -------------------------- | --------------------- | ------------------------ | --------- |
| LiteLLM Proxy x 2 Replicas | 2 / 2 (1 / 1)         | 4Gi / 4Gi (2Gi / 2Gi)    | —         |
| Redis                      | 0.15 / 0.1            | 192Mi / 128Mi            | 2Gi       |
| PostgreSQL\*               | —                     | —                        | —         |
| **Total**                  | ~2.15 / ~2.1 vCPU     | ~4 / ~4 GiB RAM          | ~2 Gi PVC |

\*Reusing main AI/Run CodeMie PostgreSQL instance

### Configuration

Detailed configuration instructions including:

- PostgreSQL setup
- LiteLLM proxy configuration for AWS Bedrock, Azure OpenAI, and Google Vertex AI
- Region-specific configurations
- Authentication setup

For complete installation and configuration instructions, please refer to the [codemie-helm-charts repository documentation](https://gitbud.epam.com/epm-cdme/codemie-helm-charts).

## AI/Run Assistants Evaluation

AI/Run Assistants Evaluation provides tools to assess and improve the quality of your AI assistants.

:::info
For detailed setup and usage instructions, refer to the codemie-helm-charts repository.
:::

## AI Code Explorer (AICE)

AI Code Explorer is an extension that enhances code exploration capabilities within AI/Run CodeMie.

:::info
For detailed setup and usage instructions, refer to the codemie-helm-charts repository.
:::

## Angular Upgrade Assistant

Angular Upgrade Assistant helps automate and simplify Angular application upgrades.

:::info
For detailed setup and usage instructions, refer to the codemie-helm-charts repository.
:::

## Salesforce DevForce AI

Salesforce DevForce AI provides AI-powered development tools for Salesforce environments.

:::info
For detailed setup and usage instructions, refer to the codemie-helm-charts repository.
:::
