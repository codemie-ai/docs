# How do I attach Skills to Assistants? How to add Skills to an Assistant? How to attach Skills when creating an Assistant? How to attach Skills from Skill details page? How do Skills load automatically?

When skills are attached to an assistant:

- **Automatic loading** - Skills load when relevant to user requests
- **Tool inheritance** - Assistant automatically gets tools from skills
- **Modular capabilities** - Build assistants from focused skill sets
- **Consistent behavior** - All assistants using same skill behave consistently

## Method 1: From Assistant Page

You can attach skills when creating a new assistant or editing an existing one.

**Step 1: Open Assistant Configuration**

- **For new assistant:** Navigate to **Assistants** → **Create Assistant**
- **For existing assistant:** Navigate to **Assistants** → Select assistant → **Edit**

**Step 2: Select Skills**

1. Find the **Skills** section in the assistant configuration
2. Click **Add** or select from dropdown
3. Select one or more skills from the list
4. Click **Save** or **Create Assistant**

The assistant now has the selected skills attached. You can view attached skills in the assistant details.

## Method 2: From Skill Details Page

Attach a skill to multiple assistants directly from the Skill Details page.

**Step 1: Open Skill Details**

1. Navigate to **Skills** → **Project Skills**
2. Click on a skill to open details page

**Step 2: Attach to Assistants**

1. Scroll to **Attach to Assistants** section
2. Select assistants from the dropdown
3. Click on assistants to attach the skill

The skill is now attached to the selected assistants.

## Method 3: Attach Skills in Chat

Dynamically attach skills to a specific conversation without modifying the assistant.

**Step 1: Open Chat**

Start or open an existing chat with an assistant.

**Step 2: Attach Skills**

1. Click the **Skills** button (bottom toolbar)
2. In the **Attach Skills** modal:
   - Browse your **Project Skills**
   - Or explore **Marketplace Skills**
   - Select one or more skills to add
3. Click **Confirm**

The selected skills are now active for this chat session only.

## Skill Loading Behavior

### Automatic Loading Based on Relevance

Skills are triggered automatically when they're relevant to the user's request.

**Example:**

```yaml
Assistant: BA Helper
Skills:
  - JIRA Ticket Structure
  - Find Duplicate Tickets
  - Release Planning
```

**User asks:** "Create a draft story for the new feature"

**System behavior:**

1. Detects request involves creating a ticket
2. Loads `JIRA Ticket Structure` skill
3. Applies skill instructions
4. Uses JIRA tool (inherited from skill)

**User asks:** "Find existing tickets about login issues"

**System behavior:**

1. Detects request is about finding duplicates
2. Loads `Find Duplicate Tickets` skill
3. Uses JIRA + Elasticsearch tools
4. Follows skill search procedures

> **Tip:** Skills are loaded on-demand based on your query and the skill's description. The assistant automatically determines which skills are relevant.

### How Relevance is Determined

The assistant uses skill **descriptions** to determine relevance:

**Skill Description:**

```
Skill: JIRA Ticket Structure
Description:
Use this skill when creating, editing, or reviewing JIRA tickets
to ensure they follow company standards for formatting, completeness,
and quality.
```

**Relevant queries:**

- ✅ "Create a story for user authentication"
- ✅ "Review this ticket draft"
- ✅ "Format this as a JIRA bug"

**Not relevant:**

- ❌ "What's the weather today?"
- ❌ "Summarize this document"

> **Tip:** Write clear, specific skill descriptions to ensure correct automatic loading.

## Working with Multiple Skills

### Composing Assistant Capabilities

Build powerful assistants by combining focused skills:

**Example: Business Analyst Assistant**

```yaml
Assistant: BA Pro
System Prompt: You are a senior business analyst assistant.

Skills:
  - JIRA Ticket Structure # Loads when creating tickets
  - Find Duplicate Tickets # Loads when searching
  - Release Planning # Loads for releases
  - Sprint Management # Loads for sprint work
  - Stakeholder Communication # Loads for updates

Inherited Tools:
  - JIRA (from multiple skills)
  - Confluence (from Release Planning, Sprint Management)
  - Elasticsearch (from Find Duplicate Tickets)
  - Slack (from Stakeholder Communication)
```

**Benefits:**

- **Specialized knowledge** - Each skill handles specific tasks
- **Automatic context** - Right instructions load at right time
- **Simplified maintenance** - Update one skill, affects all assistants
- **Reduced token usage** - Only relevant skills load

### Skill Priority and Conflicts

If multiple skills apply to the same query:

- **All relevant skills load** - The assistant can use instructions from multiple skills
- **No conflicts** - Skills are additive, not exclusive
- **Clear separation** - Design skills with distinct purposes to minimize overlap

**Example:**

```
User: "Create a ticket and check for duplicates"

System loads:
  - JIRA Ticket Structure (for creation)
  - Find Duplicate Tickets (for search)

Both skills apply simultaneously.
```

## Removing Skills from Assistants

To remove a skill from an assistant:

1. Navigate to **Assistants**
2. Edit the assistant
3. Find the **Skills** section
4. Click **X** or **Remove** next to the skill
5. Click **Save Changes**

**Effects:**

- Skill is removed from assistant
- Skill instructions no longer available
- Inherited tools from that skill are removed (unless manually added or from other skills)
- Other assistants using the skill are unaffected

## Sources

- [Attach Skills To Assistants](https://docs.codemie.ai/user-guide/skills/attach-skills-to-assistants)
