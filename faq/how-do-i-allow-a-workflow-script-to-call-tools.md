# How do I allow a workflow script to call tools such as Jira?

A script in a workflow step calls no tools by default. In the editor, open the Tool node that runs the workspace script tool, open the tool selection in the **Tools the script may call** section, and select the tools, the same way as for a Tool node or an assistant. Several tools can be selected. Only tools that can be called from a script are listed.

For a tool that needs credentials, **Automatic Credentials Lookup** makes the script use the integration of the user who runs the workflow. With it off, one integration is selected, and the script always uses it. The script cannot choose an integration itself. A call to a tool that is not selected fails with `tool_unavailable`.

## Sources

- [Choosing the Tools of a Workflow Step](https://docs.codemie.ai/user-guide/tools_integrations/tools/workspace-script-sdk#choosing-the-tools-of-a-workflow-step)
