---
id: adding-mcp-server
title: Adding an MCP Server
sidebar_label: Adding an MCP Server
---

# Adding an MCP Server

Learn how to add a Model Context Protocol (MCP) server to your CodeMie platform.

MCP (Model Context Protocol) servers allow you to integrate external tools with your CodeMie assistants. This integration enables your assistants to leverage a wide variety of tools through MCP servers without requiring custom integrations for each new tool type.

## What is MCP?

MCP (Model Context Protocol) is a standardized protocol that allows AI assistants to interact with external tools and services. By adding MCP servers to CodeMie, you can extend the capabilities of your assistants with specialized tools for various tasks.

### Benefits of MCP Integration

- **Extensibility**: Easily add new tools without custom integration development
- **Standardization**: Use a common protocol for tool integration
- **Flexibility**: Choose from a growing ecosystem of MCP-compatible tools
- **Ecosystem Integration**: Leverage and contribute to the growing ecosystem of MCP tools
- **Rapid Deployment**: Quick setup process for adding new capabilities

## Prerequisites

Before adding an MCP server, ensure you have:

- Access to the MCP Servers section in CodeMie
- Required credentials or API keys for the MCP server (if applicable)
- Understanding of the tool's purpose and configuration requirements
- Appropriate permissions to add MCP servers in your project

## Adding an MCP Server

Follow these steps to add an MCP server to your CodeMie platform.

### Step 1: Navigate to MCP Servers

Navigate to the **MCP Servers** section in CodeMie.

![MCP Servers Page](./adding-mcp-server/mcp-servers-page.png)

### Step 2: Add New MCP Server

Click the **Add MCP Server** button to begin the configuration process.

![MCP Add Server](./adding-mcp-server/mcp-add-server.png)

### Step 3: Search and Select MCP Server

Search for the MCP server you want to add using the search functionality or browse by categories.

![MCP Search Categories](./adding-mcp-server/mcp-search-categories.png)

**Search options:**
- **Search by name**: Type the server name in the search bar
- **Filter by category**: Use category filters to narrow down options
- **Browse all**: Scroll through available MCP servers

### Step 4: View Server Details

Click on an MCP server card to view its details and capabilities.

![MCP Server Card](./adding-mcp-server/mcp-server-card.png)

**Server card information:**
- **Server name**: The name of the MCP server
- **Description**: What the server does and its capabilities
- **Category**: The functional category (e.g., Database, File System, API)
- **Required configuration**: What parameters need to be configured

### Step 5: Install the Server

Click the **Install** button to proceed with installation.

![MCP Install Button](./adding-mcp-server/mcp-install-button.png)

## Configuration Methods

CodeMie supports two methods for configuring MCP servers:

![MCP Config Method](./adding-mcp-server/mcp-config-method.png)

### Method 1: Form Configuration

The Form method provides a user-friendly interface for configuring MCP servers through input fields.

![MCP Form Config](./adding-mcp-server/mcp-form-config.png)

#### Using Form Configuration

**When to use Form configuration:**
- You're new to MCP servers
- The server has a simple configuration
- You prefer a guided, field-by-field approach
- You want validation and helpful hints

**Form configuration steps:**

1. **Fill in required fields**: Enter values for all mandatory parameters
2. **Add optional fields**: Configure optional parameters as needed
3. **Validate inputs**: The form will indicate any errors or missing values
4. **Save configuration**: Click Save when all fields are correctly filled

**Example Form Configuration:**

![MCP Form Example](./adding-mcp-server/mcp-form-example.png)

**Common form fields:**
- **Server Name**: A descriptive name for this MCP server instance
- **Description**: Purpose and usage notes
- **Command**: The executable command to run the server
- **Arguments**: Command-line arguments for the server
- **Environment Variables**: Key-value pairs for environment configuration

### Method 2: JSON Configuration

The JSON method allows you to configure MCP servers by providing a complete JSON configuration.

![MCP JSON Config](./adding-mcp-server/mcp-json-config.png)

#### Using JSON Configuration

**When to use JSON configuration:**
- You have an existing MCP server configuration
- You're migrating from another system
- You need complex or nested configuration
- You prefer working with raw JSON

**JSON configuration steps:**

1. Click the **Config** button to switch to JSON mode

![MCP Config Button](./adding-mcp-server/mcp-config-button.png)

2. **Paste or write JSON configuration**: Enter the complete MCP server configuration in JSON format

![MCP JSON Example](./adding-mcp-server/mcp-json-example.png)

3. **Validate JSON**: Ensure the JSON is properly formatted
4. **Save configuration**: Click Save to apply the configuration

**Example JSON Configuration:**

