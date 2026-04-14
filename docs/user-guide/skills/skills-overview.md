---
id: skills-overview
title: Skills Overview
sidebar_label: Overview
pagination_prev: user-guide/skills/skills-index
pagination_next: user-guide/skills/create-skill
sidebar_position: 1
---

# Skills Overview

Skills are reusable sets of instructions designed to make AI assistants smarter and more efficient by automating common tasks, sharing knowledge, and eliminating repetitive prompts.

## What are Skills?

Skills enable users to:

- **Create reusable instructions** - Define focused, task-specific guidance that can be applied across multiple assistants
- **Share knowledge** - Distribute best practices, guidelines, and standardized procedures across projects or teams
- **Eliminate redundancy** - Avoid duplicating instructions in system prompts for every assistant
- **Enable collaboration** - Ensure everyone benefits from consistent approaches without extra setup
- **Build modular AI** - Compose assistants from focused, reusable capabilities

## Skill Activation

Skills can be activated in multiple ways:

**1. Automatic Loading (Assistant-level)**

When a skill is attached to an assistant, it loads automatically based on relevance to the user's request.

```
User: "Create a draft story for the new feature"
→ Assistant detects "JIRA Ticket Structure" skill is relevant
→ Skill loads automatically
→ Assistant applies ticket formatting guidelines
```

**2. Dynamic Attachment (Chat-level)**

Skills can be added to individual chats without modifying the assistant itself.

```
User adds "Find Duplicate Tickets" skill to current chat
→ Skill attaches to this conversation only
→ Loads on-demand when relevant
→ Other chats with same assistant remain unaffected
```

**3. Workflow Assistant Configuration (YAML-level)**

Skills can be embedded directly into virtual assistants defined in workflow YAML.

```
Workflow YAML defines an assistant with a skills list
→ Assistant loads configured skills during workflow execution
→ Skill usage is logged in execution history
→ Other assistants and workflows are unaffected
```

**4. Marketplace Discovery**

Public skills can be discovered and attached from the Skills Marketplace.

## Getting Started

Ready to create your first skill? Continue to the next guide:

[Create a Skill →](./create-skill)

Or explore how to attach skills to assistants:

[Attach Skills to Assistants →](./attach-skills-to-assistants)
