---
id: plugin
title: Plugin
sidebar_label: Plugin
---

# Plugin

Extend AI Assistant capabilities with external tools through CodeMie Plugins.

This guide provides step-by-step instructions for setting up and configuring CodeMie Plugins to enhance your AI Assistant capabilities with external tools and custom functionality.

## Overview

CodeMie Plugins enable you to extend your AI Assistant's capabilities by connecting to external tools, file systems, and custom development environments. This powerful feature allows assistants to interact with your local or remote environment, execute commands, analyze code, and manage repositories.

:::warning Important
Before using an AI Assistant with Plugin tools enabled, you must run the `codemie-plugin` CLI in your remote environment. This step is **required each time** you want to interact with the AI Assistant!
:::

## Prerequisites

To use CodeMie Plugins, you'll need to:

1. Install AI/Run CodeMie Plugins Client (`codemie-plugin` CLI)
2. Configure a Plugin Integration in AI/Run CodeMie
3. Create an AI Assistant with the Plugin Tool enabled

## System Requirements

To enable the Plugin Engine in your remote runtime environment, two key components are required:

| Software | Minimum Version | Purpose |
|----------|----------------|---------|
| **Python** | 3.12 or higher | Core runtime environment |
| **Node.js** | v22 or higher | Supporting runtime components |

### Why These Requirements?

- **Python**: Many configurations, command-line tools, and development toolkits in AI/Run CodeMie rely on Python-based scripts
- **Node.js**: Supports crucial systems within the Plugin Engine, particularly for server-side workflows and MCP server functionality

Python and Node.js work together to power the full functionality of the Plugin Engine, enabling advanced features such as code analysis, repository management, and seamless integration with toolkits.

### Download Links

If your current versions don't meet these requirements, update to the specified versions:

