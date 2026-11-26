---
id: analytics-privacy
title: 'Analytics Privacy: Hide Prompts in Analytics'
sidebar_label: Analytics Privacy
sidebar_position: 3
description: Turn on prompt reduction in CodeMie CLI so that analytics keeps only command, skill and agent names, ticket and MR numbers and metrics, and no prompt text or other project content leaves the machine.
pagination_prev: user-guide/codemie-cli/codemie-cli
pagination_next: null
---

# Analytics Privacy: Hide Prompts in Analytics

By default, the analytics that CodeMie CLI collects (see [Enable AI Analytics](./enable-analytics.md))
carries the text of prompts, tool input and output, file paths and branch names. Some projects
have rules that forbid sharing any project information outside the developer's machine.

**Analytics privacy**, also called **prompt reduction**, is an opt-in setting for these projects.
With it on, analytics keeps only the work signal: which command, skill or agent ran, on which
ticket and merge or pull request, and the usage metrics. Every other piece of content is replaced
by a placeholder before it is sent or stored.

The setting can be turned on for all projects on the machine or for a single project. It is off by
default, and with it off analytics is unchanged.

## What is sent and what is hidden

| Sent unchanged                                      | Hidden                                     |
| --------------------------------------------------- | ------------------------------------------ |
| Event and tool type names, including MCP tool names | Prompt text (reduced as described below)   |
| Command, skill and agent type names                 | Tool input and tool responses              |
| Ticket and merge or pull request numbers            | File paths and transcript paths            |
| Model names, token counts, costs and other metrics  | Session titles                             |
| Session and project identifiers                     | Error messages and descriptions            |
| Repository name and git remote                      | Branch names (ticket keys are kept)        |
| Shared branch names such as `main` or `develop`     | Any other text field, including new fields |

A hidden field is replaced by `REDACTED:<FIELD>`, where `<FIELD>` is the field name, for example
`REDACTED:TOOL-INPUT`. If a field cannot be reduced, it is sent as `REDACTED:FAILED`, the metrics
are still sent, and the failure is written to the local log without the field content. A prompt that
keeps some parts and loses other text ends with `REDACTED:REST_PROMPT`.

### How prompts and branches are reduced

| Value                                                  | Sent as                                                                                                                                                   |
| ------------------------------------------------------ | --------------------------------------------------------------------------------------------------------------------------------------------------------- |
| A prompt that starts with a command or skill           | The command name plus the ticket and MR references found in the whole prompt: `/review-pr !456 check auth` becomes `/review-pr !456 REDACTED:REST_PROMPT` |
| A prompt without a command                             | The ticket and MR references only: `fix EPMCDME-123 see !456` becomes `EPMCDME-123 !456 REDACTED:REST_PROMPT`                                             |
| A prompt with no command, ticket or MR                 | `REDACTED:PROMPT`                                                                                                                                         |
| An automatic prompt (hook, task or agent notification) | Its bare marker, for example `<task-notification>`                                                                                                        |
| A continuation prompt after a context reset            | `This session is being continued from a previous conversation`                                                                                            |
| A git branch                                           | Its ticket keys (`feature/acme-EPMCDME-5` becomes `EPMCDME-5`), or `REDACTED:BRANCH` when it has none                                                     |
| A shared branch name                                   | Sent unchanged when the whole name is exactly `main`, `master`, `develop`, `dev`, `qa`, `test`, `testing`, `perf`, `stage`, `staging` or `prod`           |
| A Skill or Agent tool call                             | The skill or agent type name; the description and prompt passed to the subagent are dropped                                                               |

`REDACTED:REST_PROMPT` is added only when text was removed: `/review-pr !456` typed alone is sent
as it is. Every prompt in a session is reduced, not only the first one.

The following ticket and MR references are recognized, in any letter case, and kept as written:

- Jira-style keys: `EPMCDME-123`, `epmcdme-123`
- GitHub: `#24` and `org/repo#24`
- Azure DevOps: `AB#123`
- GitLab: `!456`
- Merge and pull request URLs: only the path word and number are kept, such as `pull/24` or
  `merge_requests/77`, including the `merge-requests`, `pull-requests`, `pullrequests` and
  `pullrequest` forms
- Issue URLs: only the path word and number are kept, such as `issues/31` or `work_items/33`

Text that only resembles a command or a reference is not kept: `/usr/bin/node` in the middle of a sentence,
`#fff`, a `# Plan` heading or `v1.2.3`. A prompt that does not start with a command keeps no command
name. A word such as `step-2` matches the ticket key pattern and is kept.

:::info Ticket attribution is not affected
Ticket attribution in [AI Attribution](../analytics/ai-attribution.md) is computed from the raw
prompt and branch on the machine, before reduction. It gives the same result with reduction on or
off.
:::

## Turn analytics privacy on

### With `codemie setup`

Run `codemie setup`. The last step, **Analytics privacy**, shows what is sent and what is hidden,
and the current setting:

```text
Analytics privacy
Hide prompts and project details in the analytics CodeMie collects.
  Sent:   commands (/commit), skill and agent names, ticket and MR numbers, metrics
  Hidden: prompt text, file paths, tool input/output, branch names (ticket keys kept)
  Note:   conversation history in CodeMie chat is not affected.

Current: global off · this project (payments-service) off
? Hide prompts in analytics? (Use arrow keys)
❯ Off
  On for all projects
  On for this project only (payments-service)
```

The choices depend on the current setting:

