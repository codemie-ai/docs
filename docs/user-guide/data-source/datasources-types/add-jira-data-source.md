---
id: add-jira-data-source
title: Add and Index Jira Data Source
sidebar_label: Add and Index Jira Data Source
---

# Add and Index Jira Data Source

Connect and index Jira projects as data sources.

Jira is a powerful project management and issue tracking data source in AI/Run CodeMie, enabling assistants to access project information, track issues, and manage tasks. This guide walks you through the process of adding and indexing Jira projects.

## Prerequisites

:::note Required Integration
This data source requires you to have at least one Jira integration added to AI/Run CodeMie. For more details, please refer to the [Integrations Overview](../../integrations/) guidelines.
:::

Before adding a Jira data source, ensure you have:

- Configured Jira integration with API token or personal access token
- Access to the Jira project you want to index
- Appropriate permissions to read Jira issues
- Knowledge of JQL (Jira Query Language) for filtering

## Adding a Jira Data Source

To add Jira as a data source with AI/Run CodeMie platform, follow these detailed steps:

![Jira Data Source Form](./add-jira-data-source/jira-datasource-form.png)

### Step-by-Step Process

#### 1. Preparation

Before adding a new Jira data source, you need to generate integration with Jira on the Integration tab.

**How to create a Jira integration:**
- Navigate to the Integrations section
- Add a new Jira integration
- Provide your Jira URL and API token
- Save the integration for use in data sources

**Refer to the [Integrations Overview](../../integrations/) guidelines for detailed integration setup instructions.**

#### 2. Navigate to Data Sources

Navigate to the **Data Sources** section in AI/Run CodeMie.

#### 3. Create New Data Source

Click the **+ Create Datasource** button and add all required data according to recommendations.

#### 4. Select Jira Source Type

Select **Jira** source type in the add new data source window.

#### 5. Configure Jira-Specific Fields

##### Project
Select the name of the project with which you want to associate that DataSource.

**Purpose**: Organizes data sources by project for better management and team collaboration.

##### JQL Expression

Add **JQL expressions** to filter the data you want to index. This field is required.

**Purpose**: Filters which Jira issues to include in indexing based on specific criteria.

**Common JQL Example:**

```
project = "PROJECTKEY" AND assignee = "John Doe"
```

This example filters:
- Issues in the PROJECTKEY project
- Assigned to John Doe

**More JQL Examples:**

```
# Index all issues in a specific project
project = "MYPROJECT"

# Index issues with specific status
project = "MYPROJECT" AND status = "In Progress"

# Index recently updated issues
project = "MYPROJECT" AND updated >= "2024-01-01"

# Combine multiple criteria
project = "MYPROJECT" AND (priority = High OR priority = Critical) AND status != Closed

# Filter by issue type
project = "MYPROJECT" AND type = Bug

# Filter by labels
project = "MYPROJECT" AND labels = "backend"
```

