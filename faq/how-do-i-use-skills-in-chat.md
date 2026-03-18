# How do I use Skills in chat? How to attach Skills dynamically? How to add Skills to a specific conversation? When should I use dynamic Skills vs permanent Skills? How to remove Skills from chat?

**Dynamic Skill Attachment** allows you to:

- Add skills to specific conversations on-demand
- Use specialized skills only when needed
- Keep assistant configuration simple
- Avoid loading unnecessary skills for every chat

## When to Use Dynamic Skills

**Use dynamic attachment when:**

- ✅ Skill is needed occasionally, not for every conversation
- ✅ Testing a new skill before permanently adding to assistant
- ✅ Different chats need different skill combinations
- ✅ Avoiding cluttering assistant with too many skills

**Use assistant-level attachment when:**

- Skill is needed frequently for most conversations
- Skill is core to assistant's purpose
- All users need the same skill

## Adding Skills in Chat

### Method 1: Configuration Tab

**Step 1: Open Configuration**

1. Start or open a chat with an assistant
2. Click the **Configuration** tab (icon in chat interface)
3. Find the **Skills** section

**Step 2: Add Skill**

1. Click **Add** or **Select Skills**
2. In the **Attach Skills** modal, browse and search for skills:
   - **Project Skills** - Your personal skills
   - **Marketplace Skills** - Community-shared skills
3. Select one or more skills from the list
4. Skills attach to this chat session only

**Step 3: Use the Skill**

The skill is now available for this conversation:

- Loads automatically when relevant
- Provides instructions and guidance
- Inherits required tools (same as assistant-level)

The chat shows loaded skills and connected assistants in the right panel during the conversation.

> **Tip:** Skills attached via Configuration tab persist for the current chat session but don't modify the assistant itself.

### Method 2: Quick Create New Skill

Create and attach a new skill directly from the chat:

**Step 1: Create in Chat**

1. In chat, click **Skills** section
2. Click **Add** button
3. In the popup:
   - **Option A:** Upload instructions file (.md)
   - **Option B:** Enter skill details manually
4. Provide:
   - Skill Name
   - Description
   - Instructions
5. Click **Create**

**Step 2: Attach to Chat**

1. Newly created skill automatically attaches to current chat
2. Click **Save Changes**
3. Skill is now active in this conversation

**Step 3: Use or Save to Project**

The skill:

- Works in this chat immediately
- Is saved to your Project Skills
- Can be reused in other chats or assistants

## Dynamic Loading Behavior

### On-Demand Activation

Skills attached to chat load based on relevance, just like assistant-level skills:

**Example:**

```yaml
Assistant: BA Helper (no skills attached at assistant level)

Chat Configuration:
  Dynamically Attached Skills:
    - JIRA Ticket Structure
    - Find Duplicate Tickets
```

**Conversation:**

```
User: "Create a story for user authentication"

System:
  - Detects request is about creating tickets
  - Loads "JIRA Ticket Structure" skill
  - Applies skill instructions
Assistant (uses JIRA Ticket Structure):
I'll create a story following our ticket structure guidelines...
```

### Scope of Dynamic Skills

Skills attached in chat:

- **Chat-specific** - Apply only to current conversation
- **Not permanent** - Don't modify the assistant's base configuration
- **Other chats unaffected** - Other conversations with same assistant don't have this skill

## Use Cases

### Use Case 1: Occasional Tasks

**Scenario:** Need to check for duplicate tickets, but not every time.

**Solution:** Attach "Find Duplicate Tickets" skill dynamically when needed.

```
Chat 1: General JIRA work
  Skills: (none attached dynamically)

Chat 2: Creating new features
  Skills:
    - Find Duplicate Tickets (attached for this chat only)
```

**Benefit:** Assistant isn't cluttered with skills not needed for most conversations.

### Use Case 2: Testing New Skills

**Scenario:** Created new skill, want to test before adding permanently.

**Solution:** Attach skill to test chat, verify it works.

