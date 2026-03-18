# How to add and index X-ray Data Source in CodeMie?

Connect and index X-ray test cases, test plans, and test executions as data sources to enable AI assistants to access and analyze test management information.

X-ray is a test management solution for Jira that allows AI/Run CodeMie assistants to work with test cases, test plans, test executions, and test-related information.

---

## Prerequisites

### Required Integration

You must have at least one X-ray integration configured in AI/Run CodeMie. See Integrations Overview for details.

Before adding an X-ray data source, ensure you have:

- **X-ray API Keys**: Client ID and Client Secret (see [Xray API Keys documentation](https://docs.getxray.app/display/XRAYCLOUD/Authentication+-+REST+v2))
- **Configured X-ray integration** with API credentials
- **Access** to the X-ray instance and Jira project
- **Appropriate permissions** to read test cases and test-related issues
- **Knowledge of JQL** (Jira Query Language) for filtering test data

> **Important:** X-ray data sources require a valid JQL query. Test your JQL in Jira before adding the data source to avoid indexing errors.

---

## Step 1: Create X-ray Integration

Before adding an X-ray data source, you need to create an integration with X-ray.

### Generate X-ray API Keys

Follow the [Xray API Keys documentation](https://docs.getxray.app/display/XRAYCLOUD/Authentication+-+REST+v2) to create API credentials in Xray Global Settings.

### Configure Integration in CodeMie

1. Navigate to the **Integrations** section
2. Select **User Integrations** or **Project Integrations** based on your needs:
   - **User Integrations**: Available only to you across all projects
   - **Project Integrations**: Shared with all members of the selected project
3. Click **+ Create**
4. Select **User** or **Project** integration scope
5. Choose **X-ray** as the Credential Type
6. Provide:
   - X-ray instance URL
   - Client ID
   - Client Secret
7. Click **+ Create** to save the integration

---

## Step 2: Create X-ray Data Source

### Navigate to Data Sources

1. Go to the **Data Sources** section
2. Click **+ Create Datasource**

### Configure Basic Settings

**Select Project**: Choose the project with which you want to associate this data source

**Shared with project**: Enable to share this data source with the entire project team

**Name**: Enter a unique alias for quick identification (e.g., `xraytest`)

- Only lowercase letters allowed
- Cannot start with underscore (\_) or hyphen (-)
- No spaces, commas, or special characters (:, ", \*, +, /, \, |, ?, #, >, \<)

**Description**: Provide a brief description (e.g., `X-ray test cases for WEB project`)

### Choose Data Source Type

**Datasource Type**: Select **X-ray** from the dropdown

### Configure JQL Query

**JQL Query**: Enter a JQL expression to filter the test data you want to index. This field is **required**.

#### Common JQL Examples for X-ray

```jql
# Index all tests from a specific project
project = "WEB" AND issuetype = "Test"

# Index manual tests only
project = "WEB" AND issuetype = "Test" AND "Test Type" = "Manual"

# Index tests from multiple projects
project IN ("WEB", "API") AND issuetype = "Test"

# Index automated tests
project = "WEB" AND issuetype = "Test" AND "Test Type" = "Automated"

# Index specific test by key
project = "WEB" AND key = "WEB-123"
```

#### JQL Quick Reference for X-ray

- Use `issuetype = "Test"` to filter Xray test issues
- Add `AND "Test Type" = "Manual"` to filter by test type
- Use `AND project = "PROJECT-KEY"` to limit to specific projects
- Add `AND key = ISSUE-KEY` to index a specific test

### Select Integration

**Select integration for X-ray**: Choose the X-ray integration you created in Step 1 from the dropdown menu

### Configure Embedding Model

**Model used for embeddings**: Select the embedding model for indexing (e.g., `Text Embedding Ada`)

This model converts test case text into vector embeddings for semantic search. The default model is appropriate for most use cases.

---

## Step 3: Configure Automatic Reindexing (Optional)

Configure how often the data source should automatically synchronize with X-ray.

**Reindex Type**: Choose one of the following scheduler options:

- **No schedule (manual only)**: Default setting. Requires manual reindexing through the Data Sources interface
- **Every hour**: Recommended for active test projects with frequent updates
- **Daily at midnight**: For test projects with regular daily activity
- **Weekly on Sunday at midnight**: For less active test projects
- **Monthly on the 1st at midnight**: For archived or completed test suites
- **Custom cron expression**: Enter a custom cron expression (e.g., `0 9 * * MON-FRI` for weekdays at 9 AM)

> **Why Schedule Reindexing?**  
> Test cases and test plans can change frequently. Scheduled reindexing ensures your assistants always have access to the latest test information, including new test cases, updated test steps, and recent test execution results.

---

## Step 4: Create and Index

Click **+ Create** to create the X-ray data source. Indexing will begin automatically based on your scheduler configuration.

---

## What Gets Indexed

When you create an X-ray data source, the following information is indexed:

- **Test Cases**: Test issue summaries, descriptions, and test steps
- **Test Details**: Test type (Manual, Automated, Cucumber, etc.)
- **Test Metadata**: Labels, components, priority, status
- **Custom Fields**: Any custom fields associated with test issues
- **Links and Relationships**: Links to requirements, user stories, or defects

> The indexed content allows assistants to understand test coverage, analyze test scenarios, suggest similar tests, and provide insights about test cases based on natural language queries.

---

## Error Handling

### Common Errors

#### Incorrect JQL Expression

**Symptom**: Error message appears at the top of the Add data source window

**Cause**: The JQL expression syntax is invalid or references non-existent projects/fields

**Solutions**:

- Verify JQL syntax is correct
- Check that project keys are spelled correctly
- Ensure field names exist in your Jira/Xray instance
- Test JQL in Jira search before using in AI/Run CodeMie
- Simplify complex expressions to identify the issue

#### Common JQL Mistakes for X-ray

```jql
# ❌ Incorrect - Missing issue type filter
project = "WEB"

# ✅ Correct - Include issue type for Xray tests
project = "WEB" AND issuetype = "Test"

# ❌ Incorrect - Wrong field name for test type
project = "WEB" AND testType = Manual

# ✅ Correct - Proper field name with quotes
project = "WEB" AND "Test Type" = "Manual"

# ❌ Incorrect - Invalid operator
project = "WEB" AND issuetype EQUALS "Test"

# ✅ Correct - Correct operator
project = "WEB" AND issuetype = "Test"
```

#### Common JQL Operators

- `=` : equals
- `!=` : not equals
- `IN` : matches any value in a list
- `~` : contains (text search)
- `IS EMPTY` : field has no value
- `IS NOT EMPTY` : field has a value

---

## Using X-ray Data Source in Assistants

After successfully creating and indexing your X-ray data source, you can connect it to any assistant.

### Adding Data Source to Assistant

1. Navigate to **Assistants** section
2. Click **+ Create Assistant** or edit an existing assistant
3. In the **Data Source Context** section, click the dropdown menu
4. Select your X-ray data source from the list
5. Save the assistant configuration

Your assistant can now access and analyze test cases from the indexed X-ray data source, enabling it to:

- Answer questions about test coverage
- Suggest similar test cases
- Analyze test scenarios
- Generate test documentation
- Provide insights about test distribution and patterns

---

## Managing X-ray Data Sources

To manage your X-ray data source:

1. Open the **Data Sources** tab
2. Find the X-ray data source by name
3. Click the **"…"** button (three dots)

Available actions:

- **View**: Preview indexed test data and statistics
- **Edit**: Modify JQL query, integration, or scheduler settings
- **Full Reindex**: Completely rescan and update all test data
- **Delete**: Remove the data source and all associated data
- **Resume Indexing**: Continue indexing if the process previously failed

Your X-ray data source is now configured and ready to enhance your assistants with test management knowledge.

## Sources

- [Add Xray Data Source](https://docs.codemie.ai/user-guide/data-source/datasources-types/add-xray-data-source)
