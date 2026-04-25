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
- [Restore System Instructions](./restore-system-instructions.md) - Revert to previous instruction versions
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
