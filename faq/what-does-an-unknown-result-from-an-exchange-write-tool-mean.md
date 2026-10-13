# What does an "Unknown" result from an Exchange write tool mean?

A message that starts with `Unknown.` means that the change may or may not have been made, for example because the connection was lost or the server did not respond after the request was submitted. A message that starts with `Not applied.` means that the mailbox is unchanged.

After `Unknown.`, check the mailbox before repeating the operation. For send and forward, check the Sent Items folder, because repeating the request can send a second message. The toolkit never repeats a send or forward automatically, and it does not turn a failed default delete into a permanent delete.

## Sources

- [Microsoft Exchange](https://docs.codemie.ai/user-guide/tools_integrations/tools/ms-exchange/)
