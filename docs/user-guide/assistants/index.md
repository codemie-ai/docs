---
id: assistants-overview
title: Assistants
sidebar_position: 1
pagination_prev: user-guide/index
pagination_next: null
---

# How to Work With Assistants

## Overview

This section covers how to create, manage, and collaborate with Assistants in AI/Run CodeMie.

---

## Getting Started

Core assistant management tasks:

- [Create Assistant](./create-assistant.md) - Build assistants from scratch
- [Share Assistants](./sharing-assistants.md) - Share assistants with team members
- [Edit Assistants](./edit-assistants.md) - Modify assistant configurations
- [Assistant Version History](./assistant-version-history.md) - Browse, compare, and restore previous system instruction versions
- [Delete Assistants and Chats](./delete-assistants-and-chats.md) - Remove unused assistants and conversations

## Templates

Quick start with pre-built assistants:

- [Assistant Templates](./assistant-templates.md) - Pre-built templates for common tasks
- [Create Assistant From a Template](./create-assistant-from-a-template.md) - Quick start with templates

## Marketplace

Discover and share assistants with the community:

- [Marketplace Overview](./marketplace-overview.md) - Discover community-contributed assistants
- [Publish to Marketplace](./marketplace-publishing.md) - Share your assistants with the community
- [Assistant Categories Management](./assistant-categories-management.md) - Organize assistants with categories
- [Clone Assistant from Marketplace](./clone-assistant-from-marketplace.md) - Customize marketplace assistants

## Orchestration

Coordinate multiple assistants:

- [Sub-Assistants and Orchestration](./sub-assistants-multi-assistant-orchestrator.md) - Coordinate multiple specialized assistants

## Favorites and Pinned Assistants

Personalize your workspace for faster access:

- [Favorites](./favorites.md) - Save frequently used assistants, skills, and workflows as favorites
- [Pinned Assistants](./pinned-assistants.md) - Pin assistants to the navigation sidebar for one-click access

## Filtering Assistants

The **Project Assistants** list provides a filter panel for narrowing the list. Filters can be combined, and the selected values are kept in the page address.

### MCP Servers Filter

The **MCP servers** filter shows only assistants that use a selected MCP server:

- Multi-select dropdown with a search field. Typing searches the MCP server catalog by name, and results load after a short delay.
- Shows assistants that use **any** of the selected servers.
- Counts only enabled MCP references. An MCP server that is attached to an assistant but switched off is not matched.
- Only assistants visible to the current user are listed.
- Pre-selected when opened from the **Assistants** count on the **MCPs management** page. See [MCP Management](../tools_integrations/tools/mcp/mcp-management.md#assistants-filtered-by-mcp-server).
- Available only in **Project Assistants** and only when the MCP feature is enabled on the deployment. The filter is not shown in **Marketplace**, **Templates**, and **Favorites**.

If the selected MCP server was deleted or is not accessible, the list shows the message `This MCP server could not be found or you no longer have access to it.` instead of the generic `No assistants found.` message.

## Moving Assistants Between Projects

You can move an assistant from one project to another by changing its project assignment:

1. Navigate to **Assistants** → **Project Assistants**.
2. Click the **Actions** button (⋮) next to the assistant and select **Edit**.
3. Change the **Project** dropdown to the desired target project.
4. Click **Save**.

The assistant moves to the new project immediately. All configuration (system instructions, tools, skills, and settings) is preserved.

:::warning Datasource Compatibility
When you move an assistant to a different project, any attached data sources that do not exist in the target project are automatically removed from the assistant's configuration. Verify the assistant's data source assignments after the move.
:::

:::warning Integrations
Integrations are not transferred between projects regardless of their level (project or user). If the assistant relied on integrations (e.g., Jira, Confluence, Git), you will need to recreate them in the target project.
:::

:::info
You can only move an assistant to a project you have access to.
:::

## Organizing and Managing Communication with Assistants

Manage conversations and organize your workspace:

- [Group Chats](./group-chats.md) - Communicate with multiple assistants in one conversation
- [Folders Overview](./folders-overview.md) - Organize chat history by assistant
- [Supported File Formats](./supported-file-formats-and-csv-handling-in-chat-assistant.md) - Upload and analyze files in chats
- [Share Chat Conversations](./share-assistant-chat-with-other-users.md) - Share conversations with team members
- [Export Assistant Chat Messages](./export-assistant-chat-messages-to-word-and-pdf-formats.md) - Export chats to various formats
- [HTML Preview](./html-preview.md) - Preview and interact with HTML content in chat
- [Chat Input Settings](./chat-input-settings.md) - Control Web Search, Code Interpreter, and LLM model per conversation from the chat toolbar
