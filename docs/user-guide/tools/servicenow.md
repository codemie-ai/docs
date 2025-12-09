---
id: servicenow
title: ServiceNow
sidebar_label: ServiceNow
sidebar_position: 17
---

# ServiceNow

## 1. Obtain ServiceNow API Key

1.1. To integrate ServiceNow with CodeMie, follow the steps below:

- [Get Personal Developer Instance](https://developer.servicenow.com/dev.do#!/learn/learning-plans/washingtondc/new_to_servicenow/app_store_learnv2_buildmyfirstapp_washingtondc_personal_developer_instances)
- [Configure API Key](https://www.servicenow.com/docs/bundle/yokohama-platform-security/page/integrate/authentication/task/configure-api-key.html)

## 2. Configure Integration in CodeMie

2.1. In the CodeMie main menu, click the **integration** button.

2.2. Select **User** or **Project** and click the **Creates**. As an alternative way of getting to the User page, you can click the Add User button in front of the desired tool when creating/editing your assistant of step 3. This link will open a new page New User integration page. Note that this link appears only if no such tools are configured by the users.

2.3. In the new user setting menu, fill in the following parameters:

- **Project Name**: Select the name of your project.
- **Credential Type**: ServiceNow.
- **Alias**: Alias is a representation of the user setting (e.g., ServiceNow).
- **Instance URL**: Fill in the URL field (e.g., https://dev42348283.service-now.com).
- **API Key**: API Key from step 1.

  2.4. Click **Create**.

## 3. Create Assistant with ServiceNow Tool

3.1. Click **Explore Assistant**, Click **Create Assistant** fill in the following parameters:

- **Project Name**: Select the name of your project.
- **Name**: Specify the assistant name.
- **Description**: Specify description.
- **System Instructions**: Specify system instructions.
- **Available tools**: IT Service Management - and select from drop down list Alias of credentials from step 2.3.

  3.2. Click **Create**.

## 4. Use Your Assistant

4.1. Click **Explore Assistant**, select **My Assistant** and choose by **Name** your assistant. Enjoy.
