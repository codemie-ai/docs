# How do I get notified when a budget soft limit is reached in CodeMie?

Each budget can be configured to send an email notification to a designated owner when spending crosses the soft limit for the first time in a budget period.

To enable notifications on a budget:

1. Open the budget for editing (Administration → **Budgets**, or the project **Budgets** tab).
2. In the **Soft-Limit Notifications** section, enter the **Notification owner email**.
3. Enable the **Notify on soft limit** toggle.
4. Save the budget.

A single email is sent per budget period — no further notifications are dispatched until the period resets.

This feature requires a platform administrator to enable `BUDGET_SOFT_LIMIT_NOTIFICATION_ENABLED=true` on the deployment. To also send emails (not only show the UI fields), `BUDGET_SOFT_LIMIT_EMAIL_ENABLED=true` and SMTP must be configured. See [Budget Soft-Limit Notifications](https://docs.codemie.ai/admin/configuration/codemie/project-budget-management#budget-soft-limit-notifications) for setup details.

## Sources

- [Budget Management — Soft-Limit Notifications](https://docs.codemie.ai/user-guide/budget-management/#soft-limit-notifications)
- [Project Budget Management — Budget Soft-Limit Notifications](https://docs.codemie.ai/admin/configuration/codemie/project-budget-management#budget-soft-limit-notifications)
