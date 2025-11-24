---
id: user-configuration-overview
sidebar_position: 1
title: User Configuration Overview
description: Complete workflow for configuring user authentication and authorization
---

# User Configuration Overview

This guide provides a complete workflow for configuring user authentication and authorization for the AI/Run CodeMie platform. The process is divided into three main parts that must be completed in sequence.

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

### 1. [Initial Realm Setup](./initial-realm-setup) (One-time)

A one-time prerequisite to enable custom attributes in Keycloak.

### 2. User Provisioning

The first step where you choose a method to create user entities in the system. Available options:

- **[Option A: Create Users Manually](./user-provisioning/manual-creation)** - Ideal for initial setup, creating your first administrator, or managing a small number of users
- **[Option B: Create Users with Keycloak Assistant](./user-provisioning/keycloak-assistant)** - Powerful method for bulk user creation (requires pre-existing admin account)
- **[Option C: Keycloak + Entra ID](./user-provisioning/keycloak-entra-id)** (Recommended) - Integrate Keycloak with Microsoft Entra ID for seamless single sign-on

:::warning Critical Prerequisite
After a user is created via any method from Part 1, they **cannot sign in** until you complete at least **Step 2.1: Assign a Role**.
:::

### 3. User Authorization

Assigning permissions to users. The configuration path depends on the role:

- **[Step 2.1: Assign a Role](./user-authorization/assign-roles)** - Grants platform-level capabilities and enables sign-in
- **[Step 2.2: Assign Attributes](./user-authorization/assign-attributes)** - Required for `developer` users to access projects and create assistants

Additionally, this section includes:

- **[Platform Administration Guide](./platform-administration)** - Explains how users with the `admin` role can create and manage projects

## Next Steps

After completing user configuration:

- (Optional) Configure [UI Customization](../ui-customization)
- Proceed to [AI Models Integration](../../ai-models-integration/) to configure LLM and embedding models
