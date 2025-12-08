---
id: add-aws-knowledge-bases
title: Add AWS Knowledge Bases as Data Source
sidebar_label: Add AWS Knowledge Bases as Data Source
pagination_next: null
---

# Add AWS Knowledge Bases as Data Source

Connect and index AWS Knowledge Bases as data sources.

AWS Knowledge Bases is a powerful data source in AI/Run CodeMie, enabling assistants to access information stored in Amazon Bedrock Knowledge Bases. This guide walks you through the process of setting up AWS IAM credentials and adding AWS Knowledge Bases as a data source.

## Prerequisites

:::note Required Integration
This data source requires you to have at least one AWS integration added to AI/Run CodeMie. For more details, please refer to the [Integrations Overview](../../integrations/) guidelines.
:::

Before adding an AWS Knowledge Bases data source, ensure you have:

- An active AWS account with access to Amazon Bedrock
- AWS Knowledge Base already created in your AWS account
- Permission to create IAM users and access keys
- Understanding of AWS IAM policies and permissions
- AWS Knowledge Base ID ready

:::tip AWS Knowledge Bases Overview
AWS Knowledge Bases (part of Amazon Bedrock) let you index large-scale enterprise data. This integration is ideal for companies already using AWS infrastructure.
:::

## AWS IAM Setup

Before creating an AWS integration in AI/Run CodeMie, you need to set up an IAM user with appropriate permissions in your AWS account.

### Step 1: Create IAM User

#### 1. Log into your AWS account

Navigate to the AWS Management Console and log in with your credentials.

#### 2. Access IAM Service

In the search bar, enter `IAM` to access the Identity and Access Management service.

![AWS IAM Users](./add-aws-knowledge-bases/image37.png)

#### 3. Navigate to Users

Navigate to **Access management** → **Users**. Click **Create user**:

![AWS Create User](./add-aws-knowledge-bases/image45.png)

#### 4. Set User Details

**User name**: Provide a descriptive name for the IAM user (e.g., `codemie-kb-user`)

**Best practices for user naming:**

- Use descriptive names indicating the purpose (e.g., `codemie-bedrock-access`)
- Follow your organization's naming conventions
- Include service or application name for easy identification

#### 5. Set Permissions

Click **Next** to proceed to the permissions setup.

#### 6. Attach Policies

![AWS Attach Policies](./add-aws-knowledge-bases/image49.png)

Attach the following AWS managed policy:

- **AmazonBedrockFullAccess** - Provides full access to Amazon Bedrock services including Knowledge Bases

:::warning Permission Scope
For production environments, consider creating a custom policy with more restrictive permissions that only allow access to specific Knowledge Bases. The `AmazonBedrockFullAccess` policy grants broad permissions and should be used carefully.
:::

:::danger Production Security
Never use `AmazonBedrockFullAccess` in production. Always create custom IAM policies with least-privilege access to specific Knowledge Base ARNs.
:::

**Alternative: Custom Policy**

For more granular control, create a custom policy with these permissions:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "bedrock:GetKnowledgeBase",
        "bedrock:ListKnowledgeBases",
        "bedrock:Retrieve",
        "bedrock:RetrieveAndGenerate"
      ],
      "Resource": "*"
    }
  ]
}
```

:::info Custom Policy Benefits
This custom policy grants only the minimum permissions needed:

- `GetKnowledgeBase`: Read KB metadata
- `ListKnowledgeBases`: Discover available KBs
- `Retrieve`: Query the knowledge base
- `RetrieveAndGenerate`: Generate responses with KB context
  :::

#### 7. Review and Create

Review the user configuration and click **Create user**.

The IAM user has been successfully created.

### Step 2: Create Access Keys

After creating the IAM user, you need to generate access keys for programmatic access.

#### 1. Select the User

From the Users list, click on the newly created user.

#### 2. Create Access Key

![AWS User Created](./add-aws-knowledge-bases/image18.png)

Navigate to the **Security credentials** tab and scroll to **Access keys** section.

Click **Create access key**.

![AWS Create Access Key](./add-aws-knowledge-bases/image5.png)

:::info
Third-party service is the appropriate option when granting access to external applications like AI/Run CodeMie.
:::

:::warning Security Best Practice
Download your access keys immediately and store them securely. AWS shows them only once. If lost, you must create new access keys.
:::

#### 4. Retrieve Access Keys

1. In the AI/Run CodeMie main menu, click the Integrations button.
2. Select User or Project and click the + Create button.
3. Fill in the required fields and click Create:

- Project Name: Specify project name.
- Credential Type: **AWS**
- Alias: Specify the integration name.
- Region: Specify the AWS Region to work in.
- Access Key ID: Paste the **Access Key** ID data copied from preview step.
- Secret access key: Paste the **Secret Access Key** data copied from preview step.

![AWS Integration Create Form](./add-aws-knowledge-bases/aws-integration-create-form.png)
:::info
You can “Test Integration” connection before creating.
:::

![AWS Integration Test Connection](./add-aws-knowledge-bases/aws-integration-test-connection.png)

To verify connection click on Profile Icon -> Settings -> EXTERNAL VENDORS -> Knowledge Bases

![AWS Knowledge Bases Settings](./add-aws-knowledge-bases/aws-knowledge-bases-settings.png)

Now you can select data source from the drop down list in **Data Source Context section** of your assistant:

![AWS DataSource Dropdown Select](./add-aws-knowledge-bases/aws-datasource-dropdown-select.png)
