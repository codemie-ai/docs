---
id: enable-analytics
title: Enable AI Analytics
sidebar_label: Enable AI Analytics
sidebar_position: 2
description: Turn on CodeMie analytics for Claude Code and GitHub Copilot with the CodeMie CLI, choose which projects are tracked, check the status, and fix delivery problems.
pagination_prev: user-guide/codemie-cli/codemie-cli
pagination_next: null
---

# Enable AI Analytics

CodeMie CLI collects usage analytics from the AI coding tools developers already use and sends
it to CodeMie, where it appears in [AI Attribution](../analytics/ai-attribution.md): who ran a
session, in which repository, with which model and tools, what it cost, and what it changed.

This guide is for developers who set analytics up on their machine and for managers who roll it
out to a team. Each developer runs the commands on their own computer; nothing is configured
centrally and nothing is written to the repositories.

| Vendor flag      | Collects analytics from                                                                                     |
| ---------------- | ----------------------------------------------------------------------------------------------------------- |
| `--claude-otlp`  | Claude Code (terminal), the Claude Code extension for VS Code, Claude Desktop (when routed through CodeMie) |
| `--copilot-otlp` | GitHub Copilot CLI, GitHub Copilot Chat in VS Code                                                          |

A client does not need to be installed when you connect it: its configuration is written in
advance and takes effect once the application is installed.

## Quick start

For a manager to share with the team: four commands turn analytics on for every project.

```bash
codemie self-update                       # 1. CodeMie CLI 0.17.0 or later
codemie profile login                     # 2. sign in with your CodeMie SSO account
codemie proxy connect --claude-otlp       # 3. Claude Code, VS Code extension, Claude Desktop
codemie proxy connect --copilot-otlp      #    and/or GitHub Copilot CLI and Copilot Chat
codemie proxy doctor                      # 4. check that everything is green
```

Restart the applications the command names (Claude Code, VS Code, Claude Desktop). Sessions
started after the restart appear in AI Attribution.

## Prerequisites

- **CodeMie CLI 0.17.0 or later.** Check with `codemie --version` and update with
  `codemie self-update`. To install the CLI, see [Installation](./index.md#installation).
- **A CodeMie SSO profile.** Run `codemie setup` the first time, or `codemie profile login` to
  sign in again. Analytics is sent under the signed-in account and the profile's CodeMie
  project.
- **macOS, Windows, or Linux.** For Claude Desktop under Windows, run the commands from Windows,
  not from WSL.

## Step 1. Connect analytics

Run the command for the tools you use. You can pass both flags in one run.

```bash
codemie proxy connect --claude-otlp
codemie proxy connect --copilot-otlp
codemie proxy connect --claude-otlp --copilot-otlp
```

The command:

- asks you to confirm and shows the CodeMie profile and URL it will use;
- starts the local CodeMie proxy, a background process on `http://127.0.0.1:4001` that receives
  analytics from your tools and delivers it to CodeMie;
- installs the analytics hooks into the tools' user-level settings (for Claude Code,
  `~/.claude/settings.json`);
- prints one line per client: `connected`, `configured (not installed yet — takes effect once
installed)`, or a failure with the reason.

Then restart each application the command names.

