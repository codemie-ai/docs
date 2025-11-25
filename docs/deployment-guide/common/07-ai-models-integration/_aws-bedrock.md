:::note
**Required in case of using Anthropic Claude models**
:::

## Overview

This section describes the process of enabling AWS Bedrock models in AWS account.

## Steps to Enable Bedrock Models

**1. Access AWS Bedrock Console**

1. Sign in to the AWS Management Console
2. Navigate to the AWS Bedrock service
3. Select "Model access" from the left navigation panel

**2. Request Model Access**

1. In the Model access page, you'll see available foundation models grouped by providers

2. Common providers include:
   - Anthropic (Claude models)
   - Amazon

3. For each model you want to enable:
   - Locate the model in the list
   - Check the checkbox next to the model name
   - Click "Request model access"

**3. Verify Model Access**

1. After requesting access, the status will initially show as "Pending"
2. Wait for the status to change to "Access granted"
3. This typically takes only a few minutes
4. Refresh the page to see updated status

**4. Region-Specific Configuration**

- Note that model access needs to be enabled separately for each AWS region
- Repeat the process for additional regions if needed
