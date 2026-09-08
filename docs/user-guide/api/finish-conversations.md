---
id: finish-conversations
title: Finish Conversations
sidebar_label: Finish Conversations
sidebar_position: 3
pagination_prev: user-guide/api/index
pagination_next: null
---

# Finish Conversations

A conversation can be marked **finished** so it no longer accepts new or edited messages. History remains readable. Finishing is a platform API capability for custom applications and schedulers — for example, closing chats that are considered stale to reduce hallucination risk on very long threads.

CodeMie does not automatically finish conversations after a period of time. Any close-after-N-hours policy belongs in an external job that calls the APIs on this page.

Finishing is not the same as [deleting a chat](../assistants/delete-assistants-and-chats.md). Deleted conversations are removed. Finished conversations stay in history and can still be renamed, pinned, moved between folders, shared, rated, or deleted.

## Finished state

A conversation is finished when `finished_at` is set. An active conversation has `finished_at` of `null`.

Read, list, and search responses expose this timestamp in **snake_case** as `finished_at`. Finish-endpoint responses use **camelCase** (`finishedAt`, `conversationId`).

| Source                                                                                                               | Field         | Meaning                                                            |
| -------------------------------------------------------------------------------------------------------------------- | ------------- | ------------------------------------------------------------------ |
| `GET /v1/conversations`, `GET /v1/conversations/{id}`, `GET /v1/conversations/search`, `GET /v1/admin/conversations` | `finished_at` | Timestamp the conversation was finished, or `null` if still active |
| `POST .../finish` and `POST .../finish-bulk`                                                                         | `finishedAt`  | Same timestamp on the finish payload                               |

Query filters use the camelCase alias `isFinished`:

- `isFinished=true` — conversations where `finished_at` is set
- `isFinished=false` — conversations where `finished_at` is `null`

## Authentication

Requests require a Bearer token. See [Working with the CodeMie API](./index.md) for how to obtain one.

| Endpoint                                          | Who can call it                        |
| ------------------------------------------------- | -------------------------------------- |
| `POST /v1/conversations/{conversation_id}/finish` | Conversation owner (`WRITE`)           |
| `GET /v1/conversations` with `isFinished`         | Authenticated user (own conversations) |
| `POST /v1/admin/conversations/finish-bulk`        | Platform administrator                 |
| `GET /v1/admin/conversations`                     | Platform administrator                 |

Base URL in the examples below: `https://codemie.example.com/code-assistant-api`.

## Finish a conversation (owner)

**POST** `/v1/conversations/{conversation_id}/finish`

Marks one conversation as finished. The caller must have write access (the owner).

### Success response

**Status code:** `200`

```json
{
  "conversationId": "8d3d3296-0251-4dd2-ba36-88024ebda9da",
  "finishedAt": "2026-08-11T12:00:00"
}
```

The payload does not include an `alreadyFinished` flag.

### Example

```bash
curl -X POST "https://codemie.example.com/code-assistant-api/v1/conversations/<conversation_id>/finish" \
  -H "Authorization: Bearer <access-token>"
```

### Error responses

| Status code | When                              |
| ----------- | --------------------------------- |
| **403**     | Caller does not have write access |
| **404**     | Conversation does not exist       |
| **409**     | Conversation is already finished  |

A second finish of the same conversation returns HTTP 409 rather than repeating the `200` payload.

## Finish conversations in bulk (admin)

**POST** `/v1/admin/conversations/finish-bulk`

Finishes many conversations in one request. Each ID is handled independently: a missing ID does not fail the rest of the batch.

### Request body

| Field               | Type      | Required | Description                                        |
| ------------------- | --------- | -------- | -------------------------------------------------- |
| **conversationIds** | String\[] | Yes      | Conversation IDs to finish. Minimum 1, maximum 500 |

```json
{
  "conversationIds": [
    "8d3d3296-0251-4dd2-ba36-88024ebda9da",
    "a1b2c3d4-e5f6-7890-abcd-ef1234567890"
  ]
}
```

### Success response

**Status code:** `200`

