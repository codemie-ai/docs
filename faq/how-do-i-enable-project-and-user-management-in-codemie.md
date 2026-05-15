# How do I enable Project & User Management in AI/Run CodeMie?

Project & User Management requires **Platform-managed mode** to be enabled by a platform
administrator. It is off by default.

To enable it, set the following values in your Helm charts and redeploy both components:

**`codemie-api` — `extraEnv`:**

```yaml
extraEnv:
  - name: ENABLE_USER_MANAGEMENT
    value: 'true'
  - name: USER_PROJECT_LIMIT
    value: '3'
```

**`codemie-ui` — `values.yaml`:**

```yaml
viteEnableUserManagement: true
viteEnableBudgetManagement: true
```

After applying both changes, the **Projects management** and **Users management** tabs
appear under **Settings → Administration** for users with the Admin role.

If you are switching from an existing Keycloak-managed deployment, you also need to run a
one-time user migration — see the full guide for details.

## Sources

- [Platform-managed Mode Configuration](https://codemie-ai.github.io/docs/admin/configuration/access-control/platform-managed-mode-configuration)
