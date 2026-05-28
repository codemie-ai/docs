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

## Roles in CodeMie

Five role levels are defined in CodeMie:

1. **Maintainer**
2. **Admin**
3. **Project Admin**
4. **Regular User**
5. **External User**

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

| Capability / Scope                                       | Maintainer                                                        | Admin                                   | Project Admin                                                | Regular User                             | External User                                          |
| -------------------------------------------------------- | ----------------------------------------------------------------- | --------------------------------------- | ------------------------------------------------------------ | ---------------------------------------- | ------------------------------------------------------ |
| Role level                                               | Highest operational role                                          | Platform-wide administrative role       | Project-scoped administrative role                           | Standard user role                       | Special user type for guest/external scenarios         |
| Platform-wide admin access                               | ✅                                                                | ✅                                      | ❌                                                           | ❌                                       | ❌                                                     |
| Manage users and access assignments across the platform  | ✅                                                                | ✅                                      | ❌                                                           | ❌                                       | ❌                                                     |
| Manage key platform settings and operational views       | ✅                                                                | ✅                                      | ❌                                                           | ❌                                       | ❌                                                     |
| Manage budget and billing controls                       | ✅ (exclusive)                                                    | ❌                                      | ❌                                                           | ❌                                       | ❌                                                     |
| Manage members and project-level access                  | ✅                                                                | ✅                                      | ✅ (managed projects only)                                   | ❌                                       | ❌                                                     |
| View project-level analytics (including spending trends) | ✅                                                                | ✅                                      | ✅ (managed projects only)                                   | ❌                                       | ❌                                                     |
| View own usage and spending analytics                    | ✅                                                                | ✅                                      | ✅                                                           | ✅                                       | ✅ (where access is allowed)                           |
| Access scope                                             | Platform-wide                                                     | Platform-wide                           | Assigned projects only                                       | Assigned projects and knowledge sources  | Regular-user scope with stricter limits where required |
| Assignment model                                         | Assigned in CodeMie directly (not a separate Keycloak realm role) | Granted via Keycloak `admin` realm role | Derived from project attributes such as `applications_admin` | Derived from standard access assignments | Determined by external/guest user classification       |

## Role Hierarchy

```
Maintainer ──► Admin ──► Project Admin ──► Regular User
    │               │
    │               └── Full platform access
    └── Budget/billing management (exclusive)
```

:::info
For step-by-step instructions on assigning roles and attributes in Keycloak,
see the [Access Control](../configuration/access-control/index.md) section.
:::
