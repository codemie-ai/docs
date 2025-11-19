---
id: aws
title: AWS
sidebar_label: AWS
---

# AWS

Amazon Web Services cloud platform integration.

AI/Run CodeMie can interact with various cloud providers, including Amazon Web Services (AWS). This integration enables users to view and manage cloud resources. To integrate AI/Run CodeMie with the AWS cloud provider, follow the steps below:

## 1. Configure AWS Account

### 1.1 Log Into AWS

Log into your AWS account.

### 1.2 Access IAM

In the search bar, enter **IAM**.

### 1.3 Navigate to Users

Navigate to **Access management -> Users**. Click **Create user**:

![AWS Create User](./images/aws-create-user.png)

### 1.4 Set Permissions

Set permissions at your discretion and click **Create user**:

![AWS Set Permissions](./images/aws-set-permissions.png)

### 1.5 View User Page

Click on the created user to view their management page:

![AWS User Page](./images/aws-user-page.png)

### 1.6 Create Access Key

Navigate to **Security credentials -> Access keys** and click **Create access key**:

![AWS Create Access Key](./images/aws-create-access-key.png)

### 1.7 Copy Access Keys

Copy **Access key** and **Secret access key**:

![AWS Access Keys](./images/aws-access-keys.png)

## 2. Create Integration in AI/Run CodeMie

### 2.1 Navigate to Integrations

In the **AI/Run CodeMie** main menu, click the **Integrations** button.

Select **User or Project** and click the **+ Create** button.

### 2.2 Fill in Required Fields

Fill in the required fields and click **Create**:

- **Project Name**: Specify project name.
- **Credential Type**: AWS
- **Alias**: Specify the integration name.
- **Region**: Specify the AWS Region to work in.
- **Access Key ID**: Paste the Access Key ID data copied from step 1.7.
- **Secret access key**: Paste the Secret access key data copied from step 1.7.

![AWS Integration Form](./images/aws-integration-form.png)

(Optional) you can "Test Integration" connection before creating.

## 3. Configure Assistant

### 3.1 Enable AWS Integration

Modify your assistant by enabling AWS integration or create a new assistant with this tool:

![AWS Assistant Configuration](./images/aws-assistant-config.png)

## 4. Verify AWS Integration

Verify **AWS** integration by asking assistant a relevant question:

![AWS Verification](./images/aws-verification.png)

Now your assistant can interact with Amazon Web Services to view and manage cloud resources.