```json
{
  "mcpServers": {
    "filesystem": {
      "command": "npx",
      "args": [
        "-y",
        "@modelcontextprotocol/server-filesystem",
        "/path/to/allowed/directory"
      ]
    }
  }
}
```

**Common JSON structure:**

```json
{
  "mcpServers": {
    "server-name": {
      "command": "executable-command",
      "args": ["argument1", "argument2"],
      "env": {
        "ENV_VAR_1": "value1",
        "ENV_VAR_2": "value2"
      }
    }
  }
}
```

**JSON configuration best practices:**
- Use proper JSON syntax (commas, quotes, brackets)
- Validate JSON before saving (use a JSON validator)
- Include all required fields
- Document complex configurations with comments (in external documentation)
- Keep sensitive values secure

### Step 6: Save Configuration

After completing the configuration using either method, click the **Save** button.

![MCP Save Button](./adding-mcp-server/mcp-save-button.png)

The MCP server will be added to your available tools.

## Configuring Environment Variables

MCP servers often require environment variables for proper operation, such as API keys, authentication tokens, or configuration parameters.

### Adding Environment Variables

1. Click **Add environment variables** on the expanded MCP tool card

![MCP Add Env Button](./adding-mcp-server/mcp-add-env-button.png)

2. Enter the environment variable configuration

![MCP Env Variables](./adding-mcp-server/mcp-env-variables.png)

**Environment variable format:**

```
KEY=value
ANOTHER_KEY=another_value
API_KEY=your_api_key_here
```

**Common environment variables:**
- `API_KEY`: Authentication key for API access
- `API_URL`: Base URL for API endpoints
- `TIMEOUT`: Request timeout in seconds
- `LOG_LEVEL`: Logging verbosity level
- `DATABASE_URL`: Database connection string

**Best practices:**
- Never commit secrets to version control
- Use descriptive variable names
- Document required vs optional variables
- Store sensitive values securely
- Rotate credentials regularly

### Environment Variable Examples

**Example 1: API Authentication**

```
GITHUB_TOKEN=ghp_xxxxxxxxxxxxxxxxxxxx
GITHUB_API_URL=https://api.github.com
```

**Example 2: Database Connection**

```
DATABASE_HOST=localhost
DATABASE_PORT=5432
DATABASE_NAME=mydb
DATABASE_USER=admin
DATABASE_PASSWORD=secure_password
```

**Example 3: Service Configuration**

```
SERVICE_ENDPOINT=https://api.example.com
REQUEST_TIMEOUT=30
MAX_RETRIES=3
LOG_LEVEL=info
```

## Testing MCP Server Integration

To ensure your MCP server is correctly configured and accessible, CodeMie provides a convenient **Test integration** feature.

### Testing from the Edit MCP Server Page

After configuring an MCP server, you can test the integration directly from the edit page.

![MCP Test Integration](./adding-mcp-server/mcp-test-integration.png)

#### How to Test Integration

1. Navigate to the MCP server configuration page
2. Click the **Test integration** button

![MCP Test Button](./adding-mcp-server/mcp-test-button.png)

3. View the test results

![MCP Test Success](./adding-mcp-server/mcp-test-success.png)

**Test results will show:**
- **Connection status**: Whether the server is reachable
- **Available tools**: List of tools provided by the server
- **Configuration validation**: Whether configuration is correct
- **Error messages**: Any issues that need to be resolved

### Test Results Interpretation

**Successful test:**
- Green status indicator
- List of available tools from the server
- "Connection successful" message

![MCP Test List](./adding-mcp-server/mcp-test-list.png)

**Failed test:**
- Red status indicator
- Error message describing the issue
- Suggestions for resolution

### Common Test Failures

#### Connection Failed

**Symptom**: Cannot connect to the MCP server

**Possible causes:**
- Incorrect command or executable path
- Server not installed or not accessible
- Network connectivity issues
- Firewall blocking connection

**Solutions:**
1. Verify the command path is correct
2. Ensure the MCP server package is installed
3. Check network connectivity
4. Review firewall settings
5. Validate server logs for errors

#### Authentication Error

**Symptom**: Server rejects authentication

**Possible causes:**
- Missing or incorrect API keys
- Expired credentials
- Invalid environment variables
- Insufficient permissions

**Solutions:**
1. Verify API keys are correct
2. Check credential expiration dates
3. Ensure environment variables are properly set
4. Verify account has required permissions
5. Regenerate credentials if needed

#### Configuration Error

**Symptom**: Server starts but configuration is invalid

**Possible causes:**
- Missing required parameters
- Invalid JSON syntax
- Incorrect argument format
- Incompatible configuration version

**Solutions:**
1. Review required configuration parameters
2. Validate JSON syntax
3. Check argument formatting
4. Consult MCP server documentation
5. Use Form method for guided configuration

