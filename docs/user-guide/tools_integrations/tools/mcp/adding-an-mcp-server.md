---
id: adding-an-mcp-server
title: Adding an MCP Server
sidebar_label: Adding an MCP Server
pagination_prev: user-guide/tools_integrations/tools/mcp/mcp
pagination_next: user-guide/tools_integrations/tools/mcp/mcp-integration-credentials
sidebar_position: 1
---

# Adding an MCP Server

:::note Restricted Mode
Your administrator may enable the **mcpCustomServersDisabled** component. When active, only MCP servers from the admin-managed catalog are permitted. The **Manual Setup** option will be blocked at save time. Contact your platform administrator if you need to use a server that is not in the catalog.
:::

## Configuration Steps

1. Navigate to the **Create Assistant** or **Edit Assistant** page
2. In the **Available tools** section, expand the **External tools** category
3. Click on the External tools card to expand it
4. Select **Browse Catalog** for already predefined MCP servers or **Manual Setup** for adding your own MCP server

![External tools](../images/image90.png)

## Add Predefined MCP Servers from Browse Catalog

1. Search MCP with Categories filter or by name and click **Add**
2. Add required **Environment Variables**
3. Add or select environment variables from the dropdown list if needed
4. And click **Save**
5. Click **Test Integration** and **Add** to complete the configuration

![Browse catalog](../images/image95.png)

## Add MCP Server with Form Manual Setup

When configuring an MCP server using the Form method:

1. Fill in the required fields:
   - **Name**: A unique identifier for your server (required)
   - **Description**: Details about the server's purpose (optional)
   - **Tools Tokens Size Limit**: in need to change value by default
   - **Command**: The command used to invoke the server (required)
   - **Arguments**: Any additional parameters needed, space-separated (optional)
2. Select environment variables from the dropdown if needed
3. Click **Test Integration** and **Add** to complete the configuration

**Example**:

- **Name**: time-mcp-server
- **Description**: time-mcp-server
- **Command**: uvx
- **Arguments**: `mcp-server-time --local-timezone=America/New_York`

![Form setup](../images/image71.png)

## Add MCP Server with JSON Method Manual Setup

For advanced configurations, you can use the JSON method:

1. Fill in the basic fields (Name, Description, Command, **Tools Tokens Size Limit**)
2. Enter valid JSON data in the **JSON format** field
3. Select environment variables as needed
4. Click **Add Server** to complete the configuration

**Example**:

```json
{
  "command": "uvx",
  "args": ["mcp-server-time", "--local-timezone=America/New_York"]
}
```

![JSON setup](../images/image49.png)

**Example of the conversation**:

![MCP conversation](../images/image80.png)

## Managing Environment Variables

MCP servers often require environment variables for proper operation:

1. Click **Add environment variables** on the expanded MCP tool card
2. Choose between **Project Environment Variables** or **User Environment Variables**
3. Fill in the required fields:
   - **Alias**: A user-friendly name for the variable
   - **Key**: The environment variable key name
   - **Value**: The value to assign (will be securely stored)
4. Click **Add Environment Variables** to save the configuration

:::tip Credentials on shared assistants
When the assistant is used by other people, decide whether the integration configured here is shared by everyone or chosen per user. See [MCP Integration Credentials](./mcp-integration-credentials.md) for how the credential source is resolved for each user at run time.
:::

## Configuring Headers with User Context Placeholders

For Streamable HTTP MCP servers, you can configure custom headers with dynamic placeholders that are automatically resolved at request time.
This feature enables user-specific routing, audit logging, and context propagation.

### Available Placeholders

**User Context Placeholders:**

- `{{user.name}}` - Resolves to the authenticated user's full name (e.g., "John Doe")
- `{{user.username}}` - Resolves to the authenticated user's username/email (e.g., "John.Doe@epam.com")
- `{{user.token}}` - Resolves to the authenticated user's JWT token for per-user authentication

**Environment Variable Placeholders:**

- `{{VARIABLE_NAME}}` - Resolves to values from configured environment variables

