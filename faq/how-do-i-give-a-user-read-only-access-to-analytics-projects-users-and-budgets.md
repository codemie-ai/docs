# How do I give a user read-only access to Analytics, Projects, Users, and Budgets?

Enable the **Auditor** flag on the user account. Auditors have read-only, platform-wide
visibility across all four sections — Analytics (all tabs with cross-user filtering),
Projects, Users, and Budgets — without any write access or admin privileges.

To enable it:

1. Go to **Settings → Administration → Users Management**.
2. Open the target user.
3. In the **Platform Roles** block, toggle the **Auditor** switch on and click **Save**.

The Auditor flag can be assigned by Platform Admins and Maintainers. It is off by default
and cannot be self-assigned.

## Sources

- [Auditor Flag](https://docs.codemie.ai/admin/security/roles-rbac#auditor-flag)
- [Users Management — Platform Roles](https://docs.codemie.ai/user-guide/project-user-management/users#platform-roles)
