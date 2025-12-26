---
id: initial-realm-setup
sidebar_position: 2
title: Initial Realm Setup
description: One-time setup to enable custom attributes in Keycloak
---

This is a one-time configuration step that must be completed before creating any users. It enables Keycloak to store custom attributes required for AI/Run CodeMie's project access control system.

## Configuration Steps

Follow these steps to enable unmanaged attributes in the Keycloak realm:

### 1. Open the Keycloak Console

Navigate to your Keycloak admin console URL (typically `https://keycloak.<your-domain>/auth/admin/`).

### 2. Select the Correct Realm

Choose the `codemie-prod` realm from the dropdown at the top left corner of the interface.

![Select Realm](@site/docs/configuration-guide/images/user-configuration/image-2025-9-16_16-20-31.png)

![Realm Selected](@site/docs/configuration-guide/images/user-configuration/image-2025-9-16_16-23-9.png)

### 3. Navigate to Realm Settings

Click on **Realm Settings** in the left sidebar menu.

![Realm Settings](@site/docs/configuration-guide/images/user-configuration/image-2025-9-16_16-23-49.png)

### 4. Enable Unmanaged Attributes

1. Scroll down to find the **Unmanaged Attributes** parameter
2. Select **Enabled** from the dropdown
3. Click **Save** to apply the changes

![Enable Unmanaged Attributes](@site/docs/configuration-guide/images/user-configuration/image-2025-9-16_16-34-28.png)

![Select Enabled](@site/docs/configuration-guide/images/user-configuration/image-2025-9-16_16-34-52.png)

![Save Changes](@site/docs/configuration-guide/images/user-configuration/image-2025-9-16_16-36-10.png)

## Next Steps

With realm setup complete, you can now proceed to:

- User Provisioning - Create users using your preferred method
- If you already have users created, proceed to User Authorization
