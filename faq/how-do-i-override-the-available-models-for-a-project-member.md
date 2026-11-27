# How do I override the available models for a project member?

Open **Settings → Administration → Projects management**, select the project, and switch to the
**Members** tab. Click the **⋮ (Actions)** menu on the member's row and select **Override models**.
In the **Model Override** dialog, enable or disable models with the checkboxes, select the member's
default model, and click **Apply changes**.

The override applies only to that member within the project and takes precedence over the project's
model configuration: it can add models that the project does not offer or remove models that the
rest of the project can use. Models disabled at the platform level cannot be enabled by an
override.

The action is available to **Platform Admins** and **Project Admins**, and only when the
`features:userModelOverride` flag is enabled.

## Sources

- [Override Models for a Member](https://docs.codemie.ai/user-guide/project-user-management/projects#override-models-for-a-member)
