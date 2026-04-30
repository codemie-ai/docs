---
id: access-control-overview
sidebar_position: 1
title: Access Control Overview
description: Complete workflow for configuring user authentication and authorization
pagination_prev: admin/configuration/index
---

This guide provides a complete workflow for configuring user authentication and authorization for the AI/Run CodeMie platform.

## Deployment Modes

The platform supports two user management modes. The active mode is controlled by the
`ENABLE_USER_MANAGEMENT` environment variable in your deployment configuration.

|                                 | **Keycloak-managed mode** (`ENABLE_USER_MANAGEMENT=False`) | **Platform-managed mode** (`ENABLE_USER_MANAGEMENT=True`)            |
| ------------------------------- | ---------------------------------------------------------- | -------------------------------------------------------------------- |
| **Roles & project access**      | Read from Keycloak JWT claims on every request             | Stored in the platform database; synced from IDP once on first login |
| **Assigning projects to users** | Keycloak `applications` / `applications_admin` attributes  | In-app UI: Settings → Administration → Projects management           |
| **Managing users**              | Keycloak admin interface                                   | In-app UI: Settings → Administration → Users management              |
| **Local authentication**        | Not available                                              | Supported (`IDP_PROVIDER=local`)                                     |

The workflow below applies to both modes. Steps that differ between modes are marked
accordingly.

## Prerequisites

Before you begin, please ensure you have the following:

- **A successful deployment of all AI/Run CodeMie components**
- **Access to your Kubernetes cluster via `kubectl`**

### Conditional Prerequisites

Depending on your chosen authentication method:

- **For options involving Keycloak (A, B, and C):** You will need administrative access to the Keycloak UI. You can retrieve the admin credentials by running:

```bash
# Get Keycloak Admin Username
kubectl get secret keycloak-admin -n security -o jsonpath='{.data.username}' | base64 -d; echo

# Get Keycloak Admin Password
kubectl get secret keycloak-admin -n security -o jsonpath='{.data.password}' | base64 -d; echo
```

- **For option involving Entra ID (C):** You will need administrative access to your organization's Microsoft Azure portal.

## User Configuration Workflow

The user configuration process consists of three main parts:

### 1. [Initial Realm Setup](./initial-realm-setup.md) (One-time)

A one-time prerequisite to enable custom attributes in Keycloak.

### 2. User Provisioning

The first step where you choose a method to create user entities in the system. Available options:

- **[Option A: Create Users Manually](./user-provisioning/manual-creation.md)** - Ideal for initial setup, creating your first administrator, or managing a small number of users
- **[Option B: Create Users with Keycloak Assistant](./user-provisioning/keycloak-assistant.md)** - Powerful method for bulk user creation (requires pre-existing admin account)
- **[Option C: Keycloak + Entra ID](./user-provisioning/keycloak-entra-id.md)** (Recommended) - Integrate Keycloak with Microsoft Entra ID for seamless single sign-on

:::warning Critical Prerequisite
After a user is created via any method from Part 1, they **cannot sign in** until you complete at least **Step 2.1: Assign a Role**.
:::

### 3. User Authorization

Assigning permissions to users. The configuration path depends on the role:

- **[Step 2.1: Assign a Role](./user-authorization/assign-roles.md)** — Grants platform-level capabilities and enables sign-in. Required in both modes.
- **[Step 2.2: Assign Attributes](./user-authorization/assign-attributes.md)** — _(Keycloak-managed mode only)_ Required for `developer` users to access projects via Keycloak JWT attributes.

:::info Platform-managed mode — Step 2.2 not required
If `ENABLE_USER_MANAGEMENT=True`, skip Step 2.2. Project and role assignments are managed
through the in-app UI after the user signs in for the first time.
See [Project & User Management](../../../user-guide/project-user-management/projects.md).
:::

Additionally, this section includes:

- **[Platform Administration Guide](../codemie/platform-administration.md)** - Explains how users with the `admin` role can create and manage projects

## Next Steps

After completing user configuration, proceed to configure AI models integration for your platform.