```json
{
  "total": 3,
  "results": [
    {
      "conversationId": "8d3d3296-0251-4dd2-ba36-88024ebda9da",
      "alreadyFinished": false,
      "finishedAt": "2026-08-11T12:00:00",
      "error": null
    },
    {
      "conversationId": "already-closed-id",
      "alreadyFinished": true,
      "finishedAt": "2026-07-01T09:00:00",
      "error": null
    },
    {
      "conversationId": "missing-id",
      "alreadyFinished": false,
      "finishedAt": null,
      "error": "not_found"
    }
  ]
}
```

| Result field                                             | Meaning                              |
| -------------------------------------------------------- | ------------------------------------ |
| `alreadyFinished: false`, `finishedAt` set, `error` null | Newly finished in this request       |
| `alreadyFinished: true`, `finishedAt` set, `error` null  | Already finished; treated as success |
| `error: "not_found"`                                     | No conversation with that ID         |

### Example

```bash
curl -X POST "https://codemie.example.com/code-assistant-api/v1/admin/conversations/finish-bulk" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer <admin-access-token>" \
  -d '{
    "conversationIds": [
      "8d3d3296-0251-4dd2-ba36-88024ebda9da",
      "a1b2c3d4-e5f6-7890-abcd-ef1234567890"
    ]
  }'
```

## List conversations for a scheduler (admin)

**GET** `/v1/admin/conversations`

Paginated list of conversations across all users, ordered by creation date ascending (oldest first). Intended for jobs that find unfinished conversations and then call bulk finish.

### Query parameters

| Parameter      | Type      | Default       | Description                                 |
| -------------- | --------- | ------------- | ------------------------------------------- |
| **isFinished** | Boolean   | omitted (all) | `true` for finished, `false` for unfinished |
| **startedAt**  | Date-time | omitted       | Lower bound on conversation start time      |
| **project**    | String    | omitted       | Restrict results to one project             |
| **page**       | Integer   | `0`           | 0-based page index                          |
| **perPage**    | Integer   | `20`          | Page size (1–200)                           |

### Example

```bash
curl -G "https://codemie.example.com/code-assistant-api/v1/admin/conversations" \
  -H "Authorization: Bearer <admin-access-token>" \
  --data-urlencode "isFinished=false" \
  --data-urlencode "startedAt=2026-01-01T00:00:00" \
  --data-urlencode "project=my-project" \
  --data-urlencode "page=0" \
  --data-urlencode "perPage=100"
```

Each item in `data` includes `finished_at`. Pagination metadata uses `page`, `per_page`, `total`, and `pages`.

## Filter a user's own conversation list

**GET** `/v1/conversations`

The same `isFinished` query parameter is available on the authenticated user's conversation list.

```bash
curl -G "https://codemie.example.com/code-assistant-api/v1/conversations" \
  -H "Authorization: Bearer <access-token>" \
  --data-urlencode "isFinished=false"
```

Optional `page` and `per_page` query parameters paginate the list (0-based `page`, default page size 20, maximum 200). When both pagination parameters are omitted, the full list is returned.

`GET /v1/conversations/{conversation_id}` and `GET /v1/conversations/search` include `finished_at` on conversation (chat) results. Search folder hits leave `finished_at` unset.

## What is blocked after finish

Further **message content** changes return HTTP **409 Conflict**. The guard runs on:

- Assistant chat send (before a new model response is generated)
- Conversation history import (`PUT /v1/conversations/{conversation_id}/history`)
- AI message edits
- Deleting a history turn or clearing conversation history
- Workflow chat execution and workflow resume on that conversation

Typical 409 body:

```json
{
  "error": {
    "message": "Conversation is finished",
    "details": "This conversation was closed and can no longer receive new messages (id=<conversation_id>).",
    "help": "Start a new conversation to continue."
  }
}
```

The following remain allowed on a finished conversation: pin, rename, move folder, share, submit or remove feedback, and delete the conversation.

:::tip Scheduler pattern

1. List unfinished conversations with `GET /v1/admin/conversations?isFinished=false` (add `startedAt` and `project` as needed).
2. Finish the returned IDs with `POST /v1/admin/conversations/finish-bulk`.
3. Repeat on the next page until no unfinished rows remain.
   :::
