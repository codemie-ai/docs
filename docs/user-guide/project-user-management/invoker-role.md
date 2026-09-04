---
id: invoker-role
title: Invoker Role
sidebar_label: Invoker Role
sidebar_position: 4
pagination_prev: user-guide/project-user-management/index
pagination_next: null
description: The Invoker is a run-only, least-privileged role in AI/Run CodeMie. Learn what an Invoker can and cannot do, how the role is assigned, and how it differs from other roles.
---

# Invoker Role

The **Invoker** is the least-privileged role on the platform. An Invoker uses the assistants
and workflows that other people have built and shared, but never sees or changes how they are
configured. The Invoker interface is deliberately reduced to a chat-first experience, similar to
a general-purpose AI chat product.

The role is intended for people who need to _run_ AI assistants without being able to
_author_ them: business users, support staff, reviewers, or anyone who should not have access
to prompts, tools, models, data sources, or platform configuration.

:::info Admin configuration required
The Invoker role is assigned from Users Management, which requires **Platform-managed mode**
(`ENABLE_USER_MANAGEMENT=True`). The role also requires **activity events** to be enabled
(`ACTIVITY_EVENTS_ENABLED=True`), because every Invoker action is recorded in the audit trail.
If auditing is disabled, assigning the role is rejected with the message
**Invoker role unavailable**.
:::

## What an Invoker Can Do

| Area                  | Allowed                                                                                                                                                                                                                                         |
| --------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Assistants            | Chat with assistants shared with the projects the Invoker belongs to, and with the Invoker's own clones. Browse the **Project**, **Marketplace**, and **Favorites** lists. Like, favorite, and pin assistants.                                  |
| Marketplace           | Clone a Marketplace assistant into the personal project and chat with the clone.                                                                                                                                                                |
| Workflows             | Browse shared workflows and run them. View, abort, resume, and delete the Invoker's **own** executions.                                                                                                                                         |
| Chats                 | Full conversation history: rename, move to folders, delete, attach files, export a single message, and open conversation links shared by other users.                                                                                           |
| Personal integrations | Create, edit, test, and delete personal integrations, including Google and SharePoint OAuth flows. Only credential types that some accessible assistant actually needs can be created. Bind a personal integration to an assistant's tool slot. |
| Profile               | View and edit the own profile and preferences.                                                                                                                                                                                                  |

## What an Invoker Cannot Do

| Area               | Restricted                                                                                                                                                                                                                      |
| ------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Configuration      | View or edit any assistant or workflow configuration: system prompt, tools, toolkits, MCP servers, skills, model settings, data source bindings, or workflow YAML. Assistant and workflow pages show a reduced, read-only view. |
| Models             | Change the LLM model in a chat or influence any AI configuration. The model configured by the assistant's author is always used.                                                                                                |
| Authoring          | Create, edit, delete, publish, or share assistants, workflows, skills, or templates. This includes the Invoker's own clones, which are run-only.                                                                                |
| Platform features  | Data Sources, AI Katas, Analytics, Skills, project integrations, and all administration screens. These entries are removed from the navigation, and direct links open an **Access denied** page.                                |
| Sharing and export | Create shared conversation links or export a full conversation. Opening a link shared by someone else is allowed.                                                                                                               |
| Direct API access  | Call any API route outside the allowed set. Such requests are rejected with **Access denied** and recorded in the audit trail.                                                                                                  |

:::note
Restrictions are enforced by the backend, not only hidden in the interface. An Invoker who
calls the API directly is denied in exactly the same way as in the UI.
:::

## The Invoker Interface

When a user with the Invoker role signs in, the interface switches to a reduced layout:

- **Navigation** shows **Chats**, **Assistants**, **Workflows**, **Applications** (when
  configured), **Favorites**, **Integrations**, and **Help**. **Skills**, **Data Sources**,
  **AI Katas**, **Analytics**, and administration settings are not shown.
- **Assistant pages** show the name, description, categories, and conversation starters. When an
  assistant needs a personal integration, an **Integration needed** section lists the required
  credential types. When it depends on MCP servers, an **MCP server needed** notice is shown.
