---
id: azure-openai
sidebar_position: 4
title: Azure OpenAI
description: Enable and configure Azure OpenAI models
pagination_prev: admin/configuration/codemie/ai-models-integration/ai-models-integration-overview
pagination_next: null
---

# Azure OpenAI Configuration

## Overview

This guide explains how to enable Azure OpenAI services in your Azure account and deploy AI models for use with AI/Run CodeMie. Azure OpenAI provides access to OpenAI models including GPT-4.1, GPT-5, o1, and o3-series models.

:::info When to Use This Guide
This configuration is required if you plan to use Azure OpenAI models such as GPT-4.1, GPT-5, or any OpenAI models hosted on Azure.
:::

## Prerequisites

Before starting, ensure you have:

- **Azure Subscription**: Active Azure subscription with appropriate permissions
- **Resource Group**: Existing or ability to create a resource group
- **Regional Availability**: Check [Azure OpenAI model availability by region](https://learn.microsoft.com/en-us/azure/ai-services/openai/concepts/models#model-summary-table-and-region-availability)
- **Quota Understanding**: Review [Azure OpenAI quota and limits](https://learn.microsoft.com/en-us/azure/ai-services/openai/quotas-limits)

## Step 1: Create Azure OpenAI Resource

### 1.1 Navigate to Azure Portal

1. Go to [Azure Portal](https://portal.azure.com)
2. Sign in with your Azure credentials

### 1.2 Create Azure OpenAI Service

1. In the search bar, type "Azure OpenAI" and select **Azure OpenAI**
2. Click **Create** or **Create Azure OpenAI resource**
3. Fill in the required configuration:

**Basics Tab**:

| Field              | Value                | Description                          |
| ------------------ | -------------------- | ------------------------------------ |
| **Subscription**   | Your subscription    | Azure subscription to use            |
| **Resource group** | Select or create new | Logical grouping for resources       |
| **Region**         | Choose region        | Select region closest to your users  |
| **Name**           | Unique name          | Resource name (globally unique)      |
| **Pricing tier**   | S0 (Standard)        | Recommended for production workloads |

**Network Tab**:

| Setting     | Recommendation | Description                                               |
| ----------- | -------------- | --------------------------------------------------------- |
| **Network** | All networks   | Allow access from all networks (configure security later) |

4. Click **Review + create**
5. Review settings and click **Create**
6. Wait for deployment to complete (typically 1-2 minutes)

## Step 2: Configure API Access

### 2.1 Access Resource Keys and Endpoint

1. Once deployment completes, click **Go to resource**
2. In the left navigation, select **Keys and Endpoint**
3. Note down the following information:

| Information            | Where to Find             | Purpose            |
| ---------------------- | ------------------------- | ------------------ |
| **Key 1** or **Key 2** | Keys and Endpoint section | API authentication |
| **Endpoint**           | Keys and Endpoint section | API base URL       |
| **Location**           | Overview page             | Resource region    |

### 2.2 Save Credentials Securely

Store the following information for later use:

```bash
# Example credentials (replace with your values)
AZURE_OPENAI_ENDPOINT=https://your-resource-name.openai.azure.com/
AZURE_OPENAI_KEY=your-api-key-here
AZURE_OPENAI_REGION=eastus2
```

## Step 3: Deploy AI Models

### 3.1 Access Azure AI Foundry Portal

1. Return to your Azure OpenAI resource in Azure Portal
2. On the **Overview** tab, click **Go to Azure AI Foundry portal**
3. The Azure AI Foundry portal will open in a new tab

### 3.2 Navigate to Deployments

1. In Azure AI Foundry portal, locate the left navigation menu
2. Under **Shared resources**, click **Deployments**
3. You'll see a list of existing deployments (if any)

### 3.3 Deploy a Model

1. Click **Deploy model** or **+ Create new deployment**
2. Select **Deploy base model**
3. Browse or search for your desired model (e.g., "gpt-4o")
4. Select the model and click **Confirm**

### 3.4 Configure Deployment Settings

| Setting                     | Description                    |
| --------------------------- | ------------------------------ |
| **Deployment name**         | Identifier for this deployment |
| **Deployment type**         | Standard or Global Standard    |
| **Model version**           | Specific model version         |
| **Tokens per Minute (TPM)** | Rate limit for requests        |

**TPM Rate Limit Guidelines**:

- **Single Instance**: Set to maximum available if this is your only deployment in the region
- **Multiple Deployments**: Divide quota across deployments based on expected usage
- **Check Quota**: Navigate to **Quotas** in left menu to see available capacity

5. Review settings and click **Deploy**
6. Wait for deployment to complete (typically 30-60 seconds)

### 3.5 Verify Deployment

1. Once deployed, the model appears in your **Deployments** list
2. Note the **Deployment name** - you'll use this in CodeMie configuration
3. Verify **Status** shows as **Succeeded**

## Step 4: Deploy Additional Models (Optional)

Repeat **Step 3** to deploy additional models based on your requirements:

**Recommended Models**:

- **GPT-4o**: General-purpose, multimodal reasoning and code generation
- **GPT-4o-mini**: Cost-effective option for simpler tasks
- **GPT-4.1**: Advanced reasoning with larger context window
- **GPT-5**: Latest generation model with enhanced capabilities
- **o1/o3-mini**: Specialized reasoning models for complex problem-solving
- **Embedding models**: `text-embedding-ada-002` for vector embeddings

Each model deployment allows you to set specific TPM limits and deployment configurations.

## Step 5: Configure Regional Deployments (Optional)

For high availability and redundancy:

1. Create Azure OpenAI resources in multiple regions
2. Deploy same models in each region
3. Configure load balancing using [LiteLLM Proxy](../../../deployment/extensions/litellm-proxy/)

## Quota Management

### Understanding Quotas

Azure OpenAI quotas are managed at the **region + model** level:

- **Tokens Per Minute (TPM)**: Maximum tokens processed per minute
- **Requests Per Minute (RPM)**: Maximum API requests per minute
- **Deployment Limits**: Maximum number of model deployments per resource

### Viewing and Managing Quotas

1. In Azure AI Foundry portal, click **Quotas** in left navigation
2. View current quota allocation and usage
3. Request quota increases if needed:
   - Click **Request quota**
   - Fill in justification and requirements
   - Submit request (approval typically takes 2-5 business days)

## Security Best Practices

### Network Security

1. **Enable Private Endpoints**:
   - Create private endpoint for Azure OpenAI resource
   - Restrict access to your virtual network

2. **Configure Network Rules**:
   - Navigate to resource **Networking** settings
   - Add allowed IP ranges or virtual networks
   - Enable **Allow Azure services on the trusted services list**
