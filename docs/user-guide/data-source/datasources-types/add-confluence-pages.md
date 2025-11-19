---
id: add-confluence-pages
title: Add and Index Confluence Pages
sidebar_label: Add and Index Confluence Pages
---

# Add and Index Confluence Pages

Connect and index Confluence pages as data sources.

Confluence pages are powerful knowledge base sources in AI/Run CodeMie, enabling assistants to access documentation, project information, and team knowledge. This guide walks you through the process of adding and indexing Confluence pages.

## Prerequisites

:::note Required Integration
This data source requires you to have at least one Confluence integration added to AI/Run CodeMie. For more details, please refer to the [Integrations Overview](../../integrations/) guidelines.
:::

Before adding a Confluence data source, ensure you have:

- Configured Confluence integration with a personal access token
- Access to the Confluence space you want to index
- Appropriate permissions to read Confluence pages
- Knowledge of CQL (Confluence Query Language) for filtering

## Adding a Confluence Data Source

To index Confluence pages, fill in the following fields:

![Confluence Data Source Form](./add-confluence-pages/confluence-datasource-form.png)

### Step-by-Step Process

#### 1. Preparation

Before adding a new Confluence data source, you need to:

1. Generate a personal access token in Confluence
2. Create a corresponding integration via the **Integration** tab

![Confluence Integration](./add-confluence-pages/confluence-integration.png)

**How to create a Confluence integration:**
- Navigate to the Integrations section
- Add a new Confluence integration
- Provide your Confluence URL and personal access token
- Save the integration for use in data sources

#### 2. Navigate to Data Sources

Navigate to the **Data Sources** section in AI/Run CodeMie.

#### 3. Create New Data Source

Click the **+ Create Datasource** button and add all required data according to recommendations.

#### 4. Select Confluence Source Type

Select **Confluence** source type in the add new data source window.

#### 5. Configure Confluence-Specific Fields

##### Project
Select the name of the project with which you want to associate that DataSource.

**Purpose**: Organizes data sources by project for better management and team collaboration.

##### CQL Expression

Add **CQL expressions** to filter the data you want to index. This field is required.

**Purpose**: Filters which Confluence pages to include in indexing based on specific criteria.

**Common CQL Examples:**

```
space = CODEMIE AND type = page AND ancestor = 1593803553
```

This example filters:
- Pages in the CODEMIE space
- Only page-type content (excludes blogs, comments)
- Under a specific ancestor page ID

**More CQL Examples:**

```
# Index all pages in a specific space
space = "MYSPACE" AND type = page

# Index pages with specific labels
space = "MYSPACE" AND label = "documentation"

# Index recently updated pages
space = "MYSPACE" AND lastModified >= "2024-01-01"

# Combine multiple criteria
space = "MYSPACE" AND type = page AND (label = "public" OR label = "documentation")
```

