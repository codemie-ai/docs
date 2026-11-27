# How do I enable AI Katas for my deployment?

Starting from version 2.67.0, AI Katas are disabled by default. To make the feature available,
add the `features:katas` component to the `customer-config.yaml` configuration file with
`enabled: true`:

```yaml
components:
  - id: "features:katas"
    settings:
      enabled: true
      name: "AI Katas"
      description: "Show AI Katas navigation, pages, floating kata window and kata metrics in the leaderboard"
```

When enabled, the AI Katas navigation item, all Katas pages, the floating kata window, the
onboarding tour step, and the Kata Completion score and Katas Completed metric in the leaderboard
all become visible. When disabled (or when the entry is absent from the configuration), every Katas
surface is hidden with no error.

## Sources

- [Customer Feature Configuration](https://docs.codemie.ai/admin/configuration/codemie/customer-feature-configuration)
- [AI Katas Overview](https://docs.codemie.ai/user-guide/ai-katas/katas-overview)
