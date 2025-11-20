---
id: user-provisioning-overview
sidebar_position: 2
title: User Provisioning
sidebar_label: User Provisioning
description: Choose a method to create user entities in the system
---

# User Provisioning

This section covers the first step of user configuration where you choose a method to create user entities in the system. After creating users through any of these methods, you must proceed to [User Authorization](../user-authorization/assign-roles) to grant them the necessary permissions.

## Available Options

### Option A: Manual User Creation

**Ideal for:** Initial setup, creating your first administrator, or managing a small number of users.

Create users manually through the Keycloak admin interface. This is the simplest method and requires no additional setup.

[Learn more →](./manual-creation)

---

### Option B: Keycloak Assistant

**Ideal for:** Bulk user creation and programmatic user management.

Use the AI/Run CodeMie Keycloak Manager assistant to create users in bulk with a conversational interface.

**Prerequisites:** Requires a pre-existing admin account.

[Learn more →](./keycloak-assistant)

---

### Option C: Keycloak + Entra ID (Recommended)

**Ideal for:** Organizations using Microsoft Entra ID.

Integrate Keycloak with Microsoft Entra ID to enable single sign-on with corporate credentials. This method automates permission assignment for new users.

[Learn more →](./keycloak-entra-id)

---

### Option D: Entra ID Only

**Ideal for:** Direct Entra ID integration without Keycloak.

Use Microsoft Entra ID directly for authentication and user management.

[Learn more →](./entra-id-only)

---

:::warning Critical Next Step
After creating a user via any method above, they **cannot sign in** until you complete at least **[Step 2.1: Assign a Role](../user-authorization/assign-roles)** in the User Authorization section.
:::
