---
id: assistant-creator-skill
title: Create an Assistant with the Assistant Creator Skill
sidebar_label: Assistant Creator Skill
sidebar_position: 2
pagination_prev: user-guide/assistants/create-assistant
pagination_next: user-guide/assistants/sharing-assistants
description: Create an assistant through a guided conversation with the Assistant Creator marketplace skill, without filling in the assistant configuration form
---

# Create an Assistant with the Assistant Creator Skill

**Assistant Creator** is a public marketplace skill, pre-published on every AI/Run CodeMie
instance, that builds an assistant through conversation. Instead of opening the assistant
configuration form, a plain-language description of the desired assistant is enough — the
skill asks any missing questions, proposes a complete configuration, and creates the assistant
only after explicit confirmation.

This differs from the other two ways to [create an assistant](./create-assistant.md):

| Method                | Project, model, and datasources  | Follow-up questions | Result                                               |
| --------------------- | -------------------------------- | ------------------- | ---------------------------------------------------- |
| **Manual Creation**   | Set by the user                  | None                | A blank form to fill in field by field               |
| **Generate with AI**  | Left untouched                   | None                | A pre-filled form that still needs review and saving |
| **Assistant Creator** | Selected during the conversation | Asked as needed     | A created assistant, ready to use, once confirmed    |

## Prerequisites

- Access to at least one project where assistants can be created.
- Permission to create assistants in that project.

## Starting a Conversation with Assistant Creator

Assistant Creator is used like any other [marketplace skill](../skills/marketplace-skills.md) —
attach it to a chat and describe the assistant to build.

1. Start or open a chat with any assistant.
2. Click the **Skills** button in the chat input field.
3. In the **Attach Skills** modal, open the **Marketplace Skills** tab and select **Assistant
   Creator**.
4. Click **Confirm**.
5. Describe the assistant to create, for example: "I need an assistant that reviews pull
   requests against our coding standards and summarizes risky changes."

See [Skills in Chat](../skills/skills-in-chat.md) for more on attaching skills to a
conversation.

## Walking Through the Conversation

Assistant Creator guides the conversation through a fixed sequence of steps. Some steps are
skipped automatically when the initial description already provides enough information.

1. **Project** — Confirms which project the assistant belongs to, from the projects
   accessible to the current user.
2. **Clarify** — Asks follow-up questions only for details missing from the description, such
   as the assistant's purpose or the kind of tasks it should handle.
3. **Discover** — Looks up what is available in the selected project: permitted models,
   toolkits with ready credentials, project data sources, valid categories, and sharing modes.
   Only resources accessible to the current user are considered.
4. **Draft** — Proposes a complete configuration: name, description, system instructions,
   model, tools, and data sources.
5. **Review** — Presents the full draft for review before anything is created.
6. **Confirm** — Shows the complete draft and returns a confirmation phrase. Nothing is
   created until that exact phrase is sent back, verbatim, in a later message.
7. **Create** — Creates the assistant once the confirmation phrase is confirmed.
8. **Report** — Reports the outcome, including a link to the new assistant.
9. **Optional test** — Offers to run a single test exchange against the new assistant. This
   step only runs if explicitly requested, since it consumes model budget.

:::info Confirmation requires the exact phrase, not just "yes"
Assistant Creator shows the complete draft configuration and asks for a confirmation phrase to
be sent back verbatim before creating anything — a plain "yes" is not enough. Changing the
description, asking for a different model, or adding another tool during review updates the
draft and invalidates any confirmation phrase already issued; a new one is requested from the
next review.
:::

## What Assistant Creator Can and Cannot Do

Assistant Creator acts only as the requesting user, using only that user's own permissions —
it never acts as the platform owner.

**Assistant Creator can:**

- Create a new assistant in a project the current user has access to.
- Select from models, toolkits, and data sources the current user is permitted to use.
- Run one optional smoke test against the newly created assistant, on request.

**Assistant Creator cannot:**

- Modify or delete an existing assistant.
- Publish the new assistant to the marketplace.
- Create a remote or Bedrock-hosted assistant.
- Bypass the platform's normal validation for assistant creation.

By default, an assistant created this way is private to the user who created it. Sharing it
with a project follows the same process as any other assistant — see
[Share Assistants](./sharing-assistants.md).

If an assistant with the same name already exists, Assistant Creator pauses and asks whether
to rename the new assistant or continue with the duplicate name.

:::note The same capability, without the skill
Assistant Creator is built on the assistant-creation tools in the
[Platform Tools](../tools_integrations/tools/platform-tools.md) toolkit. Enabling that toolkit
on any assistant grants the same conversational assistant-creation capability directly, without
attaching the Assistant Creator skill.
:::

## Related Pages

- [Create Assistant](./create-assistant.md) - Manual and AI-generated assistant creation
- [Skills Marketplace](../skills/marketplace-skills.md) - Discover and attach marketplace skills
- [Skills in Chat](../skills/skills-in-chat.md) - Attaching skills to a conversation
- [Share Assistants](./sharing-assistants.md) - Share a created assistant with a project
- [Platform Tools](../tools_integrations/tools/platform-tools.md) - The underlying assistant-creation tools
