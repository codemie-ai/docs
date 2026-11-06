---
id: adding-an-mcp-server
title: Adding an MCP Server
sidebar_label: Adding an MCP Server
pagination_prev: user-guide/tools_integrations/tools/mcp/mcp
pagination_next: user-guide/tools_integrations/tools/mcp/mcp-integration-credentials
sidebar_position: 1
---

import EnterpriseFeature from '@site/src/components/EnterpriseFeature';

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

## Testing a Saved MCP Server Configuration (Administrators)

<EnterpriseFeature />

Administrators can verify that a server saved in the MCP catalog connects and exposes tools, without attaching it to an assistant. The test runs against the saved configuration, and the result is shown immediately. The result is not stored: no "last test" status or timestamp is kept on the server.

### Prerequisites

- The **Administrator** role on the AI/Run CodeMie platform
- The Enterprise package installed on the deployment (the **MCPs management** page is hidden otherwise)
- The `adminActions` and `mcpConnect` components enabled in the customer configuration. See [Customer Feature Configuration](../../../../admin/configuration/codemie/customer-feature-configuration.md)

### Run a Test

1. Navigate to **Settings** → **Administration** → **MCPs management**
2. Locate the MCP server in the catalog table
3. Click the three dots menu (⋮) in the server row and select **Test Integration**

   The same **Test Integration** action is available in the actions of the **View Details** sidebar.

4. While the test is running, the action is disabled for that server to prevent duplicate requests
5. The outcome is displayed as a notification (see [Test Results](#test-results))

![MCPs management table with the Test Integration action](./images/mcp-test-row-menu.png)

The test works for servers of any status. An **inactive** server can be tested before being activated.

:::note Restricted Mode
When restricted mode (`mcpCustomServersDisabled`) is active, an inactive or non-public catalog server cannot be tested. The test fails with a message that restricted mode prevents the configuration from being used at runtime. Activate the server and make it public, then repeat the test.
:::

### Servers That Require Credentials

If the server defines required environment variables, the test cannot run without credentials. In this case the **Integration required** window opens first:

1. Review the list of environment variables that the test needs
2. Select an existing MCP integration from the list, or click **Add Environment Variables** to create a new integration. The newly created integration is selected automatically
3. Click **Test Integration**

![Integration required window](./images/mcp-test-integration-required.png)

If **Test Integration** is clicked with no integration selected, the hint **Select an integration to run the test** is displayed. While the test is running, the status of the **Test Integration** button reflects progress, success, warning, or failure. The window stays open, so a different integration can be selected and the test repeated.

:::info
Credentials from the selected integration are used for this test only. If a required variable is still missing, the test fails with `Missing required credentials: <variable names>` and the MCP server is not contacted.
:::

### Authentication Prompts

Some servers require sign-in while the test is running. In this case the test pauses and one of the following windows opens:

| Window                          | When it appears                                 | What to do                                                                                                                                    |
| ------------------------------- | ----------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------- |
| **MCP authentication required** | The MCP server requires an OAuth sign-in        | Click **Authenticate** for the listed server and complete the sign-in. After all servers are authenticated, the test is re-run automatically  |
| **Authentication required**     | The server is protected by the MCP broker login | Click **Login to MCP Server**, which opens the broker login page in a new browser tab. After signing in, close the tab and run the test again |

### Test Results

| Result      | Notification                                               | Meaning                                                                                     |
| ----------- | ---------------------------------------------------------- | ------------------------------------------------------------------------------------------- |
| **Success** | `MCP connection test successful (N tools)`                 | The server started, the connection was established, and `N` tools were retrieved            |
| **Warning** | `Connected to '<server>' but no tools were retrieved. ...` | The connection works, but the server returned no tools. Check that the server exposes tools |
| **Failure** | An error message followed by a diagnostic hint             | The connection failed. Review the message and the hint shown with it                        |

![Successful and failed test notifications](./images/mcp-test-result.png)

### API

The test is also available through the REST API (administrator access required):

```http
POST /v1/mcp-configs/{config_id}/test
```

The request body is optional. `settings_id` selects the MCP integration whose credentials are used for the test.

```json
{
  "settings_id": "<integration-id>"
}
```

Example response:

```json
{
  "status": "success",
  "message": "Success",
  "error_category": null,
  "tools_count": 12
}
```

`status` is one of `success`, `warning`, or `failure`. `error_category` and `tools_count` are populated when applicable. Nothing is persisted.

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
