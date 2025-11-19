---
id: add-google-data-source
title: Add and Index Google Data Source
sidebar_label: Add and Index Google Data Source
---

# Add and Index Google Data Source

Connect and index Google Documents as data sources.

Google Documents are a valuable knowledge source in AI/Run CodeMie, enabling assistants to access structured documentation and FAQs. This guide walks you through the process of adding and indexing Google Docs.

## Overview

Google Documents can be indexed by providing a link with read-only access to AI/Run CodeMie's Google account. The document must be formatted in a specific way, such as FAQs, to be compatible with the platform's parsing and LLM routing capabilities.

## Prerequisites

Before adding a Google Docs data source, ensure you have:

- A Google Document formatted according to AI/Run CodeMie requirements
- Permission to share the document with AI/Run CodeMie's service account
- Understanding of the required document structure

## Required Document Format

Google documents should be created in a specific format to allow AI/Run CodeMie to parse it and use it for LLM routing efficiently instead of traditional semantic search.

### Format Structure

The document format should follow these guidelines:

**1. Titles with triple numeration**
- Use format: `1.1.1.` (numbered sections)
- Apply text style: **Heading 3**
- This creates a hierarchical structure for easy navigation

**2. Content text**
- Use text style: **Normal** for all content inside sections
- Keep content clear and concise
- Structure information logically

### Example Structure

```
1.1.1. What is AI/Run CodeMie?
AI/Run CodeMie is a platform for...

1.1.2. How do I get started?
To get started with AI/Run CodeMie...

1.2.1. Creating your first assistant
Follow these steps to create...
```

