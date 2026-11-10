# Which project budget is charged when I use a Marketplace assistant?

It depends on whether the user is a member of the project that owns the assistant:

- **Member of the assistant's project** — the assistant's project is charged, even if the user
  has a different default project.
- **Not a member** — the user's default project is charged. If no default project is set by an
  administrator, the user's personal project is used.

If the charged project has no budget that covers the request, the user's personal or default
budget is charged instead, and the request is marked as a budget fallback in usage analytics.

The same default-project rule applies to other usage that is not tied to a specific project, such
as AI generation of assistants, skills, and workflows, and CLI requests sent without a configured
project. Assistants, workflows, and data sources that belong to a project always charge their
own project.

## Sources

- [Budget Management — Default Project](https://codemie-ai.github.io/docs/user-guide/budget-management#default-project)
- [Users Management — Default Project](https://codemie-ai.github.io/docs/user-guide/project-user-management/users#default-project)