:::info Existing Claude logins are kept
`--claude-otlp` does not take over a client that is already set up. The Claude Code extension
for VS Code shares Claude Code's settings, so its analytics is collected even when it keeps its
own Claude login. Claude Desktop sends analytics only when it runs through the CodeMie proxy:
if it is already signed in to Claude or uses another gateway, the command leaves it as it is,
says so, and it is not collected. To route it through CodeMie, run
`codemie proxy connect --claude-desktop`
(see [Connect applications to CodeMie models](#connect-applications-to-codemie-models)).
:::

:::tip Scripts and CI
Without an interactive terminal the command needs `--yes` to skip the confirmation:
`codemie proxy connect --claude-otlp --yes`. Use `--profile <name>` to connect with a profile
other than the active one.
:::

## Step 2. Choose which projects are tracked

By default analytics is collected for **every project** on the machine. To track only selected
repositories, connect with `--scope project` from the root of each repository:

```bash
cd ~/work/payments-service
codemie proxy connect --claude-otlp --scope project

cd ~/work/web-portal
codemie proxy connect --claude-otlp --scope project
```

Each run adds the current repository to the tracked list and keeps the ones already there.

| Command                                    | Result                                                          |
| ------------------------------------------ | --------------------------------------------------------------- |
| `connect --claude-otlp`                    | All projects on first connect; an existing project list is kept |
| `connect --claude-otlp --scope user`       | All projects; **replaces** an existing project list             |
| `connect --claude-otlp --scope project`    | Adds the current repository to the tracked list                 |
| `disconnect --claude-otlp --scope project` | Removes the current repository from the tracked list            |

The same applies to `--copilot-otlp`.

:::warning
`--scope user` clears the list of selected projects and starts tracking every project.
:::

## Step 3. Check that it works

```bash
codemie proxy analytics status     # what is collected: scope, tracked and excluded projects
codemie proxy clients              # which tools are connected
codemie proxy doctor               # what is wrong, if anything, and the command that fixes it
```

`codemie proxy analytics status` shows the effective configuration for each connected tool:

```text
Claude:
  Hooks: installed
  Scope: selected projects (project scope)
  Tracked:
    my-org/payments-service
    my-org/web-portal
  Collection: enabled
  Excluded: none

Consented folders: none
Delivery health — run: codemie proxy doctor
```

`codemie proxy clients` lists every client with `connected`, `not connected`, or `not found`
and, for a client that is not connected, the command that connects it.

Then open **Analytics → AI Attribution** in CodeMie. New sessions appear after they are
delivered; the proxy sends them in the background and retries on its own.

## Pause or exclude analytics

To stop collection without uninstalling anything, use `codemie proxy analytics`. These
commands keep the hooks installed, so turning collection back on is instant, and they survive a
later `connect` or `disconnect`.

```bash
codemie proxy analytics exclude             # stop collecting for the current project
codemie proxy analytics include             # collect it again
codemie proxy analytics exclude ~/work/sandbox   # or pass a path

codemie proxy analytics disable             # pause collection for every project
codemie proxy analytics enable              # resume it
```

`exclude` works even when every project is tracked. Without a flag the commands apply to every
connected tool; add `--claude-otlp` or `--copilot-otlp` to limit them to one vendor.

After `include` or `enable`, the command says whether the project is collected right now and,
if not, which command to run.

## Turn analytics off

| I want to…                                | Run                                                         |
| ----------------------------------------- | ----------------------------------------------------------- |
| Pause everything, keep it installed       | `codemie proxy analytics disable`                           |
| Stop one project, keep the others         | `codemie proxy analytics exclude` in that project           |
| Remove one project from the selected list | `codemie proxy disconnect --claude-otlp --scope project`    |
| Remove Claude analytics completely        | `codemie proxy disconnect --claude-otlp`                    |
| Remove Copilot analytics completely       | `codemie proxy disconnect --copilot-otlp`                   |
| Remove everything CodeMie configured      | `codemie proxy disconnect --all`, then `codemie proxy stop` |

`codemie proxy disconnect --claude-otlp` removes the hooks and settings it wrote and gives
Claude Desktop and the VS Code extension back their own Claude login if CodeMie routed them.
Restart the applications afterwards.

## Personal Claude subscriptions: work-folder consent

If a developer uses Claude Code with a **personal Claude subscription** rather than through
CodeMie, CodeMie does not send those sessions until the developer confirms that the folder is
work. The sessions are kept on the machine in the meantime. To allow collection for a work
repository:

```bash
cd ~/work/payments-service
codemie proxy analytics consent grant       # authorize this folder (and its subfolders)
codemie proxy analytics consent list        # folders authorized for the signed-in account
codemie proxy analytics consent revoke      # withdraw it
```

Use `--project <name>` with `grant` to attribute the folder to a CodeMie project other than the
profile's. Consent applies to Claude Code only.

## The local proxy

Analytics is delivered through the CodeMie proxy, a background process on your machine. You
rarely need to manage it directly: `connect` starts it, and the analytics hooks start it again
on their next event, for example after a reboot.

```bash
codemie proxy status       # running or stopped, URL, port, profile, version
codemie proxy start        # start it (needed after a reboot for Claude Desktop, Codex, VS Code BYOK)
codemie proxy restart      # restart it, keeping its port and keys
codemie proxy stop         # stop it
```

`codemie proxy status` prints facts only and adds one line, `Issues found — run: codemie proxy
doctor`, when something is wrong. Use `codemie proxy restart --profile <name>` to switch the
proxy to another profile.

## Troubleshooting

Start with the diagnosis. `codemie proxy doctor` checks the proxy, the sign-in, every client,
the analytics connectors and delivery, and prints the command that fixes each finding:

```bash
codemie proxy doctor            # one section per area, ends with a count such as "1 warning, 0 errors"
codemie proxy doctor --verbose  # adds config file paths and Claude Desktop sessions
codemie doctor                  # full CLI health check, includes a short Proxy section
```

| `doctor` reports                                       | Fix                                                       |
| ------------------------------------------------------ | --------------------------------------------------------- |
| Proxy is not running                                   | `codemie proxy start`                                     |
| Proxy started by an older CLI (after `self-update`)    | `codemie proxy restart`                                   |
| Proxy not responding or unhealthy                      | `codemie proxy restart`                                   |
| CodeMie sign-in has expired or was rejected            | `codemie profile login`                                   |
| CodeMie unreachable                                    | Check your network or VPN, then run `doctor` again        |
| Collection is paused                                   | `codemie proxy analytics enable`                          |
| No analytics connector connected                       | `codemie proxy connect --claude-otlp` or `--copilot-otlp` |
| A client points at another port or uses the shared key | `codemie proxy connect` with that client's flag           |
| The tracked-project list is invalid                    | `codemie proxy connect --claude-otlp --overwrite`         |
| Analytics preferences cannot be read                   | Fix or delete the file named in the message               |
| An older CodeMie CLI is first on `PATH`                | Update or remove the older install                        |
| Delivery: last send failed, or waiting for CodeMie     | Nothing to do: delivery retries on its own                |
| Delivery: CodeMie isn't set up to accept this data     | Contact your CodeMie administrator                        |
| Delivery: destination doesn't match your account       | `codemie proxy restart`                                   |

Common questions:

- **A project does not show up.** Run `codemie proxy analytics status` inside it. It is either
  excluded (`codemie proxy analytics include`), not in the selected list
  (`codemie proxy connect --claude-otlp --scope project`), or collection is paused
  (`codemie proxy analytics enable`). With a personal Claude subscription, also check
  [work-folder consent](#personal-claude-subscriptions-work-folder-consent).
- **Nothing arrives after connecting.** Restart the application: tools read their settings at
  startup.
- **Sessions from a paused period appear later.** Usage is read from the session transcript, so
  after `enable` or `include` the next event reports what was written in the meantime (Claude
  Code and Copilot CLI).
- **More detail.** Run `CODEMIE_DEBUG=true codemie proxy doctor`.

## Connect applications to CodeMie models

The same proxy also routes desktop applications and IDEs to the CodeMie model catalog, so they
use your organization's models and SSO instead of a personal subscription:

| Command                                      | Application                                                       |
| -------------------------------------------- | ----------------------------------------------------------------- |
| `codemie proxy connect --claude-desktop`     | Claude Desktop (see [Claude Desktop](./claude/claude-desktop.md)) |
| `codemie proxy connect --vscode-claude-code` | Claude Code extension for VS Code                                 |
| `codemie proxy connect --vscode`             | GitHub Copilot Chat models in VS Code (bring your own key)        |
| `codemie proxy connect --codex-desktop`      | Codex desktop app                                                 |
| `codemie proxy connect --omp`                | oh-my-pi                                                          |

Add `--insiders` for VS Code Insiders. Each has a matching `codemie proxy disconnect` flag.
Run `codemie proxy connect` without a flag to list all targets.

## Command reference

| Command                                       | Options                                                                                                                                         |
| --------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------- |
| `codemie proxy connect`                       | `--claude-otlp`, `--copilot-otlp`, client flags, `--scope user\|project`, `--yes`, `--profile <name>`, `--overwrite`, `--insiders`, `--verbose` |
| `codemie proxy disconnect`                    | Same target flags, `--all`, `--scope user\|project`, `--insiders`                                                                               |
| `codemie proxy analytics status`              | `--claude-otlp`, `--copilot-otlp`, `--json`                                                                                                     |
| `codemie proxy analytics enable` / `disable`  | `--claude-otlp`, `--copilot-otlp`                                                                                                               |
| `codemie proxy analytics include` / `exclude` | `[path]`, `--claude-otlp`, `--copilot-otlp`                                                                                                     |
| `codemie proxy analytics consent grant`       | `[path]`, `--project <name>`, `--yes`                                                                                                           |
| `codemie proxy analytics consent revoke`      | `[path]`                                                                                                                                        |
| `codemie proxy analytics consent list`        |                                                                                                                                                 |
| `codemie proxy status`                        | `--json`, `--show-key`                                                                                                                          |
| `codemie proxy clients`                       | `--json`                                                                                                                                        |
| `codemie proxy doctor`                        | `--verbose`, `--json`                                                                                                                           |
| `codemie proxy start`                         | `--port <port>`, `--profile <name>`                                                                                                             |
| `codemie proxy restart`                       | `--profile <name>`                                                                                                                              |
| `codemie proxy stop`                          |                                                                                                                                                 |
| `codemie proxy reset-mcp-auth`                | `--claude-desktop`                                                                                                                              |

Every command accepts `--help`.

:::note Renamed commands
Older forms keep working until December 31, 2026 and print the replacement:
`--claude-code-otlp` → `--claude-otlp`; `--copilot-chat-otlp` and `--copilot-cli-otlp` →
`--copilot-otlp`; `proxy status --deep` → `proxy doctor`; `proxy inspect desktop` →
`proxy doctor --verbose`; `--silent` → `--yes`; `--force` → `--overwrite` or `proxy restart`;
`analytics connect-folder` / `disconnect-folder` → `analytics consent grant` / `revoke`.
:::

## Related

- [AI Attribution](../analytics/ai-attribution.md): where the collected analytics is shown.
- [Claude Desktop](./claude/claude-desktop.md): route Claude Desktop to CodeMie models.
- [CodeMie CLI](./index.md): installation and all CLI commands.
