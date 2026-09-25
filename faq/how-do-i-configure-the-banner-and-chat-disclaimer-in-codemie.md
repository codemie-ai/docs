# How do I configure the banner and the chat disclaimer in CodeMie? How do I show a notice to all users?

CodeMie offers two notices shown to every user:

- **Banner** (`banner`) — a dismissible notice across the top of the application with an optional link.
- **Chat disclaimer** (`chatDisclaimer`) — a permanent short notice below the chat message input; Markdown links are clickable.

Both can be set in `customer-config.yaml` as deployment defaults and changed at runtime in **Settings → Administration → Customer Configuration** without a redeploy:

```yaml
components:
  - id: "banner"
    settings:
      enabled: true
      message: "Scheduled maintenance on Saturday 00:00–02:00 UTC"
      linkLabel: "Learn more"
      linkRoute: "/help"

  - id: "chatDisclaimer"
    settings:
      enabled: true
      text: "AI responses may be inaccurate. See the [usage policy](https://example.com/policy)."
```

The banner link appears only when both `linkLabel` and `linkRoute` are set. The link target accepts an application path or a full `http`/`https` URL; `javascript:`, `data:`, and `vbscript:` targets are rejected.

The `banner` component replaces the legacy `bannerMessage`, `bannerLinkLabel`, and `bannerLinkRoute` components, which are no longer read.

## Sources

- [Dynamic Customer Configuration](https://docs.codemie.ai/admin/configuration/codemie/dynamic-customer-configuration)
- [Customer Feature Configuration](https://docs.codemie.ai/admin/configuration/codemie/customer-feature-configuration)
