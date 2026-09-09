---
id: subworkflows
title: Sub-workflows
sidebar_label: Sub-workflows
pagination_prev: user-guide/workflows/create-workflow
pagination_next: user-guide/workflows/llm-model-name-in-workflow
sidebar_position: 3
description: Invoke a child workflow from a parent workflow while keeping their execution contexts separate
---

<!-- cspell:words subworkflows SUBWORKFLOW -->

# Sub-workflows

A Sub-workflow node lets one workflow invoke another workflow as part of its execution path. Use it to reuse a workflow for a well-defined task, split a large process into smaller workflows, or compose common processing steps without duplicating nodes.

The invoked workflow is the **child workflow**. The workflow containing the Sub-workflow node is the **parent workflow**.

## Prerequisites

Before adding a Sub-workflow node, ensure that:

- An administrator has enabled the `features:subWorkflow` customer feature.
- The child workflow already exists and you have permission to access it.
- The child workflow is not the parent workflow itself.
- You know what input the child expects and what its last state returns.

When the feature is disabled, the **Sub-Workflow** node and its advanced configuration are not shown in the editor.

## Add a Sub-workflow Node

1. Open the parent workflow in the Visual Workflow Editor.
2. In the node palette, find **Sub-Workflow** under **Action**, and add it to the canvas.
3. Select the node to open **Sub-Workflow Configuration**.
4. In the required **Sub-Workflow** picker, select an accessible child workflow.
5. Connect the node's incoming and outgoing connections to the parent workflow's execution path.
6. Click **Save**, or click **Save & Run** to save and test the parent workflow.
7. Enter the parent workflow input and monitor the execution. The Sub-workflow node completes after the child workflow reaches a terminal state.

The picker lists workflows available to the current user. Saving or running validates the selected workflow. A self-reference, a deleted workflow, or a workflow you cannot access is rejected.

## Input, Output, and Context Isolation

The visual editor does not provide an input-mapping field. Input is selected implicitly according to the Sub-workflow node's position:

```text
Parent input -> preceding parent node -> Sub-workflow -> next parent node
                  output becomes           receives the child's
                  the child input          last state output
```

- If the Sub-workflow node is the first executable node after START, the child receives the parent's original user input.
- Otherwise, the child receives the immediately preceding persisted node output.
- If no preceding output is available, the child receives the parent's original user input.

:::warning Verify the Child Input
Place the Sub-workflow node directly after the node whose persisted output should become the child input. There is no separate input-mapping control in the visual editor.
:::

The child runs as a separate execution linked to the parent. It starts with a fresh execution context and does not inherit the parent's full context or history. Only the child's last state output is returned to the Sub-workflow node; if the child has no output, an empty string is returned. The returned value then follows the same parent context and history rules as any other node output.

:::info Isolated Execution
Parent context and history are not merged into the child, and child context and history are not merged back into the parent.
:::

If the child execution fails, the Sub-workflow node fails. If the child is aborted, the node is aborted as well.

## Configure Nesting

Sub-workflows can invoke other workflows. To configure a workflow's nesting limit in the visual editor:

1. Open the workflow.
2. Select **Workflow Config**.
3. Open **Advanced**.
4. Expand **Sub-workflow**.
5. Set **Max Nesting Level** to a value from 1 through 10. Leave it empty to use the server default.

:::warning The Child Owns the Limit
For each invocation, CodeMie uses the **selected child workflow's** Max Nesting Level. If the child does not define one, CodeMie uses the server setting `SUBWORKFLOW_MAX_NESTING_DEPTH`, whose default is `1`.
:::

For example, if workflow A invokes workflow B, B's setting determines whether the invocation is within the nesting limit. If B then invokes workflow C, C's setting is evaluated for that invocation. Executions that exceed the effective limit are rejected before another child execution is created.

The visual editor accepts values from 1 through 10. YAML validation requires a value of at least 1 but does not apply the visual editor's maximum of 10.

## Interrupt and Resume

A Sub-workflow node supports `interrupt_before`, like other workflow states. When configured, the parent can pause before the node runs.

If the child itself becomes interrupted, the parent also becomes interrupted and retains a link to that active child execution. Resuming the parent resumes the **same child execution** at the correct point; it does not start a replacement child execution.

## YAML Example

The following configuration invokes a child workflow and then continues to `publish-result`:

```yaml
states:
  - id: invoke-child
    workflow_id: child-workflow-id
    interrupt_before: true
    next: publish-result
```

`workflow_id` is the selected child's workflow ID. For complete nesting and pooling settings, see [Sub-workflow Node](./configuration/specialized-nodes.md#85-sub-workflow-node).

## Pooling

Administrators can reduce workflow startup latency by enabling a pool of precompiled, user-agnostic workflow graphs. User data and execution-specific delegates are added only when an instance is used and are cleared when it is released.

Pooling is not configured in the visual editor. It is used only when both the global `SUBWORKFLOW_POOL_ENABLED` setting and the selected child workflow's `pool_config.enabled` setting are enabled. Configure the child workflow in YAML as described in [Sub-workflow Node](./configuration/specialized-nodes.md#85-sub-workflow-node). Administrators can review global settings in [CodeMie API Configuration](../../admin/configuration/codemie/api-configuration.md#sub-workflows).

## Troubleshooting

| Problem                                                                             | Cause and resolution                                                                                      |
| ----------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------- |
| **Sub-Workflow** is not in the node palette                                         | Ask an administrator to enable the `features:subWorkflow` customer feature.                               |
| The child workflow cannot be selected or validation reports that it is inaccessible | Confirm that the workflow exists and that you have permission to access it.                               |
| Validation rejects the selected workflow                                            | A workflow cannot invoke itself. Select a different child workflow.                                       |
| Execution reports that the nesting limit was exceeded                               | Review the selected child's **Max Nesting Level**, or ask an administrator to review the server fallback. |
| The child receives unexpected input                                                 | Check the Sub-workflow node's position and the immediately preceding node's persisted output.             |
| The Sub-workflow node fails or is aborted                                           | Inspect the linked child execution. A failed or aborted child propagates that status to the parent node.  |
