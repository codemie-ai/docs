---
id: assign-attributes
sidebar_position: 3
title: 'Step 2.2: Assign Attributes'
sidebar_label: Assign Attributes
description: Configure project access for users with developer role
---

# Step 2.2: Assign Attributes to Developer Users

Attributes define which projects a user with the `developer` role can access and what permissions they have within those projects. This step is **required** for all users with the `developer` role.

## Understanding Attributes

| Attribute (Key)      | Grants Role               | Permissions Within Assigned Projects                                                               | Value Configuration                                                                                                               |
| -------------------- | ------------------------- | -------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------- |
| `applications`       | **Standard User**         | Allows the user to create, edit, delete, share, and publish **their own** assistants.              | Enter a comma-separated list of project names where the user has standard access (e.g., `my_awesome_project`, `example_project`). |
| `applications_admin` | **Project Administrator** | Allows the user to manage **all assistants in the project** and **project-specific integrations**. | Enter a comma-separated list of project names where the user has admin rights.                                                    |

:::info Automatic Project Creation
The system is designed to streamline project setup. When you assign the `applications` attribute to a user, any project listed in the **Value** that does not already exist will be **created automatically** on the platform.

This behavior applies to both personal and shared projects:

- **Personal Project Example:** If you assign the value `john_doe` to a user with the username `john_doe`, a personal project named `john_doe` is created for them.
- **Shared Project Example:** If you assign the value `team-alpha` to one or more users, a shared project named `team-alpha` will be automatically created the first time it is assigned.

_**Note for Administrators:** Manual project creation (as described in the [Platform Administration Guide](../platform-administration)) is now only necessary if a project needs to be set up for administrative purposes before any users are assigned to it._
:::

:::note How to Configure a Project Administrator
To grant a user **Project Administrator** privileges, they **must be assigned both** the `applications` and `applications_admin` attributes:

1. Assign the `developer` role (from [Step 2.1](./assign-roles)).
2. Add the `applications` attribute, listing all projects the user should have access to.
3. Add the `applications_admin` attribute, listing the specific projects where they should have admin rights.

The `applications` attribute defines the base list of accessible projects, and `applications_admin` elevates their permissions within that list.
:::

## How to Assign Attributes

### 1. Navigate to User Attributes

In the user details page, click on the **Attributes** tab.

![Attributes Tab](../../images/user-configuration/image-2025-9-15_1-38-42.png)

### 2. Add Attributes

Click the **Add attributes** button to create a new attribute.

![Add Attributes Button](../../images/user-configuration/image-2025-9-15_1-38-51.png)

### 3. Configure Standard Access

For standard user access to projects:

- **Key:** `applications`
- **Value:** Comma-separated list of project names (e.g., `my_project,team_project`)

![Standard User Attribute](../../images/user-configuration/image-2025-9-15_1-38-56.png)

### 4. Configure Admin Access (Optional)

For project administrator access:

1. First ensure `applications` attribute includes the projects
2. Add another attribute:
   - **Key:** `applications_admin`
   - **Value:** Comma-separated list of projects to admin (must be subset of `applications`)

![Project Admin Attributes](../../images/user-configuration/image-2025-9-15_1-42-30.png)

### 5. Save Changes

Click **Save** to apply the attributes. The user now has access to the specified projects.
