# How do I configure MCP_INSTRUCTIONS_NONCE_SECRET for MCP server instructions?

`MCP_INSTRUCTIONS_NONCE_SECRET` is an environment variable of the `codemie-api` service. It keys the delimiters that wrap MCP server instructions in the system prompt. Set it to the same value of at least 32 characters on every API replica, for example the output of `openssl rand -hex 32`.

1. Create a Kubernetes secret that holds the value, for example `codemie-mcp-secrets` with the key `MCP_INSTRUCTIONS_NONCE_SECRET`.
2. Reference it in the `extraEnv` section of the `codemie-api` Helm values with a `secretKeyRef`.
3. Run `helm upgrade` and wait for the pods to restart.

When the variable is unset, each pod uses its own random key, which still works but causes LLM prompt-cache misses across replicas and restarts. A value shorter than 32 characters stops the API at startup. Create the secret before referencing it, because a missing secret prevents the pods from starting.

## Sources

- [Customer Feature Configuration: MCP Server Instructions](https://docs.codemie.ai/admin/configuration/codemie/customer-feature-configuration#mcp-server-instructions)
- [CodeMie API Configuration Reference](https://docs.codemie.ai/admin/configuration/codemie/api-configuration)
