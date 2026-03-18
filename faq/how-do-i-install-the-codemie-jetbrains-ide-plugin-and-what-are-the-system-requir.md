# How do I install the CodeMie JetBrains IDE plugin and what are the system requirements? How can I troubleshoot CodeMie JetBrains plugin issues like freezing or authentication problems? How to Install and Use the CodeMie JetBrains IDE Plugin?

## How to Install and Use the CodeMie JetBrains IDE Plugin

## Overview

The CodeMie JetBrains IDE plugin brings native CodeMie integrations directly into your JetBrains development environment, including IIntelliJ IDEA, WebStorm, PyCharm, DataGrip. This plugin provides seamless access to CodeMie assistants, project selection, and development tools without leaving your IDE.

## Prerequisites

- \***\*JetBrains IDE\*\*** (IntelliJ IDEA, WebStorm, PyCharm, DataGrip.)
- \***\*CodeMie Account\*\*** for authentication

## Installation

1. Open your JetBrains IDE
2. Go to \***\*Settings/Preferences\*\*** > \***\*Plugins\*\***
3. Search for "CodeMie" in the marketplace
4. Click \***\*Install\*\*** and restart your IDE

## Key Features

Native IDE Integration:

- \***\*Sidebar Interface\*\***: Access CodeMie directly from the IDE sidebar
- \***\*Project Context\*\***: Automatic integrations with your current development context
- \***\*Assistant Tools\*\***: All development tools are automatically integrated when selecting assistants

Conversation Management:

- \***\*Chat History\*\***: Navigate through previous conversations with assistants
- \***\*New Conversations\*\***: Create new assistant interactions as needed
- \***\*Web Sync\*\***: All IDE conversations are synchronized with the CodeMie web platform

## Troubleshooting

## Common Issues and Solutions

Plugin Not Responding:

1. Click the \***\*Refresh\*\*** button in the plugin interface
2. Restart your JetBrains IDE
3. Check VPN connection status

Authentication Problems:

1. Verify EPAM VPN connection
2. Clear plugin cache in settings
3. Reset login data through plugin settings

Development Tools Not Working:

1. Ensure Global Protect version 6.3.x is installed
2. Verify VPN connection to EPAM network
3. Check plugin settings for toolkit configurations

Plugin Settings  
Access plugin settings to:

- \***\*Toggle Toolkits\*\***: Enable/disable specific development toolkits
- \***\*Add MCP Plugins\*\***: Configure Model Context Protocol plugins
- \***\*Reset Cache\*\***: Clear cached data and login information
- \***\*Manage Connections\*\***: Update authentication and connection settings

### **1.3.23. Where can I find the name of the LLM model? LLM model name for workflow? List of names of LLM models?**

1. **Open the Codemie web page:**  
   Go to [https://epa.ms/codemie](https://epa.ms/codemie)

2. **Open DevTools (Developer Tools):**  
   Press the F12 key or right-click on the page and select **"Inspect"**.

3. **Go to the Network tab:**  
   This tab shows all network requests made by the page.

4. **Refresh the page (F5)**  
   This will load all the network activity, including the LLM request.

5. **Find the request named llm_models:**  
   In the “Name” column filter or search for llm_models.  
   Double-click on the request or select it.

6. **Click on the Response tab:**  
   You will see a JSON response from the server.

7. **Locate the base_name field:**  
   Inside the JSON object, you'll find model information.  
   The base_name field indicates the model name used in the workflow.  
   Example: "base_name": "gpt-4o-2024-08-06"

## Sources

- [Jetbrains Plugin](https://docs.codemie.ai/user-guide/ide/jetbrains-plugin)
