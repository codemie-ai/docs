# Why are DIAL or Google OAuth unavailable or disabled in the New Integration form?

Some credential types exist at one scope only. **DIAL** is available at the **Project** scope only, and **Google OAuth** is available at the **User** scope only.

- In the **Credential Type** dropdown, a type bound to the other scope carries the hint "Switches Scope to …". Selecting it switches the **Scope** automatically.
- After such a type is selected, the scope that does not match is disabled: **User** for DIAL, **Project** for Google OAuth. To change the scope, select a different credential type first.
- Members without project-admin rights see Project-only types such as DIAL as disabled with the hint "Project only · needs project admin rights".
- **Google OAuth** is displayed only when the Google OAuth feature is enabled in the customer configuration.

## Sources

- [Integrations](https://docs.codemie.ai/user-guide/tools_integrations/integrations/#scope-bound-credential-types)
