---
id: share-workflow-execution
title: Share Workflow Execution
sidebar_label: Share Execution
pagination_prev: user-guide/workflows/create-workflow-from-template
pagination_next: user-guide/workflows/exporting-workflow-execution
sidebar_position: 6
description: How to share workflow execution results with team members
---

# Share Workflow Execution

To let a colleague look at a workflow execution, send them the execution link. First make sure they are allowed to open it, as described below.

## Before sending a link

A colleague can open the execution only when both conditions are met:

1. They are a member of the project that the workflow belongs to.
2. The workflow is shared with that project.

To share the workflow with its project:

1. In **Workflows**, open the three dots menu (**More options**) on the workflow card and select **Edit**.
2. Click **Workflow Config** and stay on the **Basic** tab.
3. Turn on **Shared with Project Team**.
4. Click **Save**.

A workflow that is not shared shows the label **Not shared** on its card. Sharing a workflow does not extend access to people outside its project.

## Share the execution

1. Open the execution in the workflow's **Workflow Execution History**.
2. Copy the address from the browser address bar. It has the form `https://<your-domain>/workflows/<workflow-id>/workflow-executions/<execution-id>`.
3. Send it to the colleague.

When the colleague opens the link they see that execution: the graph, **Starting Prompt**, and the input and result of every step. Their own **Workflow Execution History** list on the left stays empty, because it lists only the executions they started themselves.

## Share the workflow instead

The three dots menu (**More options**) on a workflow card also has **Copy Link**. It copies the address of the workflow itself (`https://<your-domain>/workflows/<workflow-id>`) and shows the message "Link to workflow copied to clipboard". The link opens the workflow page, not an execution. It is meant for pointing a colleague at the workflow and not at a particular run. The **View Details** page shows no separate copy button for this link.

## Who can open a shared link

| Colleague is in the workflow's project | Workflow is shared with the project | Result                                                                                                                                           |
| -------------------------------------- | ----------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------ |
| Yes                                    | Yes                                 | The execution opens.                                                                                                                             |
| Yes                                    | No                                  | The page opens empty and shows the message "Access denied". Turn on **Shared with Project Team** and send the link again.                        |
| No                                     | Yes                                 | The page opens empty and shows the message "Access denied". Move the workflow to a project the colleague belongs to, or add them to the project. |
| No                                     | No                                  | The page opens empty and shows the message "Access denied".                                                                                      |

:::note No Share button
A workflow execution has no **Share** button or share dialog. Sharing works through the execution link and the access conditions above.
:::

:::info Access Requirements
Users must be signed in to AI/Run CodeMie. The link only works for users who belong to the workflow's project while the workflow is shared with that project.
:::
