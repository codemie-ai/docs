# How do I move a data source to another project? Can I transfer a data source between projects?

Yes, you can move a data source from one project to another by changing its project assignment:

1. Navigate to the **Data Sources** section
2. Click the **Actions** button (⋮) next to the data source and select **Edit**
3. Change the **Project** field to the desired target project
4. Click **Save**

The data source moves to the new project along with all its indexed content. The data source name must be unique within the target project.

**Important considerations:**

- You can only move a data source to a project you have access to
- After moving a data source, any assistants in the original project that referenced it will lose access. You may need to update assistant configurations in the original project or move the related assistants to the same target project
- Integrations are not transferred between projects regardless of their level (project or user). If the data source relied on integrations (e.g., Git, Confluence, Jira connections), you will need to recreate them in the target project

## Sources

- [Data Source Overview](https://docs.codemie.ai/user-guide/data-source/data-source-overview/)