:::tip JQL Resources
For more information on writing JQL expressions, refer to the [Atlassian JQL documentation](https://www.atlassian.com/software/jira/guides/jql/cheat-sheet#intro-to-jql).
:::

##### Integration Selection

Select the **integration for Jira** from the dropdown.

**What you'll see:**
- Previously created Jira integrations will be displayed
- Choose the integration that corresponds to your Jira instance
- Ensure the integration has valid credentials

##### Model Used for Embeddings

Specify the assistant's LLM model for processing Jira content.

**Purpose**: Determines which AI model processes the Jira issues for indexing.

**Common options:**
- Standard models for general purposes
- Follow your organization's model selection guidelines

#### 6. Create the Data Source

Click the **+ Create** button and wait for the process to finish.

**What happens next:**
1. AI/Run CodeMie validates the JQL expression
2. Connection to Jira is established
3. Indexing process begins automatically
4. Progress can be monitored in the data source list

## Error Handling for Jira Data Sources

### Common Errors

#### Incorrect JQL Expression

**Symptom**: Error message appears at the top of the Add data source window

![Jira JQL Error](./add-jira-data-source/jira-jql-error.png)

**Cause**: The JQL expression syntax is invalid or references non-existent projects/fields

**Solutions:**
1. Verify JQL syntax is correct
2. Check that project keys are spelled correctly
3. Ensure field names exist in your Jira instance
4. Test JQL in Jira search before using in AI/Run CodeMie
5. Simplify complex expressions to identify the issue

**Example of common JQL mistakes:**

```
# ❌ Incorrect - Project key without quotes when containing spaces
project = My Project AND type = Bug

# ✅ Correct - Project key with quotes
project = "My Project" AND type = Bug

# ❌ Incorrect - Invalid field name
project = MYPROJECT AND issueType = Bug

# ✅ Correct - Valid field name
project = MYPROJECT AND type = Bug

# ❌ Incorrect - Wrong operator
project = MYPROJECT AND status EQUALS "In Progress"

# ✅ Correct - Correct operator
project = MYPROJECT AND status = "In Progress"
```

#### Expired Authorization Token

**Cause**: The API token used in the Jira integration has expired or been revoked

**Solutions:**
1. Navigate to the Integrations section
2. Locate your Jira integration
3. Generate a new API token in Jira
4. Update the integration with the new token
5. Retry creating the data source

#### Connection Timeout

**Cause**: Cannot establish connection to Jira server

**Solutions:**
- Check network connectivity to Jira
- Verify Jira URL is correct in integration
- Ensure Jira server is accessible
- Review firewall settings
- Try again after a few minutes

#### Permission Denied

**Cause**: Insufficient access to Jira project or issues

**Solutions:**
- Verify integration has read access to the project
- Check Jira project permissions
- Ensure API token has appropriate scopes
- Request access from Jira project administrator

## Understanding JQL Expressions

JQL (Jira Query Language) is essential for filtering Jira issues effectively.

### Basic JQL Syntax

**Field operators:**
- `=` : Equals
- `!=` : Not equals
- `>` : Greater than
- `<` : Less than
- `>=` : Greater than or equal
- `<=` : Less than or equal
- `~` : Contains text
- `!~` : Does not contain text
- `IN` : Matches any of a list of values
- `NOT IN` : Does not match any of a list of values
- `IS` : Is (for null/empty values)
- `IS NOT` : Is not (for null/empty values)

**Logical operators:**
- `AND` : Both conditions must be true
- `OR` : Either condition must be true
- `NOT` : Negates a condition

### Common JQL Fields

#### project
Filter by Jira project

```
project = "MYPROJECT"
project IN ("PROJ1", "PROJ2", "PROJ3")
```

#### type
Filter by issue type

```
type = Bug
type IN (Bug, Task, Story)
```

#### status
Filter by issue status

```
status = "In Progress"
status IN ("To Do", "In Progress")
```

#### priority
Filter by priority

```
priority = High
priority IN (High, Critical)
```

#### assignee
Filter by assignee

```
assignee = "john.doe"
assignee = currentUser()
assignee IS EMPTY
```

#### reporter
Filter by reporter

```
reporter = "jane.smith"
reporter = currentUser()
```

#### created
Filter by creation date

```
created >= "2024-01-01"
created > startOfWeek()
created >= -7d
```

#### updated
Filter by update date

```
updated >= "2024-01-01"
updated > startOfDay()
updated >= -30d
```

#### resolution
Filter by resolution

```
resolution = Fixed
resolution IS EMPTY
```

#### labels
Filter by labels

```
labels = "backend"
labels IN ("frontend", "backend")
```

#### component
Filter by component

```
component = "API"
component IN ("API", "Database")
```

### JQL Functions

JQL provides functions for dynamic filtering:

```
# Current user
assignee = currentUser()

# Time-based functions
created > startOfDay()
updated >= startOfWeek()
resolved <= endOfMonth()

# Relative dates
created >= -7d  # Last 7 days
updated >= -1w  # Last week
resolved >= -30d  # Last 30 days
```

### JQL Best Practices

1. **Start simple**: Begin with basic project filters and add complexity gradually
2. **Test in Jira**: Use Jira search to test JQL before using in AI/Run CodeMie
3. **Use quotes**: Quote values with spaces or special characters
4. **Limit scope**: Filter to specific projects or issue types to improve indexing performance
5. **Combine criteria**: Use AND/OR to create precise filters
6. **Document your JQL**: Add comments in data source descriptions explaining the filter logic

## Best Practices

### JQL Expression Design

- **Be specific**: Filter to only the issues your assistants need
- **Use project filters**: Always include project filters to limit scope
- **Exclude closed issues**: Consider filtering out resolved/closed issues if not needed
- **Label strategically**: Use labels to mark issues for indexing
- **Test thoroughly**: Verify JQL returns expected results in Jira first

### Integration Management

- **Token security**: Treat API tokens as sensitive credentials
- **Regular updates**: Rotate tokens periodically for security
- **Minimal permissions**: Grant only necessary permissions to tokens
- **Document tokens**: Keep records of token purposes and expiration dates

### Project Organization

- **Structured projects**: Organize Jira projects logically by team or product
- **Consistent labeling**: Use consistent label schemes for easy filtering
- **Component usage**: Utilize components to categorize issues
- **Regular cleanup**: Close or resolve outdated issues regularly

### Indexing Strategy

- **Start small**: Begin with a single project to test configuration
- **Monitor performance**: Track indexing duration and adjust filters if needed
- **Regular updates**: Schedule reindexing when Jira projects change significantly
- **Incremental updates**: Use incremental reindexing for frequent updates (Jira supports this)

## Use Cases

### Project Management

- Track project progress and blockers
- Monitor issue status and assignments
- Access sprint information
- Reference project roadmaps

### Bug Tracking

- Index bug reports and fixes
- Track bug resolution status
- Access reproduction steps
- Reference related issues

### Task Management

- Track task assignments and completion
- Monitor task priorities
- Access task descriptions and requirements
- Reference task dependencies

### Sprint Planning

- Index sprint issues and stories
- Access sprint goals and objectives
- Track sprint progress
- Reference completed sprints

## Maintenance

### Regular Tasks

- **Reindex after updates**: Trigger reindexing after significant project changes
- **Update JQL filters**: Adjust JQL as project structure changes
- **Monitor indexing**: Check indexing status regularly
- **Review integration**: Verify integration credentials remain valid

### Performance Optimization

- **Refine JQL**: Narrow filters to reduce indexed issue volume
- **Close old issues**: Clean up Jira before reindexing
- **Use status filters**: Implement status-based filtering for better control
- **Schedule wisely**: Reindex during off-peak hours for large projects

## Troubleshooting Tips

### JQL Not Working as Expected

1. Copy the JQL expression
2. Paste into Jira search (Advanced Search)
3. Verify it returns expected issues
4. Adjust the expression until results are correct
5. Use the refined JQL in AI/Run CodeMie

### Integration Issues

1. Test integration credentials manually
2. Check token expiration date
3. Verify Jira URL is accessible
4. Review integration permissions
5. Regenerate token if necessary

### Indexing Takes Too Long

1. Check the number of issues matched by JQL
2. Reduce scope by refining JQL filters
3. Split large projects into multiple data sources
4. Use more specific status filters
5. Consider indexing only recently updated issues

### Missing Issues in Results

**Common causes:**
- JQL filter is too restrictive
- Issues don't match the query criteria
- Indexing not completed yet
- Permission issues with certain issues

**Solutions:**
1. Review and broaden JQL filter
2. Verify issues exist in Jira with expected values
3. Wait for indexing to complete
4. Check Jira permissions for all issues

## Next Steps

After adding your Jira data source:

- [Monitor indexing progress](../data-source-overview/indexing-data-sources)
- [Configure assistants](../../assistants/) to use the indexed Jira content
- [Set up workflows](../../workflows/) that leverage issue tracking
- Review [indexing duration](../data-source-overview/indexing-duration) estimates

:::tip Performance Tip
Using specific JQL expressions to filter Jira issues can significantly reduce indexing time and improve assistant response quality by focusing on relevant issues. Start with a narrow scope (e.g., specific project and status) and expand as needed.
:::

Now your Jira project is configured as a data source and ready to enhance your assistants with issue tracking and project management capabilities.
