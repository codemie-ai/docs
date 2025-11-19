---
id: gcp
title: GCP
sidebar_label: GCP
---

# GCP

Google Cloud Platform services integration.

AI/Run CodeMie can operate Google Cloud Platform (GCP) resources. Integration with GCP tools enables users to view and manage cloud resources. To integrate AI/Run CodeMie with the GCP cloud provider, follow the steps below:

## 1. Configure GCP Account

### 1.1 Log Into GCP

Log into your GCP account.

### 1.2 Select Project

Select Project ID, if not selected yet.

### 1.3 Create Service Account

In the Navigation menu, select **IAM -> Service Accounts**. Create a service account or use an existing one with the permissions you want to delegate to AI/Run CodeMie. Refer to the [official documentation](https://cloud.google.com/iam/docs/service-accounts-create) for more details.

### 1.4 Create Private Key

Navigate to a created/selected account. In the **Keys** tab, click **Add key -> Create new key**:

![GCP Service Account Keys](./images/gcp-service-account-keys.png)

### 1.5 Select JSON Format

On the **create private key** window, select the **JSON** format and click **Create**:

![GCP Create Key](./images/gcp-create-key.png)

### 1.6 Download JSON File

Download the .json file with the service account credentials and copy its data.

## 2. Create Integration in AI/Run CodeMie

### 2.1 Navigate to Integrations

In the **AI/Run CodeMie** main menu, click the **Integrations** button.

Select **User or Project** and click the **+ Create** button.

### 2.2 Fill in Required Fields

Fill in the required fields and click **Create**:

- **Project Name**: Specify project name.
- **Credential Type**: GCP
- **Alias**: Specify the integration name.
- **Service Account Key in JSON format**: Paste the service account key you copied on the step 1.6.

## 3. Verify GCP Integration

Verify **GCP** integration by asking assistant a relevant question:

![GCP Verification](./images/gcp-verification.png)

Now your assistant can interact with Google Cloud Platform to view and manage cloud resources.
