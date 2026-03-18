# What are Skills? What are Skills in CodeMie? How do Skills work? Why should I use Skills? What is the difference between Skills and system prompts?

Skills are reusable sets of instructions designed to make AI assistants smarter and more efficient by automating common tasks, sharing knowledge, and eliminating repetitive prompts.

## What are Skills?

Skills enable users to:

- **Create reusable instructions** - Define focused, task-specific guidance that can be applied across multiple assistants
- **Share knowledge** - Distribute best practices, guidelines, and standardized procedures across projects or teams
- **Eliminate redundancy** - Avoid duplicating instructions in system prompts for every assistant
- **Enable collaboration** - Ensure everyone benefits from consistent approaches without extra setup
- **Build modular AI** - Compose assistants from focused, reusable capabilities

## Why Use Skills?

### Problem: Overloaded System Prompts

Consider a Business Analyst assistant with a large system prompt containing instructions for various user needs:

```
System Prompt (3,000+ tokens):
- Complex guidelines for JIRA ticket structures
- Duplicate ticket search procedures
- Release planning workflows
- Sprint management instructions
- Stakeholder communication templates
- Documentation standards
- ...and more
```

**Issues with this approach:**

- **Hard to maintain** - Updating instructions requires editing multiple assistants
- **Inconsistent** - Different team members might have different versions
- **Context bloat** - Large system prompts consume valuable token budget
- **Not reusable** - Same instructions must be copied to every assistant
- **Always loaded** - All instructions are present even when not needed

### Solution: Skills

Break down the monolithic system prompt into focused, reusable skills:

- **JIRA Ticket Structure** - Guidelines for creating well-formed tickets
- **Find Duplicate Tickets** - Procedures for searching existing issues
- **Release Planning** - Workflows for release preparation
- **Sprint Management** - Best practices for sprint ceremonies

**Benefits:**

- **Maintainable** - Update skill once, affects all assistants using it
- **Consistent** - Single source of truth for each procedure
- **Efficient** - Skills load on-demand when needed
- **Reusable** - Share skills across assistants, projects, and teams
- **Modular** - Compose assistants from focused capabilities

## How Skills Work

### Skill Structure

Each skill contains:

| Field                | Description                                                                  |
| -------------------- | ---------------------------------------------------------------------------- |
| **Name**             | Clear, descriptive title for the skill                                       |
| **Description**      | Detailed information helping the assistant recognize when to apply the skill |
| **Instructions**     | Clear skill purpose, context, and step-by-step directions                    |
| **Tools** (optional) | Required tools for skill execution                                           |
| **Project**          | Project scope for the skill                                                  |
| **Sharing**          | Visibility (private, project, marketplace)                                   |

### Skill Activation

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

**3. Marketplace Discovery**

Public skills can be discovered and attached from the Skills Marketplace.

## Sources

- [Skills Overview](https://docs.codemie.ai/user-guide/skills/skills-overview)
