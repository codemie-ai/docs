---
id: adding-an-mcp-server
title: Adding an MCP Server
sidebar_label: Adding an MCP Server
sidebar_position: 21
---

# Adding an MCP Server

## Configuration Steps

1. Navigate to the **Create Assistant** or **Edit Assistant** page
2. In the **Available tools** section, expand the **External tools** category
3. Click on the External tools card to expand it
4. Select **Browse Catalog** for already predefined MCP servers or **Manual Setup** for adding your own MCP server

![External tools](./images/image90.png)

## Add Predefined MCP Servers from Browse Catalog

1. Search MCP with Categories filter or by name and click **Add**
2. Add required **Environment Variables**
3. Add or select environment variables from the dropdown list if needed
4. And click **Save**
5. Click **Test Integration** and **Add** to complete the configuration

![Browse catalog](./images/image95.png)

## Add MCP Server with Form Manual Setup

When configuring an MCP server using the Form method:

1. Fill in the required fields:
   - **Name**: A unique identifier for your server (required)
   - **Description**: Details about the server's purpose (optional)
   - **Tools Tokens Size Limit**: in need to change value by default
   - **Command**: The command used to invoke the server (required)
   - **Arguments**: Any additional parameters needed, space-separated (optional)
2. Select environment variables from the dropdown if needed
3. Click **Test Integration** and **Add** to complete the configuration

**Example**:

- **Name**: time-mcp-server
- **Description**: time-mcp-server
- **Command**: uvx
- **Arguments**: `mcp-server-time --local-timezone=America/New_York`

![Form setup](./images/image71.png)

## Add MCP Server with JSON Method Manual Setup

For advanced configurations, you can use the JSON method:

1. Fill in the basic fields (Name, Description, Command, **Tools Tokens Size Limit**)
2. Enter valid JSON data in the **JSON format** field
3. Select environment variables as needed
4. Click **Add Server** to complete the configuration

**Example**:

```json
{
  "command": "uvx",
  "args": ["mcp-server-time", "--local-timezone=America/New_York"]
}
```

![JSON setup](./images/image49.png)

**Example of the conversation**:

![MCP conversation](./images/image80.png)

## Managing Environment Variables

MCP servers often require environment variables for proper operation:

1. Click **Add environment variables** on the expanded MCP tool card
2. Choose between **Project Environment Variables** or **User Environment Variables**
3. Fill in the required fields:
   - **Alias**: A user-friendly name for the variable
   - **Key**: The environment variable key name
   - **Value**: The value to assign (will be securely stored)
4. Click **Add Environment Variables** to save the configuration

## Testing MCP Server Integration

To ensure your MCP server is correctly configured and accessible, CodeMie provides a convenient **Test integration** feature:

### Testing from the Edit MCP Server Page

1. Navigate to the **Edit assistant** page
2. Find and expand the MCP server tool card
3. Click on the three dots menu, then click **Edit**
4. On the **Edit an MCP server** page, locate the **Test integration** button next to **Cancel** and **Save**
5. Click the **Test integration** button
6. The system will immediately verify the connection and display the result:
   - **Success**: The MCP server is properly configured and accessible
   - **Failure**: Troubleshooting information will be provided

### Testing from the MCP Server Card

1. Navigate to the **Edit assistant** page
2. Find and expand the MCP server tool card
3. Click on the three dots menu
4. Select the **Test integration** option
5. The system will perform the verification and display results immediately

This feature helps you quickly confirm that your MCP server connection is working properly without having to test it through actual assistant conversations.
