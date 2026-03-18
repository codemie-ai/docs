# How do I retrieve X-ray test cases in CodeMie assistants? What is the difference between X-ray Tool and X-ray Data Source? How to query test cases from X-ray using JQL in CodeMie? How do I integrate X-ray Test Management with my assistant?

# X-ray Tool Integration

## Overview

X-ray Tool enables assistants to retrieve and interact with test cases from X-ray Test Management for Jira in real-time. With X-ray Tool, assistants can query test cases on-demand, retrieve test details, and support quality assurance workflows through natural language requests.

## Prerequisites

### Required Integration

At least one X-ray integration must be configured in AI/Run CodeMie. Without a valid X-ray integration, the X-ray Tool cannot retrieve test case information.

### Before You Begin

Ensure you have:

- **X-ray API Keys**: Client ID and Client Secret
- **X-ray instance URL**: Your organization's X-ray endpoint
- **Access permissions**: Ability to read test cases in your X-ray projects
- **Basic JQL knowledge**: Understanding of Jira Query Language for filtering tests

---

## Setting Up X-ray Integration

### Step 1: Create X-ray API Keys

1. Navigate to X-ray Global Settings in your Jira instance
2. Generate a new API key
3. Copy the **Client ID** and **Client Secret** — you'll need these for the integration

