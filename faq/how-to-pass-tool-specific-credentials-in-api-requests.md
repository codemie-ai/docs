# How to pass tool-specific credentials in API requests? How to pass Tool Credentials via endpoint with toolsConfig?

## Content:

## Passing Tool Credentials via API

CodeMie's `https://codemie.lab.epam.com/code-assistant-api/v1/assistants/model` endpoint supports dynamic passing of tool credentials through API requests. This feature enables multi-tenant use cases, allowing the same assistant to be used by different users with their individual tool credentials.

What is the toolsConfig feature?

The `toolsConfig` field in the `/assistants/model` endpoint allows you to:

- Provide credentials for multiple tools in a single API call
- Use your own authentication details instead of global/static tokens
- Isolate credentials between different users and requests
- Support custom integrations with varying external system authorizations

## Request Structure

To pass tool credentials, include the `toolsConfig` field in your POST request body:

```json
{
  "text": "your-query-here",
  "llmModel": "gpt-4o",
  "stream": true,
  "toolsConfig": [
    {
      "name": "Plugin",
      "toolCreds": {
        "plugin_key": "12345"
      }
    },
    {
      "name": "generic_jira_tool",
      "toolCreds": {
        "token": "your-token-here",
        "url": "https://jiraeu.epam.com"
      }
    }
  ]
}
```

## Example Request

```bash
curl -X 'POST' \
  'http://localhost:8080/v1/assistants/{assistant_id}/model' \
  -H 'accept: application/json' \
  -H 'user-id: example-user' \
  -H 'Authorization: Bearer example-token' \
  -H 'Content-Type: application/json' \
  -d '{
    "text": "Show my current Jira tickets",
    "llmModel": "gpt-4o",
    "toolsConfig": [
      { "name": "generic_jira_tool", "toolCreds": { "token": "your-token", "url": "https://jiraeu.epam.com" }}
    ]
  }'
```

## Security Considerations

- Credentials are only used for the duration of the request and are not persisted
- Credentials are not exposed in logs or error messages
- Each tool uses only the provided credentials for the request execution

## Common Use Cases

1. **Multiple Users, One Assistant:** Different team members can use the same assistant with their own credentials
2. **Cross-Organization Access:** Access resources across different organizations with appropriate credentials
3. **Custom Integrations:** Connect to custom tool endpoints not globally configured
4. **Development and Testing:** Use different environments (dev/test/prod) with the same assistant but different credentials

## Sources

- [API Overview](https://docs.codemie.ai/user-guide/api/)
- [Integrations Overview](https://docs.codemie.ai/user-guide/tools_integrations/integrations/)
