---
id: roles-rbac
title: CodeMie Roles Overview
sidebar_label: Roles & RBAC
sidebar_position: 2
pagination_prev: admin/security/index
pagination_next: null
---

# CodeMie Roles Overview

CodeMie uses a role-based access control model built on top of Keycloak.
This page describes the platform roles and how they map to Keycloak realm roles and user attributes.

## Roles in CodeMie

CodeMie has five role levels:

1. **Maintainer**
2. **Admin**
3. **Project Admin**
4. **Regular User**
5. **External User**

## How Keycloak Access Is Interpreted

### Realm Roles

- The `admin` realm role in Keycloak grants platform-level **Admin** rights in CodeMie.
- The `developer` realm role does not grant elevated admin rights by itself.
  It is treated as a standard user role unless additional Project Admin access is explicitly assigned.

### Project Attributes

| Keycloak Attribute   | Effect in CodeMie                                   |
| -------------------- | --------------------------------------------------- |
| `applications`       | Projects where the user is a regular project member |
| `applications_admin` | Projects where the user is a Project Admin          |

**Attribute resolution rules:**

- If a project appears in **both** attributes, the user is treated as **Project Admin** for that project.
- If a project appears **only** in `applications_admin`, the user still receives Project Admin access.

### Note on Access Timing

- In deployments where user management is enabled inside CodeMie, project access and admin status
  are read from identity data at first sign-in and then managed within CodeMie.
- In deployments where user management is **not** enabled in CodeMie, platform admin status
  is resolved directly from the identity provider settings on each authentication.

## Role Descriptions

### Maintainer

- Highest operational role in the platform.
- Includes all Admin rights.
- Exclusively manages budget and billing controls.
- Assigned in CodeMie directly — not a separate Keycloak realm role.

### Admin

- Platform-wide administrative access.
- Manages users and access assignments across the platform.
- Manages key platform settings and operational views.
- Does **not** automatically include Maintainer-only budget controls.

### Project Admin

- Administrative rights scoped to specific projects only.
- Can manage members and project-level access within those projects.
- Can view project-level analytics, including spending trends, for managed projects.
- Cannot perform platform-wide admin actions.

### Regular User

- Works with own and shared resources.
- Has access only to assigned projects and knowledge sources.
- Can view own usage and spending analytics in accessible projects.

### External User

- A special user type for external or guest scenarios.
- Follows regular-user behavior by default, but with stricter limits where required.

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
