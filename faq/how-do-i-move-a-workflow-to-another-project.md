# How do I move a workflow to another project? Can I transfer a workflow between projects?

Yes, you can move a workflow from one project to another by changing its project assignment:

1. Open the workflow for editing (click **Edit** from the workflow card actions menu)
2. Open **Workflow Config** → **Basic** tab
3. Change the **Project name** dropdown to the desired target project
4. Click **Save**

The workflow moves to the new project immediately. All configuration (states, transitions, and settings) is preserved.

**Important considerations:**

- You can only move a workflow to a project you have access to
- Integrations are not transferred between projects regardless of their level (project or user). If the workflow used integrations (e.g., Jira, Confluence, Git), you will need to recreate them in the target project

## Sources

- [Workflows Overview](https://docs.codemie.ai/user-guide/workflows/workflows-overview)
- [Create Workflow](https://docs.codemie.ai/user-guide/workflows/create-workflow)
