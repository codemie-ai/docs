# How do I share an assistant with specific users in CodeMie?

An assistant owner can grant access to selected internal CodeMie users without sharing the assistant with the whole project. This is independent of the **Shared with Project** option.

1. Navigate to **Assistants** → **Project Assistants**.
2. Click the **Actions** button (⋮) next to the assistant and select **Share**.
3. In the **Share assistant** dialog, search for users by name or email, select them, and click **Save**.

Recipients can find the assistant under their personal project, chat with it, and view its configuration, but cannot edit or re-share it. To revoke access, open the same dialog and click **Remove** next to the user. Access is removed immediately.

The **Share** action is available only when the platform runs in platform-managed mode (`ENABLE_USER_MANAGEMENT=True`), and assistants that use personal integrations cannot be shared this way.

## Sources

- [Share Assistants](https://docs.codemie.ai/user-guide/assistants/sharing-assistants)
