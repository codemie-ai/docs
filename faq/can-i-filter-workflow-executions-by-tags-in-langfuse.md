# Can I filter workflow executions by tags in Langfuse?

Yes. Once a workflow execution completes, its tags appear in the Langfuse UI under **Traces**. Use the **Tags** filter to find executions by one or more tags — only traces that carry all specified tags are returned.

Tags must be passed at execution time via the API `tags` field or the SDK `tags` parameter. They cannot be added to an execution after it has started.

## Sources

- [Execute Workflow](https://codemie-ai.github.io/docs/user-guide/api/#execute-workflow)
