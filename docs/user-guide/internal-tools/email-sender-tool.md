---
id: email-sender-tool
title: Email Sender Tool
sidebar_label: Email Sender Tool
---

# Email Sender Tool

Send emails from assistants using SMTP integration.

In AI/Run CodeMie, admins have extended functionality to send emails through assistants. This integration allows you to automate email sending from your workflows and assistants.

## 1. Create Email Integration

### 1.1 Navigate to Integrations

Click on **Integrations** and select the project name.

### 1.2 Configure Integration

Fill in the following parameters:

- **Project Name**: Specify project name.
- **Credential Type**: Email
- **Alias**: Specify the integration name.
- **SMTP server URL**: In pattern `url:port`
- **SMTP Server Username**: Account username
- **SMTP Server Password**: Account password

![Email Integration Form](./images/email-integration-form.png)

(Optional) you can "Test Integration" connection before creating.

## 2. Configure Assistant

### 2.1 Enable Email Tool

Open assistant or create a new one and choose in tool **Notification -> Email**:

![Email Assistant Configuration](./images/email-assistant-config.png)

## 3. Send Emails

### 3.1 Basic Email

To send a basic email message, you need to provide:

- Email address (To field)
- Subject
- Text of email

![Email Send Example](./images/email-send-example.png)

### 3.2 Using CC Field

When you need to include additional recipients without adding them to the primary recipient list, you can use the CC (Carbon Copy) field:

- **Email address (To field)**: Specify the primary recipient(s)
- **CC field**: Specify the secondary recipient(s) who should receive a copy
- **Subject**: Specify the subject of the email
- **Text**: Provide the content of the email

**Example:**

To send an email with CC recipients, include both the "To" and "CC" parameters in your request.

**Use Cases:**

- Keeping stakeholders informed without making them primary recipients
- Sending project updates to team members while CCing managers or other departments
- Ensuring multiple parties receive the same information simultaneously

![Email Received](./images/email-received.png)

## Important Notes

:::warning Multi-Factor Authentication Restriction
Email integration will not work for organization accounts that have Multi-Factor Authentication (MFA) enabled and prohibit the generation of App Tokens.
:::

### Supported Email Services

You can add any email services such as Gmail or Outlook for integration. Please ensure you generate an App Token to enable this functionality. Below are the links to the documentation for generating App Tokens:

- **Generate an App Token for Gmail**: [https://support.google.com/accounts/answer/185833?hl=en](https://support.google.com/accounts/answer/185833?hl=en)
- **Generate an App Token for Outlook**: [https://support.microsoft.com/en-us/account-billing/how-to-get-and-use-app-passwords-5896ed9b-4263-e681-128a-a6f2979a7944](https://support.microsoft.com/en-us/account-billing/how-to-get-and-use-app-passwords-5896ed9b-4263-e681-128a-a6f2979a7944)
