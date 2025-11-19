---
id: using-mcp-tools
title: Using MCP Tools in Assistants
sidebar_label: Using MCP Tools in Assistants
---

# Using MCP Tools in Assistants

How to leverage MCP tools within your assistants.

Once you've [added and configured MCP servers](./adding-mcp-server), your assistants can automatically discover and use the tools provided by those servers. This enables your assistants to extend their capabilities with external tools without requiring manual integration for each tool.

## How MCP Tools Work with Assistants

MCP tools integrate seamlessly with CodeMie assistants through an automatic discovery and execution process:

### 1. Automatic Tool Discovery

The assistant automatically discovers available tools from the MCP server.

**What happens:**
- When an assistant is configured with MCP tools, it queries the MCP server for available tools
- The MCP server responds with a list of tools, their descriptions, and required parameters
- The assistant adds these tools to its available capabilities
- Tool descriptions help the assistant understand when and how to use each tool

**Example tools discovered:**
- File system operations (read, write, search files)
- Database queries (SQL execution, schema inspection)
- API calls (REST API requests, data fetching)
- Development tasks (Git operations, code analysis)

### 2. Tool Invocation Through Assistant Interface

Users can invoke these tools through the assistant interface.

**How it works:**
- Users interact with the assistant using natural language
- The assistant determines when a tool should be used based on the user's request
- The assistant formulates the appropriate tool call with necessary parameters
- The tool executes the requested operation
- Results are returned to the assistant

**Example interaction:**

```
User: "Read the contents of config.json file"
Assistant: [Uses filesystem MCP tool to read the file]
Assistant: "Here are the contents of config.json: ..."
```

### 3. Formatted Tool Responses

Tool responses are formatted and presented to the user.

**Response formatting:**
- Raw tool output is processed by the assistant
- The assistant interprets the results in context
- Responses are formatted in a user-friendly manner
- Additional analysis or explanation may be provided

**Example response:**

```
Tool Output: {"name": "config", "version": "1.0", "debug": true}
Assistant Response: "The config.json file contains the following settings:
- Application name: config
- Version: 1.0
- Debug mode: enabled

The debug mode is currently active, which may impact performance in production."
```

### 4. Error Handling

If connection issues occur, the assistant provides appropriate error messages.

**Error scenarios:**
- MCP server is unavailable
- Tool execution fails
- Invalid parameters provided
- Permission denied
- Timeout occurred

**Example error handling:**

```
User: "Execute SQL query on the database"
Assistant: "I encountered an error while connecting to the database server.
The connection timed out. Please check that the database server is running
and accessible, and verify the connection settings in the MCP server configuration."
```

## Configuring Assistants to Use MCP Tools

To enable MCP tools in your assistant:

### Step 1: Navigate to Assistant Configuration

1. Go to the **Assistants** section
2. Select the assistant you want to configure
3. Click **Edit** or create a new assistant

### Step 2: Enable MCP Tools

In the assistant configuration:

1. Navigate to the **Tools** section
2. Find the **MCP Tools** category
3. Select the MCP servers you want to enable
4. Save the assistant configuration

### Step 3: Test the Integration

After configuration:

1. Open a chat with the assistant
2. Request an operation that requires an MCP tool
3. Verify the tool is invoked correctly
4. Check the response is formatted appropriately

## Best Practices for Using MCP Tools

### Tool Selection

**Choose appropriate tools:**
- Only enable tools relevant to the assistant's purpose
- Consider the assistant's role and typical user requests
- Avoid enabling too many tools unnecessarily

**Examples:**
- **Developer Assistant**: Enable Git, filesystem, and database MCP tools
- **Documentation Assistant**: Enable filesystem and API MCP tools
- **Support Assistant**: Enable API and database MCP tools

### Tool Descriptions

**Provide clear descriptions:**
- Ensure MCP server tool descriptions are clear and accurate
- Help the assistant understand when to use each tool
- Include parameter descriptions and examples

