# How is a conversation finished so it cannot receive new messages?

A conversation is finished through the CodeMie API, not through a chat UI control. The conversation owner calls `POST /v1/conversations/{conversation_id}/finish`. Platform administrators can finish many conversations at once with `POST /v1/admin/conversations/finish-bulk`.

After finish, sending or editing messages returns HTTP 409 Conflict. History stays readable. Pin, rename, share, feedback, and delete remain allowed. Finishing is not the same as deleting a chat.

A conversation is finished when `finished_at` is set (`null` means it is still active). List, get, and search responses include this field.

## Sources

- [Finish Conversations](https://docs.codemie.ai/user-guide/api/finish-conversations)
- [Delete Assistants and Chats](https://docs.codemie.ai/user-guide/assistants/delete-assistants-and-chats)
