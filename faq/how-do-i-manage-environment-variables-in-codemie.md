# How do I manage environment variables in CodeMie? Connecting Anthropic MCP Servers with Plugin Engine? What credentials do I need for Anthropic MCP server integration? How do I troubleshoot Anthropic MCP server connection issues? What community service tools are available through Anthropic MCP servers?

Overview  
Anthropic MCP servers can be integrated with CodeMie's Plugin Engine to leverage community service tools. This integrations enhances your assistant's capabilities with specialized AI functionality from Anthropic's models.

## Connection Setup

1. **Prerequisites**
   - Access to Anthropic MCP server credentials
   - Plugin Engine running in your environment

2. **Configuration Steps**
   - Navigate to the "Create Assistant" or "Edit Assistant" page
   - Expand the "External tools" category in the "Available tools" section
   - Click on the MCP server tool card
   - Select **Browse Catalog** for already predefined mcp servers or **Manual Setup** for adding your own mcp server.

3. **Anthropic-Specific Configuration**
   - **Name**: Enter a descriptive name (e.g., "Anthropic-Claude")
   - **Description**: Describe the purpose (e.g., "Connection to Anthropic MCP for community tools")
   - **Command**: Enter the connection command for Anthropic servers
   - **Arguments**: Add any required Anthropic-specific parameters

4. **Environment Variable Setup**
   - Click "Add environment variables" on the MCP tool card
   - Add the following Anthropic-specific variables:
     - **ANTHROPIC_API_KEY**: Your Anthropic API key
     - **ANTHROPIC_API_URL**: The Anthropic MCP server URL

## Validating Anthropic MCP Connection

To verify your connection to Anthropic MCP servers:

1. Create a simple test request in your assistant
2. Check for successful response indicators
3. Verify that community service tools are accessible

## Using Anthropic Community Service Tools

Once connected, you can utilize Anthropic community tools by:

1. Referencing the tool by name in your prompts
2. Following the specific syntax required by each tool
3. Checking tool execution status in the response

## Troubleshooting

If you encounter issues connecting to Anthropic MCP servers:

- Verify your API credentials are correct
- Check network connectivity to Anthropic servers
- Ensure your Plugin Engine is properly configured
- Review environment variable settings

## Sources

- [Adding An Mcp Server](https://docs.codemie.ai/user-guide/tools_integrations/tools/adding-an-mcp-server)
- [Plugin](https://docs.codemie.ai/user-guide/tools_integrations/tools/plugin)
