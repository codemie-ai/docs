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

Six role levels are defined in CodeMie:

1. **Maintainer**
2. **Admin**
3. **Project Admin**
4. **Regular User**
5. **Invoker**
6. **External User**

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

| Capability / Scope                                       | Maintainer                                                        | Admin                                   | Project Admin                                                | Regular User                             | Invoker                                                                                   | External User                                          |
| -------------------------------------------------------- | ----------------------------------------------------------------- | --------------------------------------- | ------------------------------------------------------------ | ---------------------------------------- | ----------------------------------------------------------------------------------------- | ------------------------------------------------------ |
| Role level                                               | Highest operational role                                          | Platform-wide administrative role       | Project-scoped administrative role                           | Standard user role                       | Run-only, least-privileged role                                                           | Special user type for guest/external scenarios         |
| Platform-wide admin access                               | ✅                                                                | ✅                                      | ❌                                                           | ❌                                       | ❌                                                                                        | ❌                                                     |
| Manage users and access assignments across the platform  | ✅                                                                | ✅                                      | ❌                                                           | ❌                                       | ❌                                                                                        | ❌                                                     |
| Manage key platform settings and operational views       | ✅                                                                | ✅                                      | ❌                                                           | ❌                                       | ❌                                                                                        | ❌                                                     |
| Manage budget and billing controls                       | ✅ (exclusive)                                                    | ❌                                      | ❌                                                           | ❌                                       | ❌                                                                                        | ❌                                                     |
| Manage members and project-level access                  | ✅                                                                | ✅                                      | ✅ (managed projects only)                                   | ❌                                       | ❌                                                                                        | ❌                                                     |
| View project-level analytics (including spending trends) | ✅                                                                | ✅                                      | ✅ (managed projects only)                                   | ❌                                       | ❌                                                                                        | ❌                                                     |
| View own usage and spending analytics                    | ✅                                                                | ✅                                      | ✅                                                           | ✅                                       | ❌                                                                                        | ✅ (where access is allowed)                           |
| Create and configure assistants, workflows, and skills   | ✅                                                                | ✅                                      | ✅                                                           | ✅                                       | ❌ (run shared ones and clone from Marketplace only)                                      | ✅ (where access is allowed)                           |
| View assistant and workflow configuration                | ✅                                                                | ✅                                      | ✅                                                           | ✅                                       | ❌                                                                                        | ✅ (where access is allowed)                           |
| Change the LLM model in a chat                           | ✅                                                                | ✅                                      | ✅                                                           | ✅                                       | ❌                                                                                        | ✅ (where access is allowed)                           |
| Manage personal integrations                             | ✅                                                                | ✅                                      | ✅                                                           | ✅                                       | ✅ (only credential types required by an accessible assistant)                            | ✅ (where access is allowed)                           |
| Access scope                                             | Platform-wide                                                     | Platform-wide                           | Assigned projects only                                       | Assigned projects and knowledge sources  | Assigned projects only; every action is audited                                           | Regular-user scope with stricter limits where required |
| Assignment model                                         | Assigned in CodeMie directly (not a separate Keycloak realm role) | Granted via Keycloak `admin` realm role | Derived from project attributes such as `applications_admin` | Derived from standard access assignments | Assigned in CodeMie directly (`is_invoker` flag); exclusive with all administrative roles | Determined by external/guest user classification       |

## Role Hierarchy

```
Maintainer ──► Admin ──► Project Admin ──► Regular User ──► Invoker
    │               │                                          │
    │               └── Full platform access                   └── Run-only: no configuration
    └── Budget/billing management (exclusive)                      visibility, no authoring
```

## Invoker Role

The **Invoker** sits below the Regular User. It is meant for people who should run assistants
and workflows that others have built, without seeing prompts, tools, models, data sources, or
any platform configuration. The interface is reduced to a chat-first experience.

- **Assignment**: set directly in CodeMie from Users Management (`is_invoker` flag on the user
  account). It is not derived from Keycloak roles or attributes.
- **Exclusivity**: cannot be combined with Maintainer, Admin, Auditor, or Project Admin.
- **Prerequisite**: activity events (`ACTIVITY_EVENTS_ENABLED=True`) must be enabled; every
  Invoker action and every denied request is written to the audit trail.
- **Enforcement**: the backend denies every API route outside the Invoker allow-list with
  **Access denied**, so the restriction holds for direct API access as well as for the UI.

See [Invoker Role](../../user-guide/project-user-management/invoker-role.md) for the full list
of permitted and restricted actions.

:::info
For step-by-step instructions on assigning roles and attributes in Keycloak,
see the [Access Control](../configuration/access-control/index.md) section.
:::