#### Tool Not Available

**Symptom**: Server connects but expected tools are missing

**Possible causes:**
- Incorrect server version
- Missing dependencies
- Incomplete installation
- Configuration limiting available tools

**Solutions:**
1. Verify server version is correct
2. Check all dependencies are installed
3. Reinstall the server package
4. Review configuration for tool restrictions
5. Consult server documentation

## MCP Server Categories

MCP servers are organized into categories based on their functionality:

### File System

Tools for file and directory operations:
- Read and write files
- List directory contents
- File search and manipulation
- File metadata operations

**Example servers:**
- `@modelcontextprotocol/server-filesystem`
- File management tools

### Database

Tools for database interactions:
- Query databases (SQL, NoSQL)
- Database administration
- Data export/import
- Schema management

**Example servers:**
- PostgreSQL MCP server
- MySQL MCP server
- MongoDB MCP server

### API Integration

Tools for interacting with external APIs:
- REST API calls
- GraphQL queries
- Webhook management
- API authentication

**Example servers:**
- GitHub API server
- Slack API server
- Custom API integrations

### Development Tools

Tools for software development tasks:
- Code analysis
- Git operations
- CI/CD integration
- Testing utilities

**Example servers:**
- Git MCP server
- Code review tools
- Testing frameworks

### Productivity

Tools for productivity and automation:
- Task management
- Calendar integration
- Email operations
- Document processing

**Example servers:**
- Google Calendar server
- Email integration
- Task automation tools

## Best Practices

### Server Configuration

- **Use descriptive names**: Name servers clearly to identify their purpose
- **Document configurations**: Keep notes on why specific configurations were chosen
- **Test thoroughly**: Always test integration before using in production
- **Version control**: Track configuration changes
- **Regular updates**: Keep MCP servers updated to latest versions

### Security

- **Secure credentials**: Never hardcode sensitive information
- **Use environment variables**: Store secrets in environment variables
- **Principle of least privilege**: Grant only necessary permissions
- **Regular audits**: Review MCP server access and permissions
- **Monitor usage**: Track which assistants use which MCP servers

### Performance

- **Resource limits**: Set appropriate timeouts and resource constraints
- **Connection pooling**: Configure connection limits for database servers
- **Caching**: Use caching where appropriate to reduce load
- **Error handling**: Implement proper error handling and retries
- **Logging**: Enable logging for troubleshooting

### Maintenance

- **Monitor health**: Regularly check MCP server status
- **Update regularly**: Keep servers updated with latest versions
- **Clean up unused**: Remove MCP servers no longer in use
- **Document changes**: Keep records of configuration modifications
- **Backup configurations**: Save configuration backups

## Use Cases

### File Management

Add filesystem MCP servers to enable assistants to:
- Read and analyze log files
- Process document collections
- Manage project files
- Search file contents

### Database Operations

Add database MCP servers to enable assistants to:
- Query business data
- Generate reports
- Analyze database schemas
- Perform data migrations

### API Integration

Add API MCP servers to enable assistants to:
- Fetch data from external services
- Update third-party systems
- Integrate with business tools
- Automate workflows

### Development Tasks

Add development MCP servers to enable assistants to:
- Review code changes
- Run tests
- Deploy applications
- Manage repositories

## Troubleshooting

### Server Won't Start

**Common causes:**
- Executable not found
- Missing dependencies
- Port already in use
- Insufficient permissions

**Solutions:**
1. Verify executable path is correct
2. Install required dependencies
3. Check if port is available
4. Run with appropriate permissions
5. Check server logs for details

### Tools Not Appearing

**Common causes:**
- Server not properly configured
- Tools not enabled in configuration
- Version compatibility issues
- Cache issues

**Solutions:**
1. Verify configuration is complete
2. Enable required tools in settings
3. Check version compatibility
4. Clear cache and restart
5. Reinstall the server

### Performance Issues

**Common causes:**
- Resource constraints
- Network latency
- Too many concurrent requests
- Inefficient queries

**Solutions:**
1. Increase resource limits
2. Optimize network configuration
3. Implement rate limiting
4. Optimize queries and operations
5. Scale horizontally if needed

## Next Steps

After adding your MCP server:

- [Configure assistants](../assistants/) to use the MCP tools
- [Test the MCP tools](./using-mcp-tools) in assistant conversations
- [Monitor MCP server performance](./mcp-monitoring) and logs
- Explore additional MCP servers to extend capabilities

:::tip Best Practice
Start with a single MCP server to understand the configuration process, then gradually add more servers as needed. Always test thoroughly before deploying to production assistants.
:::

Now your MCP server is configured and ready to extend your assistants' capabilities with external tools and services.