| Current setting      | Choice                                     | Result                                                                                 |
| -------------------- | ------------------------------------------ | -------------------------------------------------------------------------------------- |
| Off for all projects | **Off**                                    | Turns it off for the current project too, if it was on there                           |
| Off for all projects | **On for all projects**                    | Reduces analytics for every project on the machine                                     |
| Off for all projects | **On for this project only (`<project>`)** | Reduces analytics for the current project only                                         |
| On for all projects  | **Keep on for all projects**               | Changes nothing                                                                        |
| On for all projects  | **Off**                                    | Turns it off for all projects and the current project, and lists projects that stay on |
| On for all projects  | **On for this project only (`<project>`)** | Turns the global setting off and the current project on in one step                    |

The project choice is saved in `.codemie/codemie-cli.config.json` at the project root. Committing
that file applies the setting to every team member who works in the repository. A repository that
ignores `.codemie` in `.gitignore` needs the file force-added:

```bash
git add -f .codemie/codemie-cli.config.json
```

:::warning
Commit the project file only when it holds the analytics setting alone. If the same file also holds
CLI profiles, committing it also commits their API keys and URLs.
:::

When reduction is turned on and Claude Code analytics (`--claude-otlp`) still sends data in the
`http/protobuf` format, setup reports it and asks `Switch to http/json?`. Answer yes; see
[Known limits](#known-limits) for the reason.

### In the configuration file

The setting is a single key, `analytics.promptReduction`, in the same file that holds the CLI
profiles:

```json
{
  "analytics": { "promptReduction": true }
}
```

| File                                         | Scope               |
| -------------------------------------------- | ------------------- |
| `~/.codemie/codemie-cli.config.json`         | All projects        |
| `<project>/.codemie/codemie-cli.config.json` | The current project |

- Reduction is on when **either** file has `true`. While the global setting is on, a project cannot
  turn reduction off for itself.
- `false`, a missing key or a missing file means off.
- A file that cannot be read or is malformed counts as **on**, and a warning is written to the log
  once.
- A project file may hold only this key. It does not change which CLI profile is used.
- In a monorepo, every `.codemie` folder from the working directory up to the repository root is
  read, so a package inside the repository follows the opt-in at the root.

## Where analytics privacy applies

The same rules cover every analytics route:

- the analytics hooks for Claude Code, GitHub Copilot CLI and GitHub Copilot Chat;
- native Claude Code telemetry sent through `codemie proxy connect --claude-otlp`;
- Claude Desktop (Cowork) sessions;
- the GitHub Copilot usage enrichment;
- managed-agent session metrics, including error text and branch;
- the local `codemie analytics` report;
- `codemie analytics sync`.

The decision is made once per session, when the session's first analytics event is collected, from
the global setting and the session's project. The background proxy then follows that decision for
the rest of the session.

### Local report and sync

With reduction on, the local `codemie analytics` report is reduced by default, in the terminal and
in every export: the session title is reduced like a prompt, the branch is cut to its ticket keys, the
project is shown as its folder name, and other text fields are replaced by placeholders. Metrics, models, tools and costs are unchanged.

To see the full data on the local machine, use `--unreduced`:

```bash
codemie analytics --unreduced
codemie analytics --unreduced --export html
```

`--unreduced` applies only to the local report. It sends nothing, and every other route stays
reduced. With reduction on, `--redact` has no extra effect, because reduction already hides more.

`codemie analytics sync` always sends reduced data for a project that opted in, and has no
unreduced option. A report that covers several projects reduces only the sessions of the projects
that opted in.

`codemie analytics sync status` and the summary of `codemie analytics sync install` print a
**Prompt reduction** line: on globally, or off globally with the number of projects on the machine
that turned it on in `codemie setup`. The line is for information only. A project whose committed
configuration file turns reduction on is reduced even when it is not counted.

## Known limits

- **Native Claude Code telemetry in `http/protobuf` format is dropped.** Protobuf records cannot be
  reduced field by field, so they are skipped for reduced sessions and the log names the fix. To
  keep them, switch the connection to `http/json` by running
  `codemie proxy connect --claude-otlp`, or answer yes when `codemie setup` offers it.
- **Conversation history is not reduced.** Managed agents still upload full conversations to
  CodeMie conversation history. Analytics privacy covers analytics only.
- **Data already collected does not change.** Analytics that was spooled, synced or stored before
  reduction was turned on is not rewritten.
- **Claude Desktop (Cowork) cannot read a project's configuration.** For Cowork, setup keeps a list
  of opted-in projects in `~/.codemie/analytics-reduction-projects.json`. A Cowork session without
  a known working directory follows the global setting only, and an unreadable list counts as on.
- **Reduced event ids cannot be guessed.** The ids of reduced events are keyed with a random local
  key stored in `~/.codemie/analytics-event-key`. The key is never logged or sent.

## Check that it works

1. Turn reduction on for a project with `codemie setup`.
2. Start Claude Code in that project and send `/review-pr !456 secret notes`.
3. Run `codemie analytics` in the project. The recorded prompt reads
   `/review-pr !456 REDACTED:REST_PROMPT`.
4. Send a plain prompt with no command or ticket. It is recorded as `REDACTED:PROMPT`.

To turn reduction off, run `codemie setup` and choose **Off**.

## Related

- [Enable AI Analytics](./enable-analytics.md): connect analytics and choose which projects are
  tracked.
- [AI Attribution](../analytics/ai-attribution.md): where the collected analytics is shown.
- [CodeMie CLI](./index.md): installation and all CLI commands.