:::tip How User Context Placeholders Work
User context placeholders like `{{user.token}}`, `{{user.name}}`, and `{{user.username}}` are **automatically resolved from the authenticated user's session** at request time.
You don't need to configure them in environment variables or integrations - each user automatically gets their own token/name/username injected.
This differs from environment variable placeholders like `{{API_KEY}}`, which use static values configured in the `env` section and are the same for all users.
:::

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
    "Authorization": "Bearer {{user.token}}"
  },
  "env": {
    "PROJECT_NAME": "my-project",
    "API_KEY": "my-api-key"
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
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

### Use Cases

User context placeholders are beneficial for:

- **User authentication**: Pass authenticated user JWT to MCP servers requiring per-user authentication (`{{user.token}}`)
- **User-specific routing**: Route requests to different backends based on user identity
- **Audit logging**: Track which user triggered specific MCP server operations
- **Authorization**: Pass user information to downstream services for access control
- **Context propagation**: Maintain user context across microservices architecture

:::note Security and Concurrency

- User placeholders (including `{{user.token}}`) are resolved securely at request time from the authenticated user context
- Token resolution is thread/async-safe: each concurrent request receives its own user JWT with no cross-request leakage
- JWT token values are never logged to prevent security exposure
- If no authenticated user context exists, the system fails safely without injecting a token
  :::

## Sending the User Profile to an MCP Server

CodeMie can attach a small, non-sensitive profile of the authenticated user to every tool call it makes on an MCP server.
The tool can use it for audit logging, per-user scoping of results, or personalisation.

This is separate from the [header placeholders](#configuring-headers-with-user-context-placeholders) described above.
Placeholders put values into HTTP headers, while the user profile travels in the tool call itself.

### Overview

Sending the user profile is **enabled by default**.
CodeMie sends it to every MCP server unless the option is switched off for that server or assistant.

:::warning Check the servers you use
The profile includes personal data such as name and email (see [What the Tool Receives](#what-the-tool-receives)).
Switch the option off for any MCP server that should not receive it, especially servers operated by third parties.
:::

### Turning It Off for an MCP Server

Set `allow_user_context` to `false` in the MCP server configuration JSON. It can be set in three places:

- **When adding a server manually.** Use the [JSON method](#add-mcp-server-with-json-method-manual-setup) in **Manual Setup**.
- **When editing an existing server.** Open the server from the assistant, click **Edit**, and change the JSON. The new value applies to the next tool call.
- **As a catalog default (administrators).** Open **Settings** > **Administration** > **MCPs catalog management**, create or edit the server, and add the field to **Configuration JSON**. Assistants that use the catalog server inherit the value.

Example configuration:

```json
{
  "name": "example-http-server",
  "type": "streamable-http",
  "url": "http://127.0.0.1:3001/mcp",
  "allow_user_context": false
}
```

| Value            | Result                                              |
| ---------------- | --------------------------------------------------- |
| `true` (default) | The user profile is sent with every tool invocation |
| `false`          | The user profile is not sent to this MCP server     |

:::note
There is no separate toggle for this option in the interface. Set `allow_user_context` in the JSON configuration.
:::

### Overriding It per Assistant

The value set on the MCP server is the default for every assistant that uses it.
An assistant can override that default in its own MCP server entry using the same `allow_user_context` field.
How the override works depends on where the server comes from.

**A server from the MCP catalog.** The catalog value is a ceiling, so an assistant can switch the profile off but cannot switch it on again if the administrator turned it off:

| Assistant value | Catalog value `true`         | Catalog value `false`        |
| --------------- | ---------------------------- | ---------------------------- |
| not set         | The user profile is sent     | The user profile is not sent |
| `true`          | The user profile is sent     | The user profile is not sent |
| `false`         | The user profile is not sent | The user profile is not sent |

**A server with its own configuration.** When the assistant uses a server it configured itself, the assistant value wins whenever it is set:

| Assistant value | Result                                                  |
| --------------- | ------------------------------------------------------- |
| not set         | The MCP server value applies                            |
| `true`          | The user profile is sent, whatever the server value     |
| `false`         | The user profile is not sent, whatever the server value |

### What the Tool Receives

The profile is delivered in the request `_meta` object under the key `codemie.ai/user-context`, on `tools/call` requests.
Every field is optional, so a tool should treat a missing field as "not provided".

| Field                                     | Description                                        |
| ----------------------------------------- | -------------------------------------------------- |
| `id`                                      | Stable CodeMie user identifier                     |
| `username`                                | Login name                                         |
| `name`, `email`, `picture`                | Display name, email and avatar URL (personal data) |
| `roles`                                   | CodeMie roles                                      |
| `is_admin`, `is_maintainer`, `is_auditor` | Role flags                                         |
| `user_type`                               | User type, for example `regular`                   |
| `project_names`, `admin_project_names`    | Projects the user belongs to or administers        |
| `knowledge_bases`                         | Knowledge bases the user can access                |

The profile never contains tokens or passwords.
If a tool must act as the user against another system, use `{{user.token}}` in the server headers instead.

:::warning Privacy and trust
`name`, `email` and `picture` are personal data. Because the profile is sent by default, switch the option off for MCP servers that do not need it or are not trusted with it.
The profile is not signed, so a tool should rely on it only when just CodeMie can reach the MCP server.
:::

:::note Requirements
The MCP-Connect service must be a release that accepts and forwards the user profile. Contact the platform administrator if the tool does not receive it.
:::

## Testing MCP Server Integration

To ensure your MCP server is correctly configured and accessible, CodeMie provides a convenient **Test integration** feature:

### Testing from the Edit MCP Server Page

1. Navigate to the **Edit assistant** page
2. Find and expand the MCP server tool card
3. Click on the three dots menu, then click **Edit**
4. On the **Edit an MCP server** page, locate the **Test integration** button next to **Cancel** and **Save**
5. Click the **Test integration** button
6. The system will immediately verify the connection and display the result:
   - **Success**: The MCP server is properly configured and accessible
   - **Failure**: Troubleshooting information will be provided

### Testing from the MCP Server Card

1. Navigate to the **Edit assistant** page
2. Find and expand the MCP server tool card
3. Click on the three dots menu
4. Select the **Test integration** option
5. The system will perform the verification and display results immediately

This feature helps you quickly confirm that your MCP server connection is working properly without having to test it through actual assistant conversations.

## Propagating Client Headers to MCP Servers

CodeMie supports forwarding custom HTTP headers from client SDK requests to MCP server invocations.
This allows you to pass request-scoped context — such as tenant identifiers, correlation IDs, or custom authorization tokens — directly through to the tools your assistant calls on an MCP server.

### Overview

Header propagation is **opt-in** and **disabled by default**.
Clients must explicitly enable it per request by setting `propagate_headers: true` in the request body.

### How It Works

When header propagation is enabled:

1. A client sends a request to CodeMie with `propagate_headers: true` and includes one or more `X-*` HTTP headers
2. CodeMie extracts all `X-*` headers from the incoming request, filtering out a configurable blocklist of sensitive headers
3. The extracted headers are attached to the MCP execution context and sent to the MCP-Connect bridge in the body of every tool invocation (`tools/list` and `tools/call`)
4. The MCP-Connect bridge receives the headers and forwards them to the target MCP server

```
SDK Request  ──►  CodeMie API  ──►  MCPToolkitService  ──►  MCPConnectClient
  X-Tenant-ID: abc          extract_custom_headers()         request_headers in body
  propagate_headers: true   (filters blocked headers)        ──►  MCP-Connect  ──►  MCP Server
```

### Using Header Propagation

#### With Assistant Chat

Set `propagate_headers: true` in the request body when calling the assistant chat endpoint.
Any `X-*` headers you include in the HTTP request are forwarded to MCP tool invocations.

```http
POST /v1/assistants/{assistant_id}/chat
Content-Type: application/json
X-Tenant-ID: my-tenant
X-Correlation-ID: req-abc-123
X-User-Context: engineering-team

{
  "text": "List all open pull requests",
  "propagate_headers": true
}
```

#### With Workflow Execution

Set `propagate_headers: true` in the request body when creating a workflow execution.

```http
POST /v1/workflows/{workflow_id}/executions
Content-Type: application/json
X-Tenant-ID: my-tenant
X-Correlation-ID: req-abc-123

{
  "user_input": "Run the code review pipeline",
  "propagate_headers": true
}
```

#### With Workflow Resume

Pass `propagate_headers` as a query parameter when resuming an interrupted workflow execution.

```http
PUT /v1/workflows/{workflow_id}/executions/{execution_id}/resume?propagate_headers=true
Content-Type: application/json
X-Tenant-ID: my-tenant
```

### Security: Header Filtering

Not all `X-*` headers are forwarded. CodeMie applies a blocklist to prevent propagation of sensitive credentials and internal tokens.

**Default Blocked Headers** (case-insensitive):

| Header              | Reason                    |
| ------------------- | ------------------------- |
| `Authorization`     | Bearer tokens, Basic auth |
| `Cookie`            | Session cookies           |
| `Set-Cookie`        | Session cookies           |
| `X-Api-Key`         | API key credentials       |
| `X-Auth-Token`      | Authentication tokens     |
| `X-Internal-Secret` | Internal service secrets  |
| `X-Internal-Token`  | Internal service tokens   |

:::warning Important
Administrators can customize the blocklist via the `MCP_BLOCKED_HEADERS` environment variable. See the [API Configuration Guide](../../../../admin/configuration/codemie/api-configuration.md#mcp-header-propagation) for details.
:::

### Configuring MCP Servers to Receive Propagated Headers

To make use of propagated headers, your MCP server must be prepared to read them from the tool invocation context it receives from MCP-Connect.

#### HTTP MCP Servers

For HTTP-transport MCP servers, the propagated headers are delivered to the MCP-Connect bridge as part of the invocation request body under the `request_headers` field.
MCP-Connect can be configured to forward them as HTTP headers to the upstream MCP server.

**Example Configuration:**

```json
{
  "name": "my-api-server",
  "description": "Internal API MCP server",
  "type": "streamable-http",
  "url": "https://my-api-server.internal/mcp",
  "headers": {
    "Content-Type": "application/json",
    "X-Service-Name": "codemie"
  }
}
```

When `propagate_headers: true` is set on the request, the client-supplied headers (e.g., `X-Tenant-ID`, `X-Correlation-ID`) are passed alongside the static headers defined in the server config.

#### stdio MCP Servers

For command-based (stdio) MCP servers, the propagated headers are included in the invocation request body sent to MCP-Connect.
How MCP-Connect delivers them to the stdio process depends on your MCP-Connect configuration (for example, via environment variables or standard input).
Consult your MCP-Connect deployment documentation for details.

### Common Use Cases

#### Multi-Tenant Context

Pass a tenant identifier so the MCP server can scope its responses to the correct tenant.

```http
POST /v1/assistants/{assistant_id}/chat
X-Tenant-ID: acme-corp

{
  "text": "Show me this week's deployment status",
  "propagate_headers": true
}
```

The MCP server receives `X-Tenant-ID: acme-corp` and uses it to filter data for the acme-corp tenant.

#### Request Tracing

Propagate a correlation ID so that traces span from the SDK call all the way to the MCP server and back.

```http
POST /v1/workflows/{workflow_id}/executions
X-Correlation-ID: trace-7f3a9b21
X-Request-Source: ci-pipeline

{
  "user_input": "Run integration tests",
  "propagate_headers": true
}
```

#### Forwarding User Identity

Pass end-user identity metadata when the MCP server needs to perform access control or audit logging on its side.

```http
POST /v1/assistants/{assistant_id}/chat
X-End-User-ID: u-4892
X-End-User-Role: developer

{
  "text": "Deploy to staging",
  "propagate_headers": true
}
```

:::note
Do not pass raw auth tokens (e.g., `X-Auth-Token`) via header propagation — these are blocked by default.
If the MCP server needs user authentication, configure it through the MCP server's `integration_alias` or `env` credentials instead.
:::

## Troubleshooting

If your assistant cannot reach the MCP server:

- Verify the server URL and authentication are correct
- Check that the MCP server is operational and accessible
- Ensure network connectivity between CodeMie and the MCP server
- Review environment variable configurations