For detailed instructions, refer to the [Xray API Keys documentation](https://docs.getxray.app/display/XRAYCLOUD/Authentication+-+REST+v2).

### Step 2: Navigate to Integrations

1. Go to the **Integrations** section in the CodeMie main menu
2. Select **User Integrations** or **Project Integrations**:
   - **User Integrations**: Available only to you across all projects
   - **Project Integrations**: Shared with all project members
3. Click **+ Create**

### Step 3: Configure Integration Settings

**Select:** Choose User or Project integration scope

**Project:** Select your target project (for Project integrations)

**Global Integration:** Enable to make the integration available across multiple projects

**Credential Type:** Select **X-ray**

**Alias:** Provide a descriptive name (e.g., "XrayTest", "QA-Xray")

### Step 4: Set Up Authentication

Configure the X-ray authentication parameters:

**URL:** Your X-ray instance URL (e.g., `https://xray.example.app`)

**Client ID:** Your X-ray API client ID

**Client Secret:** Your X-ray API client secret

**Max results per query:** Maximum number of test cases to return per query (default: 200)

> **Security Note:** Sensitive information is encrypted and displayed in masked format. When updating integration settings, masked values remain unchanged and secure.

### Step 5: Save Integration

Click **+ Save** to store the integration configuration.

---

## Using X-ray Tool in Assistants

### Step 1: Create or Edit Assistant

1. Navigate to the **Assistants** section
2. Click **+ Create Assistant** or select an existing assistant and click **Edit**

### Step 2: Add X-ray Tool

1. In the **Available tools** section, locate **X-ray** or **Quality Assurance**
2. Select X-ray from the tools list
3. Choose your configured X-ray integration from the dropdown menu

### Step 3: Save Assistant Configuration

Click **Create** or **Save** to apply the changes.

---

## Querying Test Cases

Once X-ray Tool is configured, you can retrieve test cases using natural language requests. The assistant translates your request into appropriate X-ray queries.

### Example Natural Language Queries

```
Get 10 tests from project = "WEB - Flyporter" and issuetype = "Xray Test"

Show me manual tests from the API Testing project

Find all tests assigned to John Doe in the Mobile project

List automated tests in project KEY-123

Get test cases with status "Ready for Testing"
```

### Understanding Query Results

The assistant returns test case information including:

- **Test Key**: Unique identifier (e.g., WEB-456)
- **Summary**: Test case title or description
- **Test Type**: Manual, Automated, Cucumber, etc.
- **Status**: Current test status
- **Additional metadata**: Assignee, priority, labels, etc.

---

## JQL Syntax for Test Queries

X-ray Tool supports JQL-like expressions for filtering test cases with precision.

### Basic Query Structure

```
get [number] tests from [JQL expression]
```

### Common JQL Expressions

#### Filter by Project

```jql
project = "PROJECT-KEY"
```

#### Filter by Issue Type

```jql
issuetype = "Xray Test"
```

#### Filter by Test Type

```jql
"Test Type" = "Manual"
```

#### Combine Multiple Conditions

```jql
project = "WEB" AND issuetype = "Xray Test" AND "Test Type" = "Manual"
```

#### Filter by Assignee

```jql
project = "API" AND assignee = "john.doe@example.com"
```

#### Filter by Status

```jql
project = "MOBILE" AND status = "Ready for Testing"
```

### JQL Best Practices

- Always specify the project to avoid retrieving tests from unrelated projects
- Use quotes around multi-word field names (e.g., `"Test Type"`)
- Combine conditions with `AND` or `OR` operators
- Test your JQL in Jira before using it with the X-ray Tool

For comprehensive JQL documentation, refer to the [Atlassian JQL Reference](https://support.atlassian.com/jira-software-cloud/docs/use-advanced-search-with-jira-query-language-jql/).

---

## X-ray Tool vs X-ray Data Source

Understanding the difference helps you choose the right approach:

| Aspect                      | X-ray Tool                 | X-ray Data Source                       |
| --------------------------- | -------------------------- | --------------------------------------- |
| **Retrieval Method**        | Real-time API queries      | Pre-indexed semantic search             |
| **Setup Requirement**       | Integration only           | Integration + Data Source configuration |
| **Usage Context**           | Direct test retrieval      | AI-powered test analysis                |
| **Reindexing**              | Not required               | Requires periodic reindexing            |
| **Query Type**              | JQL-based                  | Natural language semantic search        |
| **Assistant Configuration** | Added to "Available tools" | Added to "Data Source Context"          |

### When to Use X-ray Tool

- You need real-time test case retrieval
- You want to query specific tests using JQL
- You prefer on-demand access without indexing overhead

### When to Use X-ray Data Source

- You need semantic search across test cases
- You want the assistant to analyze test patterns
- You require deep contextual understanding of test coverage

---

## Troubleshooting

### Common Issues

**Issue:** Assistant cannot retrieve test cases

**Possible Causes:**

- X-ray integration not configured
- Invalid or expired API credentials
- Incorrect X-ray URL
- Missing access permissions

**Solutions:**

1. Verify the X-ray integration is active and saved
2. Check Client ID and Client Secret are correct
3. Ensure the X-ray URL is accessible
4. Confirm you have read permissions for test cases

---

**Issue:** Query returns no results

**Possible Causes:**

- Incorrect JQL syntax
- Project key does not exist
- No test cases match the query criteria

**Solutions:**

1. Test the JQL expression in Jira directly
2. Verify project key spelling
3. Simplify the query to broaden results
4. Check that test cases exist in the specified project

---

**Issue:** "Max results exceeded" message

**Cause:** Query returns more test cases than the configured maximum

**Solutions:**

1. Add more specific JQL filters to narrow results
2. Increase "Max results per query" in integration settings
3. Break the query into multiple smaller queries

---

## Security Considerations

- API credentials are encrypted and stored securely
- Integration credentials are masked in the UI
- Only users with appropriate permissions can create integrations
- X-ray Tool respects Jira and X-ray access permissions

---

## Additional Resources

- [X-ray API Documentation](https://docs.getxray.app/display/XRAYCLOUD/Authentication+-+REST+v2)
- [Jira Query Language (JQL) Reference](https://support.atlassian.com/jira-software-cloud/docs/use-advanced-search-with-jira-query-language-jql/)
- How to add and index X-ray Data Source in CodeMie
- Integrations Overview

## Sources

- [Xray](https://docs.codemie.ai/user-guide/tools_integrations/tools/xray)
- [Add Xray Data Source](https://docs.codemie.ai/user-guide/data-source/datasources-types/add-xray-data-source)