- **Python**: [python.org/downloads](https://python.org/downloads)
- **Node.js**: [nodejs.org/en/download](https://nodejs.org/en/download)

## Installation Steps

### Step 1: Install uv - Python Package Installer

To prepare your remote environment for running `codemie-plugin` CLI, install the Python package installer:

#### macOS and Linux

**Option 1 - Install via script:**

```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
```

**Option 2 - Install via Homebrew:**

```bash
brew install uv
```

#### Windows

**PowerShell:**

```powershell
powershell -ExecutionPolicy ByPass -c "irm https://astral.sh/uv/install.ps1 | iex"
```

### Step 2: Install codemie-plugins

```bash
uvx pip install codemie-plugins
```

This command installs the `codemie-plugins` package in an isolated Python environment using the `uvx` tool.

### Step 3: Generate Your Plugin Key

Run the following command in your local environment:

```bash
uvx codemie-plugins config generate-key
```

The Plugin Key helps identify your environment and validate that you have the necessary permissions to use AI/Run CodeMie plugins. Without the key, the plugins cannot communicate with AI/Run CodeMie's services or execute certain commands.

:::warning Important
Copy and save the Plugin Key that is generated, as you will need it during the integration process in AI/Run CodeMie.
:::

## Configuration

### Creating Plugin Integration

#### Step 1: Access Integrations

Log in to the AI/Run CodeMie platform and navigate to the **Integrations** section and click **+Create**.

#### Step 2: Configure Plugin Integration

From the dropdown menu, choose **Plugin** as the type of integration and fill in the following details:

- **Alias**: Give your integration a descriptive name
- **Plugin Key**: Enter the Plugin Key you generated in Step 3
- **Project** (if applicable): Select the project where this integration will be active

:::note
If you create a project integration (not a user integration), make sure to select the correct project where this integration will be active.
:::

### Creating AI Assistant with Plugin Tool

#### Step 1: Select Template

Open AI/Run CodeMie platform and navigate to **Assistants** → **Templates**:

1. Click **+Create Assistant**

#### Step 2: Configure the Assistant

**Basic Configuration:**

- Choose an appropriate template or start from scratch
- Configure system instructions and model settings

**Plugin Tool Setup:**

1. In the **Available Tools** section, locate the **Plugin** tool
2. Enable the Plugin tool
3. Select your configured plugin integration from the dropdown

**Customization (Optional):**

This template includes generic instructions and predefined tools for Plugins. However, you can customize it by specifying relevant project details, such as:

- Project-specific requirements
- Coding standards
- File structure preferences
- Any other specific details about your project

## Running AI/Run Development Plugin

To allow your AI Assistant to use pre-built external tools, run the AI/Run Development Plugin:

```bash
uvx codemie-plugins development run --repo-path /path/to/repo
```

:::warning Important
Be sure to replace `/path/to/repo` with the actual location of your repository.
:::

### Available Pre-built Tools

This enables the execution of the following external tools:

- **File Operations**: Read, write, and manage files in your repository
- **Git Operations**: Execute git commands and manage version control
- **Code Analysis**: Analyze code structure and quality
- **Command Execution**: Run shell commands in your environment
- **Repository Navigation**: Browse and search your codebase

### Verifying Connection

**Check NATS.io URI:**

Bidirectional communication between the remote runtime environment and The Plugin Engine is handled through the NATS.io messaging system. You should see the following URI:

```
nats://nats-codemie.epmd-edp-anthos.eu.gcp.cloudapp.epam.com:443
```

If the displayed URI is different, update it using:

```bash
codemie-plugins config set PLUGIN_ENGINE_URI nats://nats-codemie.epmd-edp-anthos.eu.gcp.cloudapp.epam.com:443
```

**Confirm Successful Registration:**

After running the command, confirm that you see output indicating successful tool registration. This indicates that the Plugin Engine is running successfully.

**Test Plugin Connection:**

Start chatting with your Assistant:

1. Ask: "What tools do you have?"
2. Verify that the plugin tools are available

:::danger Critical
Your AI Assistant will only be able to execute the external tools when codemie-plugins CLI is actively running in the command line. You must keep the CLI session open and ensure that you see live updates (e.g., health checks or status indicators) to confirm that the Plugin Engine is operational.
:::

## Using Plugin-Enabled Assistants

With the plugin CLI running, your assistant can:

### File System Access

- **Read files**: Access and analyze files in your local environment
- **Write files**: Create and modify files based on your instructions
- **Navigate directories**: Browse and explore your file system
- **Search files**: Find files by name, content, or pattern

### Code Management

- **Analyze code**: Review code structure, identify issues, and suggest improvements
- **Refactor code**: Make systematic changes across multiple files
- **Generate code**: Create new files and functions based on requirements
- **Execute scripts**: Run commands and scripts in your environment

### Repository Operations

- **Git operations**: Perform git commands (status, diff, commit, push, pull)
- **Branch management**: Create, switch, and merge branches
- **Code review**: Analyze changes and provide feedback
- **Documentation**: Generate or update documentation files

## Use Cases

### Development Workflow Automation

- Automate repetitive coding tasks
- Generate boilerplate code
- Refactor large codebases
- Maintain code consistency

### Code Analysis and Review

- Identify code smells and anti-patterns
- Suggest performance improvements
- Ensure coding standards compliance
- Generate code documentation

### Project Setup and Configuration

- Initialize new projects with proper structure
- Configure build tools and dependencies
- Set up CI/CD pipelines
- Create project documentation

### File Management

- Organize project files
- Rename and restructure directories
- Clean up unused files
- Migrate code between projects

## Security Considerations

### Access Control

- **Plugin Key Security**: Treat your Plugin Key like a password - never share it or commit it to version control
- **File System Access**: The plugin has access to files in the directory where it's running - be cautious about which directory you start it in
- **Command Execution**: Review commands before allowing the assistant to execute them

### Best Practices

- **Use Specific Directories**: Start the plugin CLI in specific project directories rather than root or home directories
- **Review Changes**: Always review file changes before committing them
- **Limit Scope**: Configure assistants with specific, limited responsibilities
- **Monitor Activity**: Keep track of what the assistant is doing in your environment

## Usage Example: Container Monitoring

**Scenario:** Sarah, a DevOps engineer, struggles with managing multiple containerized applications on her laptop during development and testing. She wants an AI Assistant that will generate health reports including system performance, container uptime, resource trends, and potential issues.

**Process:**

1. **Run the Development Plugin**: Sarah starts by running the AI/Run Development Plugin via command line. After a successful run, the connection response confirms that 5 tools are available for use.

2. **Interact with AI Assistant**: Sarah moves to the chat interface and requests the Assistant to perform the task. The AI Assistant processes the request and uses the Run Command Line Tool to execute specified commands and retrieve necessary data.

3. **Monitor Execution**: Sarah can see logs directly in the command line to verify the tool's execution.

4. **Get Results**: The Assistant organizes the data and generates a structured health report summarizing system performance, container uptime, resource trends, and any detected issues.

## Troubleshooting Guide

### Problem 1: Authorization Violation

**Error Message:** `nats.errors.Error: nats: 'Authorization Violation'`

**Cause:** Your plugin's security key is either missing or doesn't match the system's records.

**Solution:**
1. Verify your Plugin Key is correct
2. Regenerate the Plugin Key if necessary using `uvx codemie-plugins config generate-key`
3. Update the Plugin Integration in AI/Run CodeMie with the new key
4. Restart the plugin CLI

### Problem 2: Connection Failure

**Error Message:** `Could not open connection to the host, on port 443: Connect failed`

**Cause:** Your VPN software (GlobalProtect) is outdated and unable to establish a secure connection.

**Solution:**
1. Update GlobalProtect to version 6.3 or later
2. Ensure you are connected to the VPN
3. Verify network connectivity to the NATS server
4. Check firewall settings

### Common Issues

**Plugin CLI Won't Start**:
- Verify Python 3.12+ and Node.js v22+ are installed
- Check that `uv` is properly installed
- Ensure Plugin Key is correct

**Connection Errors**:
- Verify network connectivity
- Check firewall settings
- Ensure Plugin Key matches the integration configuration

**Assistant Can't Access Files**:
- Verify plugin CLI is running
- Check that you're in the correct directory
- Ensure proper file permissions

**Commands Not Executing**:
- Confirm plugin CLI connection is active
- Check command syntax
- Verify necessary tools are installed in your environment

## Alternative Installation Method (Windows)

There is an alternative way to install codemie-plugin CLI in your local environment for Windows – using **Windows Subsystem for Linux (WSL)**. This might be a better alternative if you're already familiar with Linux workflows or prefer using bash-based commands instead of PowerShell.

To use this method:

1. Ensure that WSL is enabled by running: `wsl --status`
2. Start your WSL distribution
3. For detailed instructions on setting up WSL, refer to the official Microsoft guide: [How to install Linux on Windows with WSL](https://docs.microsoft.com/en-us/windows/wsl/install)
4. Follow the macOS/Linux installation instructions

## Conclusion

As you can see from the list of pre-built external tools in the AI/Run Development Plugin, its capabilities are quite limited and may not cover more complex or customized tasks. For these scenarios, using plugin-based MCP servers offers a better solution.

## Limitations

- Plugin tools are designed for local/containerized deployments
- Requires active CLI session for each interaction
- File system access is limited to the directory where CLI is started
- Network connectivity required between environment and AI/Run CodeMie instance
- VPN connection may be required (GlobalProtect version 6.3 or later)

## Additional Resources

For more information about CodeMie Plugins and advanced configuration:

- **MCP Servers**: For more advanced and customized tasks, see [Adding MCP Server](../external-tools/adding-mcp-server)
- **Plugin Repository**: Check internal documentation for the CodeMie plugins repository
- **Custom Plugin Development**: Refer to plugin development guidelines

:::note
The Plugin feature is particularly useful for containerized AI/Run CodeMie deployments where you need direct interaction with your development environment. For more complex scenarios, consider using MCP servers instead.
:::
