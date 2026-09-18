# How do I use placeholder variables in a workflow template?

Some workflow templates use placeholder variables to mark values that must be provided before the workflow can run — for example, a project-specific datasource ID or assistant ID. A placeholder uses the syntax `${input:variable_name}` and can appear anywhere in the template's YAML configuration.

When creating a workflow from a template that contains placeholders, a **Configure Template Variables** dialog appears, listing every unique placeholder found in the template. Provide a value for each one and click **Apply** — the values are substituted everywhere the placeholder appears in the template before the workflow create form opens. If the same placeholder name is used multiple times in a template, it is requested only once.

Templates without placeholder variables are unaffected and open the create form directly, as before.

## Sources

- [Create a Workflow from a Template](https://docs.codemie.ai/user-guide/workflows/create-workflow-from-template/)
