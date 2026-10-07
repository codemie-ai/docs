# How do I migrate CODE_EXECUTOR_SECURITY_THRESHOLD after upgrading to 2.57.0?

In 2.57.0 the semantics of `CODE_EXECUTOR_SECURITY_THRESHOLD` were corrected. Previously the
values behaved inverted — `LOW` enforced the strictest policy and `HIGH` the most permissive.
The values now match their names: `LOW` is permissive and `HIGH` is the most restrictive.

The default was also changed from `LOW` to `HIGH`. Under the corrected semantics `HIGH` enforces
exactly what `LOW` enforced before, so deployments that do not set this variable explicitly are
unaffected.

**Action required only if** the deployment explicitly sets `CODE_EXECUTOR_SECURITY_THRESHOLD=LOW`
to obtain strict enforcement — change it to `HIGH`.

No other changes are needed for deployments relying on the default.

## Sources

- [Code Executor & Python Sandbox — API Configuration](https://docs.codemie.ai/admin/configuration/codemie/api-configuration#code-executor--python-sandbox)
- [Release Notes 2.57.0](https://docs.codemie.ai/admin/update/release-notes#v2-57-0)
