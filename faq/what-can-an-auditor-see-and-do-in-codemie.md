# What can an Auditor see and do in CodeMie?

The Auditor flag grants read-only, platform-wide visibility without any write access.

**What an Auditor can see:**

| Section   | Access                                                                                                        |
| --------- | ------------------------------------------------------------------------------------------------------------- |
| Analytics | All tabs (Insights, CLI Insights, AI/Run Adoption, Leaderboard), all users and projects, full Summary Metrics |
| Projects  | All platform projects with spending data                                                                      |
| Users     | All users with full details and per-user budget spend                                                         |
| Budgets   | All global and project budgets with current spend                                                             |

**What an Auditor cannot do:**

All write actions are denied — create, edit, delete, deactivate, assign, sync. Controls are
hidden in the UI; direct API calls return 403.

**Settings sidebar:** Projects Management, Users Management, and Budgets Management are
visible. Activity Events and enterprise admin items (AI/Run Adoption admin, Categories,
MCPs, Providers) are not visible.

The Auditor flag is additive: it can be set on any user regardless of their base role.
When combined with Admin or Maintainer, the base role takes full precedence and the Auditor
flag has no additional effect.

## Sources

- [Auditor Flag](https://docs.codemie.ai/admin/security/roles-rbac#auditor-flag)
- [Roles & RBAC](https://docs.codemie.ai/admin/security/roles-rbac)
