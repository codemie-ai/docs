# Can I enable the budget soft-limit notification UI without sending emails in CodeMie?

Yes. The notification UI and email dispatch are controlled by two independent flags, so the owner email field and the notification toggle can be made visible and editable in the budget form without any emails being sent.

Set only the master flag:

```yaml
extraEnv:
  - name: BUDGET_SOFT_LIMIT_NOTIFICATION_ENABLED
    value: 'true'
  # Leave BUDGET_SOFT_LIMIT_EMAIL_ENABLED unset (defaults to false)
```

With this configuration, project administrators can configure a notification owner email and enable the toggle per budget, but no email is dispatched when the soft limit is crossed. SMTP configuration is not required in this mode.

To also send emails, set `BUDGET_SOFT_LIMIT_EMAIL_ENABLED=true` and configure SMTP variables. See [Budget Soft-Limit Notifications](https://docs.codemie.ai/admin/configuration/codemie/project-budget-management#budget-soft-limit-notifications) for the full setup.

## Sources

- [Project Budget Management — Budget Soft-Limit Notifications](https://docs.codemie.ai/admin/configuration/codemie/project-budget-management#budget-soft-limit-notifications)
