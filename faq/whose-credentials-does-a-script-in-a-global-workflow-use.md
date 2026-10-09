# Whose credentials does a script in a global workflow use?

It depends on how the tool is set up in the step. With **Automatic Credentials Lookup**, the tool runs with the integration of the user who runs the workflow. With an integration alias selected, the alias is resolved for the author of the workflow in a global workflow, so everyone who runs it acts under the author's integration. In a workflow that is not global, the alias is resolved for the user who runs it.

Saving or validating a global workflow like this shows a notification that lists the tools running under the author's integration. Publishing to the marketplace lists the selected aliases in the credential review, which asks for confirmation.

## Sources

- [Choosing the Tools of a Workflow Step](https://docs.codemie.ai/user-guide/tools_integrations/tools/workspace-script-sdk#how-the-integration-is-chosen)
- [Publish Workflow to Marketplace](https://docs.codemie.ai/user-guide/workflows/marketplace-publishing)
