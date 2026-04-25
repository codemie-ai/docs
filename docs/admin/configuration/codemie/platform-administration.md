---
id: platform-administration
sidebar_position: 3
title: Platform Administration
description: Managing projects and platform settings
pagination_prev: admin/configuration/access-control/access-control-overview
pagination_next: null
---

This guide is for users who have been assigned the global `admin` role. It explains how to create new projects and access existing ones within the AI/Run CodeMie platform.

:::tip
For a full guide to creating projects, managing project members, and the Users Management panel,
see [Project & User Management](../../../user-guide/project-user-management/projects.md).
:::

## Creating a New Project

Follow these steps to create a new project:

### 1. Open Settings

Click on your **Profile** icon in the bottom left corner and select **Settings**.

![Profile Menu](@site/docs/admin/configuration/images/user-configuration/image-2025-9-17_8-56-47.png)

![Settings Option](@site/docs/admin/configuration/images/user-configuration/image-2025-9-17_8-57-59.png)

### 2. Navigate to Administration

In the Settings panel, click on the **Administration** tab.

:::info
The Administration menu and its items are controlled by the `adminActions` component. See [Customer Feature Configuration](./customer-feature-configuration.md) to configure which menu items are visible to users.
:::

![Administration Tab](@site/docs/admin/configuration/images/user-configuration/image-2025-9-17_8-59-14.png)

### 3. Create a New Project

Click on the **Create Project** button.

![Create Project Button](@site/docs/admin/configuration/images/user-configuration/image-2025-9-17_9-4-16.png)

### 4. Enter Project Details

Fill in a unique **Project Name** (e.g., `sample_project`) and click **Add**.

![Project Creation Form](@site/docs/admin/configuration/images/user-configuration/image-2025-9-17_9-4-43.png)

:::note Next Step
After creating the project, assign users to it:

- **Keycloak-managed mode** — follow [Step 2.2: Assign Attributes](../access-control/user-authorization/assign-attributes.md) to add the project name to the user's `applications` attribute in Keycloak.
- **Platform-managed mode** — open the project in Settings → Administration → Projects management and add users directly from the [Projects Management](../../../user-guide/project-user-management/projects.md) UI.
  :::

## Accessing Existing Projects

:::note How Project Access Works for Admins
The project dropdown menu will initially appear empty for users with the `admin` role. To find and access any project, the administrator must start typing its name in the search bar (at least **three characters** are required).

_Example: The project dropdown is initially empty, but projects appear after typing "sam"._
:::

![Empty Dropdown](@site/docs/admin/configuration/images/user-configuration/image-2025-9-17_9-8-51.png)

![Projects After Search](@site/docs/admin/configuration/images/user-configuration/image-2025-9-17_9-10-29.png)

---

**Optional Convenience Tip (Keycloak-managed mode only):** For frequently used projects, you can optionally assign the `applications` attribute to an `admin` user in Keycloak. Any projects listed in this attribute will then appear in their dropdown by default, without needing to search. For more details, see [Assign Attributes](../access-control/user-authorization/assign-attributes.md).
