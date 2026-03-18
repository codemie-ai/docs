# How do I set up MCP servers in CodeMie assistants? How do I configure external tools like MCP servers in my assistant? What are MCP servers and how do I configure them in CodeMie?

MCP (Model Context Protocol) servers allow you to integrate external tools with your CodeMie assistants. This integrations enables your assistants to leverage a wide variety of tools through MCP servers without requiring custom integrations for each new tool type.

## Benefits of MCP Integration

- **Enhanced Functionality**: Access a wide variety of external tools, dramatically expanding your assistant's capabilities
- **Future-Proofing**: Work with an emerging industry standard for AI tool integration
- **Reduced Development Time**: No need to build custom integrations for each tool
- **Ecosystem Integration**: Leverage and contribute to the growing ecosystem of MCP tools

## Adding an MCP Server

1. Navigate to the "Create Assistant" or "Edit Assistant" page
2. In the "Available tools" section, expand the "External tools" category
3. Click on the MCP server tool card to expand it
4. Select **Browse Catalog** for already predefined mcp servers or **Manual Setup** for adding your own mcp server.

## Form Configuration Method

When configuring an MCP server using the Form method with **Manual Setup**:

1. Fill in the required fields:
   - **Name**: A unique identifier for your server (required)
   - **Description**: Details about the server's purpose (required)
   - **Tools Tokens Size Limit**: in need to change value by default
   - **Command**: The command used to invoke the server (required)
   - **Arguments**: Any additional parameters needed, space-separated (optional)
2. Select environment variables from the dropdown if needed
3. Click "Add" to complete the configuration

Example:

- **Name**: time-mcp-server
- **Description**: time-mcp-server
- **Command**: uvx
- **Arguments**: mcp-server-time --local-timezone=America/New_York

## JSON Configuration Method

For advanced configurations, you can use the JSON method with **Manual Setup**:

1. Fill in the basic fields (Name, Description, Command, Tools Tokens Size Limit)
2. Enter valid JSON data in the "JSON format" field
3. Select environment variables as needed
4. Click "Add" to complete the configuration

Example:  
{  
 "command": "uvx",  
 "args": [
"mcp-server-time",
"--local-timezone=America/New_York"
]  
}

## Managing Environment Variables

MCP servers often require environment variables for proper operation:

1. Click "Add environment variables" on the expanded MCP tool card
2. Fill in the required fields:
   - **Alias**: A user-friendly name for the variable
   - **Key**: The environment variable key name
   - **Value**: The value to assign (will be securely stored)
3. Click "Add Environment Variables" to save the configuration

## Testing MCP Server Integration

To ensure your MCP server is correctly configured and accessible, CodeMie provides a convenient "Test integration" feature:

## Testing from the Edit MCP Server Page

1. Navigate to the "Edit assistant" page
2. Find and expand the MCP server tool card
3. Click on the three dots menu, then click "Edit"
4. On the "Edit an MCP server" page, locate the "Test integration" button next to "Cancel" and "Save"
5. Click the "Test integration" button
6. The system will immediately verify the connection and display the result:
   - Success: The MCP server is properly configured and accessible
   - Failure: Troubleshooting information will be provided

## Testing from the MCP Server Card

1. Navigate to the "Edit assistant" page
2. Find and expand the MCP server tool card
3. Click on the three dots menu
4. Select the "Test integration" option
5. The system will perform the verification and display results immediately

This feature helps you quickly confirm that your MCP server connection is working properly without having to test it through actual assistant conversations.

## Using MCP Tools in Assistants

Once configured, your assistant can use tools from the MCP server:

1. The assistant automatically discovers available tools from the MCP server
2. Users can invoke these tools through the assistant interface
3. Tool responses are formatted and presented to the user
4. If connection issues occur, the assistant provides appropriate error messages

## Troubleshooting MCP Server Connections

If you encounter issues with MCP servers:

- Verify the server URL and authentication are correct
- Check that the MCP server is operational and accessible
- Ensure network connectivity between CodeMie and the MCP server
- Review environment variable configurations

For more information, see the video tutorials: [CodeMie integrations with JetBrains via MCP](https://videoportal.epam.com/video/y76LlgVY) and [CodeMie SDK and Assistants MCP Server](https://videoportal.epam.com/video/Q7zQ5ObJ).

## Sources

- [Adding An Mcp Server](https://docs.codemie.ai/user-guide/tools_integrations/tools/adding-an-mcp-server)
- [Using Mcp Tools In Assistants](https://docs.codemie.ai/user-guide/tools_integrations/tools/using-mcp-tools-in-assistants)
