# Why aren't all changes highlighted in the workflow visual diff?

The visual diff highlights structural and configuration changes: nodes added, removed, or with a modified configuration. A node's on-canvas position is a visual layout detail, not a tracked configuration difference, so a node that was only moved — with nothing else changed — is not highlighted.

To confirm whether a node's configuration actually changed, or to see the exact before/after values behind an amber "modified" highlight, use the textual YAML diff instead. It is opened separately from the YAML panel's **Version History** button.

## Sources

- [Workflow Version History](https://docs.codemie.ai/user-guide/workflows/workflow-version-history)
