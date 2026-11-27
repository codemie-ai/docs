---
id: index
title: API
sidebar_label: API
pagination_prev: user-guide/index
pagination_next: null
sidebar_position: 8
---

# Working with the CodeMie API

Below are the instructions for integrating with the CodeMie API/SDK. This guide demonstrates the process for authenticating and calling the API.

---

## Authentication Methods

There are two main ways to integrate with the CodeMie platform, depending on how you plan to use it:

### Client Password (User Credentials)

Use this method if you plan to work with the CodeMie SDK (Python, NodeJS). It relies on a specific user's credentials (username/password) and a configured Keycloak client.

[Learn more about User Password Access →](./user-password-access)

### Client Secret (Service Account)

Use this method for programmatic or backend access without relying on individual user credentials.

[Learn more about Client Secret Access →](./client-secret-access)

:::note
Enterprise customers supplied by scripts to create and manage User Password and Client Secret clients in Keycloak
:::

---

## Making API Requests

Once you obtain a valid token (from either authentication method), include it in the `Authorization` header of your requests.

```bash
curl -X POST "https://codemie.example.com/code-assistant-api/v1/assistants/05959338-06de-477d-9cc3-08369f858057/model" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer <your-access-token>" \
  -d '{
    "text": "hi"
  }'
```

**Response Example:**

```json
{
  "generated": "Hello! Welcome to CodeMie, your AI-powered SDLC assistant. 😊 How can I help you today?",
  "timeElapsed": 2.2828991413116455,
  "tokensUsed": null,
  "thoughts": [
    {
      "id": "105bd3e4-a861-495b-b817-847555651642",
      "parent_id": null,
      "metadata": {},
      "in_progress": false,
      "input_text": "",
      "message": "Hello! Welcome to CodeMie, your AI-powered SDLC assistant. 😊 How can I help you today?",
      "author_type": "Tool",
      "author_name": "Codemie Thoughts",
      "output_format": "text",
      "children": []
    }
  ],
  "taskId": null
}
```

---

## Using the API Example: Call Assistant

Once you have the JWT token, include it in the `Authorization` header of your API requests to interact with the CodeMie API/SDK.

### Endpoint

**POST** `/v1/assistants/{assistant_id}/model`

Call particular assistant for getting answers/tasks.

### Required Fields for Request Body

