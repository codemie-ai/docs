---
id: aws-bedrock
sidebar_position: 5
title: AWS Bedrock
description: Enable and configure AWS Bedrock foundation models
pagination_prev: admin/configuration/codemie/ai-models-integration/ai-models-integration-overview
pagination_next: null
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
- **IAM Permissions**: Permissions to invoke Bedrock models (`bedrock:InvokeModel` or `bedrock:Converse`)
- **AWS Marketplace Permissions**: Required for first-time activation of marketplace models

## Model Access Overview

:::info Model Access Page Retired
The **Model access** page in the AWS Bedrock console has been retired. Serverless foundation models are now **automatically enabled** across all AWS commercial regions when first invoked in your account, so you can start using them instantly without manual activation.
:::

### How Model Access Works

**Automatic Activation**:

- Foundation models are enabled automatically when you first invoke them via API
- No need to manually request access through the console
- Models become available account-wide after first invocation

**Special Requirements**:

1. **Anthropic Models**: First-time users must submit use case details before accessing these models (see CLI/SDK method below)
2. **AWS Marketplace Models**: A user with AWS Marketplace permissions must invoke the model once to enable it account-wide for all users

**Access Control**:

- Account administrators can control model access through IAM policies
- Use Service Control Policies (SCPs) to restrict access as needed

### Getting Started

To start using Bedrock models, you can:

1. **Console Method**: Select a model from the Model catalog and open it in the playground
2. **API Method**: Invoke the model using the API operations via CodeMie
3. **CLI/SDK Method**: Use AWS CLI or SDK to programmatically accept model agreements (required for third-party models like Anthropic)

**Recommended Models for AI/Run CodeMie**:

| Provider      | Model             | Use Case                                 |
| ------------- | ----------------- | ---------------------------------------- |
| **Anthropic** | Claude 4.5 Sonnet | Primary chat, reasoning, code generation |
| **Anthropic** | Claude 4.5 Opus   | Complex reasoning, large context tasks   |
| **Amazon**    | Titan Embeddings  | Text embeddings for RAG                  |

## Regional Considerations

### Cross-Region Model Availability

Different models are available in different AWS regions. Not all foundation models are accessible in every region.

**Before using models**:

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

## Manage Model Access Using SDK and CLI

:::tip Programmatic Access
For automation and infrastructure-as-code workflows, you can manage AWS Bedrock model access programmatically using the AWS CLI and SDK. This approach is recommended for production deployments and CI/CD pipelines.
:::