- **Marketplace cards** offer **Clone** instead of **Chat**. A Marketplace assistant is chatted
  with only after it has been cloned.
- **Chat** has no model selector and no advanced options. The assistant's configured model is
  used for every message.
- **Integrations** shows only the **Personal** integrations of the current user. The **Project**
  tab is not available.
- **Help** hides deployment-specific information such as the available models catalog.

## Cloning a Marketplace Assistant

1. Open **Assistants → Marketplace**.
2. Click **Clone** on the assistant card.
3. Enter a name in the **Clone assistant** dialog and confirm.
4. The clone is created in the Invoker's personal project and a chat with it opens
   immediately.

:::warning
A clone created by an Invoker does **not** carry over the source assistant's MCP servers or
skills. If a Marketplace assistant relies on MCP tools, the clone loses that capability. Ask
the assistant's author to share the original assistant with the project instead.
:::

Clones are run-only: an Invoker cannot edit or delete a clone after it is created. Personal
credentials are attached through the **Integration needed** section, not by editing the
assistant.

## Personal Integrations for Invokers

An Invoker can create only the credential types that at least one accessible assistant
requires. When a type is not needed by any assistant, the integration form shows guidance
instead of saving:

> No assistant or workflow accessible to you currently needs `<credential type>`. Pick a type
> one of your assistants needs, or add the integration directly from that assistant's own
> "Integration needed" section.

The recommended flow is to start from the assistant:

1. Open the assistant page. The **Integration needed** section lists every credential type the
   assistant requires and whether the author already provided it.
2. Select an existing personal integration for each tool, or create a new one from the same
   section.
3. Click **Save**. The binding applies only to the current user; other users of the same
   assistant are not affected.

Integrations created by an Invoker are always personal. An Invoker cannot create project
integrations or make a personal integration global.

## Assigning the Role

The Invoker role is a platform-wide flag on the user account, not a per-project setting. Project
membership still decides _which_ projects the Invoker sees; the role only limits what the user
can do inside them.

The role is assigned from the **User Details** panel in
[Users Management](./users.md#assign-the-invoker-role). The following rules apply:

- Invoker is mutually exclusive with **Admin**, **Maintainer**, **Auditor**, and **Project
  Admin**. Enabling Invoker clears the Admin, Maintainer, and Auditor switches. If the user is
  a Project Admin in any project, the assignment is rejected until that role is removed.
- The account can still be added to projects as a regular member by any Project Admin. The
  Invoker restriction follows the account into every project.
- Existing assistants, workflows, or integrations owned by the user remain in place, but the
  user can no longer edit them while the role is active.

## Audit Trail

Every action performed by an Invoker is recorded as an activity event, including chat turns,
workflow executions, clones, integration changes, tool-slot bindings, file uploads, and every
denied request. This makes the role suitable for environments where run-only access must be
provable.

## Comparison with Other Roles

| Capability                                   | Invoker | Regular User | Project Admin | Admin / Maintainer |
| -------------------------------------------- | ------- | ------------ | ------------- | ------------------ |
| Chat with shared assistants                  | ✅      | ✅           | ✅            | ✅                 |
| Run shared workflows                         | ✅      | ✅           | ✅            | ✅                 |
| View assistant and workflow configuration    | ❌      | ✅           | ✅            | ✅                 |
| Create and edit assistants and workflows     | ❌      | ✅           | ✅            | ✅                 |
| Change the LLM model in a chat               | ❌      | ✅           | ✅            | ✅                 |
| Manage personal integrations                 | ✅      | ✅           | ✅            | ✅                 |
| Manage project integrations and data sources | ❌      | ❌           | ✅            | ✅                 |
| Manage project members                       | ❌      | ❌           | ✅            | ✅                 |
| Access administration and analytics          | ❌      | ❌           | ❌            | ✅                 |

For the complete platform role model, see [CodeMie Roles Overview](../../admin/security/roles-rbac.md).
