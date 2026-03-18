# CodeMie assistants webhooks? CodeMie workflows webhooks? CodeMie workflow triggers? CodeMie assistants triggers?

CodeMie assistants and Workflows can be triggered using webhooks. It means that all the tools that support sending webhooks can be integrated with CodeMie. Below is a list of some examples where webhooks can be beneficial:

Examples where webhooks are beneficial:

1. Automatically trigger a code review assistant when developers create pull requests.

2. Send real-time notifications via workflow when issues are created, updated, or resolved in Jira.

3. Trigger a customer support assistant when a new support ticket is created in your helpdesk system.

To create a webhook integrations (Project Admins only)application-admins to request permission you can create support request ticket [https://support.epam.com/ess?id=sc_cat_item\&sys_id=a914679897ffd910386e3a871153afca\&name=RequestHelpOrConsultation\&sysparm_copy_vars=%7B%22u_warning%22%3A%22%22%2C%22confrmation%22%3A%22false%22%2C%22u_topic%22%3A%2234cec5fd1b4d8a5c934e32649b4bcb63%22%7D](https://support.epam.com/ess?id=sc_cat_item&sys_id=a914679897ffd910386e3a871153afca&name=RequestHelpOrConsultation&sysparm_copy_vars=%7B%22u_warning%22%3A%22%22%2C%22confrmation%22%3A%22false%22%2C%22u_topic%22%3A%2234cec5fd1b4d8a5c934e32649b4bcb63%22%7D), follow the steps below:

1. Create the assistant you want to react to webhooks.

2. In the Assistants -> Project Assistants list, click the assistant name to copy its ID.

3. (Optional) Create a Workflow or Datasource – these resource types also support webhooks.

## 4. Select Integration Type: User or Project and click Create

5. On the New Project integrations page, fill in the fields to create a webhook:

- \***\*Project Name:\*\*** Specify project name.

- \***\*Credential Type:\*\*** Select Webhook.

- \***\*Alias:\*\*** integrations name.

- \***\*Webhook ID, Access Key ID, Secure Header Name/Value, Resource type, Resource ID:** Complete as instructed.

6. Copy the Webhook URL for use in your external tool.

7. Configure your external tool (e.g., GitLab, Jira) with the Webhook URL and select trigger events as needed.

In the URL field, paste the Webhook URL you copied while creating the webhook integrations in CodeMie. Specify the trigger events and save the changes. In our case, we set the comment event trigger only.

You can also enable additional settings, such as SSL Verification. But note that they require additional efforts to set up.

In GitLab, you can verify that webhook works properly by clicking the test button

8. To test that webhook, we will create a merge request and put a comment into it.

9. In the CodeMie chat history, a new chat appears with a system message.

CodeMie assistants and Workflows can be triggered using webhooks – all tools and services that support sending webhooks can integrate with CodeMie assistants and Workflows.

As of version 1.1.0, only users with the Project Admin role can create and manage Webhook integrations. User-level Webhook integrations are no longer supported. If you are not a Project Admin, the "Webhook" option will not appear for you, and any previous user-level Webhook integrations you created will no longer function.

What if I am not a Project Admin?  
If you attempt to access or create a Webhook integrations as a non-admin, you will see a notification similar to:

> “Webhook integrations is now restricted to Project Admins. Please contact your project administrator if you need access.”  
> Previous user-level Webhook integrations created by non-admins are now restricted and will not function.  
> **If you have any questions about integrations permissions, contact your project admin or see Managing Project Admin Roles.**

## Sources

- [Webhook](https://docs.codemie.ai/user-guide/tools_integrations/tools/webhook)
- [Scheduler](https://docs.codemie.ai/user-guide/tools_integrations/tools/scheduler)
