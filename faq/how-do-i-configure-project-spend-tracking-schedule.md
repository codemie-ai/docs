# How do I configure the project spend tracking schedule?

Project spending data is collected by a background scheduler that runs automatically for all
projects. You can control when it runs using the `LITELLM_SPEND_COLLECTOR_SCHEDULE`
environment variable.

Set it to any valid cron expression (UTC). The default runs nightly at 11 PM:

```
LITELLM_SPEND_COLLECTOR_SCHEDULE=0 23 * * *
```

No per-project filtering configuration is needed — all projects are collected automatically.

## Sources

- [API Configuration — LiteLLM Spend Tracking](https://docs.codemie.ai/configuration-guide/api-configuration#litellm-spend-tracking)