:::tip CQL Resources
For more information on writing CQL expressions, refer to the [Atlassian CQL documentation](https://confluence.atlassian.com/doc/confluence-search-syntax-158720.html).
:::

##### Integration Selection

Select the **integration for Confluence** from the dropdown.

**What you'll see:**
- Previously created Confluence integrations will be displayed
- Choose the integration that corresponds to your Confluence instance
- Ensure the integration has valid credentials

##### Model Used for Embeddings

Specify the assistant's LLM model for processing Confluence content.

**Purpose**: Determines which AI model processes the Confluence pages for indexing.

**Common options:**
- Standard models for general purposes
- Follow your organization's model selection guidelines

#### 6. Create the Data Source

Click the **+ Create** button and wait for the process to finish.

![Confluence Creation Success](./add-confluence-pages/confluence-create-success.png)

**What happens next:**
1. AI/Run CodeMie validates the CQL expression
2. Connection to Confluence is established
3. Indexing process begins automatically
4. Progress can be monitored in the data source list

## Error Handling for Confluence Data Sources

### Common Errors

#### Incorrect CQL Expression

**Symptom**: Error message appears at the top of the Add data source window

**Cause**: The CQL expression syntax is invalid or references non-existent spaces/pages

**Solutions:**
1. Verify CQL syntax is correct
2. Check that space names are spelled correctly
3. Ensure page IDs exist in your Confluence instance
4. Test CQL in Confluence search before using in AI/Run CodeMie
5. Simplify complex expressions to identify the issue

**Example of common CQL mistakes:**

```
# ❌ Incorrect - Space name without quotes
space = My Space AND type = page

# ✅ Correct - Space name with quotes
space = "My Space" AND type = page

# ❌ Incorrect - Invalid field name
space = MYSPACE AND pageType = page

# ✅ Correct - Valid field name
space = MYSPACE AND type = page
```

#### Expired Authorization Token

**Symptom**: Authorization error appears during data source creation

![Confluence Auth Error](./add-confluence-pages/confluence-auth-error.png)

**Cause**: The personal access token used in the Confluence integration has expired or been revoked

**Solutions:**
1. Navigate to the Integrations section
2. Locate your Confluence integration
3. Generate a new personal access token in Confluence
4. Update the integration with the new token
5. Retry creating the data source

#### Connection Timeout

**Cause**: Cannot establish connection to Confluence server

**Solutions:**
- Check network connectivity to Confluence
- Verify Confluence URL is correct in integration
- Ensure Confluence server is accessible
- Review firewall settings
- Try again after a few minutes

#### Permission Denied

**Cause**: Insufficient access to Confluence pages

**Solutions:**
- Verify integration has read access to the space
- Check Confluence space permissions
- Ensure personal access token has appropriate scopes
- Request access from Confluence space administrator

## Understanding CQL Expressions

CQL (Confluence Query Language) is essential for filtering Confluence content effectively.

### Basic CQL Syntax

**Field operators:**
- `=` : Equals
- `!=` : Not equals
- `>` : Greater than
- `<` : Less than
- `>=` : Greater than or equal
- `<=` : Less than or equal

**Logical operators:**
- `AND` : Both conditions must be true
- `OR` : Either condition must be true
- `NOT` : Negates a condition

### Common CQL Fields

#### space
Filter by Confluence space

```
space = "PROJECTDOCS"
space in ("DOCS1", "DOCS2", "DOCS3")
```

#### type
Filter by content type

```
type = page
type = blogpost
type in (page, blogpost)
```

#### title
Filter by page title

```
title ~ "Getting Started"
title = "API Documentation"
```

#### label
Filter by page labels

```
label = "public"
label in ("documentation", "api", "tutorial")
```

#### ancestor
Filter by parent page ID

```
ancestor = 1234567890
```

#### lastModified
Filter by modification date

```
lastModified >= "2024-01-01"
lastModified > now("-30d")
```

#### creator
Filter by page creator

```
creator = "john.doe"
```

### CQL Best Practices

1. **Start simple**: Begin with basic space filters and add complexity gradually
2. **Test in Confluence**: Use Confluence search to test CQL before using in AI/Run CodeMie
3. **Use quotes**: Always quote space names with spaces or special characters
4. **Limit scope**: Filter to specific spaces or labels to improve indexing performance
5. **Combine criteria**: Use AND/OR to create precise filters
6. **Document your CQL**: Add comments in data source descriptions explaining the filter logic

## Best Practices

### CQL Expression Design

- **Be specific**: Filter to only the pages your assistants need
- **Use space filters**: Always include space filters to limit scope
- **Exclude archived**: Add conditions to exclude archived or outdated content
- **Label strategically**: Use labels to mark pages for indexing
- **Test thoroughly**: Verify CQL returns expected results in Confluence first

### Integration Management

- **Token security**: Treat personal access tokens as sensitive credentials
- **Regular updates**: Rotate tokens periodically for security
- **Minimal permissions**: Grant only necessary permissions to tokens
- **Document tokens**: Keep records of token purposes and expiration dates

### Content Organization

- **Structured spaces**: Organize Confluence content logically by project or topic
- **Consistent labeling**: Use consistent label schemes for easy filtering
- **Page hierarchy**: Maintain clear page hierarchies with ancestor relationships
- **Regular cleanup**: Archive or delete outdated pages regularly

### Indexing Strategy

- **Start small**: Begin with a single space to test configuration
- **Monitor performance**: Track indexing duration and adjust filters if needed
- **Regular updates**: Schedule reindexing when Confluence content changes significantly
- **Incremental updates**: Use incremental reindexing when available

## Use Cases

### Team Documentation

- Index team wikis and knowledge bases
- Access project documentation through assistants
- Search for standard operating procedures
- Reference onboarding materials

### Project Management

- Index project plans and roadmaps
- Access meeting notes and decisions
- Reference sprint documentation
- Track project milestones

### Technical Documentation

- Index API documentation
- Access architecture decision records
- Reference technical specifications
- Search troubleshooting guides

### Knowledge Sharing

- Index best practices and lessons learned
- Access training materials
- Reference case studies
- Search for example implementations

## Maintenance

### Regular Tasks

- **Reindex after updates**: Trigger reindexing after major Confluence updates
- **Update CQL filters**: Adjust CQL as Confluence structure changes
- **Monitor indexing**: Check indexing status regularly
- **Review integration**: Verify integration credentials remain valid

### Performance Optimization

- **Refine CQL**: Narrow filters to reduce indexed content volume
- **Remove outdated pages**: Clean up Confluence before reindexing
- **Use labels**: Implement label-based filtering for better control
- **Schedule wisely**: Reindex during off-peak hours for large spaces

## Troubleshooting Tips

### CQL Not Working as Expected

1. Copy the CQL expression
2. Paste into Confluence search (Advanced Search)
3. Verify it returns expected pages
4. Adjust the expression until results are correct
5. Use the refined CQL in AI/Run CodeMie

### Integration Issues

1. Test integration credentials manually
2. Check token expiration date
3. Verify Confluence URL is accessible
4. Review integration permissions
5. Regenerate token if necessary

### Indexing Takes Too Long

1. Check the number of pages matched by CQL
2. Reduce scope by refining CQL filters
3. Split large spaces into multiple data sources
4. Use more specific ancestor filters
5. Consider indexing only recently modified pages

## Next Steps

After adding your Confluence data source:

- [Monitor indexing progress](../data-source-overview/indexing-data-sources)
- [Configure assistants](../../assistants/) to use the indexed Confluence content
- [Set up workflows](../../workflows/) that leverage documentation
- Review [indexing duration](../data-source-overview/indexing-duration) estimates

:::tip Performance Tip
Using specific CQL expressions to filter Confluence pages can significantly reduce indexing time and improve assistant response quality by focusing on relevant documentation. Start with a narrow scope and expand as needed.
:::

Now your Confluence pages are configured as a data source and ready to enhance your assistants with documentation and knowledge base content.
