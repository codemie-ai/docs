# How do I move an assistant to another project? Can I transfer an assistant between projects?

Yes, you can move an assistant from one project to another by changing its project assignment:

1. Navigate to **Assistants** → **Project Assistants**
2. Click the **Actions** button (⋮) next to the assistant and select **Edit**
3. Change the **Project** dropdown to the desired target project
4. Click **Save**

The assistant moves to the new project immediately. All configuration (system instructions, tools, skills, and settings) is preserved.

**Important considerations:**

- You can only move an assistant to a project you have access to
- Any attached data sources that do not exist in the target project are automatically removed from the assistant's configuration. Verify the assistant's data source assignments after the move
- Integrations are not transferred between projects regardless of their level (project or user). If the assistant relied on integrations (e.g., Jira, Confluence, Git), you will need to recreate them in the target project

## Sources

- [Assistants Overview](https://docs.codemie.ai/user-guide/assistants/)
- [Edit Assistants](https://docs.codemie.ai/user-guide/assistants/edit-assistants)
