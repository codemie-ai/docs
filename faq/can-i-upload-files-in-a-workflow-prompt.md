# Can I upload files in a workflow prompt? How to use file as prompt?

## Supported File Types and Limitations

The following file formats are supported for workflow uploads:

- Images: jpeg, png, jpg, gif
- Documents: pdf, pptx
- Data: csv
- Maximum file size: 50MB

## How to Configure File Uploads in Workflows

1. Create a workflow with a user prompt step that requires file input
2. Configure the state with `interrupt_before: true`
3. In the task description, specify that file upload is expected
4. Add appropriate handling for the uploaded file in subsequent states

How to use file as prompt

1. Open Workflow
2. Click 'Execute' button
3. Click 'Attach File' button
4. Choose file
5. Execute

## Sources

- [Workflow Advanced Features](https://docs.codemie.ai/user-guide/workflows/configuration/advanced-features)
