# What does an "Unknown" result from an Exchange write tool mean?

An error message that contains `Unknown.` means that the change may or may not have been made, for example because the connection was lost or the server did not respond after the request was submitted. A message that contains `Not applied.` means that the mailbox is unchanged.

After `Unknown.`, check the mailbox before repeating the operation. For send and forward, check the Sent Items folder, because repeating the request can send a second message. In chat, the assistant can call the tool again on its own, so tell it in the instructions not to repeat a send after `Unknown.`.

## Sources

- [Microsoft Exchange: Not Applied and Unknown](https://docs.codemie.ai/user-guide/tools_integrations/tools/ms-exchange/#not-applied-and-unknown)
