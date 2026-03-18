# How to pass authorization tokens to MCP servers using dynamic headers? How to use authorization token in MCP configuration ? How to configure propagate headers for MCP?

When configuring MCP servers in AI Assistants, you can use dynamic header substitution from incoming requests. This allows passing authorization tokens and other data from the client to the MCP server.

Basic Syntax  
In MCP server configuration, use the $headers.\<header-name> expression to reference headers from the incoming request:

{  
 "url": "https://my.mcpserver.com/mcp",  
 "type": "streamable-http",  
 "headers": {  
 "X-Tenant-ID": "$headers.x-tenant-id",  
 "Authorization": "Bearer $headers.x-my-custom-auth-token",  
 "Content-Type": "application/json"  
 },  
 "single_usage": false  
}

How it works:

Client sends request with header X-My-Custom-Auth-Token: abc123xyz and flag propagate_headers: true  
CodeMie substitutes the value: $headers.x-my-custom-auth-token → abc123xyz  
MCP server receives header Authorization: Bearer abc123xyz

Requirements  
For dynamic headers to work, the following is required:

Client must send header with X- prefix  
✅ X-My-Custom-Auth-Token, X-External-API-Token, X-Tenant-ID  
❌ Authorization, Api-Token, Custom-Token  
Client must set propagate_headers: true in the request body  
Header must not be blocked for security reasons  
❌ Authorization, Cookie, X-API-Key, X-Auth-Token  
✅ X-External-API-Token, X-My-Custom-Token

Use streamable-http transport type in MCP configuration

Configuration Examples  
Example 1: Basic Token Passing

{  
 "url": "https://my.mcpserver.com/mcp",  
 "type": "streamable-http",  
 "headers": {  
 "X-Tenant-ID": "$headers.x-tenant-id",  
 "Content-Type": "application/json"  
 },  
 "single_usage": false  
}  
Example 2: Authorization Token pass

{  
 "url": "https://secure.mcpserver.com/api/mcp",  
 "type": "streamable-http",  
 "headers": {  
 "Authorization": "Bearer $headers.x-my-custom-auth-token",  
 "Content-Type": "application/json"  
 },  
 "single_usage": false  
}  
Example 3: Multiple Headers

{  
 "url": "https://api.mcpserver.com/mcp",  
 "type": "streamable-http",  
 "headers": {  
 "X-Tenant-ID": "$headers.x-tenant-id",  
    "X-User-ID": "$headers.x-user-id",  
 "X-Request-ID": "$headers.x-request-id",  
    "X-Environment": "$headers.x-environment",  
 "Content-Type": "application/json"  
 },  
 "single_usage": false  
}  
Example 4: Mixed Static and Dynamic Headers

{  
 "url": "https://api.mcpserver.com/mcp",  
 "type": "streamable-http",  
 "headers": {  
 "X-API-Version": "v2",  
 "X-Service-Name": "codemie-integration",  
 "X-Tenant-ID": "$headers.x-tenant-id",  
    "X-User-Email": "$headers.x-user-email",  
 "Authorization": "Bearer $headers.x-api-token",  
 "Content-Type": "application/json"  
 },  
 "single_usage": false  
}

## Example 5: Combining with Environment Variables

{  
 "url": "https://api.mcpserver.com/mcp",  
 "type": "streamable-http",  
 "headers": {  
 "X-Tenant-ID": "$headers.x-tenant-id",  
 "X-API-Key": "{{API_KEY}}",  
 "Content-Type": "application/json"  
 },  
 "env": {  
 "API_KEY": "your-api-key-here"  
 },  
 "single_usage": false  
}  
Note:

{{VARIABLE}} syntax resolves from the env field (static value)

$headers.\<name> syntax resolves from incoming request headers (dynamic value)

Header Resolution Rules  
Case Insensitivity: Header names are matched case-insensitively

{  
 "headers": {  
 "X-Auth": "$headers.x-auth-token"  
 }  
}  
This will match any of:

X-Auth-Token  
x-auth-token  
X-AUTH-TOKEN

