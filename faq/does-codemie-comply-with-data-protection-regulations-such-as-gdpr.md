# Does CodeMie comply with data protection regulations such as GDPR?

CodeMie is designed for client-controlled deployment, which means the client organization owns and operates the platform and is the data controller for compliance purposes. This model directly supports compliance with GDPR and equivalent regulations such as Mexico's LFPDPPP.

**Data residency**

Because CodeMie runs entirely within your own infrastructure (AWS, GCP, Azure, or on-premises Kubernetes), data residency is determined by the region you select at deployment time. No data leaves the environment you control.

**Built-in privacy controls**

The platform implements the following data protection capabilities out of the box:

| Principle                  | Implementation                                                                          |
| -------------------------- | --------------------------------------------------------------------------------------- |
| Data minimization          | Only the prompt and relevant context are sent to AI models                              |
| Right to erasure           | Users can delete all their conversations from the UI; admin deletion APIs are available |
| Data subject access rights | All PII data can be provided on request                                                 |
| Data security              | AES-256 encryption at rest, TLS 1.2+ in transit, KMS-managed key rotation               |
| Access control             | RBAC via Keycloak with project-scoped permissions and SSO integration                   |
| Data localization          | Storage region is fully configurable per deployment                                     |

**AI risk management**

The platform aligns with ISO/IEC 42001 (AI risk management standard), including AI safety guardrails, risk assessment, monitoring, and continuous lifecycle reviews.

**Responsibility**

Since the client controls the deployment environment, data handling policies are enforced by the client organization in accordance with their own contractual and regulatory obligations.

## Sources

- [Security & Data Processing](https://docs.codemie.ai/admin/security)
- [Deployment Overview](https://docs.codemie.ai/admin/deployment/aws/overview)
