---
id: litellm-proxy-overview
sidebar_label: LiteLLM Proxy
sidebar_position: 1
title: LiteLLM Proxy Installation and Configuration Guide
description: Load balancing and high availability for LLM requests
---

# LiteLLM Proxy Installation and Configuration Guide

This guide provides instructions for installing and configuring the LiteLLM Proxy, which serves as a unified gateway for our platform. It enables seamless connection to a diverse range of Large Language Models (LLMs) from providers like AWS Bedrock, Azure OpenAI, and Google Vertex AI. LiteLLM is the recommended solution for implementations that require support for multiple LLM providers or advanced features such as spend tracking and user-based budgeting.

## Prerequisites

:::info Prerequisites

Before you begin, please ensure you have the following:

- **Access to your Kubernetes cluster via `kubectl`.**
- **Access to the [codemie-helm-charts](https://gitbud.epam.com/epm-cdme/codemie-helm-charts) repository.**

**Conditional Prerequisites:**

- **If you are using AWS Bedrock LLM models:**
  - Option 1 (Recommended for EKS): IAM Role with access to Bedrock services for use with IRSA (IAM Roles for Service Accounts)
  - Option 2: AWS User with access to Bedrock services

- **If you are using Azure OpenAI LLM models:**
  - Option 1 (Recommended): Azure Entra ID Application with access to Azure OpenAI services
  - Option 2: Direct API key authentication

- **If you are using GCP Vertex AI LLM models:**
  - GCP Service Account with access to Vertex AI

:::

:::warning

Minimal supported version of AI/Run CodeMie for use with LiteLLM Proxy is 2.0.0. Make sure you've updated your CodeMie installation before proceeding.

:::

## LiteLLM Proxy System Requirements

The diagram below depicts the LiteLLM Proxy deployed on Kubernetes infrastructure within a cloud environment.

![LiteLLM Architecture](./images/litellm-architecture.drawio.png)

### Components and Requirements

| Component                  | CPU (Limits/Requests) | Memory (Limits/Requests) | Storage   |
| -------------------------- | --------------------- | ------------------------ | --------- |
| LiteLLM Proxy x 2 Replicas | 2 / 2 (1 / 1)         | 4Gi / 4Gi (2Gi / 2Gi)    | —         |
| Redis                      | 0.15 / 0.1            | 192Mi / 128Mi            | 2Gi       |
| PostgreSQL[^1]             | —                     | —                        | —         |
| **Total**                  | ~2.15 / ~2.1 vCPU     | ~4 / ~4 GiB RAM          | ~2 Gi PVC |

[^1]: Reusing main AI/Run CodeMie PostgreSQL instance

## Deployment Workflow

This guide provides a complete workflow for installing and integrating the LiteLLM Proxy. The process is divided into the following parts:

1. **[PostgreSQL Database Setup](./postgres-setup)** — Create a dedicated database and user for LiteLLM.
2. **[Configure API and Proxy Values](./configure-values)** — Configure the required `values.yaml` files for CodeMie and LiteLLM.
3. **[Cloud Provider Authentication](./auth-secrets)** — Configure credentials for AWS, Azure, and GCP.
4. **[LiteLLM Model Configuration](./model-config)** — Configure model lists and regions.
5. **[Deployment](./deployment)** — Install the LiteLLM Proxy using one of two methods:
   - Automated Deployment (Recommended)
   - Manual Deployment

For users migrating from the deprecated DIAL Proxy, see:

- **[Migration Guide from DIAL to LiteLLM](./migration-guide)**

## Next Steps

Follow the deployment workflow starting with [PostgreSQL Database Setup](./postgres-setup).
