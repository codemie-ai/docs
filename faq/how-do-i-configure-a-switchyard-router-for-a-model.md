# How do I configure a Switchyard router for a model?

Add a `switchyard` list to the capable model's entry in the LLM model configuration YAML.
Each entry needs its own `base_name`, an `efficient` field pointing to the `base_name` of a
cheaper model in the same family, and a `mode` of `signal` or `classifier`:

```yaml
llm_models:
  - base_name: 'claude-sonnet-4-6'
    # ... other model fields
    switchyard:
      - base_name: 'claude-sonnet-4-6-switchyard-claude-4-5-haiku-signal'
        label: 'SY Signal Sonnet/Haiku'
        efficient: 'claude-4-5-haiku'
        mode: signal
```

`SWITCHYARD_ENABLED` must also be set to `true` — it is the platform-wide master switch and
overrides any per-model YAML configuration when `false`. Once enabled, the router appears as a
selectable model in the LLM model dropdown.

## Sources

- [Switchyard Auto-Routing](https://docs.codemie.ai/admin/configuration/codemie/ai-models-integration/switchyard-model-routing)
