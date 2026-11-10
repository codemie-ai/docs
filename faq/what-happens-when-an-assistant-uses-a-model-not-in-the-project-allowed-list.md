# What happens when an assistant uses a model not in the project's allowed list?

When an assistant or workflow is configured to use a model that the project has since ruled out,
it silently falls back to the **project's default model** at runtime. No error is shown to the
user and the assistant continues to respond — using the default model instead of the configured
one.

To avoid silent substitution, review assistants after changing a project's model configuration.
The assistant's model setting still shows the original model; updating it to a currently allowed
model makes the behavior explicit.

## Sources

- [Model Configuration](https://docs.codemie.ai/user-guide/project-user-management/projects#model-configuration)
