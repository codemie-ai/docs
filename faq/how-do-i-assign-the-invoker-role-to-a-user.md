# How do I assign the Invoker role to a user?

Open **Profile → Settings → Administration → Users management**, open the **User Details** panel for the user, and turn on the **Invoker** switch. The change is saved immediately and the user gets the restricted, chat-first interface on their next page load.

Invoker is mutually exclusive with Admin, Maintainer, Auditor, and Project Admin: turning it on clears the Admin, Maintainer, and Auditor switches, and it is rejected while the user is a Project Admin in any project. The role also requires activity events (`ACTIVITY_EVENTS_ENABLED=True`) to be enabled on the platform; otherwise the switch is rejected with **Invoker role unavailable**. Users Management itself is available only in Platform-managed mode.

## Sources

- [Users Management](https://docs.codemie.ai/user-guide/project-user-management/users/)
- [Invoker Role](https://docs.codemie.ai/user-guide/project-user-management/invoker-role/)
