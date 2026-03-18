# How to Install codemie-plugins using pip? How to setup codemie plugins on Windows? MacOS codemie plugin installation steps?

You can install and use CodeMie plugins by using the `codemie-plugins` PyPi package:

First you need to clone repository https://gitbud.epam.com/epm-cdme/codemie-plugins

## Quick Installation

**Using pip:**  
pip install codemie-plugins  
Using uvx (Recommended for isolated environment):

Install  
uvx pip install codemie-plugins

Run uvx codemie-plugins
Basic Usage  
After installation, you can run commands like:

Configure your plugin key  
codemie-plugins config set PLUGIN_KEY your-plugin-key

Run the development toolkit  
codemie-plugins development run

List available MCP servers  
codemie-plugins mcp list

Run MCP servers  
codemie-plugins mcp run -s filesystem  
For more detailed instructions, see the CodeMie Plugin Quickstart documentation.

## Sources

- [Plugin](https://docs.codemie.ai/user-guide/tools_integrations/tools/plugin)