:::tip Example Document
For a complete example of the correct format, refer to [this example Google Document](https://docs.google.com/document/d/19EXgnFCgJontz0ToCAH6zMGwBTdhi5X97P9JIby4wHs/edit#heading=h.b01c2ig0adfg).
:::

## Sharing the Document

To allow AI/Run CodeMie to parse a Google Document, you must share the document with AI/Run CodeMie's service account.

### Service Account Email

Share your document with:

```
codemie-kb-crawler@or2-msq-epmd-edp-anthos-t1iylu.iam.gserviceaccount.com
```

### How to Share

1. Open your Google Document
2. Click the **Share** button in the top-right corner
3. Enter the service account email address
4. Set permissions to **Viewer** (read-only access)
5. Click **Send**

:::warning Important
Ensure you grant at least **Viewer** permissions. The service account only needs read access to index the document.
:::

## Adding a Google Data Source

Follow these detailed steps to add a Google Document as a data source:

![Google Data Source Form](./add-google-data-source/google-datasource-form.png)

### Step-by-Step Process

#### 1. Preparation

Before adding the data source:

1. **Format the document** according to the required structure
2. **Share the document** with the AI/Run CodeMie service account
3. **Copy the document URL** from your browser

#### 2. Navigate to Data Sources

Navigate to the **Data Sources** section in AI/Run CodeMie.

#### 3. Create New Data Source

Click the **+ Create Datasource** button and add all required data according to recommendations.

#### 4. Select Google Docs Source Type

Select **Google Docs** source type in the add new data source window.

#### 5. Configure Google Docs-Specific Fields

##### Project
Select the name of the project with which you want to associate that DataSource.

**Purpose**: Organizes data sources by project for better management and team collaboration.

##### Document URL

Provide the Google Document URL.

**URL format:**
```
https://docs.google.com/document/d/DOCUMENT_ID/edit
```

**Requirements:**
- Must be a valid Google Docs URL
- Document must be shared with the service account
- Document must have appropriate permissions

##### Data Source Name

Specify a relevant and distinctive name for your Google Docs data source.

**Naming best practices:**
- Use descriptive names that indicate the document content
- Follow lowercase naming conventions
- Use hyphens or underscores for word separation
- Examples: `product-faq`, `onboarding-guide`, `technical-docs`

##### Description

Provide a brief description that outlines the document's content and purpose.

**Description best practices:**
- Explain what information the document contains
- Note the document structure (e.g., FAQ format)
- Mention the intended use case
- Example: "Product FAQ with common user questions and answers"

##### Model Used for Embeddings

Specify the assistant's LLM model for processing the Google Docs content.

**Purpose**: Determines which AI model processes the document for indexing.

**Common options:**
- Standard models for general purposes
- Follow your organization's model selection guidelines

#### 6. Create the Data Source

Click the **+ Create** button and wait for the process to finish.

**What happens next:**
1. AI/Run CodeMie validates the document URL and access
2. Connection to Google Docs is established
3. Document is parsed according to the format structure
4. Indexing process begins automatically
5. Progress can be monitored in the data source list

## Document Formatting Guidelines

### Heading Structure

Use the triple numeration system for all sections:

**Level 1 Topics:**
```
1.1.1. First main topic
1.1.2. Second main topic
1.1.3. Third main topic
```

**Level 2 Subtopics:**
```
1.2.1. First subtopic
1.2.2. Second subtopic
```

**Apply Heading 3 style:**
- Ensures proper parsing by AI/Run CodeMie
- Creates navigable structure
- Enables efficient LLM routing

### Content Guidelines

**Use Normal text style for:**
- Answers and explanations
- Detailed descriptions
- Code examples
- Lists and bullet points

**Best practices:**
- Keep sections focused on single topics
- Use clear, concise language
- Break long content into subsections
- Include relevant examples

### FAQ Format

For FAQ-style documents:

```
1.1.1. How do I create a new project?
To create a new project, follow these steps:
1. Navigate to the Projects page
2. Click the "Create Project" button
3. Fill in the required fields
4. Click "Save"

1.1.2. How do I invite team members?
Team members can be invited by:
1. Opening the project settings
2. Selecting "Team Members"
3. Entering email addresses
4. Clicking "Send Invitations"
```

## Error Handling

### Common Errors

#### Document Not Accessible

**Cause**: Document hasn't been shared with the service account or has incorrect permissions

**Solutions:**
1. Verify document is shared with the service account email
2. Check that permissions are set to at least "Viewer"
3. Ensure document URL is correct
4. Confirm document is not in a restricted Google Drive folder

#### Invalid Document Format

**Cause**: Document doesn't follow the required formatting structure

**Solutions:**
1. Review the document structure requirements
2. Ensure headings use Heading 3 style
3. Verify triple numeration format (e.g., 1.1.1.)
4. Check that content uses Normal text style
5. Refer to the example document for guidance

#### Parsing Failed

**Cause**: Document structure cannot be parsed correctly

**Solutions:**
1. Simplify complex formatting
2. Remove unsupported elements (tables, images with text)
3. Ensure consistent heading format throughout
4. Test with a simplified version first

#### Permission Denied

**Cause**: Service account doesn't have access to the document

**Solutions:**
1. Re-share the document with the service account
2. Check Google Workspace sharing settings
3. Verify domain-wide sharing policies aren't blocking access
4. Ensure document isn't in a restricted folder

## Best Practices

### Document Organization

- **Single purpose**: Keep each document focused on a specific topic
- **Logical structure**: Use clear hierarchical organization
- **Consistent formatting**: Apply the same structure throughout
- **Regular updates**: Keep content current and accurate

### Content Creation

- **Clear headings**: Use descriptive section titles
- **Concise answers**: Keep explanations focused and brief
- **Complete information**: Provide all necessary details
- **Examples**: Include practical examples when helpful

### Document Maintenance

- **Version control**: Consider creating new data sources for major updates
- **Regular reviews**: Periodically check content accuracy
- **Update sharing**: Ensure service account always has access
- **Monitor indexing**: Verify documents are properly indexed

### Performance Optimization

- **Reasonable size**: Keep documents manageable (not too large)
- **Clear structure**: Well-organized documents parse more efficiently
- **Remove redundancy**: Eliminate duplicate information
- **Focus content**: Include only relevant information

## Use Cases

### FAQ Documentation

- Create comprehensive FAQ documents
- Index customer support questions and answers
- Make troubleshooting guides accessible
- Provide product documentation

### Knowledge Base

- Build internal knowledge repositories
- Document standard operating procedures
- Store best practices and guidelines
- Create training materials

### Product Documentation

- Index product specifications
- Document feature descriptions
- Store user guides and manuals
- Maintain technical documentation

### Onboarding Materials

- Create new employee onboarding guides
- Document company policies
- Store team procedures
- Maintain training resources

## Limitations

### Format Restrictions

- **Required structure**: Must follow triple numeration and Heading 3 format
- **Text-only content**: Images and complex formatting not fully supported
- **Linear structure**: Works best with hierarchical organization
- **Manual formatting**: Document must be manually structured (no auto-conversion)

### Sharing Requirements

- **Service account access**: Must be shared with specific service account
- **Read permissions**: Requires at least Viewer access
- **Google Workspace**: Only works with Google Docs (not other formats)
- **Access maintenance**: Sharing must be maintained for continued indexing

## Troubleshooting Tips

### Document Not Indexing

1. Verify document is shared with service account
2. Check document format follows requirements
3. Ensure URL is correct and accessible
4. Review document for parsing errors
5. Test with simplified content first

### Content Not Searchable

1. Verify heading structure (triple numeration + Heading 3)
2. Check content uses Normal text style
3. Ensure sections are clearly defined
4. Review for consistent formatting
5. Wait for indexing to complete

### Parsing Inconsistencies

1. Simplify document structure
2. Remove complex formatting elements
3. Ensure consistent numeration
4. Check for hidden formatting characters
5. Create test document with clean format

## Next Steps

After adding your Google Docs data source:

- [Monitor indexing progress](../data-source-overview/indexing-data-sources)
- [Configure assistants](../../assistants/) to use the indexed Google Docs
- [Set up workflows](../../workflows/) that leverage the documentation
- Review [indexing duration](../data-source-overview/indexing-duration) estimates

:::tip Performance Tip
Well-structured Google Docs with clear heading hierarchy and focused content sections provide better LLM routing and more accurate assistant responses compared to unstructured documents.
:::

Now your Google Document is configured as a data source and ready to enhance your assistants with structured documentation and knowledge.
