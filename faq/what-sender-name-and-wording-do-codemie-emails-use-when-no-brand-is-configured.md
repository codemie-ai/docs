# What sender name and wording do CodeMie emails use when no brand is configured?

Without a brand, platform emails use neutral defaults. The sender name is `Platform Notifications`, the product name is `Platform`, and the signature is `The {productName} Team`. Message texts are neutral, for example the verification subject `Verify your {productName} account`.

The sender name is chosen in this order:

1. `email.senderName` from the brand theme package.
2. The `EMAIL_FROM_NAME` environment variable, when it is not empty.
3. `Platform Notifications`.

The default of `EMAIL_FROM_NAME` changed from `CodeMie` to empty. A deployment that relied on the old default must set `EMAIL_FROM_NAME` or `email.senderName`, or its emails show the sender `Platform Notifications`.

## Sources

- [White-Label Theming Kit - Email Branding and Defaults](https://docs.codemie.ai/admin/configuration/white-label/#email-branding-and-defaults)
- [API Configuration](https://docs.codemie.ai/admin/configuration/codemie/api-configuration)