The original AWS documentation can be found here: [Access Amazon Bedrock foundation models](https://docs.aws.amazon.com/bedrock/latest/userguide/model-access.html#model-access-modify)

### Overview

Access to all Amazon Bedrock foundation models is enabled by default with the correct AWS Marketplace permissions in all commercial AWS regions. For programmatic access to third-party models (e.g., Anthropic Claude models), you need to accept the model agreement offers.

### Prerequisites for CLI Access

- **AWS CLI**: Install and configure the latest AWS CLI with Bedrock support
- **AWS Credentials**: Valid AWS credentials with appropriate IAM permissions
- **Bedrock Permissions**: IAM permissions for `bedrock:*` operations

### Step 1: List Model IDs for Required Foundation Models

To get the list of available foundation models, run:

```bash
aws bedrock list-foundation-models
```

To filter by a specific provider (e.g., Anthropic):

```bash
aws bedrock list-foundation-models --by-provider anthropic | grep modelId
```

**Output example**:

```bash
"modelId": "anthropic.claude-sonnet-4-20250514-v1:0",
"modelId": "anthropic.claude-haiku-4-5-20251001-v1:0",
"modelId": "anthropic.claude-sonnet-4-5-20250929-v1:0",
"modelId": "anthropic.claude-opus-4-1-20250805-v1:0",
"modelId": "anthropic.claude-opus-4-5-20251101-v1:0",
"modelId": "anthropic.claude-opus-4-20250514-v1:0",
```

### Step 2: List Foundation Model Agreement Offers

Run the following command to list the agreement offers for a specific model (example: Anthropic Claude Haiku 4.5):

```bash
aws bedrock list-foundation-model-agreement-offers --model-id anthropic.claude-haiku-4-5-20251001-v1:0
```

**Output example**:

```json
{
  "modelId": "anthropic.claude-haiku-4-5-20251001-v1:0",
  "offers": [
    {
      "offerId": "offer-fu6wq1phlosn4",
      "offerToken": "token",
      "termDetails": {
        "usageBasedPricingTerm": {
          "rateCard": [
            {
              "dimension": "USE1_InputTokenCount",
              "price": "1.1",
              "description": "Million Input Tokens Regional",
              "unit": "Units"
            },
            {
              "dimension": "APN3_CacheReadInputTokenCount",
              "price": "0.11",
              "description": "Million Cache Read Input Tokens Regional",
              "unit": "Units"
            }
          ]
        }
      }
    }
  ]
}
```

:::warning Save the Offer Token
Save the `offerToken` value from the output. You'll need it in Step 4 to create the model agreement.
:::

### Step 3: Put Use Case for First-Time Users (Anthropic Models Only)

:::info One-Time Requirement
This step is required **only once** for Anthropic models and only for first-time users. You can skip this step if you've already completed it for any Anthropic model.
:::

Create a JSON file `company.info.json` with your company information:

```json
{
  "companyName": "Company XYZ",
  "companyWebsite": "www.xyz.com",
  "intendedUsers": "1",
  "industryOption": "Healthcare",
  "otherIndustryOption": "Life Sciences",
  "useCases": "Agentic AI SDLC tooling"
}
```

Run the following command:

```bash
aws bedrock put-use-case-for-model-access --form-data "$(cat company.info.json | base64)"
```

### Step 4: Create Foundation Model Agreement

Create the agreement (access) for the foundation model using the offer token and model ID from the previous steps:

```bash
aws bedrock create-foundation-model-agreement --model-id anthropic.claude-haiku-4-5-20251001-v1:0 --offer-token "token"
```

**Output example**:

```json
{
  "modelId": "anthropic.claude-haiku-4-5-20251001-v1:0"
}
```

### Step 5: Get Foundation Model Availability

Check if the model is available for use:

```bash
aws bedrock get-foundation-model-availability --model-id anthropic.claude-haiku-4-5-20251001-v1:0
```

**Output example**:

```json
{
  "modelId": "anthropic.claude-haiku-4-5-20251001-v1",
  "agreementAvailability": {
    "status": "PENDING"
  },
  "authorizationStatus": "AUTHORIZED",
  "entitlementAvailability": "AVAILABLE",
  "regionAvailability": "AVAILABLE"
}
```

:::warning Wait for Activation
The `agreementAvailability.status` will initially show `PENDING`. Wait patiently until it changes to `AVAILABLE`. This may take several minutes for first-time users.
:::

You can poll the status by running the same command periodically:

```bash
# Check status every 30 seconds
watch -n 30 'aws bedrock get-foundation-model-availability --model-id anthropic.claude-haiku-4-5-20251001-v1:0'
```

### Step 6: Activate All Other Required Foundation Models

Repeat **Steps 2, 4, and 5** for all other foundation models you need to activate:

1. List agreement offers (Step 2)
2. Create model agreement (Step 4)
3. Verify availability (Step 5)

:::tip Batch Processing
For multiple models, consider creating a shell script that loops through your required model IDs to automate the activation process.
:::

### Step 7 (Optional): Delete Foundation Model Agreement

If you need to revoke access to a model, run:

```bash
aws bedrock delete-foundation-model-agreement --model-id anthropic.claude-haiku-4-5-20251001-v1:0
```

:::danger Access Revocation
This command will revoke your access to the model. The `agreementAvailability.status` will change to `NOT_AVAILABLE` when you check with `get-foundation-model-availability`.
:::

## Next Steps

After enabling model access, configure AI/Run CodeMie to use these models by updating the AI models integration configuration. Refer to the [AI Models Integration Overview](./) for detailed configuration instructions.
