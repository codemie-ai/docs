# How do I control which MCP servers are available to users on the platform? Where do I find the predefined MCP catalog management in settings? How can I add new MCP servers to the platform's available list?

The MCPs Management feature in Administrative Settings allows platform administrators to control the catalog of available Model Context Protocol (MCP) servers, providing centralized governance and security control over which servers users can access.

Accessing MCPs Management:  
Prerequisites: You must have Administrator role/permissions on the AI/RUN CodeMie platform

## Navigation:

- Log in to the AI/RUN CodeMie platform
- Navigate to Settings → Administration
- Select "MCPs management" from the left sidebar

The MCP Management interface displays a comprehensive table with:

Name: The display name of the MCP server  
Categories: Categorized tags (Cloud, Search, Database, API, Development, etc.)  
Description: Detailed explanation of the server's functionality  
Visibility: Toggle switch to control user access  
Status: Current operational status (Active/Inactive)

Actions: Three-dots menu (⋮) for editing server details

## Adding New MCP Servers to the Catalog :

1. Click the "Add MCP Server" button in the top-right corner
2. Fill in the comprehensive server information form:  
   2.1. Name: Unique identifier for the server (required)  
   2.2. Icon URL: URL for the server's display icon  
   2.3. Category: Select from dropdown options:  
   2.4. Description: Comprehensive description of server functionality (required)  
   2.5. Documentation Section: Link to MCP documentation: URL to official server documentation (required)  
   2.6. Link to Source code: URL to the server's source code repository  
   Server Configuration:  
   2.7. Configuration JSON: Complete JSON configuration for the server (required)  
   2.8. Add env variables.  
   2.9. Click "Create" to save the new server to the catalog
3. You can select added or already existing mcp servers from the catalog. For that edit or create a new assistant in the “external tools” section click Browse catalog and select it.

## Sources

- [Adding An Mcp Server](https://docs.codemie.ai/user-guide/tools_integrations/tools/adding-an-mcp-server)
