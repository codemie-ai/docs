# How to Configure MCP Servers in Workflow Assistants. How do I add MCP server tools to my workflow assistant? What MCP servers are compatible with workflow assistants? "Can I use multiple MCP servers in a single workflow? How do environment variables work with MCP servers in workflows?

SECURITY ALERT: Currently, sensitive data in environment variables is stored in plain text. Do NOT store passwords, API keys, or other confidential information in environment variables until a secure storage solution is implemented. This is a known limitation that will be addressed in a future release.

## How to Configure MCP Servers in Workflow Assistants

Overview  
Workflow assistants now support MCP server configurations, allowing you to leverage specialized tools directly within your workflow automation. This feature provides consistency across the platform and enables more powerful workflow capabilities.

## Configuring MCP Servers in a Workflow

YAML Configuration Method  
Add the `mcp_servers` field to your assistant definition in the workflow YAML. Below are several examples showing different configurations.

## Example 1: Basic CLI MCP Server Configuration

```yaml
max_concurrency: 1
assistants:
  - id: analyzer_assistant
    model: gpt-4.1
    system_prompt: |
      You are an assistant that can analyze and list available tools.
      Your task is to provide a comprehensive list of tools, including their names and descriptions.
      Perform an actions with the tool if user asks.
    mcp_servers:
      - name: CLI MCP Server
        description: The server will only allow operations within directories
        enabled: true
        config:
          command: uvx
          args:
            - cli-mcp-server
          env:
            ALLOWED_DIR: "/usr"
            ALLOWED_COMMANDS: "ls,echo,touch"
states:
  - id: analysis
    assistant_id: analyzer_assistant
    task: |
      Provide an answer based on the user's input.
    next:
      state_id: end
Example 2: Multiple MCP Servers Configuration

yaml
assistants:
  - id: multi_tool_assistant
    model: gpt-4o
    system_prompt: |
      You are a workflow assistant with access to multiple specialized tools.
    mcp_servers:
      - name: "time-mcp-server"
        description: "Provides time-related functions"
        command: "uvx"
        args: ["mcp-server-time", "--local-timezone=America/New_York"]
        enabled: true

      - name: "sql-mcp-server"
        description: "Allows database queries"
        command: "uvx"
        args: ["mcp-server-sql"]
        env:
          CONNECTION_STRING: "postgresql://user:password@localhost:5432/mydb"
        enabled: true

Example 3: Weather API MCP Server
yaml
assistants:
  - id: weather_assistant
    model: gpt-4o
    system_prompt: |
      You are a weather information assistant.
    mcp_servers:
      - name: "weather-api"
        description: "Retrieves weather information"
        command: "uvx"
        args: ["mcp-server-weather-api"]
        env:
          API_KEY: "your-api-key"   ⚠️ See security alert below
          DEFAULT_UNITS: "metric"
        enabled: true

Example 4: Disabled MCP Server
yaml
assistants:
  - id: file_assistant
    model: gpt-4o
    system_prompt: |
      You are a file management assistant.
    mcp_servers:
      - name: "file-management-server"
        description: "Provides file operations"
        command: "uvx"
        args: ["mcp-server-files"]
        enabled: false   This server will not be loaded

Available MCP Server Options
All standard MCP server options are available for workflow assistants:

* name (required): A descriptive name for the MCP server
* description (optional): Details about the server's functionality
* command (required): The MCP server to invoke (e.g., "uvx")
* args (optional): Command-line arguments as an array
* env (optional): Environment variables for configuration parameters
* enabled (optional): Boolean flag to enable/disable the server (defaults to true)
* config (optional): Additional configuration object for complex setups
## Sources

- [Adding An Mcp Server](https://docs.codemie.ai/user-guide/tools_integrations/tools/adding-an-mcp-server)
- [Configuration Reference](https://docs.codemie.ai/user-guide/workflows/configuration/configuration-reference)
```
