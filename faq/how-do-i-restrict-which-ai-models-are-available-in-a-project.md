# How do I restrict which AI models are available in a project?

Enable the `features:projectModelOverride` flag in `customer-config.yaml` (it is off by default).
Once enabled, a **Models** tab appears on the project detail page for Project Admins and Platform
Admins.

From the **Models** tab:

1. Deselect any models the project should not use.
2. Choose a **Project default model** from the remaining enabled models.
3. Click **Apply changes**.

Only the deselected models are restricted — every model the platform offers is available by
default, and any model newly added to the platform catalog becomes available to all projects
automatically without re-opening settings.

At least one chat model must remain enabled; the save is rejected otherwise.

When [LiteLLM Proxy](https://docs.codemie.ai/admin/deployment/extensions/litellm-proxy/) is
deployed, the restriction is also enforced at the API level on the next request — no restart or
redeploy is needed.

## Sources

- [Model Configuration](https://docs.codemie.ai/user-guide/project-user-management/projects#model-configuration)
- [Customer Feature Configuration](https://docs.codemie.ai/admin/configuration/codemie/customer-feature-configuration#project-model-override)