**Good tool description:**
```json
{
  "name": "read_file",
  "description": "Reads the contents of a file from the filesystem.
                  Use this when the user asks to view, read, or examine
                  a file's contents.",
  "parameters": {
    "file_path": "Absolute or relative path to the file to read"
  }
}
```

### Error Recovery

**Handle errors gracefully:**
- Configure appropriate timeout values
- Implement retry logic for transient errors
- Provide helpful error messages to users
- Log errors for troubleshooting

**Example error handling strategy:**
```
1. First attempt: Try tool execution
2. If timeout: Retry once with extended timeout
3. If still fails: Inform user and suggest alternatives
4. Log error details for admin review
```

### Performance Optimization

**Optimize tool usage:**
- Cache tool results when appropriate
- Use batch operations when available
- Set reasonable timeout values
- Monitor tool execution times

**Performance tips:**
- For file operations: Read only necessary portions
- For database queries: Use pagination for large results
- For API calls: Implement request throttling
- For expensive operations: Inform user of expected wait time

## Common Use Cases

### File Management

**Use MCP filesystem tools for:**

```
User requests:
- "Show me the contents of package.json"
- "List all Python files in the project"
- "Create a new configuration file"
- "Search for files containing 'API_KEY'"

Assistant actions:
- Uses read_file tool to read file contents
- Uses list_directory tool to list files
- Uses write_file tool to create files
- Uses search_files tool to find matches
```

### Database Operations

**Use MCP database tools for:**

```
User requests:
- "Query the users table for active users"
- "Show me the database schema"
- "Count the number of orders this month"
- "Update the customer email address"

Assistant actions:
- Uses execute_query tool for SELECT statements
- Uses get_schema tool to retrieve structure
- Uses execute_query tool for aggregations
- Uses execute_query tool for UPDATE statements
```

### API Integration

**Use MCP API tools for:**

```
User requests:
- "Fetch the latest GitHub releases"
- "Get current weather data"
- "Send a notification to Slack"
- "Create a new issue in Jira"

Assistant actions:
- Uses api_call tool with GitHub endpoint
- Uses api_call tool with weather API
- Uses api_call tool with Slack webhook
- Uses api_call tool with Jira API
```

### Development Tasks

**Use MCP development tools for:**

```
User requests:
- "Show me recent commits on main branch"
- "Create a new feature branch"
- "Run the test suite"
- "Analyze code quality"

Assistant actions:
- Uses git_log tool to retrieve commits
- Uses git_branch tool to create branch
- Uses run_tests tool to execute tests
- Uses code_analysis tool to check quality
```

## Troubleshooting MCP Server Connections

If you encounter issues with MCP servers:

### Verify Server Configuration

**Check the basics:**
- Verify the server URL and authentication are correct
- Check that the MCP server is operational and accessible
- Ensure network connectivity between CodeMie and the MCP server
- Review environment variable configurations

