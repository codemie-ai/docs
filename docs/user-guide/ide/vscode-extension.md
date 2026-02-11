---
id: vscode-native-extension
title: VS Code Native Extension
sidebar_label: VS Code Native Extension
pagination_prev: user-guide/ide/index
pagination_next: null
sidebar_position: 3
---

# CodeMie VS Code Native Extension

The CodeMie Native VS Code extension provides a dedicated sidebar interface for CodeMie within Visual Studio Code. This extension offers full-featured access to CodeMie assistants, conversations, and tools in a native VS Code experience.

---

## Prerequisites

- CodeMie Account for authentication

---

## Installation

1. Open your Visual Studio Code IDE
2. Click on **Extensions** button or (Ctrl+Shift+X or Cmd+Shift+X)
3. Search for "[AI/Run CodeMie](https://marketplace.visualstudio.com/items?itemName=ai-run-codemie.ai-run-codemie)" in the extensions marketplace.

![Marketplace](./images/image232.png)

4. Click **Install** and follow the setup instructions provided in the extension documentation

---

### Example of usage

![Marketplace](./images/image233.png)

---

## Troubleshooting

### Common Issues and Solutions

#### Extension Not Responding

1. Click the Refresh button in the extension interface
2. Restart your Vs code IDE
3. Check connection status

#### Authentication Problems

1. Verify connection
2. Clear extension cache in settings
3. Reset login data through extension settings

## Configure Claude Code extension to work through CodeMie proxy

From version 0.1.22 there is an option to configure Claude Code VSCode extension to use Codemie as a proxy.
This allows to use claude without Claude subscription and obtaining Anthropic API Key

### Prerequisites

1. "[Claude Code for VS Code]" extension is installed

![Marketplace](./images/claude-code-extension.png)

2. "[AI/Run CodeMie VS Code Extension]" version >= 0.1.22

### Instructions

1. Enable "Use Custom Claude Code Configuration" option in AI/Run Codemie extension settings

![Marketplace](./images/configure-claude-proxy.png)

2. Open Claude Code extension and start working with it

![Marketplace](./images/claude-extension-usage.png)
