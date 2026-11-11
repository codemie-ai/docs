# Why are DIAL or Google OAuth unavailable or disabled in the New Integration form?

Some credential types exist at one scope only. **DIAL** is available at the **Project** scope only, and **Google OAuth** is available at the **User** scope only.

- Selecting a type bound to the other scope switches the **Scope** field automatically, as long as the scope is still changeable.
- After such a type is selected, the **Scope** field is locked. To change the scope, select a different credential type first.
- Members without project-admin rights see Project-only types such as DIAL as disabled with the hint "Project only · needs project admin rights".
- **Google OAuth** is displayed only when the Google OAuth feature is enabled in the customer configuration.

## Sources

- [Integrations](https://docs.codemie.ai/user-guide/tools_integrations/integrations/#scope-bound-credential-types)