**Validation steps:**
1. Use the [Test integration](./adding-mcp-server#testing-mcp-server-integration) feature
2. Check MCP server logs for errors
3. Verify credentials are valid and not expired
4. Test network connectivity manually

### Common Connection Issues

#### Server Unreachable

**Symptom**: Assistant reports "Cannot connect to MCP server"

**Possible causes:**
- MCP server is not running
- Network firewall blocking connection
- Incorrect server URL
- Server crashed or hung

**Solutions:**
1. Check if MCP server process is running
2. Verify firewall allows connections
3. Double-check server URL in configuration
4. Restart the MCP server
5. Check server logs for crash details

#### Authentication Failures

**Symptom**: Assistant reports "Authentication failed"

**Possible causes:**
- Invalid or expired credentials
- Incorrect environment variables
- Permissions changed
- API key rotated

**Solutions:**
1. Verify credentials are correct
2. Check environment variables are set
3. Ensure account has required permissions
4. Regenerate API keys if needed
5. Update MCP server configuration

#### Tool Execution Errors

**Symptom**: Tool is invoked but returns errors

**Possible causes:**
- Invalid parameters passed to tool
- Tool lacks required permissions
- External service unavailable
- Resource not found

**Solutions:**
1. Review tool parameter requirements
2. Check tool has necessary permissions
3. Verify external services are accessible
4. Confirm resources exist before accessing
5. Add input validation for parameters

#### Timeout Issues

**Symptom**: Tool execution times out

**Possible causes:**
- Operation takes too long
- Network latency
- Server overloaded
- Deadlock or hang

**Solutions:**
1. Increase timeout configuration
2. Optimize operation performance
3. Check server resource usage
4. Use pagination for large operations
5. Implement async operations where possible

### Network Connectivity

**Ensure proper network setup:**

**Checklist:**
- [ ] MCP server is accessible from CodeMie
- [ ] Firewalls allow necessary traffic
- [ ] DNS resolution works correctly
- [ ] SSL/TLS certificates are valid
- [ ] Network latency is acceptable

**Testing connectivity:**
```bash
# Test basic connectivity
ping mcp-server-hostname

# Test port accessibility
telnet mcp-server-hostname port

# Test HTTPS endpoint
curl https://mcp-server-hostname/health
```

### Environment Variables

**Verify environment configuration:**

**Common issues:**
- Variables not set
- Incorrect variable names
- Values not quoted properly
- Sensitive values exposed

**Verification steps:**
1. Check environment variables are defined
2. Verify variable names match requirements
3. Confirm values are properly formatted
4. Test with minimal configuration first
5. Gradually add complexity

## Advanced Topics

### Multiple MCP Servers

**Using multiple MCP servers with one assistant:**

**Benefits:**
- Combine tools from different sources
- Separate concerns (e.g., dev tools vs. production tools)
- Use specialized servers for specific domains

**Configuration:**
1. Add multiple MCP servers in CodeMie
2. Enable all relevant servers for the assistant
3. Ensure no tool name conflicts
4. Test tools from each server work independently

**Example configuration:**
```
Assistant: Development Helper
MCP Servers:
- filesystem-server (file operations)
- git-server (version control)
- database-server (data access)
- api-server (external integrations)
```

### Custom Tool Priorities

**Handling tool selection:**

When multiple tools can handle similar requests:
- Tool descriptions guide selection
- More specific tools take precedence
- Assistant context influences choice
- User can specify tool explicitly

**Example:**
```
Multiple "search" tools available:
- search_files (for file content)
- search_database (for database records)
- search_api (for external data)

User: "Search for customer records"
→ Assistant chooses search_database

User: "Search code for API endpoints"
→ Assistant chooses search_files
```

### Monitoring and Logging

**Track tool usage:**

**What to monitor:**
- Tool invocation frequency
- Execution times
- Error rates
- Resource consumption

**Logging best practices:**
- Log all tool invocations
- Include timestamps and parameters
- Record execution duration
- Log errors with stack traces
- Monitor for patterns

## Video Resources

For more information, see the video tutorials:

- [CodeMie Integration with JetBrains via MCP](https://videoportal.epam.com/video/y76LlgVY)
- [CodeMie SDK and Assistants MCP Server](https://videoportal.epam.com/video/Q7zQ5ObJ)

## Next Steps

After enabling MCP tools in your assistants:

- Test all configured tools with various user requests
- Monitor tool usage and performance
- Gather user feedback on tool effectiveness
- [Add additional MCP servers](./adding-mcp-server) as needed
- Optimize assistant prompts to better utilize available tools

:::tip Best Practice
Start by enabling a small set of essential tools, then gradually expand based on actual usage patterns. Monitor which tools are most frequently used and optimize those first.
:::

Now your assistants are equipped with powerful MCP tools to handle a wide range of tasks beyond basic conversation.
