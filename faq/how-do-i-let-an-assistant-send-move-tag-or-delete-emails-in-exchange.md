# How do I let an assistant send, move, tag or delete emails in Exchange?

Add the **Microsoft Exchange** toolkit to the assistant and select a Microsoft Exchange integration. The toolkit includes the write tools **Exchange: Send message**, **Exchange: Forward message**, **Exchange: Move message**, **Exchange: Tag message** and **Exchange: Delete message**.

The integration needs write permissions:

1. OAuth via Microsoft Entra ID Application: the application permission `Mail.ReadWrite` for move, tag and delete, and `Mail.Send` for send and forward, both with administrator consent.
2. NTLM: the **Full Access** permission for the service account on the mailbox, and **Send As** for send and forward.

A delete moves the message to Deleted Items unless the permanent delete is explicitly requested.

The write tools are never approved automatically. Set the **Guarded** or **Manual** tool-call policy for the assistant, because with **Auto** sends and deletes run without a confirmation.

Incoming mail can contain text that tries to steer the assistant, for example to forward messages to an outside address. Give recipient addresses in the assistant instructions or the workflow configuration, not from the content of a message. In a workflow, no one confirms a write.

## Sources

- [Microsoft Exchange](https://docs.codemie.ai/user-guide/tools_integrations/tools/ms-exchange/)
