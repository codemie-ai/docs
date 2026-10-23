# Why can't I publish my assistant to the Marketplace? What do "Assistant Quality Validation Failed" and "Assistant Verification Failed" mean?

Publishing runs two validation steps, and each opens its own dialog.

1. **Deterministic checks** cover the name, description, system prompt, categories, tools or other substance, and inline credentials. If a check fails, the **Assistant Verification Failed** dialog lists the findings with recommendations. **CRITICAL** findings block submission and must be fixed first. **OPTIONAL** findings are recommendations and do not block submission. The dialog offers **Edit assistant** and **Cancel**. When saving changes to an assistant that is already in the Marketplace, it offers **Keep editing**, **Save and remove** (assistant in review), or **Save & Unpublish** (published assistant).
2. **AI quality check** runs after the deterministic checks pass. Its recommendations appear in the **Assistant Quality Validation Failed** dialog. Click **Manual Edit** to apply the suggestions, or **Publish Anyway** to continue without them. **Publish Anyway** is available to every user, but it skips only the AI check.

Platform administrators and maintainers can additionally override CRITICAL findings from the **Assistant Verification Failed** dialog: click **Force-Publish**, enter a justification of at least 20 characters in the field that appears, and click **Confirm Force-Publish**.

## Sources

- [Publish to Marketplace](https://docs.codemie.ai/user-guide/assistants/marketplace-publishing)
