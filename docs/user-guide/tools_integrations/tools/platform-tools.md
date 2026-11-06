---
id: platform-tools
title: Platform Tools
sidebar_label: Platform Tools
pagination_prev: user-guide/tools_integrations/tools/overview
pagination_next: null
sidebar_position: 27
description: Tools for retrieving platform analytics and for creating and testing assistants directly from a conversation
---

# Platform Tools

**Platform Tools** is a built-in toolkit that needs no integration setup. It groups two kinds
of capability: retrieving platform analytics, and creating (and testing) assistants directly
from a chat with any assistant that has this toolkit enabled. Tools selected for a new
assistant may require their own integration credentials.

## Enabling Platform Tools

1. On the assistant's create or edit page, open **Available Tools**.
2. Select the **Platform Tools** card.
3. Choose which tools from the toolkit to enable.
4. Save the assistant.

Every user can enable the analytics and assistant-creation tools listed below. Two analytics
tools are visible to admins only, as noted in the table.

## Assistant Creation Tools

These three tools let any assistant with Platform Tools enabled create another assistant on
request, using the requesting user's own permissions — the same underlying capability offered
by the [Assistant Creator skill](../../assistants/assistant-creator-skill.md), available here
as ordinary tools on any assistant instead of through that dedicated marketplace skill.

| Tool                               | What it does                                                                                                                                                                                  |
| ---------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Get Assistant Creation Options** | Discovers accessible projects and, once a project is confirmed, the models, toolkits, data sources, categories, and sharing modes available for creating an assistant in it. Creates nothing. |
| **Create Assistant**               | Creates one assistant from a reviewed draft, only after the user confirms. Private by default unless sharing with the project is requested.                                                   |
| **Test Assistant**                 | Runs a single test exchange against an assistant just created with Create Assistant. Only runs when explicitly requested, since it spends model budget.                                       |

### Two-Step Confirmation

Create Assistant never creates an assistant on its first call:

1. The assistant proposes a complete draft (name, description, system instructions, model,
   tools, data sources) and calls Create Assistant without an approval ID. No assistant is created;
   a temporary draft is stored for approval verification and the tool returns `CONFIRM CREATE`
   in a copyable code block.
2. The assistant asks the user to send that confirmation phrase back **verbatim**. A plain
   "yes" does not satisfy this step.
3. Only in the turn where the user's message is exactly that phrase does the assistant call
   Create Assistant again, including the approval ID — and the assistant is created.

Changing any field of the draft after the confirmation phrase was issued invalidates it; a new
approval must be requested for the updated draft. Approval expires after five minutes and can
only be used once. Used or replaced draft payloads are cleared; expired drafts are removed by
periodic cleanup. One-shot test eligibility lasts 24 hours after creation and uses metadata
without the draft payload.

Project discovery returns at most 20 suggestions; `project_search` narrows project names.
A selected project is checked directly, even if it was not among the suggestions. Credentials
are checked only for selected tools before approval is issued and again before it is used.
Missing credentials block creation until the integrations are configured or the affected tools
are removed; a failed check does not consume an existing approval. If the selected project is
unavailable, creation is refused with up to 20 accessible alternatives and an indication of
whether more projects are available.

Creation requires an interactive chat request; workflows, background requests, and subagents
cannot approve creation through these tools.

:::info Duplicate Names
If an assistant with the same name already exists, creation pauses and asks the user to either
rename the new assistant or explicitly choose to continue with the duplicate name.
:::

## Analytics Tools

| Tool                           | What it does                                                                                                  | Availability |
| ------------------------------ | ------------------------------------------------------------------------------------------------------------- | ------------ |
| **Get Assistants**             | Retrieves assistants with platform analytics filters (scope, user, project, date range)                       | All users    |
| **Get Conversation Metrics**   | Retrieves conversation metrics aggregated at the conversation level (tokens, spend, response time)            | All users    |
| **Get Spending Analytics**     | Retrieves spending analytics aggregated by user, project, assistant, or workflow                              | All users    |
| **Get Conversation Analytics** | Retrieves AI-analyzed conversation insights (topics, satisfaction, anti-patterns) combined with usage metrics | All users    |
| **Get Raw Conversations**      | Retrieves raw conversation data, including message and tool-invocation history                                | Admin only   |
| **Get LiteLLM Key Spending**   | Retrieves spending, budget, and usage details for LiteLLM API keys by alias                                   | Admin only   |

## Related Pages

- [Assistant Creator Skill](../../assistants/assistant-creator-skill.md) - The marketplace skill built on the assistant-creation tools
- [Create Assistant](../../assistants/create-assistant.md) - Manual and AI-generated assistant creation
- [Tools Overview](./overview.md) - All available tools
