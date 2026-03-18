# How do I create a Skill? How to create Skills manually? How to import Skills from file? How to import Skills from GitHub? What format do Skill files use?

There are three methods to create skills in AI/Run CodeMie:

## Method 1: Create Skill Manually

### Step 1: Navigate to Skills Page

1. Open CodeMie
2. Click **Skills** in the left navigation panel
3. Navigate to the **Project Skills** tab
4. Click the **Create Skill** button

### Step 2: Fill Required Fields

On the Create New Skill page, provide:

| Field              | Required | Description                                                             |
| ------------------ | -------- | ----------------------------------------------------------------------- |
| **Skill Name**     | Yes      | Descriptive name (e.g., "JIRA Ticket Structure Guidelines")             |
| **Description**    | Yes      | Detailed information helping assistant recognize when to use this skill |
| **Instructions**   | Yes      | Step-by-step directions, context, and procedures                        |
| **Project**        | No       | Select target project or leave default                                  |
| **Sharing**        | No       | Control visibility (private, project, marketplace)                      |
| **Required Tools** | No       | Select tools needed for this skill                                      |

**Example:**

```
Skill Name: JIRA Ticket Structure Guidelines

Description:
Use this skill when creating, editing, or reviewing JIRA tickets to ensure
they follow company standards for formatting, completeness, and quality.

Instructions:
# JIRA Ticket Structure

## Title Format
- Use pattern: [TYPE] Brief description
- Types: STORY, BUG, TASK, EPIC
- Keep under 80 characters
- Example: [STORY] Add user authentication

## Description Template
**Problem:**
[What problem are we solving?]

**Solution:**
[How will we solve it?]

**Acceptance Criteria:**
- [ ] Criterion 1
- [ ] Criterion 2

## Labels
Required: component, priority, team
```

### Step 3: Save the Skill

Click **Create Skill** to save.

## Method 2: Import from File

### Supported Format

Skills can be imported from markdown files following the **CLAUDE code-compatible format**.

**Template structure:**

```markdown
# Skill Name

## Description

Detailed description helping assistant recognize when to use this skill.

## Instructions

Step-by-step directions:

1. First step
2. Second step
3. Third step

### Sub-section

Additional context and guidance.
```

### Import Process

1. Click **Create Skill** button
2. Click **Import from File**
3. Click **Select file from your local machine**
4. Choose your `.md` file
5. Review auto-populated fields:
   - Description field
   - Instructions field
6. Adjust if needed
7. Click **Create Skill**

> **Tip:** The import process automatically parses markdown structure and populates the Description and Instructions fields.

## Method 3: Import from GitHub

### Public GitHub Repositories

You can use public GitHub repositories with pre-built skills.

**Popular skill repositories:**

- [Claude Skills](https://github.com/anthropics/skills/tree/main/skills) - Official Anthropic skills collection

**To import from GitHub:**

1. Browse the repository
2. Find the skill file (`.md` format)
3. Download or copy the raw content
4. Use **Import from File** method with the downloaded file

## Result

After creating a skill using any method, it will appear in your **Project Skills** list. Click on the skill to view its details page.

The created skill can now be:

- Attached to assistants
- Edited or exported
- Published to marketplace (if sharing is enabled)
- Used in chat conversations

## Sources

- [Create Skill](https://docs.codemie.ai/user-guide/skills/create-skill)
