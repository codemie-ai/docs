# How do I publish a workflow to the Marketplace?

To publish a workflow to the Workflow Marketplace, open the workflow and click **Publish to Marketplace** from the actions menu or the workflow details page.

Before publishing, the system validates the workflow:

- Workflows that reference any external assistants or skills **cannot be published**. Those references must be removed first.
- Workflows with inline credentials (MCP environment variables or integration aliases) trigger a warning. Explicit confirmation is required to proceed.

After validation, select 1 to 3 categories to help users discover the workflow, then confirm to publish. The workflow becomes globally visible and executable by any authenticated user immediately.

Published workflows can be unpublished at any time by selecting **Remove from Marketplace** from the actions menu. Deleting a workflow also removes it from the Marketplace automatically.

## Sources

- [Publish Workflow to Marketplace](https://codemie-ai.github.io/docs/user-guide/workflows/marketplace-publishing)
