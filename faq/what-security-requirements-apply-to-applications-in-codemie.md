# What security requirements apply to applications in CodeMie?

Applications embedded in the CodeMie page or hosted by CodeMie must run regular security scans: SAST on every release, dependency and container scans on every release and weekly, DAST against the running application, and secret scanning on every commit. Critical and Urgent findings are fixed before the next release, and scan reports are shared with the corporate operations team.

Hosted applications also build from a corporate repository through an automated pipeline. They keep secrets only in CodeMie's secret store, send all AI calls through the CodeMie gateway, and test every release end to end before production. Linked applications, which open in a new tab, are not subject to these scan requirements.

## Sources

- [Applications](https://docs.codemie.ai/user-guide/applications/)
- [Application Integration Guide](https://docs.codemie.ai/user-guide/applications/integration-guide/)
