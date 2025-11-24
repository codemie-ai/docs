---
id: azure-openai
sidebar_position: 3
title: Azure OpenAI Models (Optional)
description: Configure Azure OpenAI Service models
---

# Azure OpenAI Models (Optional)

:::note
**Required in case of using Azure OpenAI models such as GPT-4o, etc.**
:::

## Overview

This section describes the process of enabling Azure AI models in Azure account.

## Steps to Enable Azure AI Models

1. Create Cognitive Account Resource
   - Navigate to [Azure Portal](https://portal.azure.com)
   - Search for "Azure OpenAI" and click "Create"
   - Fill in the required details:
     - Subscription
     - Resource group
     - Region
     - Name
     - Pricing tier (typically S0)
     - Network: "All networks" type
   - Click "Review + create" and then "Create"

2. Configure API Access
   - Once deployment is complete, go to the resource
   - Navigate to "Keys and Endpoint" section
   - Note down:
     - Key 1 or Key 2
     - Endpoint URL
     - Resource location

3. Deploy AI Model
   - Go to Cognitive Account
   - In "Overview" tab, click "Go to Azure AI Foundry portal"
   - In the left menu, navigate to "shared resources" -> "Deployments"
   - Click "Deploy model" -> "Deploy base model"
   - Search and select desired model
   - Click "Confirm"
   - Configure deployment settings:
     - Deployment name: [your-deployment-name]
     - Deployment type:
       - Standard
       - Global Standard
     - Model version: Select appropriate version
     - Tokens per Minute Rate Limit:
       - Set to maximum value if deploying single instance in region
       - Adjust based on quota requirements for multiple deployments
       - Reference "Quota" menu in left navigation for detailed limits
     - Review settings and click "Deploy"
