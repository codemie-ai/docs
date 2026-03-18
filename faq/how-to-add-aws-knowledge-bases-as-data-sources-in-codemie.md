# How to add AWS Knowledge Bases as Data Sources in CodeMie? How do I connect my AWS Knowledge Bases to CodeMie? What permissions do I need for AWS Knowledge Bases integration? How to verify AWS Knowledge Bases connection in CodeMie settings?

AWS Knowledge Bases can be integrated as external data sources in CodeMie, allowing you to leverage your AWS Bedrock Knowledge Bases for enhanced AI assistance.

## Prerequisites:

- Active AWS account with Bedrock access
- CodeMie platform access
- AWS Knowledge Bases already created in your AWS account

Setup Process  
Step 1: Create AWS IAM User

1. Log into your AWS account
2. In the search bar, enter IAM
3. Navigate to Access management → Users
4. Click Create user
5. Set appropriate permissions for Bedrock and Knowledge Bases access
6. Click Create user

## Step 2: Generate Access Keys

1. Click on the created user to view their management page
2. Navigate to Security credentials → Access keys
3. Click Create access key
4. Copy both Access key and Secret access key for later use

## Step 3: Configure CodeMie Integration

1. In the CodeMie main menu, click the Integrations button
2. Select User or Project integration type
3. Click the + Save button
4. Fill in the required fields:
5. Project Name: Specify your project name
6. Credential Type: Select AWS
7. Alias: Specify a meaningful integration name
8. Region: Specify the AWS Region where your Knowledge Bases are located
9. Access Key ID: Paste the Access Key from Step 2
10. Secret access key: Paste the Secret access key from Step 2
11. (Optional) Click Test Integration to verify connection
12. Click Create

## Step 4: Verify and Access Knowledge Bases

1. Click on Profile Icon → Settings
2. Navigate to EXTERNAL VENDORS → Knowledge Bases
3. Verify that your AWS Knowledge Bases are listed and accessible
4. Your Knowledge Bases will now be available in the Data Source Context dropdown when creating or editing assistants

## Important Notes

- Ensure your AWS IAM user has appropriate permissions for Bedrock and Knowledge Bases access
- The AWS region in your CodeMie integration must match the region where your Knowledge Bases are created
- Knowledge Bases will appear in the Data Source Context section after successful integration

## Sources

- [Add Aws Knowledge Bases](https://docs.codemie.ai/user-guide/data-source/datasources-types/add-aws-knowledge-bases)