Only X- Headers:\* Only headers with X- prefix are available for resolution:

✅ $headers.x-tenant-id  
❌ $headers.authorization  
❌ $headers.content-type

Blocked Headers  
The following headers are blocked by default and cannot be used with $headers. syntax:

authorization  
cookie  
set-cookie  
x-api-key  
x-auth-token  
x-internal-secret  
x-internal-token

Important: Non-X-\* headers (like Authorization, Cookie) are never extracted for propagation, regardless of the blocked list.

The blocked headers list is configured via the MCP_BLOCKED_HEADERS environment variable:

MCP_BLOCKED_HEADERS=authorization,cookie,set-cookie,x-api-key,x-auth-token,x-internal-secret,x-internal-token

Practical Scenarios  
Scenario 1: Authorization with External API  
Your MCP server needs to call an external API with the user's token:

## MCP Configuration:

{  
 "url": "https://external-api.mcpserver.com/mcp",  
 "type": "streamable-http",  
 "headers": {  
 "Authorization": "Bearer $headers.x-external-token",  
 "Content-Type": "application/json"  
 },  
 "single_usage": false  
}  
Client sends the X-External-Token header with a token, MCP server receives it in the Authorization header.

Scenario 2: Multi-Tenancy  
Tenant identification for data processing:

## MCP Configuration: Scenario 2

{
"url": "https://tenant-api.mcpserver.com/mcp",
"type": "streamable-http",
"headers": {
"X-Tenant-ID": "$headers.x-tenant-id",
    "X-Tenant-Region": "$headers.x-tenant-region",
"Content-Type": "application/json"
},
"single_usage": false
}
Scenario 3: Request Tracing
Passing identifiers for distributed tracing:

## MCP Configuration: Scenario 3

{  
 "url": "https://api.mcpserver.com/mcp",  
 "type": "streamable-http",  
 "headers": {  
 "X-Trace-ID": "$headers.x-trace-id",  
    "X-Correlation-ID": "$headers.x-correlation-id",  
 "X-Request-ID": "$headers.x-request-id",  
 "Content-Type": "application/json"  
 },  
 "single_usage": false  
}  
Best Practices  
Use descriptive header names:

✅ X-Tenant-ID, X-User-Email, X-Request-Trace-ID  
❌ X-Data, X-Value, X-Info

Document required headers for API clients

Use static values for optional parameters:

{  
 "headers": {  
 "X-Tenant-ID": "$headers.x-tenant-id",  
 "X-Environment": "production"  
 }  
}  
Don't pass internal secrets through dynamic headers. Use environment variables for sensitive static data.

Limitations  
✅ Works with streamable-http transport type  
❌ Not supported with stdio transport type  
✅ Header names are case-insensitive  
✅ Can mix static and dynamic values  
❌ Cannot use headers without X-\* prefix  
❌ Cannot use blocked headers

Troubleshooting  
Header Not Resolving:

✓ Check syntax: $headers. prefix must be lowercase  
✓ Verify header name matches the incoming one (case-insensitive)  
✓ Confirm request header starts with X-  
✓ Check that header name is not in the blocked list  
✓ Ensure client sends propagate_headers: true

## MCP Server Not Receiving Headers:

✓ Check MCP configuration for $headers.\<name> expressions  
✓ Verify transport type is streamable-http  
✓ Check CodeMie platform logs for resolution errors  
✓ Temporarily replace dynamic expressions with static strings to isolate the issue

## Example Debug Configuration:

{  
 "url": "https://api.mcpserver.com/mcp",  
 "type": "streamable-http",  
 "headers": {  
 "X-Static-Test": "static-value-works",  
 "X-Dynamic-Test": "$headers.x-test-header",  
 "X-Debug": "true"  
 },  
 "single_usage": false  
}

Send a test request and verify which headers the MCP server receives.

## Sources

- [Adding An Mcp Server](https://docs.codemie.ai/user-guide/tools_integrations/tools/adding-an-mcp-server)
