# Can the IdP sync job set maintainer and auditor roles in AI/Run CodeMie?

Yes. In IdP-managed mode the management API accepts optional `is_maintainer` and `is_auditor` flags, so the
sync job can map IdP roles (in Keycloak, realm roles) to them. Which roles are used is a setting of the job, not of the
platform.

A maintainer is always an administrator: `is_maintainer=true` without `is_admin=true` is refused with `422`.
Removing the last active maintainer or administrator, by demotion or by deactivation, is refused with `409`. A
field that is not sent leaves the stored flag unchanged.

The administrator UI still lets an administrator edit the name, the picture, the user type, and the
maintainer and auditor flags. When a role is managed by the job, a manual change of it is overwritten by the next
run. The first run with a role switched on removes the role from every user who does not hold it in the IdP,
so the roles must be handed out in the IdP and checked in a dry run first.

## Sources

- [IdP-managed Mode Configuration](https://docs.codemie.ai/admin/configuration/access-control/idp-managed-mode-configuration)
