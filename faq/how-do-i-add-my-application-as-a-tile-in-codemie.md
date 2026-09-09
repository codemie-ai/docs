# How do I add my application as a tile in CodeMie?

An application is registered as a `components` entry of type `applications:<slug>` in the deployment's `customer-config.yaml`. Registration happens through a pull request; there is no self-service UI or API for it today, and a config change requires a backend restart.

Three integration types are available: `link` (opens in a new tab), `iframe` (the application's own page framed inside CodeMie), and `module` (a Module Federation bundle that runs inside CodeMie's page). The right choice depends on how deeply the application needs to embed and whether it must be deployed into the operator's own environment — the Application Onboarding Guide walks through that decision, the field-by-field requirements for each type, and a review checklist before submitting.

## Sources

- [Application Onboarding Guide](https://docs.codemie.ai/admin/configuration/codemie/applications-onboarding/)
- [Customer Feature Configuration](https://docs.codemie.ai/admin/configuration/codemie/customer-feature-configuration/)
