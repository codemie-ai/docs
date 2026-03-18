# How to send messages by email from codemie? How to integrate email with CodeMie?

To integrate Email with CodeMie.

1. In the CodeMie main menu, click the Integrations button.
2. Select Integration Type: User or Project and click Create.
3. Select the Project Name.
4. Select the Credential Type: Email.
5. Fill in the Alias is a representation of the user setting.
6. Fill in the SMTP server Url: in pattern url:port
7. Fill in the SMTP Server Username: account username
8. Fill in the SMTP Server Password: account password
9. Click Create Integration.
10. Create or edit assistant.
11. Click Explore Assistant, Click Create Assistant fill in the following parameters:

- Project Name: Select the name of your project.
- Name: Specify the assistant name.
- Description: Specify description.
- System Instructions: Specify system instructions.
- Available tools: Notification and select from drop down list Email.

12. Click Create.

## Sending Emails

Basic Email  
To send a basic email message, you need to provide:

- Email address (To field)
- Subject
- Text of email

Using CC Field  
When you need to include additional recipients without adding them to the primary recipient list, you can use the CC (Carbon Copy) field:

- Email address (To field): Specify the primary recipient(s)
- CC field: Specify the secondary recipient(s) who should receive a copy
- Subject: Specify the subject of the email
- Text: Provide the content of the email

**Example**:  
To send an email with CC recipients, include both the "To" and "CC" parameters in your request.

**Use Cases**:

- Keeping stakeholders informed without making them primary recipients
- Sending project updates to team members while CCing managers or other departments
- Ensuring multiple parties receive the same information simultaneously

Example: To send a message you need to provide an email address, subject and text of email.

## Sources

- [Email Sender Tool](https://docs.codemie.ai/user-guide/tools_integrations/tools/email-sender-tool)
