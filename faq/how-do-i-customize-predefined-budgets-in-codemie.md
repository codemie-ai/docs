# How do I customize predefined budgets in CodeMie?

To customize predefined budgets, mount a `budgets-config.yaml` file into the CodeMie pod using
the Helm chart's `extraVolumeMounts`, `extraVolumes`, and `extraObjects` values. The file defines
a `predefined_budgets` list where each entry specifies a `budget_id`, spending limits
(`soft_budget`, `max_budget`), a reset period (`budget_duration`), and a `budget_category`.

Example Helm configuration:

```yaml
extraVolumeMounts: |
  - name: codemie-budgets-config
    mountPath: /app/config/budgets/budgets-config.yaml
    subPath: budgets-config.yaml

extraVolumes: |
  - name: codemie-budgets-config
    configMap:
      name: codemie-budgets-config

extraObjects:
  - apiVersion: v1
    kind: ConfigMap
    metadata:
      name: codemie-budgets-config
    data:
      budgets-config.yaml: |
        predefined_budgets:
          - budget_id: default
            name: Default
            soft_budget: 80.0
            max_budget: 120.0
            budget_duration: 30d
            budget_category: platform
```

The custom file fully replaces the built-in default, so include all budgets you need —
including the `default` platform budget.

## Sources

- [Budget Configuration](https://codemie-ai.github.io/docs/admin/configuration/extensions/litellm-proxy/budget-configuration)
