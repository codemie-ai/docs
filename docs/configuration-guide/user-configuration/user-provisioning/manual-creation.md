---
id: manual-creation
sidebar_position: 2
title: Manual User Creation
description: Create users manually in Keycloak
---

Manual user creation is the simplest method to add users to AI/Run CodeMie. This approach is ideal for initial setup, creating your first administrator, or managing a small number of users.

### 1. Navigate to Users Section

While in the `codemie-prod` realm, click on **Users** in the left sidebar menu.

![Users Menu](@site/docs/configuration-guide/images/user-configuration/image-2025-9-17_14-55-2.png)

### 2. Create New User

Click **Create new user** (or **Add user** if users already exist).

![Create New User](@site/docs/configuration-guide/images/user-configuration/image-2025-9-17_14-55-25.png)

![Add User Form](@site/docs/configuration-guide/images/user-configuration/image-2025-9-17_14-56-1.png)

### 3. Fill in User Details

Enter the required information:

- **Username:** Unique identifier for the user (e.g., `john_doe`)
- **Email:** User's email address (e.g., `john_doe@example.com`)
- **First name:** User's first name (e.g., `John`)
- **Last name:** User's last name (e.g., `Doe`)

Click **Create** to save the user.

![User Details Form](@site/docs/configuration-guide/images/user-configuration/image-2025-9-15_0-43-4.png)

### 4. Set User Credentials

After creating the user, you must set their initial password.

#### Navigate to Credentials Tab

Click on the **Credentials** tab in the user details page.

![Credentials Tab](@site/docs/configuration-guide/images/user-configuration/image-2025-9-15_0-45-4.png)

#### Set Password

1. Click the **Set password** button

![Set Password Button](@site/docs/configuration-guide/images/user-configuration/image-2025-9-15_0-46-20.png)

2. Enter the password in both fields:
   - **Password:** Enter the initial password
   - **Password confirmation:** Re-enter the same password

3. Configure password settings:
   - **Temporary:** Keep this **enabled** (recommended) to force the user to change their password on first login
   - If disabled, the password will be permanent until the user changes it

![Password Form](@site/docs/configuration-guide/images/user-configuration/image-2025-9-15_0-49-56.png)

4. Click **Save** to confirm the password

:::note Next Step:
After creating a user, proceed to [Part 2: User Authorization](../user-authorization/assign-roles) to assign the necessary permissions.
:::
