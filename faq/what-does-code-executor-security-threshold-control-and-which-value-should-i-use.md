# What does CODE_EXECUTOR_SECURITY_THRESHOLD control and which value should I use?

`CODE_EXECUTOR_SECURITY_THRESHOLD` sets the strictness of the security policy applied to Python
code running inside the Code Executor sandbox. Higher values block more operations:

- `SAFE` — most permissive, blocks almost nothing
- `LOW` — allows common operations such as HTTP requests
- `MEDIUM` — more restrictive, blocks potentially dangerous operations
- `HIGH` (default) — most restrictive, only allows safe operations

For production deployments the default `HIGH` is recommended. Lowering the threshold permits
additional operations but reduces the isolation guarantees of the sandbox.

## Sources

- [Code Executor & Python Sandbox — API Configuration](https://docs.codemie.ai/admin/configuration/codemie/api-configuration#code-executor--python-sandbox)
