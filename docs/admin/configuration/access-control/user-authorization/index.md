---
id: user-authorization-overview
sidebar_position: 1
title: User Authorization Overview
description: Assigning roles and attributes to users
pagination_prev: admin/configuration/access-control/access-control-overview
---

This section is a **mandatory** follow-up step for any user created in Part 1. Here, you will grant users permissions to access the platform and its projects.

:::info Two deployment modes
How project access is assigned depends on the deployment mode:

- **Keycloak-managed mode** (`ENABLE_USER_MANAGEMENT=False`) — project access is controlled by Keycloak
  JWT attributes (`applications`, `applications_admin`). Follow both Step 2.1 and Step 2.2.
- **Platform-managed mode** (`ENABLE_USER_MANAGEMENT=True`) — project access is managed through
  the in-app UI. Follow only Step 2.1 (role assignment in Keycloak). Step 2.2 is not required.
  :::

The system has three main access levels:

| Access Level               | Keycloak-managed mode                                                        | Platform-managed mode                                                     |
| -------------------------- | ---------------------------------------------------------------------------- | ------------------------------------------------------------------------- |
| **Platform Administrator** | `admin` role in Keycloak                                                     | `admin` role in Keycloak                                                  |
| **Project Administrator**  | `developer` role + `applications` & `applications_admin` Keycloak attributes | `developer` role in Keycloak + assigned as Project Admin in the in-app UI |
| **Standard User**          | `developer` role + `applications` Keycloak attribute                         | `developer` role in Keycloak + assigned to a project in the in-app UI     |
