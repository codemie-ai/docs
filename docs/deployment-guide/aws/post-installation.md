---
id: post-installation
sidebar_position: 6
title: Post-Installation Configuration
description: Required and optional configuration steps after deployment
---

# AI/Run CodeMie Post-Installation Configuration

## Prerequisites

Before you begin, ensure you have:

- A successful deployment of all AI/Run CodeMie components
- Access to your Kubernetes cluster via `kubectl`

### Retrieve Keycloak Admin Credentials

For options involving Keycloak, retrieve admin credentials:

```bash
# Get Keycloak Admin Username
kubectl get secret keycloak-admin -n security -o jsonpath='{.data.username}' | base64 -d; echo

# Get Keycloak Admin Password
kubectl get secret keycloak-admin -n security -o jsonpath='{.data.password}' | base64 -d; echo
```

## User Configuration Workflow

The user configuration process is divided into three main parts:

### 1. Initial Realm Setup (One-time)

Enable unmanaged attributes in Keycloak:

1. Open the Keycloak console
2. Choose the `codemie-prod` realm at the top left corner
3. Click on `Realm Settings`
4. Select `Enabled` for the `Unmanaged Attributes` parameter
5. Click `Save`

### 2. Part 1: User Provisioning

Choose one of the following methods to add users:

#### Option A: Create Users Manually

Ideal for initial setup or small number of users:

1. Navigate to the `Users` menu in the `codemie-prod` realm
2. Click `Create new user`
3. Fill in required fields:
   - Username
   - Email
   - First name
   - Last name
4. Click `Create`
5. Navigate to `Credentials` tab
6. Click `Set password`
7. Enter password and confirmation
8. Click `Save`

:::note
Keep the `Temporary` switch enabled to force password change on first login.
:::

#### Option B: Create Users with Keycloak Assistant

For bulk user creation using the AI/Run CodeMie Keycloak Manager assistant. Requires pre-existing admin account.

#### Option C (Recommended): Keycloak + Entra ID

Integrate Keycloak with Microsoft Entra ID for seamless single sign-on experience.

#### Option D: Entra ID Only

Use Microsoft Entra ID directly without Keycloak for authentication and user management.

:::warning Critical Prerequisite
After creating a user via any method, they **cannot sign in** until you complete at least Step 2.1: Assign a Role.
:::

### 3. Part 2: User Authorization

#### Step 2.1: Assign a Role

Grants platform-level capabilities and enables sign-in. Roles include:

- `admin` - Full platform administration capabilities
- `developer` - Project and assistant development access
- `user` - Basic platform access

#### Step 2.2: Assign Attributes (for developers)

Required for `developer` users to access projects and create assistants. Configure project access permissions and resource quotas.

## Required Steps

1. ✓ Complete Initial Realm Setup
2. ✓ Provision at least one administrator user
3. ✓ Assign admin role to the user
4. ✓ Configure user attributes (if using developer role)

## Optional Steps

### Platform Administration Guide

For users with the `admin` role:

- Create and manage projects
- Configure platform-wide settings
- Manage user permissions and quotas
- Monitor platform usage and metrics

### Integration Configuration

Configure integrations with:

- Source code repositories (GitLab, GitHub, Azure DevOps)
- CI/CD systems
- Cloud storage services (AWS S3, Azure Blob Storage)
- External authentication providers

## Verification

After completing configuration:

1. Test user login at `https://codemie.<your-domain>`
2. Verify admin can access administrative features
3. Confirm developers can create and access projects
4. Test basic assistant functionality

## Next Steps

Proceed to [AI Models Integration](./07-ai-models-integration.md) to configure LLM and embedding models.
