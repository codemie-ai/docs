---
id: azure
title: Azure
sidebar_label: Azure
sidebar_position: 6
---

# Azure

AI/Run CodeMie can interact with various cloud providers, including Microsoft Azure. This integration allows users to view and manage cloud resources. To integrate AI/Run CodeMie with Azure cloud provider, follow the steps below:

## 1. Configure Azure

1.1. Log in to your Azure account.

1.2. In the search bar, enter **Subscriptions**:

![Subscriptions](./images/image58.png)

1.3. In the **Subscriptions** page, click **+ Add** or select the **Subscription** that already exists.

1.4. Copy **Subscription ID**.

![Subscription ID](./images/image15.png)

1.5. In the search bar, enter **App registration**:

![App registration](./images/image37.png)

1.6. Click **+ New registrations** or select the application that already exists:

![New registration](./images/image66.png)

1.7. Enter the application name and click **Register**:

![Register app](./images/image35.png)

1.8. Copy **Application Client ID**:

![Client ID](./images/image7.png)

1.9. Navigate to **Manage → Certificates & secrets → Client secrets**:

![Certificates and secrets](./images/image77.png)

1.10. Click **+ New client secret**. Fill in the description field and click **Add**:

![New client secret](./images/image33.png)

1.11. Copy **Secret ID** and **Value**:

![Secret values](./images/image22.png)

## 2. Configure Integration in AI/Run CodeMie

2.1. In the AI/Run CodeMie main menu, click the **Integrations** button.

2.2. Select **User** or **Project**, depending on your needs, and click **Create**.

2.3. Fill in the required fields and click **Create**:

- **Project Name**: Specify project name.
- **Credential Type**: Azure
- **Alias**: Specify the integration name.
- **Subscription ID**: Paste the subscription ID copied on step 1.4.
- **Tenant ID**: Paste the "Application Client ID" copied from step 1.8.
- **Client ID**: Paste the **Secret ID** data copied from step 1.10.
- **Client Secret**: Paste the **Value** data copied from step 1.11.

![Azure integration](./images/image43.png)

## 3. Enable Azure Tool in Assistant

3.1. Modify your assistant by enabling Azure integration or create a new assistant with this tool:

![Enable Azure tool](./images/image60.png)
