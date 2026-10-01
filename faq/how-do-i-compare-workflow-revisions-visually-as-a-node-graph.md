# How do I compare workflow revisions visually, as a node graph?

Open the workflow in the **Visual Editor** and click **Version History** in the editor toolbar. A popup opens with a single node graph for the selected revision, using the same zoom, fit view, and drag-to-pan controls as the editor. Nodes are highlighted directly on the graph: green for added, red with a `REMOVED` badge and strikethrough label for removed, and amber for modified.

The visual diff shows structural changes only — a node that was just moved to a different position on the canvas, with no other change, is not highlighted. For the exact before/after values of a modified node, switch to the textual YAML diff, opened separately from the YAML panel's **Version History** button.

The visual diff is read-only and always compares exactly two revisions at a time.

## Sources

- [Workflow Version History](https://docs.codemie.ai/user-guide/workflows/workflow-version-history)
