---
id: aws-bedrock
sidebar_position: 5
title: AWS Bedrock
description: Enable and configure AWS Bedrock foundation models
---

# AWS Bedrock Configuration

## Overview

This guide explains how to enable AWS Bedrock foundation models in your AWS account for use with AI/Run CodeMie. AWS Bedrock provides access to high-performance foundation models from Anthropic (Claude), Amazon (Titan), etc.

:::info When to Use This Guide
This configuration is required if you plan to use AWS Bedrock models such as Anthropic Claude, Amazon Titan, or other foundation models available through AWS Bedrock.
:::

## Prerequisites

Before starting, ensure you have:

- **AWS Account**: Active AWS account with appropriate permissions
- **IAM Permissions**: Ability to manage Bedrock model access

:::warning Model Access Approval
Some foundation models require approval before use. The approval process is typically instant for most models, but some providers may require additional review.
:::

## Step 1: Access AWS Bedrock Console

### 1.1 Sign in to AWS Console

1. Go to [AWS Management Console](https://console.aws.amazon.com/)
2. Sign in with your AWS credentials
3. Ensure you're in the correct AWS region (top-right corner)

### 1.2 Navigate to AWS Bedrock

1. In the AWS Console search bar, type "Bedrock"
2. Select **Amazon Bedrock** from the results
3. The Bedrock console will open

:::tip Region Selection
Choose a region that:

- Supports the models you need
- Is close to your users for lower latency
- Meets your data residency requirements
  :::

## Step 2: Request Model Access

### 2.1 Navigate to Model Access

1. In the Bedrock console left navigation, click **Model access**
2. You'll see a table listing all available foundation models
3. Models are grouped by provider (Anthropic, Amazon, etc.)

### 2.2 Request Access to Models

1. Review the list of available models
2. Identify models you want to use
3. Select models by checking the checkbox next to each model name
4. Click **Request model access** or **Modify model access**

**Recommended Models for AI/Run CodeMie**:

| Provider      | Model             | Use Case                                 |
| ------------- | ----------------- | ---------------------------------------- |
| **Anthropic** | Claude 4.5 Sonnet | Primary chat, reasoning, code generation |
| **Anthropic** | Claude 4.5 Opus   | Complex reasoning, large context tasks   |
| **Amazon**    | Titan Embeddings  | Text embeddings for RAG                  |

## Regional Considerations

### Cross-Region Model Availability

Different models are available in different AWS regions. Not all foundation models are accessible in every region.

**Before requesting access**:

1. Verify model availability in your target region
2. Check [AWS Bedrock Model Availability](https://docs.aws.amazon.com/bedrock/latest/userguide/models-regions.html)
3. Consider data residency and compliance requirements

## Quota and Limits

### Understanding Quotas

AWS Bedrock has quotas for:

- **Requests per minute**: Limits on API call frequency
- **Tokens per minute**: Limits on token processing
- **Model-specific limits**: Vary by model and region

### Requesting Quota Increases

1. Go to AWS Service Quotas console
2. Search for "Bedrock"
3. Select the quota you need to increase
4. Click **Request quota increase**
5. Provide justification and desired limit
6. Submit request (typically approved within 2-7 days)
