# How do I add annotations to Code Executor pods?

Set the `CODE_EXECUTOR_POD_ANNOTATIONS` environment variable to a JSON object of annotation keys and string values, for example `{"admission.datadoghq.com/python-lib.version":"v4.15.2"}`. The annotations are added to the pod template of each executor Job. This applies in `sandbox-jobs` mode only.

The annotations do not enable Datadog tracing for the executed script. The executor clears the environment before it starts the script, so the variables that the Datadog init container injects do not reach the user process.

The Helm `podAnnotations` value does not reach executor Job pods. It applies only to the CodeMie API, ds-pool, and proxy-pool pods.

## Sources

- [Code Executor Configuration](https://docs.codemie.ai/admin/configuration/codemie/code-executor-configuration)
