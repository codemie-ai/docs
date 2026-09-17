# How do I set up the MS Teams Bot integration in CodeMie?

Setup has two sides. First, the CodeMie Bot app is installed in Microsoft Teams — either added from the organization's app catalog if an admin has published it, or sideloaded from a `.zip` package for evaluation or self-hosted deployments. Second, an **MS Teams Bot** integration is created in CodeMie (**Integrations → User** or **Project → + Create**, Credential Type **MS Teams Bot**) that selects which assistants are exposed to the bot.

Once both are in place, running `/setup` inside the Teams personal chat, group chat, or channel shows the assistants exposed by that integration and registers one (or lets a default be chosen among several). A User integration only exposes assistants to the user who created it in a personal chat; a Project integration (requires the `isAdmin` or `applications_admin` role) exposes assistants to any group chat or channel where `/setup` is run.

## Sources

- [MS Teams Bot Integration](https://docs.codemie.ai/user-guide/ms-teams-bot/integration/)
- [Microsoft Teams Bot](https://docs.codemie.ai/user-guide/ms-teams-bot/)
