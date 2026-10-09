# How do I allow a workflow script to call tools such as Jira?

A script in a workflow step calls no tools by default. In the editor, open the Tool node that runs the workspace script tool, click the configure button in the **Tools the script may call** section, select the tools, and click **Apply**. Only tools that can be called from a script are listed.

For a tool that needs credentials, **Automatic Credentials Lookup** makes the script use the integration of the user who runs the workflow. With it off, one or more integration aliases are selected, and the script can use only those. When several aliases are selected, the script passes `integration_alias` with one of them in `call_tool`. A call to a tool that is not selected fails with `tool_unavailable`.

## Sources

- [Choosing the Tools of a Workflow Step](https://docs.codemie.ai/user-guide/tools_integrations/tools/workspace-script-sdk#choosing-the-tools-of-a-workflow-step)
