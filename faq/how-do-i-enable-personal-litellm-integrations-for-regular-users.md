# How do I enable personal LiteLLM integrations for regular users?

By default, only maintainers and administrators can manage LiteLLM integrations. To allow
regular users to configure their own LiteLLM credentials, enable the
`features:personalLiteLLMIntegrations` feature flag in the customer configuration.

Add the following entry to `customer-config.yaml` and apply it via Helm:

```yaml
components:
  - id: "features:personalLiteLLMIntegrations"
    settings:
      enabled: true
```

Once enabled, regular users will see LiteLLM as an option in the **User** tab of the
Integrations page and can create and manage their own LiteLLM API keys independently.

## Sources

- [Customer Feature Configuration](https://docs.codemie.ai/admin/configuration/codemie/customer-feature-configuration)
- [LiteLLM Integration Guide](https://docs.codemie.ai/user-guide/tools_integrations/tools/litellm)
