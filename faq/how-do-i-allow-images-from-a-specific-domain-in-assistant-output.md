# How do I allow images from a specific domain in assistant output?

Add the domain to the `allowedImageDomains` component in `customer-config.yaml`. The value is a single comma-separated list of hostnames:

```yaml
components:
  - id: "allowedImageDomains"
    settings:
      enabled: true
      value: "raw.githubusercontent.com,.example.com,cdn.customer.io"
```

A plain entry such as `cdn.example.com` matches that host only. An entry with a leading dot such as `.example.com` matches the apex domain and all of its subdomains. Entries with fewer than two labels, such as `com`, are ignored.

The default value is empty, which blocks all external images. Images served from the platform origin or the backend API — including uploaded attachments — are always allowed and do not need an entry. After applying the change, users must reload the application, because the configuration is fetched once per browser tab.

## Sources

- [Customer Feature Configuration](https://docs.codemie.ai/admin/configuration/codemie/customer-feature-configuration)
- [Image Allow-List for LLM Output](https://docs.codemie.ai/admin/security/llm-output-image-allow-list)
