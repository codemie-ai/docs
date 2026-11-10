# How do I set a default project for a user?

Platform Admins and Maintainers set a user's default project in **Users Management**:

1. Click the **Profile** icon in the bottom-left corner → **Settings → Administration → Users management**.
2. Open the user's **User Details** panel (click the user's email or **⋮ → View details**).
3. In the **Projects** table, select the radio button in the **Default** column next to the
   project that should become the default.

The change is saved immediately. A project can also be made the default while adding it to the
user: turn on **Set as default** in the **Add Project** dialog.

A user has exactly one default project, and it must be one of the user's own projects. If no
default is set, the user's personal project is used, or the first of the user's projects by name
if the user has no personal project. Auditors can see the default project but cannot change it;
Project Admins and regular users cannot set it.

The default project decides which project budget is charged for usage that is not tied to a
specific project, such as Marketplace assistants used by non-members or CLI requests without a
configured project.

## Sources

- [Users Management — Default Project](https://codemie-ai.github.io/docs/user-guide/project-user-management/users#default-project)
- [Budget Management — Default Project](https://codemie-ai.github.io/docs/user-guide/budget-management#default-project)
