---
id: platform-administration
sidebar_position: 5
title: Platform Administration Guide
description: Managing projects and platform settings as an administrator
---

# Platform Administration Guide

This guide is for users who have been assigned the global `admin` role. It explains how to create new projects and access existing ones within the AI/Run CodeMie platform.

## Creating a New Project

Follow these steps to create a new project:

### 1. Open Settings

Click on your **Profile** icon in the bottom left corner and select **Settings**.

![Profile Menu](../../images/user-configuration/image-2025-9-17_8-56-47.png)

![Settings Option](../../images/user-configuration/image-2025-9-17_8-57-59.png)

### 2. Navigate to Administration

In the Settings panel, click on the **Administration** tab.

![Administration Tab](../../images/user-configuration/image-2025-9-17_8-59-14.png)

### 3. Create a New Project

Click on the **Create Project** button.

![Create Project Button](../../images/user-configuration/image-2025-9-17_9-4-16.png)

### 4. Enter Project Details

Fill in a unique **Project Name** (e.g., `sample_project`) and click **Add**.

![Project Creation Form](../../images/user-configuration/image-2025-9-17_9-4-43.png)

:::note Next Step
After creating the project, you can now assign it to users by following the instructions in [Step 2.2: Assign Attributes](./user-authorization/assign-attributes).
:::

## Accessing Existing Projects

:::note How Project Access Works for Admins
The project dropdown menu will initially appear empty for users with the `admin` role. To find and access any project, the administrator must start typing its name in the search bar (at least **three characters** are required).

_Example: The project dropdown is initially empty, but projects appear after typing "sam"._
:::

![Empty Dropdown](../../images/user-configuration/image-2025-9-17_9-8-51.png)

![Projects After Search](../../images/user-configuration/image-2025-9-17_9-10-29.png)

---

**Optional Convenience Tip:** For frequently used projects, you can optionally assign the `applications` attribute to an `admin` user. Any projects listed in this attribute will then appear in their dropdown by default, without needing to search. For more details, see [Step 2.2: Assign Attributes](./user-authorization/assign-attributes).
