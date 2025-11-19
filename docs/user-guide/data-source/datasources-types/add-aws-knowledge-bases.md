---
id: add-aws-knowledge-bases
title: Add AWS Knowledge Bases as Data Source
sidebar_label: Add AWS Knowledge Bases as Data Source
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

## AWS IAM Setup

Before creating an AWS integration in AI/Run CodeMie, you need to set up an IAM user with appropriate permissions in your AWS account.

### Step 1: Create IAM User

#### 1. Log into your AWS account

Navigate to the AWS Management Console and log in with your credentials.

#### 2. Access IAM Service

In the search bar, enter `IAM` to access the Identity and Access Management service.

![AWS IAM Users](./add-aws-knowledge-bases/aws-iam-users.png)

#### 3. Navigate to Users

Navigate to **Access management** → **Users**. Click **Create user**:

![AWS Create User](./add-aws-knowledge-bases/aws-create-user.png)

#### 4. Set User Details

**User name**: Provide a descriptive name for the IAM user (e.g., `codemie-kb-user`)

**Best practices for user naming:**
- Use descriptive names indicating the purpose (e.g., `codemie-bedrock-access`)
- Follow your organization's naming conventions
- Include service or application name for easy identification

#### 5. Set Permissions

Click **Next** to proceed to the permissions setup.

#### 6. Attach Policies

![AWS Attach Policies](./add-aws-knowledge-bases/aws-attach-policies.png)

Attach the following AWS managed policy:

- **AmazonBedrockFullAccess** - Provides full access to Amazon Bedrock services including Knowledge Bases

:::warning Permission Scope
For production environments, consider creating a custom policy with more restrictive permissions that only allow access to specific Knowledge Bases. The `AmazonBedrockFullAccess` policy grants broad permissions and should be used carefully.
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

#### 7. Review and Create

Review the user configuration and click **Create user**.

![AWS User Created](./add-aws-knowledge-bases/aws-user-created.png)

The IAM user has been successfully created.

### Step 2: Create Access Keys

After creating the IAM user, you need to generate access keys for programmatic access.

#### 1. Select the User

From the Users list, click on the newly created user.

#### 2. Create Access Key

Navigate to the **Security credentials** tab and scroll to **Access keys** section.

Click **Create access key**.

![AWS Create Access Key](./add-aws-knowledge-bases/aws-create-access-key.png)

#### 3. Select Use Case

Select **Third-party service** as the use case for this access key.

:::info Use Case Selection
Third-party service is the appropriate option when granting access to external applications like AI/Run CodeMie.
:::

#### 4. Retrieve Access Keys

![AWS Retrieve Keys](./add-aws-knowledge-bases/aws-retrieve-keys.png)

**Important**: Save both the **Access key ID** and **Secret access key** immediately. The secret access key will not be shown again after you leave this page.

**Best practices for key management:**
- Store keys securely (use a password manager or secrets management service)
- Never commit keys to version control systems
- Rotate keys periodically for security
- Use separate keys for different environments (dev, staging, production)

#### 5. Download or Copy Keys

Download the `.csv` file or copy both keys to a secure location. You will need these credentials when creating the AWS integration in AI/Run CodeMie.

## Creating AWS Integration in AI/Run CodeMie

After setting up the IAM user and access keys in AWS, create an integration in AI/Run CodeMie to connect to your AWS account.

### Step 1: Navigate to Integrations

Navigate to the **Integrations** section in AI/Run CodeMie.

![AWS Integrations Tab](./add-aws-knowledge-bases/aws-integrations-tab.png)

### Step 2: Create New Integration

Click the **+ Create Integration** button.

![AWS Create Integration](./add-aws-knowledge-bases/aws-create-integration.png)

### Step 3: Select AWS

Select **AWS** as the integration type.

### Step 4: Configure AWS Integration

![AWS Integration Form](./add-aws-knowledge-bases/aws-integration-form.png)

Fill in the following fields:

#### Integration Name

Provide a descriptive name for this integration (e.g., `aws-bedrock-production`).

**Naming best practices:**
- Include environment name (dev, staging, prod)
- Reference the AWS account or region
- Use clear, descriptive names

#### AWS Access Key ID

Paste the **Access key ID** you obtained when creating the IAM user access key.

#### AWS Secret Access Key

Paste the **Secret access key** you obtained when creating the IAM user access key.

:::warning Security
Never share your AWS secret access key. Treat it as a password. If compromised, immediately delete the access key in AWS IAM and create a new one.
:::

#### AWS Region

Select the AWS region where your Knowledge Base is located (e.g., `us-east-1`, `us-west-2`, `eu-west-1`).

