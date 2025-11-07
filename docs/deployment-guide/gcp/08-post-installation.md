---
id: post-installation
title: Post-Installation Configuration
sidebar_label: Post-Installation Configuration
sidebar_position: 8
---

# AI/Run CodeMie Post-Installation Configuration

## Required Steps

Before onboarding users, a few additional configuration steps are required.

### Prerequisites

Before you begin, please ensure you have the following:

- **A successful deployment of all AI/Run CodeMie components**
- **Access to your Kubernetes cluster via `kubectl`**

**Conditional Prerequisites:**

- **For options involving Keycloak (A, B, and C):** You will need administrative access to the Keycloak UI. You can retrieve the admin credentials by running:

```bash
# Get Keycloak Admin Username
kubectl get secret keycloak-admin -n security -o jsonpath='{.data.username}' | base64 -d; echo

# Get Keycloak Admin Password
kubectl get secret keycloak-admin -n security -o jsonpath='{.data.password}' | base64 -d; echo
```

- **For options involving Entra ID (C and D):** You will need administrative access to your organization's Microsoft Azure portal

### User Configuration Workflow

This guide provides a complete workflow for configuring user authentication and authorization for the AI/Run CodeMie platform. The process is divided into three main parts:

1. **Initial Realm Setup** — A one-time prerequisite to enable custom attributes
2. **Part 1: User Provisioning** — Adding Users to Keycloak
3. **Part 2: User Authorization** — Assigning Permissions

#### Initial Realm Setup

It's crucial to enable realm unmanaged attributes.

1. Open the Keycloak console
2. Choose the `codemie-prod` realm at the top left corner
3. Click on `Realm Settings`
4. Select `Enabled` for the `Unmanaged Attributes` parameter and click `Save`

#### Part 1: User Provisioning

Choose one of the following methods to create user entities in the system:

**Option A: Create Users Manually**

- Ideal for initial setup, creating your first administrator, or managing a small number of users
- Navigate to Users menu in Keycloak
- Click "Create new user" (or "Add user" if users already exist)
- Fill in required fields: Username, Email, First name, Last name
- Set credentials in the Credentials tab

**Option B: Create Users with the Keycloak Assistant**

- A powerful method for bulk user creation (requires a pre-existing admin account)
- Enable the Keycloak Manager assistant in `codemie-api/values-<cloud>.yaml`
- Use the assistant to create users programmatically

**Option C (Recommended): Keycloak + Entra ID**

- For integrating Keycloak with your company's Microsoft Entra ID for seamless single sign-on

**Option D: Entra ID Only**

- Allows you to use Microsoft Entra ID directly, without Keycloak

:::warning Critical Prerequisite for All Users
After a user is created via any method from Part 1, they **cannot sign in** until you complete at least **Step 2.1: Assign a Role**.
:::

#### Part 2: User Authorization

**Step 2.1: Assign a Role**

- This first step grants platform-level capabilities and enables sign-in
- Navigate to the user in Keycloak
- Go to Role mapping tab
- Assign appropriate role (`admin` or `developer`)

**Step 2.2: Assign Attributes to developer Users**

- This second step is required for `developer` users to access projects and create assistants
- Add custom attributes for project access and permissions

## Optional Steps

Additional configuration steps for advanced scenarios and optional features can be performed after the required setup is complete.

---

:::tip
For detailed step-by-step instructions with screenshots for each user provisioning and authorization option, please refer to the original documentation in Confluence or request access to the detailed configuration guide.
:::
