# How are attached files accessible in workflow steps?

When you attach files to a workflow execution in chat mode, each step in the workflow receives
the files in two ways:

1. **Task description**: Each attached file is appended to the task description as
   `File attached: filename.ext`, so the AI assistant in that step is aware of all files.

2. **Context variable**: The full list of file names is available as `{{file_names}}` in the
   context store. You can reference this in YAML task templates or tool arguments:

```yaml
states:
  - id: process-files
    assistant_id: analyzer
    task: |
      Analyze the following files: {{file_names}}
      Provide a summary for each file.
```

Files are included in every step automatically — no additional YAML configuration is required.

## Sources

- [Workflows Overview — Attaching Files in Chat Mode](https://docs.codemie.ai/user-guide/workflows/workflows-overview#attaching-files-in-chat-mode)
