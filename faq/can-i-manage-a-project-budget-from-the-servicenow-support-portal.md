# Can I manage a project's CodeMie budget from the EPAM Support Portal (ServiceNow)?

Yes. A monthly budget for a CodeMie project can be requested, adjusted, or cancelled through a request form in ServiceNow, per spend category (Platform, CLI, and Premium Models). Once a Delivery or Project Manager approves the request, the budget is applied in CodeMie automatically, so no administrator has to set it up by hand.

The request also takes care of the surrounding setup:

- If the project does not exist yet, it is created and, when the request names one, linked to a cost center such as the EPAM project code.
- The requester and approvers become project admins. Anyone who has not signed in to CodeMie yet is reported back to ServiceNow as not assigned instead of failing the request.
- A new request replaces the current budget, an adjustment changes only the categories that are sent, and a cancellation removes the budget.

A failed request changes nothing, and sending the same request again after a timeout or server error is safe.

ServiceNow calls the CodeMie provisioning API as a registered provisioning client, so an administrator registers its service account once before the integration is used.

## Sources

- [ServiceNow Budget Integration](https://docs.codemie.ai/admin/configuration/codemie/servicenow-budget-integration)
- [Provisioning Clients Configuration](https://docs.codemie.ai/admin/configuration/codemie/provisioning-clients)