| Field                 | Type    | Required | Description                                                                                                                             |
| --------------------- | ------- | -------- | --------------------------------------------------------------------------------------------------------------------------------------- |
| **text**              | String  | Yes      | User's ask or question                                                                                                                  |
| **stream**            | Boolean | No       | Whether to stream response by chunks or return entire answer                                                                            |
| **llmModel**          | String  | No       | Can override LLM model for assistant. Default value is selected during assistant creation                                               |
| **propagate_headers** | Boolean | No       | Forward custom `X-*` HTTP headers to MCP tool invocations for context propagation                                                       |
| **attributes**        | Object  | No       | Custom string key/value labels for this conversation, used to find and segment runs in analytics. See [Run Attributes](#run-attributes) |

### Example Request Body

```json
{
  "text": "hi",
  "llmModel": "gpt-4.1",
  "stream": true
}
```

### Example with Header Propagation

When using assistants with MCP servers, you can propagate custom HTTP headers to enable context-aware tool invocations. This is useful for multi-tenant scenarios, request tracing, or passing user-specific context.

```bash
curl -X POST "https://codemie.example.com/code-assistant-api/v1/assistants/{assistant_id}/chat" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer <your-access-token>" \
  -H "X-Tenant-ID: acme-corp" \
  -H "X-Correlation-ID: trace-123" \
  -H "X-User-Context: engineering-team" \
  -d '{
    "text": "List all deployments in production environment",
    "propagate_headers": true
  }'
```

**How it works:**

1. Custom `X-*` headers (`X-Tenant-ID`, `X-Correlation-ID`, `X-User-Context`) are included in the HTTP request
2. `propagate_headers: true` enables header forwarding to MCP servers
3. When the assistant calls MCP server tools, these headers are automatically passed along
4. The MCP server can use these headers for tenant isolation, tracing, or authorization

**Common use cases:**

- **Multi-tenancy**: Pass `X-Tenant-ID` to scope MCP tool responses to a specific tenant
- **Request tracing**: Use `X-Correlation-ID` to track requests across services
- **User context**: Forward `X-End-User-ID` or `X-User-Role` for access control

:::tip
For workflow executions, you can also enable header propagation:

```bash
POST /v1/workflows/{workflow_id}/executions
X-Tenant-ID: my-tenant

{
  "user_input": "Run deployment check",
  "propagate_headers": true
}
```

:::

[Learn more about MCP Header Propagation →](../tools_integrations/tools/mcp/adding-an-mcp-server#propagating-client-headers-to-mcp-servers)

---

## Execute Workflow

Start a workflow execution programmatically via the API or SDK.

### Endpoint

**POST** `/v1/workflows/{workflow_id}/executions`

### Request Body

| Field                 | Type      | Required | Description                                                                                                                          |
| --------------------- | --------- | -------- | ------------------------------------------------------------------------------------------------------------------------------------ |
| **user_input**        | String    | No       | Input text or data passed to the workflow                                                                                            |
| **tags**              | String\[] | No       | Tags attached to the Langfuse execution trace for filtering and analytics. Does not affect execution behavior                        |
| **session_id**        | String    | No       | Session identifier for Langfuse tracing. Defaults to `execution_id` if not provided                                                  |
| **propagate_headers** | Boolean   | No       | Forward custom `X-*` HTTP headers to MCP tool invocations                                                                            |
| **file_name**         | String    | No       | File name associated with the workflow execution                                                                                     |
| **attributes**        | Object    | No       | Custom string key/value labels for this execution, used to find and segment runs in analytics. See [Run Attributes](#run-attributes) |

### API Example

```http
POST /v1/workflows/{workflow_id}/executions
Content-Type: application/json
Authorization: Bearer <your-access-token>

{
  "user_input": "Run deployment check",
  "tags": ["experiment", "customer_X"]
}
```

### Python SDK Example

```python
result = client.workflows.run(
    workflow_id="<workflow-id>",
    user_input="Run deployment check",
    tags=["experiment", "customer_X"],
)
```

### Node.js SDK Example

`tags` is the 7th positional argument in `run()`. Pass `undefined` to skip optional arguments before it:

```typescript
const result = await client.workflows.run(
  "<workflow-id>",
  "Run deployment check", // userInput
  undefined,              // fileName
  undefined,              // sessionId
  undefined,              // propagateHeaders
  undefined,              // headers
  ["experiment", "customer_X"], // tags
);
```

:::info
Tags appear in the Langfuse **Traces** view and can be used to filter and group executions by any label you choose, for example `"prod"`, `"nightly"`, or `"customer_X"`.
:::

---

## Run Attributes

Run attributes are custom labels attached to one assistant conversation or one workflow execution. Each attribute is a string key with a string value, for example `com.epam.gen_ai.service.work_item.id` with the value `ABC-123`. Attributes identify individual runs after the fact. With the [analytics run attributes](../analytics/run-attributes.md) endpoints, runs can be found, filtered, and grouped by these values.

Attributes can be supplied on any CodeMie deployment. Reading them back in analytics requires the Enterprise package.

### Where Attributes Can Be Set

| Run type               | How to set                                                                                                                                         |
| ---------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------- |
| Assistant conversation | `attributes` field of the request body of `POST /v1/assistants/{assistant_id}/model` (see [Call Assistant](#using-the-api-example-call-assistant)) |
| Workflow execution     | `attributes` field of the request body of `POST /v1/workflows/{workflow_id}/executions` (see [Execute Workflow](#execute-workflow))                |

### Example: Assistant Conversation

```bash
curl -X POST "https://codemie.example.com/code-assistant-api/v1/assistants/{assistant_id}/model" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer <your-access-token>" \
  -d '{
    "text": "Summarize the open pull requests",
    "attributes": {
      "com.epam.gen_ai.service.work_item.id": "ABC-123",
      "team": "alpha"
    }
  }'
```

### Example: Workflow Execution

```bash
curl -X POST "https://codemie.example.com/code-assistant-api/v1/workflows/{workflow_id}/executions" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer <your-access-token>" \
  -d '{
    "user_input": "Run deployment check",
    "attributes": {
      "com.epam.gen_ai.service.work_item.id": "ABC-123"
    }
  }'
```

### SDK Examples

**Python SDK:**

```python
from codemie_sdk.models.assistant import AssistantChatRequest

# Assistant conversation
response = client.assistants.chat(
    assistant_id="<assistant-id>",
    request=AssistantChatRequest(
        text="Summarize the open pull requests",
        attributes={"com.epam.gen_ai.service.work_item.id": "ABC-123"},
    ),
)

# Workflow execution
result = client.workflows.executions("<workflow-id>").create(
    user_input="Run deployment check",
    attributes={"com.epam.gen_ai.service.work_item.id": "ABC-123"},
)
```

**Node.js SDK** (`attributes` is the 7th positional argument of the execution `create()` method):

```typescript
// Assistant conversation
const response = await client.assistants.chat("<assistant-id>", {
  text: "Summarize the open pull requests",
  attributes: { "com.epam.gen_ai.service.work_item.id": "ABC-123" },
});

// Workflow execution
const result = await client.workflows.executions("<workflow-id>").create(
  "Run deployment check", // userInput
  undefined,              // fileName
  undefined,              // sessionId
  undefined,              // propagateHeaders
  undefined,              // headers
  undefined,              // tags
  { "com.epam.gen_ai.service.work_item.id": "ABC-123" }, // attributes
);
```

:::note
The `workflows.run()` method of the Python SDK does not accept `attributes`. Use `workflows.executions(<workflow-id>).create()` to set them.
:::

### Validation Rules

The SDKs do not validate attributes. The server applies the following rules and returns `422` without starting the run when any of them is violated.

| Rule                  | Limit                                                                                                              |
| --------------------- | ------------------------------------------------------------------------------------------------------------------ |
| **Number of keys**    | At most 4 attributes per run. The limit is configurable by the platform administrator                              |
| **Key format**        | 2 to 64 characters. Lowercase letters, digits, `.`, `_`, and `-` only. Must start and end with a letter or a digit |
| **Reserved prefixes** | Keys must not start with `codemie.` or `otel.`                                                                     |
| **Value type**        | String only. Numbers, booleans, and nested objects are rejected                                                    |
| **Value length**      | 1 to 128 characters (counted as UTF-16 code units). Empty values are rejected                                      |
| **Value content**     | Control characters and unpaired surrogates are rejected                                                            |

### Behavior

- **Fixed at start.** Attributes cannot be added, changed, or removed after a conversation or execution starts.
- **Conversations.** Attributes are stored when the conversation starts. Later messages of the same conversation can omit attributes or repeat the same ones. Sending different attributes for a conversation that already has history returns `422`. A conversation started without attributes cannot receive them later once it has history.
- **Chats without history.** When `save_history` is `false`, no conversation is stored and no usage record is written. The attributes are validated and then ignored.
- **Workflow executions.** A resumed execution keeps its attributes. Sub-workflows started by the execution inherit the attributes of the parent execution.
- **Same conversation, several executions.** Each execution takes only the attributes of its own request. Executions that continue the same `conversation_id` neither inherit nor are checked against the attributes of earlier executions.
- **No attributes.** Runs without attributes behave exactly as before and appear in analytics unchanged. Runs started before the feature was released cannot be labelled retroactively.
- **Reading attributes back.** The conversation details (`GET /v1/conversations/{id}`) and workflow execution details (`GET /v1/workflows/{workflow_id}/executions/{execution_id}`) return `attributes` to any user who can read the run. The value is `null` when the run has none. For workflow conversations, `attributes` on the conversation is always `null`, because workflow attributes are stored on each execution.

### Attributes Versus Prompt Context and Tags

Run attributes are analytics labels only. They are never passed to the assistant, its tools, or the workflow, and they do not influence how a run behaves.

| Need                                                | Use                                                  |
| --------------------------------------------------- | ---------------------------------------------------- |
| Label a run for later analysis in CodeMie analytics | `attributes`                                         |
| Pass context or values into the assistant           | `metadata` or `prompt_variables` of the chat request |
| Pass input into a workflow                          | `user_input` of the workflow execution request       |
| Label a workflow trace in Langfuse                  | `tags` (see [Execute Workflow](#execute-workflow))   |

:::warning Do not store secrets or personal data
Attribute values are stored with the run, written to usage metrics and application logs, and shown to every user who can see the run or its usage analytics. Values must not contain secrets, tokens, or personal data. Values are declared by the caller and are not verified, so analytics totals grouped or filtered by attributes are only as reliable as the labelling.
:::

---

## Success Response

**Status code:** `200`

### Example: stream is false

```json
{
  "generated": "Hello! How can I assist you today?",
  "timeElapsed": 1.1063213348388672,
  "tokensUsed": null,
  "taskId": null
}
```

### Example: stream is true

When `stream: true`, the response is sent as Server-Sent Events (SSE). Each chunk is delivered incrementally until the complete response is assembled.

---

## Error Responses

| Status Code | Description                                          |
| ----------- | ---------------------------------------------------- |
| **400**     | Bad Request                                          |
| **401**     | Request is not authorized                            |
| **403**     | Consumer does not have permissions to make request   |
| **404**     | Resource does not exist                              |
| **422**     | Validation error, for example invalid run attributes |
| **500**     | Server error                                         |
