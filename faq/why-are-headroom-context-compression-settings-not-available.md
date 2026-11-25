# Why are Headroom context compression settings not available?

The settings appear only when the `features:headroom` component is enabled in
`customer-config.yaml`. Compression also requires `HEADROOM_MODE` set to `sidecar` or `sdk` on the
CodeMie API, together with a deployed Headroom sidecar or an API image built with the Headroom SDK.
With the flag on and the mode `off`, settings can be saved but no tokens are saved.

Ask a platform administrator to complete the setup described in the Headroom configuration guide.

## Sources

- [Headroom Context Compression Configuration](https://docs.codemie.ai/admin/configuration/codemie/headroom-configuration)
- [Customer Feature Configuration](https://docs.codemie.ai/admin/configuration/codemie/customer-feature-configuration#headroom)
