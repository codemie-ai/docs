# Can I limit how many projects a user can be assigned to?

Yes. When Platform-managed mode is enabled, the `USER_PROJECT_LIMIT` environment variable
controls the maximum number of shared projects a regular user can be a member of. The
default is `3`.

Set it in the `codemie-api` Helm chart `extraEnv`:

```yaml
extraEnv:
  - name: ENABLE_USER_MANAGEMENT
    value: 'true'
  - name: USER_PROJECT_LIMIT
    value: '5'
```

Super Admins are always exempt from this limit and can access all projects regardless of
the configured value.

## Sources

- [Platform-managed Mode Configuration](https://codemie-ai.github.io/docs/admin/configuration/access-control/platform-managed-mode-configuration)
