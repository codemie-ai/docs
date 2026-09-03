---
id: roles-rbac
title: CodeMie Roles Overview
sidebar_label: Roles & RBAC
sidebar_position: 2
pagination_prev: admin/security/index
pagination_next: null
---

# CodeMie Roles Overview

A role-based access control model built on top of Keycloak is used in CodeMie.
The platform roles and their mapping to Keycloak realm roles and user attributes are described on this page.

In addition to the standard roles, the **Auditor** flag is a boolean attribute on the user account that grants read-only, platform-wide visibility across Analytics, Projects, Users, and Budgets. It is not a separate platform role and can coexist with any base role.

## Roles in CodeMie

Five role levels are defined in CodeMie:

1. **Maintainer**
2. **Admin**
3. **Project Admin**
4. **Regular User**
5. **External User**

The [**Auditor flag**](#auditor-flag) is a separate boolean attribute that can be set on any user account independently of their base role.

## How Keycloak Access Is Interpreted

### Realm Roles

- Platform-level **Admin** rights in CodeMie are granted by the `admin` realm role in Keycloak.
- Elevated admin rights are not granted by the `developer` realm role by itself.
  It is treated as a standard user role unless additional Project Admin access is explicitly assigned.

### Project Attributes

| Keycloak Attribute   | Effect in CodeMie                                   |
| -------------------- | --------------------------------------------------- |
| `applications`       | Projects where the user is a regular project member |
| `applications_admin` | Projects where the user is a Project Admin          |

**Attribute resolution rules:**

- If a project is present in **both** attributes, the user is treated as **Project Admin** for that project.
- If a project is present **only** in `applications_admin`, Project Admin access is still granted.

:::tip Note on Access Timing

- In deployments where user management is enabled inside CodeMie, project access and admin status
  are read from identity data at first sign-in and then managed within CodeMie.
- In deployments where user management is **not** enabled in CodeMie, platform admin status
  is resolved directly from the identity provider settings on each authentication.
  :::

## Role Descriptions

| Capability / Scope                                       | Maintainer                                                        | Admin                                   | Project Admin                                                | Regular User                             | External User                                          | Auditor                                                          |
| -------------------------------------------------------- | ----------------------------------------------------------------- | --------------------------------------- | ------------------------------------------------------------ | ---------------------------------------- | ------------------------------------------------------ | ---------------------------------------------------------------- |
| Role level                                               | Highest operational role                                          | Platform-wide administrative role       | Project-scoped administrative role                           | Standard user role                       | Special user type for guest/external scenarios         | Additive boolean flag (not a standalone role)                    |
| Platform-wide admin access                               | ✅                                                                | ✅                                      | ❌                                                           | ❌                                       | ❌                                                     | ❌                                                               |
| Manage users and access assignments across the platform  | ✅                                                                | ✅                                      | ❌                                                           | ❌                                       | ❌                                                     | ❌                                                               |
| Manage key platform settings and operational views       | ✅                                                                | ✅                                      | ❌                                                           | ❌                                       | ❌                                                     | ❌                                                               |
| Manage budget and billing controls                       | ✅ (exclusive)                                                    | ❌                                      | ❌                                                           | ❌                                       | ❌                                                     | ❌                                                               |
| Manage members and project-level access                  | ✅                                                                | ✅                                      | ✅ (managed projects only)                                   | ❌                                       | ❌                                                     | ❌                                                               |
| View all users, projects, and budgets platform-wide      | ✅                                                                | ✅                                      | ❌                                                           | ❌                                       | ❌                                                     | ✅ (read-only)                                                   |
| View project-level analytics (including spending trends) | ✅                                                                | ✅                                      | ✅ (managed projects only)                                   | ❌                                       | ❌                                                     | ✅ (all projects)                                                |
| View own usage and spending analytics                    | ✅                                                                | ✅                                      | ✅                                                           | ✅                                       | ✅ (where access is allowed)                           | ✅                                                               |
| Access scope                                             | Platform-wide                                                     | Platform-wide                           | Assigned projects only                                       | Assigned projects and knowledge sources  | Regular-user scope with stricter limits where required | Platform-wide (read-only)                                        |
| Assignment model                                         | Assigned in CodeMie directly (not a separate Keycloak realm role) | Granted via Keycloak `admin` realm role | Derived from project attributes such as `applications_admin` | Derived from standard access assignments | Determined by external/guest user classification       | Toggle in User Details → Platform Roles (admins and maintainers) |

## Role Hierarchy

```
Maintainer ──► Admin ──► Project Admin ──► Regular User
    │               │
    │               └── Full platform access
    └── Budget/billing management (exclusive)

Auditor ──── Additive flag; grants read-only platform-wide access to Analytics,
              Projects, Users, and Budgets, regardless of base role.
              Combined with Admin or Maintainer: base role takes full precedence.
```

## Auditor Flag

The `is_auditor` flag is a boolean attribute stored on the user record alongside `is_admin`
and `is_maintainer`. It is not a new `PlatformRole` enum value — the platform role set is
unchanged.

### What the Auditor flag grants

| Section              | Auditor access                                                                                                   |
| -------------------- | ---------------------------------------------------------------------------------------------------------------- |
| **Analytics**        | All tabs (Insights, CLI Insights, AI/Run Adoption, Leaderboard), cross-user filter, full Summary Metrics         |
| **Projects**         | Read-only view of all platform projects and their spending data                                                  |
| **Users**            | Read-only view of all users, full user details, and per-user budget spend                                        |
| **Budgets**          | Read-only view of all global and project budgets with current spend platform-wide                                |
| **Settings sidebar** | Projects, Users, and Budgets management sections visible; Activity Events and enterprise admin items not visible |

Write actions (create, edit, delete, deactivate, assign, sync) are not available — controls
are hidden in the UI and the backend returns 403 for any write attempt.

### Combination with other roles

| Combination                                                          | Behavior                                                                                                                                                                                                                                                          |
| -------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `is_auditor = true`, `is_admin = false/is_maintainer = false`        | Auditor access as described above                                                                                                                                                                                                                                 |
| `is_auditor = true` with `is_admin = true` or `is_maintainer = true` | Admin or Maintainer behavior is unchanged. The Auditor switch in User Details is shown disabled with the tooltip: _"Admin and Maintainer already include full platform access — the Auditor flag has no effect for this user."_ The stored value is not modified. |

### Assigning the Auditor flag

The flag is managed through the in-app **Users Management** page, accessible to Platform
Admins and Maintainers.

1. Go to **Settings → Administration → Users Management**.
2. Open the target user (click the user row or the Actions menu).
3. In the **Platform Roles** block within the **User Details** panel, toggle the **Auditor** switch on.
4. Click **Save**.

To remove the flag, toggle the switch off and save. The flag is off by default and has no
self-service assignment surface — users cannot enable it themselves.

:::info
For step-by-step instructions on assigning roles and attributes in Keycloak,
see the [Access Control](../configuration/access-control/index.md) section.
:::
