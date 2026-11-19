# Why do I get "Authorization error: You do not have permission to create assistant" when using skip_integration_validation?

This error is returned when `skip_integration_validation: true` is included in the assistant
creation payload but the requesting user does not have the required role.

When `MARKETPLACE_MANAGEMENT_ENABLED` is enabled on the platform, only Platform Admins and
Maintainers are permitted to use the `skip_integration_validation` flag. Project Admin rights within
a project are not sufficient — the request is rejected with HTTP 403 and the CLI displays the
message `Authorization error: You do not have permission to create assistant.`

To resolve the issue, either remove `skip_integration_validation` from the JSON payload and
configure the required toolkit integrations in the project first, or have a Platform Admin or
Maintainer perform the creation.

## Sources

- [SDK Asset Management — Creating Assistants](https://docs.codemie.ai/user-guide/codemie-cli/sdk-asset-management)
