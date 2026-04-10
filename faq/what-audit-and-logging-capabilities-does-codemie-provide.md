# What audit and logging capabilities does CodeMie provide?

CodeMie provides several layers of logging and audit traceability, all stored within the client's own infrastructure.

**User activity and AI usage logs**

Every AI request is automatically logged with: user identity, model used, token consumption, cost, timestamp, response time, and request metadata. These logs are stored in Elasticsearch within your deployment and accessible via the built-in Analytics Dashboard with role-scoped visibility:

- Platform Admins see all users and projects
- Project Admins see their project scope
- Regular users see only their own activity

**Per-request spend logs**

Granular per-request logs capture the full request lifecycle including model, tokens, cost, and user. Retention is configurable and logs can be forwarded to external SIEM solutions such as Splunk, CloudWatch, or Stackdriver.

**Workflow execution history**

For workflow-based AI runs, CodeMie keeps an execution history per project. Project administrators can review all workflow executions triggered by any user within their project scope.

**API request correlation**

When assistants call external services via the OpenAPI tool, a `callback_id` can be included in the request metadata. CodeMie forwards it downstream as a `callback-id` HTTP header, allowing you to correlate CodeMie events with your own API gateway and service logs.

**Cloud-provider audit trails**

Depending on your deployment:

- **AWS**: CloudTrail and CloudWatch
- **GCP**: Cloud Audit Logs with PostgreSQL DDL logging
- **Azure**: Log Analytics workspace with Container Insights and Key Vault audit events

## Sources

- [Analytics](https://docs.codemie.ai/user-guide/analytics)
- [Security & Data Processing](https://docs.codemie.ai/admin/security)