```
1. Create skill: "Sprint Retrospective Facilitator"
2. Open test chat with BA assistant
3. Attach skill dynamically
4. Test: "Facilitate our sprint retrospective"
5. If works well: add to assistant permanently
6. If needs work: refine skill, test again
```

### Use Case 3: User-Specific Needs

**Scenario:** Different team members need different skills for same assistant.

**Solution:** Each user attaches skills relevant to their workflow.

```
User A (Developer):
  Chat with "Project Helper"
  Attached Skills:
    - Code Review Checklist
    - Git Workflow Guidelines

User B (QA Engineer):
  Chat with "Project Helper"
  Attached Skills:
    - Test Case Templates
    - Bug Report Standards
```

**Benefit:** Same assistant, customized per user without creating multiple assistants.

## Removing Skills from Chat

To detach a dynamically attached skill:

1. Open the **Configuration** tab or Skills panel in chat
2. View the list of attached skills
3. Click **Remove** button to manage skills

The chat shows loaded skills in the right panel, and you can use the **Remove Claude Skills** button to detach them from the current conversation.

**Effects:**

- Skill no longer loads for this conversation
- Inherited tools from skill are removed
- Other chats unaffected
- Assistant's base configuration unchanged

## Best Practices

### When to Use Dynamic vs. Permanent

**Dynamic attachment:**

- ✅ Skill needed occasionally
- ✅ Testing new skills
- ✅ User-specific customization
- ✅ Specialized one-off tasks

**Permanent (assistant-level) attachment:**

- ✅ Skill used in 50%+ of conversations
- ✅ Core to assistant's purpose
- ✅ All users benefit from it

### Keep Chat Configuration Simple

**Good:**

```yaml
Chat Configuration:
  Dynamically Attached Skills:
    - Find Duplicate Tickets (needed for this task)
    - Release Planning (preparing release)
```

**Avoid:**

```yaml
Chat Configuration:
  Dynamically Attached Skills:
    - Skill 1
    - Skill 2
    - Skill 3
    - Skill 4
    - Skill 5
    - Skill 6
# Too many! Consider adding to assistant or creating specialized assistant
```

### Document Custom Configurations

If you regularly use specific skill combinations in chats, document them:

```markdown
# Custom Chat Configurations

## Release Preparation Chat

Skills to attach:
- Release Planning
- Find Duplicate Tickets
- Confluence Documentation

Purpose: Preparing for quarterly releases

## Bug Triage Chat

Skills to attach:
- Bug Report Standards
- JIRA Ticket Structure
- Customer Impact Assessment

Purpose: Weekly bug review meetings
```

## Example: Complete Workflow

### Scenario: Preparing for Release

**Goal:** Use assistant with temporary skills for release preparation.

**Step 1: Start Chat**

1. Open chat with "BA Assistant"
2. Assistant has base skills (JIRA Ticket Structure)

**Step 2: Add Release Skills Dynamically**

1. Open **Configuration** tab
2. Click **Add Skills**
3. Select:
   - Release Planning
   - Find Duplicate Tickets
   - Confluence Documentation
4. Save

**Step 3: Use Enhanced Assistant**

```
User: "Prepare release notes for v2.5"

Assistant (loads Release Planning + Confluence Documentation):
I'll help prepare release notes for v2.5:

1. Gathering tickets from JIRA...
2. Organizing by feature/bug/improvement...
3. Creating Confluence page...
4. Generating release notes...

[Uses Release Planning skill for structure]
[Uses Confluence tool to create page]
[Follows release notes template from skill]
```

**Step 4: Check for Duplicates**

```
User: "Before finalizing, check for duplicate release items"

Assistant (loads Find Duplicate Tickets):
Searching for potential duplicates across sprints...
[Uses JIRA + Elasticsearch tools]
[Follows duplicate detection procedures from skill]
```

**Step 5: Complete and Detach**

After release preparation:

1. Release complete
2. Remove temporary skills from chat configuration
3. Chat returns to base assistant skills

**Result:** Specialized capabilities for specific task without permanently modifying assistant!

###

## Sources

- [Skills In Chat](https://docs.codemie.ai/user-guide/skills/skills-in-chat)
