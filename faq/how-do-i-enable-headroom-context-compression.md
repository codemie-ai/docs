# How do I enable Headroom context compression?

Set the `HEADROOM_MODE` environment variable of the CodeMie API to `sdk` or `sidecar` (the default is `off`) and enable the `features:headroom` component in `customer-config.yaml`. The `sdk` mode needs an API image built with the `INSTALL_HEADROOM_SDK` build argument, and the `sidecar` mode needs a running Headroom sidecar with a matching `HEADROOM_PROXY_TOKEN`. A change to `HEADROOM_MODE` requires a restart of the CodeMie API.

After that, assistant and workflow authors can turn on **Enable context compression** in the assistant form or the **Context compression (Headroom)** accordion of the workflow editor and choose a strategy.

## Sources

- [Headroom Context Compression](https://docs.codemie.ai/admin/configuration/codemie/headroom-context-compression)
- [Create Assistant](https://docs.codemie.ai/user-guide/assistants/create-assistant)
