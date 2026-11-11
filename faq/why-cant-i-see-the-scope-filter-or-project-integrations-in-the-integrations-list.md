# Why can't I see the Scope filter or Project integrations in the Integrations list?

The **Scope** filter (**All**, **User**, **Project**) and Project integrations are shown only to project admins (the `applications_admin` role in a project) and platform admins (`isAdmin`). Members without these rights see only their own User integrations, and the list behaves as if **Scope: User** is always selected.

Project admins see the Project integrations of the projects they administer. Platform admins see Project integrations of all projects.

To get access to Project integrations, request the `applications_admin` role through a Support ticket.

## Sources

- [Integrations](https://docs.codemie.ai/user-guide/tools_integrations/integrations/#the-integrations-list)
