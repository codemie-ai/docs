# Why can't I publish my assistant to the Marketplace? What do "Assistant Quality Validation Failed" and "Assistant Verification Failed" mean?

Before an assistant is sent for review, the system checks its name, description, system instructions, categories, and similarity to assistants already in the Marketplace. If any check fails, the **Assistant Verification Failed** dialog lists the findings with recommendations:

- **CRITICAL** findings block submission and must be fixed first.
- **OPTIONAL** findings are recommendations and do not block submission.

When publishing, the findings appear in the **Assistant Quality Validation Failed** dialog: click **Manual Edit** to apply the suggested changes. When saving changes to an assistant that is already in the Marketplace, the **Assistant Verification Failed** dialog appears instead: click **Keep editing** to fix the issues, or save the changes and take the assistant out of the Marketplace with **Save and remove** (assistant in review) or **Save & Unpublish** (published assistant).

Platform administrators and maintainers can additionally bypass CRITICAL findings with **Publish Anyway** or **Confirm Force-Publish** (with a justification of at least 20 characters).

## Sources

- [Publish to Marketplace](https://docs.codemie.ai/user-guide/assistants/marketplace-publishing)
