# Can I manage a project's CodeMie budget from the EPAM Support Portal (ServiceNow)?

Yes. A monthly budget for a CodeMie project can be requested, adjusted, or cancelled through a request form in ServiceNow, per spend category (Platform, CLI, and Premium Models). Once a Delivery or Project Manager approves the request, the budget is applied in CodeMie automatically, so no administrator has to set it up by hand.

The request also takes care of the surrounding setup:

- If the project does not exist yet, it is created, together with its cost center when the project is billed under a different EPAM project code.
- The requester and approvers become project admins. Anyone who has not signed in to CodeMie yet is reported back to ServiceNow as pending instead of failing the request.
- A new request replaces the current budget, an adjustment changes only the categories that are sent, and a cancellation removes the budget.

Submitting the same request again gives the same result, so a retry is safe.

## Sources

- [ServiceNow Budget Integration](https://docs.codemie.ai/admin/configuration/codemie/servicenow-budget-integration)
