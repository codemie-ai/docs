# How do I edit Skills? How to update a Skill? How to export Skills? How to delete a Skill? How to manage Skills?

## Viewing Skills

### Project Skills

1. Navigate to **Skills** in the left panel
2. Select **Project Skills** tab
3. View all skills in your current project

**Skills list shows:**

- Skill name
- Description preview
- Creation date
- Last modified date
- Sharing status (private, project, marketplace)

### Marketplace Skills

1. Navigate to **Skills** → **Marketplace** tab
2. Browse public skills shared by the community
3. Filter by category or search by name

## Editing Skills

### Edit Skill Content

1. Navigate to **Skills** → **Project Skills**
2. Find the skill to edit
3. Click the **three dots menu** (⋮)
4. Select **Edit**

On the edit page, you can modify:

- **Name** - Update skill title
- **Description** - Refine when-to-use guidance
- **Instructions** - Update step-by-step directions
- **Required Tools** - Add or remove tools
- **Project** - Change project assignment
- **Sharing** - Update visibility settings

## 5. Click **Save Changes**

> **Tip:** When you update a skill, all assistants using that skill immediately inherit the changes.

### Update Required Tools

To change tools for a skill:

1. Edit the skill
2. Scroll to **Tools** section
3. Add or remove tools from the list
4. Save changes

**Effect on assistants:**

- Assistants using this skill will inherit the updated tool list
- Newly added tools become available to those assistants
- Removed tools are no longer inherited (unless manually added to assistant)

## Exporting Skills

### Export to Markdown

Skills can be exported in markdown format for:

- Backup and version control
- Sharing with team members
- Documentation purposes
- Importing into other projects

**Export steps:**

1. Navigate to **Skills** → **Project Skills**
2. Find the skill
3. Click **three dots menu** (⋮)
4. Select **Export**
5. Choose format: **Markdown (.md)**
6. File downloads to your local machine

**Exported file structure:**

```markdown
# Skill Name

## Description

Detailed description of when to use this skill.

## Instructions

Step-by-step directions and procedures.

## Required Tools

- JIRA
- Confluence

## Metadata

- Created: 2024-03-01
- Modified: 2024-03-02
- Project: My Project
```

### Use Cases for Export

**Version Control:**

```bash
# Store skills in Git
git clone your-skills-repo
cd skills/
# Export skill
# Save to repository
git add jira-ticket-structure.md
git commit -m "Update JIRA ticket skill"
git push
```

**Team Sharing:**

- Export skill as `.md` file
- Send to team members
- They import into their projects

**Documentation:**

- Export all skills
- Include in project documentation
- Share with stakeholders

## Deleting Skills

### Delete a Skill

> **Warning:** Deleting a skill is permanent and cannot be undone.

1. Navigate to **Skills** → **Project Skills**
2. Find the skill
3. Click **three dots menu** (⋮)
4. Select **Delete**
5. Confirm deletion in the popup

**Effects:**

- Skill is permanently removed
- Assistants using this skill lose access
- Skill is removed from all assistants
- Inherited tools may be removed from assistants (if not manually added)

> **Tip:** Check which assistants are using the skill before deleting. Consider exporting the skill first as a backup.

### Check Skill Usage

Before deleting, verify where the skill is used:

1. Note the skill name
2. Navigate to **Assistants**
3. Search or filter assistants
4. Check Skills section of each assistant
5. Update assistants if needed before deletion

## Organizing Skills

### Project Assignment

Skills belong to projects. To move a skill to another project:

1. Edit the skill
2. Change **Project** dropdown
3. Save changes

The skill moves to the new project and becomes available to assistants in that project.

### Naming Conventions

**Best practices:**

- Use clear, descriptive names
- Include domain or tool: `JIRA Ticket Structure`, `AWS Cost Analysis`
- Indicate purpose: `Find Duplicate Tickets`, `Release Planning`

**Good names:**

- ✅ `JIRA Ticket Formatting Guidelines`
- ✅ `Kubernetes Deployment Checklist`
- ✅ `Customer Support Response Templates`

**Poor names:**

- ❌ `Skill 1`
- ❌ `Helper`
- ❌ `Instructions`

### Categorization

While the current version doesn't have explicit categories in Project Skills, you can use naming prefixes:

```
[JIRA] Ticket Structure
[JIRA] Find Duplicates
[JIRA] Release Planning

[AWS] Infrastructure Audit
[AWS] Cost Optimization

[Support] Customer Communication
[Support] Escalation Procedures
```

## Sharing and Publishing

### Sharing Settings

Control who can see and use your skill:

| Setting         | Visibility                 |
| --------------- | -------------------------- |
| **Private**     | Only you                   |
| **Project**     | All members of the project |
| **Marketplace** | Public - all CodeMie users |

To update sharing:

1. Edit the skill
2. Change **Sharing** dropdown
3. Save changes

## Cloning Skills

To create a copy of an existing skill:

1. **Export** the skill to markdown
2. Create a **new skill**
3. **Import** the exported markdown file
4. Modify as needed
5. Save with a new name

**Use cases:**

- Create variations of a skill
- Customize marketplace skills for your project
- Test changes without affecting the original

## Troubleshooting

### Skill Not Appearing in Assistant

**Problem:** After creating/editing a skill, it doesn't show in assistant's skill dropdown.

**Solutions:**

1. Verify skill is in the same project as the assistant
2. Check sharing settings - must be project-level or higher
3. Refresh the page
4. Verify skill was saved successfully

### Changes Not Reflected in Assistant

**Problem:** Updated skill but assistant still uses old version.

**Solutions:**

1. Verify changes were saved
2. Refresh assistant page
3. Re-attach skill to assistant:
   - Remove skill from assistant
   - Save
   - Re-add skill
   - Save again

### Cannot Delete Skill

**Problem:** Delete option is greyed out or fails.

**Solutions:**

1. Check permissions - you must be skill owner or admin
2. Remove skill from all assistants first
3. Contact admin if skill is marketplace-published

## Sources

- [Manage Skills](https://docs.codemie.ai/user-guide/skills/manage-skills)
- [Marketplace Skills](https://docs.codemie.ai/user-guide/skills/marketplace-skills)
