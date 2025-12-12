---
id: index
title: API
sidebar_label: API
sidebar_position: 8
pagination_next: null
pagination_prev: null
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
You can use scripts to create and manage User Password and Client Secret clients in Keycloak:

- [User Password Script](https://github.com/epam-gen-ai-run/ai-run-install/tree/main/scripts/keycloak_sdk)
- [Client Secret Script](https://github.com/epam-gen-ai-run/ai-run-install/tree/main/scripts/keycloak_api_client)
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

| Field        | Type    | Required | Description                                                                               |
| ------------ | ------- | -------- | ----------------------------------------------------------------------------------------- |
| **text**     | String  | Yes      | User's ask or question                                                                    |
| **stream**   | Boolean | No       | Whether to stream response by chunks or return entire answer                              |
| **llmModel** | String  | No       | Can override LLM model for assistant. Default value is selected during assistant creation |

### Example Request Body

```json
{
  "text": "hi",
  "llmModel": "gpt-4o",
  "stream": true
}
```

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

| Status Code | Description                                        |
| ----------- | -------------------------------------------------- |
| **400**     | Bad Request                                        |
| **401**     | Request is not authorized                          |
| **403**     | Consumer does not have permissions to make request |
| **404**     | Resource does not exist                            |
| **500**     | Server error                                       |
