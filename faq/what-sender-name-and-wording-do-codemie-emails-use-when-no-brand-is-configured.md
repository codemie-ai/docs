# What sender name and wording do CodeMie emails use when no brand is configured?

Without a brand, platform emails use neutral defaults. The sender name is `Platform Notifications`, the product name is `Platform`, and the signature is `The {productName} Team`. Message texts are neutral, for example the verification subject `Verify your {productName} account`.

The sender name of platform emails comes from the `EMAIL_FROM_NAME` setting in the values of the API chart, when it is not empty. Otherwise it is `Platform Notifications`. Neither theme package has an `email.senderName` token, and the kit scripts have no way to set the API sender name. Both scripts stop with a message when a package still contains the token.

The default of `EMAIL_FROM_NAME` changed from `CodeMie` to empty. A deployment that relied on the old default must set `EMAIL_FROM_NAME`, or its emails show the sender `Platform Notifications`.

The sender name of Keycloak emails (for example password reset) is set in the Keycloak realm settings, not in the Keycloak theme package.

## Sources

- [White-Label Theming Kit - Email Branding and Defaults](https://docs.codemie.ai/admin/configuration/white-label/#email-branding-and-defaults)
- [API Configuration](https://docs.codemie.ai/admin/configuration/codemie/api-configuration)
