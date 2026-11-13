# Why are Cost Centers, Budget Management, and Chargeback unavailable even though their feature flags are enabled?

Cost Centers, Budget Management, and Chargeback are part of the Enterprise package. They are available only when the `codemie-enterprise` package is installed, in addition to the `features:costCenters`, `features:budgetManagement`, and `features:projectChargeback` flags in `customer-config.yaml`. Without the package, the flags have no effect.

In that case, the UI hides the features and direct API calls are rejected with `403` "Feature not available", exactly as if the flags were set to `false`. If the package is installed and a flag is set to `false`, the feature stays disabled.

## Sources

- [Customer Feature Configuration](https://docs.codemie.ai/admin/configuration/codemie/customer-feature-configuration#enterprise-gated-features)
- [Enterprise Features](https://docs.codemie.ai/user-guide/getting-started/enterprise-features)