**Common AWS regions:**
- `us-east-1` - US East (N. Virginia)
- `us-west-2` - US West (Oregon)
- `eu-west-1` - Europe (Ireland)
- `ap-southeast-1` - Asia Pacific (Singapore)

:::tip Region Selection
Ensure you select the same region where your AWS Knowledge Base was created. Cross-region access is not supported for Knowledge Bases.
:::

### Step 5: Save Integration

Click **Save** to create the integration.

![AWS Success Integration](./add-aws-knowledge-bases/aws-success-integration.png)

The integration has been successfully created and is ready to use with AWS Knowledge Bases data sources.

## Adding an AWS Knowledge Bases Data Source

After creating the AWS integration, you can add AWS Knowledge Bases as data sources.

### Step-by-Step Process

#### 1. Navigate to Data Sources

Navigate to the **Data Sources** section in AI/Run CodeMie.

#### 2. Create New Data Source

Click the **+ Create Datasource** button and add all required data according to recommendations.

#### 3. Select AWS Knowledge Bases Source Type

Select **AWS Knowledge Bases** source type in the add new data source window.

![AWS Data Source Form](./add-aws-knowledge-bases/aws-datasource-form.png)

#### 4. Configure AWS Knowledge Bases-Specific Fields

##### Project

Select the name of the project with which you want to associate that DataSource.

**Purpose**: Organizes data sources by project for better management and team collaboration.

##### Knowledge Base ID

Provide the **Knowledge Base ID** from your AWS Bedrock Knowledge Base.

**How to find Knowledge Base ID:**
1. Log into AWS Management Console
2. Navigate to Amazon Bedrock service
3. Go to Knowledge Bases section
4. Select your Knowledge Base
5. Copy the Knowledge Base ID (format: `XXXXXXXXXX`)

**Example Knowledge Base ID**: `ABC123XYZ456`

##### Integration Selection

Select the **AWS integration** you created earlier from the dropdown.

**What you'll see:**
- Previously created AWS integrations will be displayed
- Choose the integration that corresponds to your AWS account and region
- Ensure the integration has valid credentials

##### Data Source Name

Specify a relevant and distinctive name for your AWS Knowledge Bases data source.

**Naming best practices:**
- Use descriptive names that indicate the content
- Include the Knowledge Base purpose or topic
- Follow lowercase naming conventions
- Use hyphens or underscores for word separation
- Examples: `product-documentation-kb`, `customer-support-kb`, `technical-faqs-kb`

##### Description

Provide a brief description that outlines the Knowledge Base's content and purpose.

**Description best practices:**
- Explain what information the Knowledge Base contains
- Note the type of content (documentation, FAQs, policies)
- Mention the intended use case
- Example: "Product documentation Knowledge Base containing user guides and technical specifications"

##### Model Used for Embeddings

Specify the assistant's LLM model for processing AWS Knowledge Bases content.

**Purpose**: Determines which AI model processes the retrieved content for further analysis and responses.

**Common options:**
- Standard models for general purposes
- Follow your organization's model selection guidelines

#### 5. Create the Data Source

Click the **+ Create** button and wait for the process to finish.

**What happens next:**
1. AI/Run CodeMie validates the Knowledge Base ID
2. Connection to AWS is established using the integration credentials
3. Knowledge Base accessibility is verified
4. Data source is registered and ready for use

:::info Indexing Note
Unlike other data source types, AWS Knowledge Bases are not indexed by AI/Run CodeMie. Instead, queries are sent directly to AWS Bedrock, which retrieves relevant information from the Knowledge Base in real-time.
:::

## Error Handling

### Common Errors

#### Invalid Knowledge Base ID

**Symptom**: Error message indicating the Knowledge Base cannot be found

**Cause**: Incorrect Knowledge Base ID or Knowledge Base doesn't exist in the specified region

**Solutions:**
1. Verify the Knowledge Base ID is correct
2. Ensure the Knowledge Base exists in AWS Bedrock
3. Check that the Knowledge Base is in the same region as specified in the integration
4. Confirm the Knowledge Base hasn't been deleted

#### Access Denied

**Symptom**: Permission denied error when trying to access the Knowledge Base

**Cause**: IAM user lacks necessary permissions to access the Knowledge Base

**Solutions:**
1. Verify the IAM user has `AmazonBedrockFullAccess` policy attached
2. Check if custom policies include required Bedrock permissions
3. Ensure the Knowledge Base resource policy allows access from the IAM user
4. Review AWS CloudTrail logs for detailed permission errors

#### Invalid Credentials

