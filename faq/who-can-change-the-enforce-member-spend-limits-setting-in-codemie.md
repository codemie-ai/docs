# Who can change the Enforce member spend limits setting in CodeMie?

When budget management is enabled, the **Enforce member spend limits** toggle in **Edit Project** is available to:

- **Project Admins**, for the projects they administer
- **Admins**, for any project
- **Maintainers**, for any project

Other users do not see the toggle, and a direct attempt to change it through the API is rejected with a permission error. Project Admins still cannot create, delete, or change the total of a project budget — those actions remain Maintainer-only.

Every change to the toggle requires confirmation and is recorded in the audit log together with the user who made it.

## Sources

- [Project Budgets](https://docs.codemie.ai/user-guide/budget-management/project-budgets)
- [Budget Management](https://docs.codemie.ai/user-guide/budget-management/)
