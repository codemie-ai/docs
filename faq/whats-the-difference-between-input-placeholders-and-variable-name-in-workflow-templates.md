# What's the difference between `${input:...}` placeholders and `{{variable_name}}` in workflow templates?

These are two distinct mechanisms that operate at different times:

- **`${input:variable_name}`** is a template placeholder. It is resolved once, when a workflow is created from a template — a dialog collects the values and substitutes them into the template's YAML configuration before the workflow is created.
- **`{{variable_name}}`** is the workflow's runtime variable syntax, resolved during workflow execution — for example, to reference the Context Store or a previous state's output.

A template can use both: `${input:...}` for values that need to be filled in once at creation time, and `{{variable_name}}` for values that are computed while the workflow runs.

## Sources

- [Create a Workflow from a Template](https://docs.codemie.ai/user-guide/workflows/create-workflow-from-template/)
- [Workflow Configuration Introduction](https://docs.codemie.ai/user-guide/workflows/configuration/introduction/)