**Symptom**: Authentication failed or invalid access key error

**Cause**: AWS access keys are incorrect, expired, or have been rotated

**Solutions:**
1. Verify Access Key ID is correct in the integration
2. Ensure Secret Access Key hasn't been modified
3. Check if the IAM user still exists in AWS
4. Generate new access keys if current ones are compromised
5. Update the integration with new credentials

#### Wrong Region

**Symptom**: Knowledge Base not found despite correct ID

**Cause**: Integration is configured for a different AWS region than where the Knowledge Base exists

**Solutions:**
1. Check the region where your Knowledge Base was created in AWS
2. Update the AWS integration to use the correct region
3. Create a new integration if multiple regions are needed
4. Verify region codes match AWS documentation

#### Connection Timeout

**Symptom**: Request timeout when trying to connect to AWS

**Cause**: Network connectivity issues or AWS service outage

**Solutions:**
- Check network connectivity to AWS services
- Verify no firewall rules blocking AWS API calls
- Check AWS Service Health Dashboard for outages
- Try again after a few minutes
- Contact AWS Support if issue persists

## Understanding AWS Knowledge Bases

AWS Knowledge Bases in Amazon Bedrock allow you to build RAG (Retrieval-Augmented Generation) applications using your own data.

### Key Concepts

#### Knowledge Base

A Knowledge Base is a managed resource in Amazon Bedrock that stores your data and makes it searchable for AI applications.

**Components:**
- **Data source**: Where your documents are stored (S3, etc.)
- **Embeddings model**: Converts text to vector representations
- **Vector database**: Stores the embeddings for fast retrieval
- **Retrieval configuration**: Controls how information is retrieved

#### RAG (Retrieval-Augmented Generation)

RAG combines information retrieval with text generation:

1. **Retrieval**: Relevant information is retrieved from the Knowledge Base
2. **Augmentation**: Retrieved context is added to the prompt
3. **Generation**: LLM generates a response using both the query and context

**Benefits:**
- Responses grounded in your specific data
- Up-to-date information without retraining models
- Reduced hallucinations
- Source attribution for answers

#### Real-Time Retrieval

Unlike indexed data sources, AWS Knowledge Bases use real-time retrieval:

**How it works:**
1. User query is sent to AI/Run CodeMie assistant
2. Assistant determines Knowledge Base should be queried
3. Query is sent to AWS Bedrock Knowledge Base
4. Relevant documents are retrieved in real-time
5. Content is returned to the assistant
6. Assistant generates response using retrieved information

**Advantages:**
- Always accesses latest data in Knowledge Base
- No need for manual reindexing
- Automatic updates when Knowledge Base content changes
- Scales with Knowledge Base size

## Best Practices

### AWS IAM Management

- **Least privilege**: Grant only necessary permissions to IAM users
- **Separate users**: Create dedicated IAM users for each environment
- **Key rotation**: Regularly rotate access keys (every 90 days recommended)
- **Monitor access**: Use AWS CloudTrail to audit API calls
- **Enable MFA**: Add multi-factor authentication for sensitive operations

### Knowledge Base Organization

- **Structured content**: Organize information logically in your Knowledge Base
- **Clear naming**: Use descriptive names for data sources
- **Regular updates**: Keep Knowledge Base content current
- **Quality data**: Ensure high-quality, accurate information
- **Test queries**: Verify retrieval works as expected

### Integration Management

- **Secure credentials**: Store AWS access keys securely
- **Document integrations**: Keep records of which integration connects to which AWS account
- **Region consistency**: Use consistent regions across related resources
- **Test connectivity**: Verify integrations work before creating data sources
- **Monitor costs**: Track AWS Bedrock usage and costs

### Data Source Configuration

- **Descriptive names**: Use clear, meaningful data source names
- **Detailed descriptions**: Provide comprehensive descriptions for better context
- **Appropriate models**: Select embedding models that match your content type
- **Project organization**: Group related Knowledge Bases by project

## Use Cases

### Enterprise Documentation

- Index company policies and procedures
- Make employee handbooks searchable
- Access technical documentation
- Reference standard operating procedures

### Customer Support

- Create FAQ knowledge bases
- Index troubleshooting guides
- Store product documentation
- Maintain support article libraries

### Product Information

- Index product specifications
- Store feature documentation
- Maintain user guides
- Reference API documentation

### Compliance and Legal

- Index regulatory documents
- Store compliance guidelines
- Access legal policies
- Reference industry standards

## Maintenance

### Regular Tasks

