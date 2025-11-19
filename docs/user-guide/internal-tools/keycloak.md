---
id: keycloak
title: Keycloak
sidebar_label: Keycloak
---

# Keycloak

Identity and access management tool integration.

To integrate Keycloak with AI/Run™ CodeMie, follow the steps below:

## 1. Configure Keycloak

### 1.1 Create a Client

In Keycloak select the realm which you want to manage.

Create a client or use an existing one e.g. (`admin-cli`).

### 1.2 Configure Integration Settings

Select the **Integrations** tab.

On the **Integrations** tab, navigate to the **Capability config** section and set the following parameters:

![Keycloak Capability Config](./images/keycloak-capability-config.png)

### 1.3 Assign Service Account Roles

Select the **Service accounts roles** tab and click **assign role**, select role (e.g., admin) and click **Assign**.

![Keycloak Service Account Roles](./images/keycloak-service-roles.png)

### 1.4 Copy Client Secret

Select the **Credentials** tab and copy the **Client secret**.

![Keycloak Client Secret](./images/keycloak-client-secret.png)

## 2. Create Integration in AI/Run™ CodeMie

### 2.1 Navigate to Integrations

In the AI/Run™ CodeMie main menu, click the **Integrations** button.

Select **User** or **Project** (this functionality is available for Administrators and application admins only) and click the **+ Create** button.

![CodeMie Integrations](./images/codemie-integrations.png)

### 2.2 Fill in Integration Parameters

In the new user setting menu, fill in the following parameters:

- **Project Name**: Select the name of your project.
- **Credential Type**: Keycloak.
- **Alias**: Alias is a representation of the user setting (e.g., Keycloak).
- **Keycloak Base URL**: Fill in the URL field (e.g., `https://keycloak.example.com/auth`).
- **Keycloak Realm**: Fill in the Realm from step 1.
- **Keycloak Client ID**: Fill in the Client ID from step 1.1.
- **Keycloak Client Secret**: Fill in the Token field with the token created from step 1.4.

![Keycloak Integration Form](./images/keycloak-integration-form.png)

### 2.3 Create the Integration

Click **Create/Update**.

## 3. Configure Assistant

### 3.1 Create or Edit Assistant

Click **Explore Assistant**, Click **Create Assistant** and fill in the following parameters:

- **Project Name**: Select the name of your project.
- **Name**: Specify the assistant name.
- **Description**: Specify description.
- **System Instructions**: Specify system instructions.
- **Available tools**: Access Management, Keycloak and select from drop down menu **alias** of credentials from step 2.2.

![Assistant Configuration](./images/assistant-configuration.png)

### 3.2 Save Assistant

Click **Create/Save**.

## 4. Use Your Assistant

Click **Explore Assistant**, select **My Assistants** and choose by **Name** your assistant, Enjoy.

![Using Keycloak Assistant](./images/using-keycloak-assistant.png)
