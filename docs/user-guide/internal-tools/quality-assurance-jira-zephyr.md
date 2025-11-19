---
id: quality-assurance-jira-zephyr
title: Quality Assurance with Jira Zephyr Scale
sidebar_label: Jira Zephyr Scale
---

# Quality Assurance with Jira Zephyr Scale

Test management and quality assurance integration with Jira Zephyr Scale addon.

The purpose of Quality Assurance tools within AI/Run CodeMie, particularly in the context of integrating with external services like Zephyr Scale addon for Jira Cloud, is to enhance and streamline the QA processes involved in software development.

## 1. Create Zephyr Scale API Token

### 1.1 Access Zephyr Scale API Tokens

In **Jira Cloud**, click on profile icon and click **Zephyr Scale API Access Tokens**:

![Zephyr API Access Tokens](./images/zephyr-api-tokens.png)

### 1.2 Create Access Token

Click **Create access token** and click copy button:

![Zephyr Create Token](./images/zephyr-create-token.png)

## 2. Create Integration in AI/Run CodeMie

### 2.1 Navigate to Integrations

Select **User or Project** and click **Create**.

(Optional) You can **Test integration**.

### 2.2 Configure Integration

Fill in the following parameters and click **Create**:

- **Project Name**: Select the name of your project.
- **Credential Type**: Zephyr Cloud
- **Alias**: Specify the integration name.
- **Token**: Paste the access token you copied from step 1.2.

![Zephyr Integration Form](./images/zephyr-integration-form.png)

## 3. Configure Assistant

### 3.1 Create Assistant

Click **Explore Assistant**, Click **Create Assistant** and fill in the following parameters:

- **Project Name**: Select the name of your project.
- **Name**: Specify the assistant name.
- **Description**: Specify description.
- **System Instructions**: Specify system instructions.
- **Available tools**: Quality Assurance and select from drop down list **Zephyr Cloud**.

### 3.2 Save Assistant

Click **Create**.

Now your assistant can interact with Jira Zephyr Scale to manage test cases, test cycles, and test execution results.
