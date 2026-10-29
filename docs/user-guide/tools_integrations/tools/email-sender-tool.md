---
id: email-sender-tool
title: Email Toolkit
sidebar_label: Email Toolkit
pagination_prev: user-guide/tools_integrations/tools/overview
pagination_next: null
sidebar_position: 14
---

<!-- cspell:words UIDVALIDITY UIDPLUS -->

# Email Toolkit

The Email toolkit lets your assistant read emails and attachments, send messages, and organize messages in mailbox folders. You can enable receiving, sending, or both in the same integration.

## 1. Configure an Email integration

1. Open **Integrations**, choose **User** or **Project**, and click **+ Create**.
2. Select **Email** as the credential type, choose your project, and enter an alias, such as `support-mailbox`.
3. Enable the capabilities you need:
   - **Receive emails (IMAP)** to list, read, copy, move, or delete messages.
   - **Send emails (SMTP)** to send messages.
4. Fill in the mail server and authentication settings below. At least one capability must be enabled.
5. Click **Test Integration** to check the connection, then save the integration. The test does not send an email.

### Mail server settings

Ask your mail administrator for the server addresses and mailbox permissions if you are unsure which values to use.

| Setting         | When to provide it                                                                   |
| --------------- | ------------------------------------------------------------------------------------ |
| IMAP server     | When receiving is enabled. Use `host:port`, for example `outlook.office365.com:993`. |
| Mailbox address | When receiving is enabled. The email address of the mailbox you want to read.        |
| SMTP server     | When sending is enabled. Use `host:port`, for example `smtp.office365.com:587`.      |
| Sender address  | When sending is enabled. The email address to send messages from.                    |

The login account can differ from the mailbox or sender address, for example when accessing a shared mailbox. Your mail administrator must grant the account permission to use those addresses.

### Authentication

- **Basic**: enter your username and password. Use an app password if your mail provider requires one and your organization allows it.
- **Microsoft Entra ID OAuth**: enter the tenant ID, client ID, and client secret supplied by your administrator. The application needs permission to access the mailbox and use the enabled mail protocols.

If your organization disables Basic authentication or app passwords, ask your administrator which method to use.

:::note Private or corporate mail servers
CodeMie checks the mail server's security certificate. If your server uses a private certificate authority (CA), ask your administrator to add that CA to the CodeMie runtime's trust store. Invalid, expired, or untrusted certificates prevent the connection.
:::

## 2. Add Email tools to an assistant

1. Create or edit an assistant.
2. In its tool selection, expand **Email**.
3. Select the tools you need from the table below.
4. Choose the integration alias you created, then save the assistant.

For a workflow Tool state, select the desired Email tool and its integration alias. Receiving must be enabled for mailbox tools; sending must be enabled for Send Email.

| Tool                                                | What it does                                                              |
| --------------------------------------------------- | ------------------------------------------------------------------------- |
| **List Email Folder** (`list_email_folder`)         | Lists message IDs in a folder, one page at a time. Uses Inbox by default. |
| **Read Email** (`read_email`)                       | Reads a message and lists its attachments.                                |
| **Read Email Attachment** (`read_email_attachment`) | Reads the content of a supported attachment.                              |
| **Copy Email** (`copy_email`)                       | Copies a message to an existing folder.                                   |
| **Move Email** (`move_email`)                       | Moves a message to an existing folder.                                    |
| **Delete Email** (`delete_email`)                   | Permanently deletes a message.                                            |
| **Send Email** (`send_email`)                       | Sends an email, with optional CC and BCC recipients.                      |

Give an assistant only the tools it needs. For example, an assistant that summarizes emails can use the three reading tools without permission to send or delete messages.

## 3. Use your assistant

Once the integration and tools are configured, you can ask your assistant to:

**List messages:**

> "List the first 10 message IDs in my Inbox."

**Read a message:**

> "Read the first message from that list and summarize it."

**Read an attachment:**

> "List the attachments on that message and summarize the PDF attachment."

**Move a message:**

> "Move that message to the Processed folder."

Create the destination folder in your mail application before asking the assistant to move or copy a message.

**Send a message:**

> "Draft an email to colleague@example.com with the subject 'Meeting notes' and the summary above. Show me the draft and ask for my approval before sending."

