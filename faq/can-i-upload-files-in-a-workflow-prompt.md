# Can I upload files in a workflow prompt? How to use file as prompt?

Yes. File upload is supported when running a workflow in **chat mode** (via the **Start Chat** button).
You can attach up to **10 files** per execution.

## Supported File Types and Limits

| Parameter     | Value                               |
| ------------- | ----------------------------------- |
| Max files     | 10 per execution                    |
| Max file size | 100 MB per file                     |
| File formats  | CSV, PDF, JPEG, JPG, PNG, GIF, PPTX |

## How to Attach Files to a Workflow in Chat Mode

1. Open the workflow and click **Start Chat**.
2. In the chat input area, click the **paperclip** icon to open a file picker, or drag and drop files into the window.
3. Each file appears as a chip — you can preview, download, or remove it before sending.
4. Send your message to start the workflow execution.

All attached files are included in the context of every workflow step.

## How to Configure File Input in YAML

To design a workflow that explicitly waits for file input from the user, configure a state with
`interrupt_before: true`. This pauses execution before the state runs, allowing the user to
provide files and additional input:

```yaml
states:
  - id: await-files
    assistant_id: file-processor
    interrupt_before: true
    task: |
      Process the attached files.
      Files: {{file_names}}
```

## Sources

- [Workflows Overview — Attaching Files in Chat Mode](https://docs.codemie.ai/user-guide/workflows/workflows-overview#attaching-files-in-chat-mode)
- [Advanced Features — Workflow Interruption](https://docs.codemie.ai/user-guide/workflows/configuration/advanced-features)