- **Monitor performance**: Track retrieval accuracy and response times
- **Update content**: Keep Knowledge Base content current in AWS
- **Review access**: Audit IAM permissions periodically
- **Check costs**: Monitor AWS Bedrock usage and optimize as needed
- **Rotate credentials**: Replace access keys on a regular schedule

### Knowledge Base Updates

**AWS side:**
- Update documents in S3 or other data sources
- Trigger Knowledge Base sync in AWS console
- Monitor sync status in Bedrock console
- Verify content updates propagated

**AI/Run CodeMie side:**
- No action required - changes reflect automatically
- Test retrieval after major content updates
- Update data source descriptions if scope changes
- Verify assistant responses use updated information

## Troubleshooting Tips

### Knowledge Base Not Returning Results

**Common causes:**
- Query doesn't match Knowledge Base content
- Knowledge Base is empty or not synced
- Retrieval configuration too restrictive
- Embeddings model mismatch

**Solutions:**
1. Verify Knowledge Base has content in AWS
2. Check Knowledge Base sync status
3. Test queries in AWS Bedrock console first
4. Review retrieval configuration settings
5. Ensure query is relevant to Knowledge Base content

### Slow Retrieval Performance

**Common causes:**
- Large Knowledge Base with many documents
- Network latency to AWS region
- Complex queries requiring multiple retrievals

**Solutions:**
1. Optimize Knowledge Base size and structure
2. Use geographically closer AWS region
3. Simplify queries when possible
4. Review AWS Bedrock performance metrics
5. Consider Knowledge Base partitioning for large datasets

### High AWS Costs

**Common causes:**
- Frequent retrieval requests
- Large document retrievals
- Inefficient query patterns

**Solutions:**
1. Monitor AWS Bedrock usage in Cost Explorer
2. Implement query caching where appropriate
3. Optimize retrieval configurations
4. Review and refine assistant prompts
5. Set up AWS Budgets alerts

## Security Considerations

### Access Control

- **IAM policies**: Use restrictive IAM policies limiting access to specific Knowledge Bases
- **Integration isolation**: Use separate integrations for different environments
- **Credential rotation**: Regularly rotate AWS access keys
- **Audit logging**: Enable AWS CloudTrail for all Bedrock API calls

### Data Privacy

- **Data residency**: Ensure Knowledge Base region complies with data residency requirements
- **Encryption**: Verify data is encrypted at rest in S3 and in transit
- **Access logs**: Monitor who accesses Knowledge Bases through CloudTrail
- **Compliance**: Ensure Knowledge Base usage meets regulatory requirements

### Best Practices

- Never commit AWS credentials to version control
- Use environment-specific IAM users
- Implement least-privilege access policies
- Enable MFA for AWS console access
- Monitor for unusual API activity
- Encrypt sensitive data before uploading to Knowledge Bases

## AWS Knowledge Bases vs Other Data Sources

### Comparison

| Feature | AWS Knowledge Bases | Other Data Sources |
| --- | --- | --- |
| **Indexing** | Real-time retrieval from AWS | Indexed in AI/Run CodeMie |
| **Updates** | Automatic, reflects AWS changes | Requires manual reindexing |
| **Storage** | Stored in AWS | Stored in AI/Run CodeMie |
| **Scalability** | Scales with AWS Bedrock | Limited by platform storage |
| **Cost** | AWS Bedrock charges apply | Platform storage costs |
| **Latency** | Network call to AWS | Local retrieval (faster) |
| **Setup** | Requires AWS account and IAM | Direct integration or upload |

### When to Use AWS Knowledge Bases

**Choose AWS Knowledge Bases when:**
- You already use AWS Bedrock for other purposes
- You need real-time access to frequently updated content
- Your data is already in S3 or AWS services
- You require AWS's scalability and reliability
- You have large document collections (> 50MB)

**Choose other data sources when:**
- Content updates infrequently
- You want faster local retrieval
- You don't have AWS infrastructure
- Files are under 50MB
- You need simpler setup without AWS account

## Next Steps

After adding your AWS Knowledge Bases data source:

- [Configure assistants](../../assistants/) to use the Knowledge Base
- [Set up workflows](../../workflows/) that leverage AWS Knowledge Bases
- Test retrieval by asking questions related to your Knowledge Base content
- Monitor AWS Bedrock costs in AWS Console

:::tip Performance Tip
For optimal results, structure your AWS Knowledge Base content with clear, focused documents. Use descriptive titles and organize information logically. This improves retrieval accuracy and helps assistants provide better responses.
:::

Now your AWS Knowledge Base is configured as a data source and ready to enhance your assistants with enterprise knowledge from Amazon Bedrock.
