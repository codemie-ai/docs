# How to manage AWS Bedrock entities through CodeMie platform settings? How to change AWS region for Bedrock entities in CodeMie? How to set up AWS Bedrock integration with CodeMie platform?

Overview  
CodeMie platform allows you to manage AWS Bedrock entities directly through the user interface, providing seamless integration and control over your Bedrock resources.

Prerequisites  
CodeMie platform access

Valid AWS Bedrock account with required access credentials

AWS Bedrock entities created and available in your AWS account

Step-by-Step Process

1. Create AWS Integration  
   Navigate to Settings > AWS Integration in the CodeMie platform

Create a valid AWS integration ensuring the region field matches where your AWS Bedrock entities are created

Validate that access to AWS Bedrock is configured correctly

2. Prepare AWS Bedrock Entities  
   In your AWS account, create AWS Bedrock entities under the region selected in your CodeMie integration

Alternatively, locate pre-existing entities with 'Prepared' status

Ensure entities are properly configured and accessible

3. Access Entity Management  
   Log in to the CodeMie platform

## Navigate to Profile → Settings → External vendor section

Observe the available AWS Bedrock entities listed

4. Import and Manage Entities  
   Import entities on the platform

Verify that the 'Manage' button is active for entities created under the specified region

Use the Manage button to perform operations on your AWS Bedrock entities

5. Region Configuration Management  
   If you need to manage entities under a different region:

## Return to Settings → AWS Integration

Change the AWS integration's region configuration to match the target region

Repeat the import process for entities in the new region

## Sources

- [Aws Bedrock](https://docs.codemie.ai/admin/configuration/codemie/ai-models-integration/aws-bedrock)
