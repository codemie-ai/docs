---
id: azure
title: Azure
sidebar_label: Azure
---

# Azure

Microsoft Azure cloud services integration.

AI/Run CodeMie can interact with various cloud providers, including Microsoft Azure. This integration allows users to view and manage cloud resources. To integrate AI/Run CodeMie with Azure cloud provider, follow the steps below:

## 1. Configure Azure Account

### 1.1 Access Subscriptions

Log in to your **Azure** account.

In the search bar, enter **Subscriptions**:

![Azure Subscriptions](./images/azure-subscriptions.png)

### 1.2 Select Subscription

In the **Subscriptions** page, click **+ Add** or select the **Subscription** that already exists.

### 1.3 Copy Subscription ID

Copy **Subscription ID**:

![Azure Subscription ID](./images/azure-subscription-id.png)

### 1.4 Access App Registration

In the search bar, enter **App registration**:

![Azure App Registration](./images/azure-app-registration.png)

### 1.5 Create or Select Application

Click **+ New registrations** or select the application that already exists:

![Azure New Registration](./images/azure-new-registration.png)

### 1.6 Register Application

Enter the application name and click **Register**:

![Azure Register](./images/azure-register.png)

### 1.7 Copy Application Client ID

Copy **Application Client ID**:

![Azure Client ID](./images/azure-client-id.png)

### 1.8 Navigate to Certificates & Secrets

Navigate to **Manage -> Certificates & secrets -> Client secrets**:

![Azure Certificates & Secrets](./images/azure-certificates-secrets.png)

### 1.9 Create New Client Secret

Click **+ New client secret**. Fill in the description field and click **Add**:

![Azure New Secret](./images/azure-new-secret.png)

### 1.10 Copy Secret ID and Value

Copy **Secret ID** and **Value**:

![Azure Secret Value](./images/azure-secret-value.png)

## 2. Create Integration in AI/Run CodeMie

### 2.1 Navigate to Integrations

In the **AI/Run CodeMie** main menu, click the **Integrations** button.

Select **User or Project**, depending on your needs, and click **Create**.

### 2.2 Fill in Required Fields

Fill in the required fields and click **Create**:

- **Project Name**: Specify project name.
- **Credential Type**: Azure
- **Alias**: Specify the integration name.
- **Subscription ID**: Paste the subscription ID copied on step 1.3.
- **Tenant ID**: Paste the "**Application Client ID**" copied from step 1.7.
- **Client ID**: Paste the **Secret ID** data copied from step 1.10.
- **Client Secret**: Paste the **Value** data copied from step 1.10.

![Azure Integration Form](./images/azure-integration-form.png)

## 3. Configure Assistant

### 3.1 Enable Azure Integration

Modify your assistant by enabling Azure integration or create a new assistant with this tool:

![Azure Assistant Configuration](./images/azure-assistant-config.png)

Now your assistant can interact with Microsoft Azure cloud services to view and manage cloud resources.
