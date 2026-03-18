# How to configure headers with User Context Placeholders in mcp configuration?

For Streamable HTTP MCP servers, you can configure custom headers with dynamic placeholders that are automatically resolved at request time. This feature enables user-specific routing, audit logging, and context propagation.

### Available Placeholders

**User Context Placeholders:**

- `{{user.name}}` - Resolves to the authenticated user's full name (e.g., "John Doe")
- `{{user.username}}` - Resolves to the authenticated user's username/email (e.g., "John.Doe@epam.com")

**Environment Variable Placeholders:**

- `{{VARIABLE_NAME}}` - Resolves to values from configured environment variables

### Example Configuration

```json
{
  "name": "example-http-server",
  "type": "streamable-http",
  "url": "http://127.0.0.1:3001/mcp",
  "headers": {
    "Content-Type": "application/json",
    "X-User-Name": "{{user.name}}",
    "X-Username": "{{user.username}}",
    "X-Project": "{{PROJECT_NAME}}",
    "X-API-KEY": "{{API_KEY}}",
    "Authorization": "Bearer {{ACCESS_TOKEN}}"
  },
  "env": {
    "PROJECT_NAME": "my-project",
    "API_KEY": "my-api-key",
    "ACCESS_TOKEN": "secret-access-token"
  }
}
```

When an authenticated user "John Doe" (username: John.Doe@epam.com) makes a request, the headers sent to the HTTP MCP server will be resolved to:

```
Content-Type: application/json
X-User-Name: John Doe
X-Username: John.Doe@epam.com
X-Project: my-project
X-API-KEY: my-api-key
Authorization: Bearer secret-access-token
```

### Use Cases

User context placeholders are beneficial for:

- **User-specific routing**: Route requests to different backends based on user identity
- **Audit logging**: Track which user triggered specific MCP server operations
- **Authorization**: Pass user information to downstream services for access control
- **Context propagation**: Maintain user context across microservices architecture

:::note  
User placeholders are resolved securely at request time and are isolated between concurrent requests to ensure thread safety.  
:::

## Sources

- [Adding An Mcp Server](https://docs.codemie.ai/user-guide/tools_integrations/tools/adding-an-mcp-server)
