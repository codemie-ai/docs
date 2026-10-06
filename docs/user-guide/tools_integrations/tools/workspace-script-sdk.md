---
id: workspace-script-sdk
title: Workspace Script SDK
sidebar_label: Workspace Script SDK
sidebar_position: 21
pagination_prev: null
pagination_next: null
---

# Workspace Script SDK

A script that runs in a workspace can call CodeMie tools while it runs. The script imports the `codemie_runtime_sdk` module and calls a tool by name. CodeMie runs the tool and returns the result to the script, so a script can read a Jira issue or a Confluence page as part of a larger task, without the model reading every response.

This page is for people who write scripts by hand, and for the administrator who enables the feature. The model that writes scripts gets a short reference in the script tool's description.

:::info Availability
The feature is off by default. An administrator turns it on in **Settings → Administration → Customer Configuration → Workspace script bridge**. It works only when the code executor runs in jobs mode, which is the default.
:::

```python
from codemie_runtime_sdk import call_tool, ToolCallError

envelope = call_tool("generic_jira_tool", {"method": "GET", "relative_url": "/rest/api/2/myself"})
print(envelope["http"]["status"], envelope["result"])
```

---

## Running a Script from a Workflow Step

A workflow can run a script as one of its steps. Add a Tool node that uses the workspace script tool (`execute_workspace_script`), set the path of the script, and attach the script file when you start the workflow.

The execution results show what the script printed and the files it created. The output of the step can be used by the next steps like the output of any other Tool node, and the files stay available to them. If the script is not found or fails, the step is marked as failed and shows the reason or the script's output.

A script in a Tool node can call tools by name with your integrations, see [Which Tools a Script Can Call](#which-tools-a-script-can-call).

---

## Which Tools a Script Can Call

A script can call only the tools that are available to it in its run. Which tools those are depends on where the script runs:

| Where the script runs                                                   | Tools the script can call                                          | Credentials used                               |
| ----------------------------------------------------------------------- | ------------------------------------------------------------------ | ---------------------------------------------- |
| A chat, or a workflow step that uses an assistant                       | The tools in that assistant's tool list, including attached skills | The assistant's own settings and credentials   |
| A workflow tool step                                                    | Tools from the catalog, by name                                    | The running user's integrations in the project |
| A workspace run without an assistant or workflow (through the REST API) | None. Every call fails with `no_context`                           | Not applicable                                 |

Not every tool can be called from a script. Some tools, such as the workspace script tool itself, are never callable. Tools that depend on the live chat session are not callable either. Use plain Python for file operations rather than tool calls.

If a script asks for a tool that is not available to its run, the call fails with `tool_unavailable`. Asking for the script tool itself fails with `tool_blocked`.

---

## Calling a Tool

`call_tool(name, args=None, *, timeout=None)` calls one tool and returns its envelope:

- `envelope["result"]` holds the tool's result. A tool that returns an object, a list, or JSON text gives the parsed value. Any other text stays a string.
- `envelope["http"]` is present only for the Jira, Confluence, GitLab, and xWiki tools. It holds `status` (the HTTP status code) and `reason`. The `result` is then the body of the third party's response. A non-2xx status is returned as data, not raised as an error, so check `status` yourself.

The arguments are the ones the tool defines. Call the tool with the names shown in the tool list of the run. An unknown argument is refused with `bad_arguments`, not ignored, so a misspelled filter cannot silently run the tool with its defaults.

---

## Several Calls at Once

Use `call_tools` to run several independent calls together:

```python
from codemie_runtime_sdk import call_tools, ToolCallError

keys = ["PROJ-1", "PROJ-2", "PROJ-3"]
calls = [
    {"name": "generic_jira_tool", "args": {"method": "GET", "relative_url": f"/rest/api/2/issue/{key}"}}
    for key in keys
]
for key, item in zip(keys, call_tools(calls)):
    if isinstance(item, ToolCallError):
        print(key, "failed:", item.code)
    else:
        print(key, item["result"]["fields"]["summary"])
```

`call_tools(calls, *, timeout=None)` takes a list of dictionaries, each with a `name` and optionally `args`. It returns a list in the same order. A call that fails is returned as a `ToolCallError` item, not raised, so one failure does not hide the other results.

- Up to `maxParallelCalls` calls (default `5`) run at the same time. The rest wait their turn.
- The `timeout` applies to the whole batch and never goes beyond the run's time limit. A call that is not answered in time returns a `ToolCallError` with the code `timeout`.
- A batch holds at most 32 calls. A problem with the batch itself, such as too many calls or an item without a `name`, raises `ToolCallError`.

Put only independent calls that read data into one batch. Calls that create, update, delete, or send something, and calls that need the result of another call, should be made one at a time with `call_tool`. The calls of a batch are not ordered.

---

## Errors

A failed call raises `ToolCallError`, or returns it as an item of a batch. The error has these attributes:

- `code`: the reason. The main codes are `tool_unavailable` (the tool is not available to this run), `bad_arguments` (the arguments do not match the tool), `tool_failed` (the tool ran and raised an error), `payload_too_large` (the request or result is over 256 KiB), `timeout` (no answer in time), and `deadline_exceeded` (too little of the run's time was left to start the call).
- `message`: a short description of the failure.
- `retryable`: `True` when repeating the same call can succeed.
- `may_have_run`: `True` when the tool may already have run before the error. A call that changes data must not be repeated while this is `True` until its result has been checked.

Check `retryable` and `may_have_run` rather than the code alone. The code `unavailable` covers two cases: the bridge is not available to the run, in which case nothing ran, and the backend stopped answering during the run, in which case the tool may have run.

---

## Limits

| Limit                         | Value                                                                   |
| ----------------------------- | ----------------------------------------------------------------------- |
| Wait for one call             | `100` seconds by default. The `timeout` argument changes it.            |
| Run time limit                | `timeoutSeconds` setting: `120` seconds by default, at most `480`.      |
| Calls served at the same time | `maxParallelCalls` setting: `5` by default. `1` serves them one by one. |
| Calls in one batch            | At most `32`.                                                           |
| Request or result size        | At most `256` KiB each.                                                 |

Calls also share a limit across all runs of the CodeMie API, so a call may wait for a free place, and that wait counts against its time. A run's time limit applies to the whole run, including the time spent waiting for a place.

:::tip Keep results small
Print or save what you need as you go, and print only what the user needs. Do not write raw tool results into the workspace unless the user asks for them.
:::