For a complete workflow that generates an onboarding email and pauses for approval before sending it, see the [human-in-the-loop workflow example](../../workflows/configuration/examples.md#115-example-human-in-the-loop-workflow-interrupt_before).

## Supported content and limits

Email bodies are returned as Markdown by default. You can disable **Convert body to Markdown** when you need the original HTML representation. Plain-text bodies are unchanged.

Supported attachments include text files, HTML, PDF, Word (`.docx`), PowerPoint (`.pptx`), Excel, and PNG/JPEG/GIF/WebP images. Documents without extractable text and unsupported formats return an error.

| Content            | Maximum size |
| ------------------ | ------------ |
| Email message      | 25 MiB       |
| Decoded attachment | 10 MiB       |
| Image attachment   | 5 MiB        |

Assistant calls can pass supported images to the model for visual analysis. Workspace scripts and direct workflow Tool states receive images as base64; avoid storing large image results in workflow context when they are not needed.

:::warning Permanent deletion
Delete Email permanently removes the selected message. Moving it to a review folder is preferable when recovery may be needed. The tool description asks for confirmation, but does not enforce an approval step. Configure the applicable tool approval policy or workflow control before allowing destructive actions.
:::

## Workflow and API reference

Use the exact `email_id` returned by a listing or another Email tool. After moving a message, use its returned `destination_email_id`; if that value is missing, list the destination folder to obtain the new ID. Copying leaves the source ID valid.

`read_email` returns attachment IDs and `encoded_size_bytes` (the MIME-encoded size, or `null` when unavailable). Pass `email_id` and `attachment_id` to `read_email_attachment` to retrieve its content and decoded `size_bytes`. Text files return text; HTML and supported documents return Markdown.

### List messages with pagination

`list_email_folder` reads `Inbox` when `folder` is omitted and returns IDs in ascending IMAP UID order. `limit` defaults to 1,000 and accepts values from 1 to 1,000.

For the first page, omit `cursor`:

```json
{
  "folder": "Inbox",
  "limit": 2
}
```

The result can be:

```json
{
  "folder": "Inbox",
  "email_items": [
    { "email_id": "imap:Inbox:12345:10" },
    { "email_id": "imap:Inbox:12345:11" }
  ],
  "has_more": true,
  "next_cursor": "imap:Inbox:12345:11"
}
```

When `has_more` is `true`, call the tool again with the same folder and pass `next_cursor` as `cursor`. Treat the cursor as a continuation value and pass it unchanged. It marks the last message already returned, so the next page starts strictly after that message in IMAP UID order. On the final page, `has_more` is `false` and `next_cursor` is `null`.

For the example above, the next call's arguments are:

```json
{
  "folder": "Inbox",
  "limit": 2,
  "cursor": "imap:Inbox:12345:11"
}
```

Continue using each page's returned `next_cursor` until `has_more` is `false`. An empty folder returns `email_items: []`, `has_more: false`, and `next_cursor: null`.

You can move or delete processed messages before requesting the next page: the continuation message does not need to remain in the source folder. The continuation must refer to the same folder and UIDVALIDITY. If the mailbox's UIDVALIDITY changes, discard the continuation and start a new listing.

Pages reflect the current mailbox, not a fixed snapshot. Start each new scheduled processing run **without** `cursor` so that earlier messages left for retry are not skipped. This continuation is for paging within a run, not a durable processing checkpoint.

### Sending and mailbox operations

`send_email` requires `recipient_emails` as a non-empty list, plus `subject` and `body`. The body can contain HTML. Optional arguments are `cc_emails`, `bcc_emails`, `from_email`, and `timeout` (30 seconds by default).

If `from_email` is omitted, the integration's sender address is used. An override requires permission from the SMTP server.

A sending failure raises a tool error. A direct workflow Tool state can stop the run on that error; do not assume that the next state will execute. Agent-mediated tool error handling follows the agent's execution policy.

Moving requires the server's IMAP `MOVE` capability. Deleting requires `UIDPLUS` for deletion that affects only the selected message; the tool fails before marking the message for deletion if this capability is unavailable. Delete Email is unavailable through workspace-script calls.

### Connection settings

IMAP uses TLS, and SMTP uses STARTTLS. Both verify the server certificate and hostname. The integration test checks each enabled capability: IMAP connects and selects Inbox; SMTP connects and authenticates without sending. A successful test does not guarantee access to every folder or permission to use a different sender address.

Microsoft Entra authentication uses `https://login.microsoftonline.com` as the default authority and `https://outlook.office365.com/.default` as the default scope.

## Untrusted email content and prompt injection

:::warning Treat message content as data
Email bodies, subjects, sender display names, and attachment contents are untrusted input, even when retrieved from an authorized mailbox. They can contain instructions intended to make an assistant forward confidential data, change recipients, or delete messages. A sender display name is not proof of identity. Markdown conversion does not make the content safe or prevent prompt injection.
:::

When building an agent or an unattended workflow:

- Give the reading or classification assistant only the tools necessary for analysis. Separate classification from sending, moving, or deleting messages.
- State in the assistant's system prompt that message and attachment contents are data, not authority to change its role, tool policy, recipients, routing rules, or output schema.
- Validate the classification result against a fixed set of allowed outcomes. A classifier or a system prompt alone is not an enforcement boundary.
- Keep permitted recipients, destination folders, and action mappings in trusted configuration. Apply recipient restrictions to To, CC, and BCC. The Email tool does not automatically enforce a recipient allowlist.
- Execute approved actions in explicit workflow states or another controlled execution path. Validate any message-derived arguments before using them, and require review for sensitive actions where appropriate.
- Avoid logging credentials, full message bodies, or attachment contents.

These precautions also apply when external content comes from other tools. For example, a scraped web page can contain instructions even after conversion to Markdown.

## Scheduled mailbox processing

Use an existing [Scheduler](../../schedulers/create-scheduler.md) to invoke an assistant or workflow periodically. The Email toolkit itself does not create an incoming-mail webhook or start a background mailbox watcher.

A folder can act as a visible queue. Create source and destination folders, then configure this processing pattern:

```text
Scheduler
  → list_email_folder(Unprocessed)
  → for each message:
      read → classify → validate result
      → perform approved action
      → move successful messages to Processed
```

Each scheduled run can process a limited batch. Messages not processed remain in the source folder for the next run. Start each run without `cursor` so it picks up the messages still waiting. Keep the current `email_id` isolated for each message, especially if processing items in parallel.

This pattern provides **at-least-once processing**, not exactly-once delivery. An action can succeed and the subsequent move can fail, leaving the message to be processed again. Use an idempotency key or durable record of completed business actions to prevent duplicate effects. Do not rely on moving the message as the only proof that its business action completed.

It is recommended to use **Move Email** to move messages that fail processing to a dedicated folder, such as Errors, for manual review. This helps prevent those messages from blocking subsequent runs. Create the destination folder in your mail application first.
