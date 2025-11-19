---
id: webhook
title: Webhook
sidebar_label: Webhook
---

# Webhook

Webhook-based event triggering for assistants and workflows.

AI/Run CodeMie assistants and Workflows can be triggered using webhooks. It means that all the tools that support sending webhooks can be integrated with AI/Run CodeMie. Below is a list of some examples where webhooks can be beneficial:

1. You need to automatically trigger code review assistant when developers create pull requests.
2. You need to send some real-time notifications via workflow when issues are created, updated, or resolved in Jira.
3. You need to trigger a customer support assistant when a new support ticket is created in your helpdesk system.

:::warning Project Admin Only
As of version 1.1.0, only users with the **Project Admin** role can create and manage Webhook integrations. User-level Webhook integrations are no longer supported. If you are not a Project Admin, the "Webhook" option will not appear for you, and any previous user-level Webhook integrations you created will no longer function.
:::

To create a webhook integration (Project Admins only), follow the steps below:

## 1. Create Assistant

Create an assistant you want to react to webhooks.

## 2. Copy Assistant Details

In the **My Assistants** list, click the assistant name and copy **ASSISTANT ID** and **ACCESS LINKS**:

![Webhook Assistant ID](./images/webhook-assistant-id.png)

:::note
You can also create a Workflow and Datasource as these resource types support webhooks as well.
:::

## 3. Navigate to Integrations

Navigate to **Integrations -> User/Project** and click **+ Create**.

## 4. Configure Webhook Integration

On the **New User/Project Integration** page, fill in the fields to create a webhook:

- **Project Name**: Specify project name.
- **Credential Type**: Webhook
- **Alias**: Specify the integration name.
- **Webhook ID**: Specify the Webhook ID to work in. This ID is used in Webhook's full URL.
- **Access Key ID**: Paste the Access Key ID data copied from step 2.
- **If enabled**: Check the toggler. If the option is disabled, the webhook won't be operating.
- **Secure Header Name (optional)**: This field is used as a means of verifying the webhook's eligibility.
- **Secure Header Value (optional)**: Enter the Secure Header's value.
- **Resource type**: Choose who will be triggered when receiving the webhook.
- **Resource ID**: Enter the ID of an Assistant/Workflow/Datasource data copied from step 2.

![Webhook Integration Form](./images/webhook-integration-form.png)

## 5. Copy Webhook URL

Copy the assistant's webhook URL to further paste it in the webhook settings:

![Webhook URL](./images/webhook-url.png)

## 6. Configure External Tool

Navigate to the tool where you want to create a webhook. In our example, we will use GitLab version control system to create a webhook for a Git repository:

![Webhook GitLab Settings](./images/webhook-gitlab-settings.png)

In the URL field, paste the Webhook URL you copied while creating the webhook integration in AI/Run CodeMie. Specify the trigger events and save the changes. In our case, we set the comment event trigger only. You can also enable additional settings, such as SSL Verification. But note that they require additional efforts to set up. In GitLab, you can verify that webhook works properly by clicking the test button:

![Webhook GitLab Test](./images/webhook-gitlab-test.png)

## 7. Test Webhook

To test the webhook, we will create a merge request and put a comment into it:

![Webhook Merge Request](./images/webhook-merge-request.png)

## 8. Verify Integration

In the AI/Run CodeMie chat history, a new chat appears with a system message.

Now your assistant can be automatically triggered by external events through webhooks!
