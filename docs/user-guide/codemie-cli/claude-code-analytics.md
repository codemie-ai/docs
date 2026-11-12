---
id: claude-code-analytics
title: Send Claude Code Sessions to Project Analytics
sidebar_label: Claude Code Project Analytics
sidebar_position: 7
pagination_prev: user-guide/codemie-cli/codemie-cli
pagination_next: null
---

import EnterpriseFeature from '@site/src/components/EnterpriseFeature';

# Send Claude Code Sessions to Project Analytics

<EnterpriseFeature />

CodeMie CLI can send native Claude Code sessions to a CodeMie project, where they appear under **CLI Analytics**. Folder consent for sharing session content is opt-in. This page covers setup, verification, and how to turn it off for the case where Claude Code is started directly with `claude` and signed in with a personal Claude subscription.

:::note Scope
The instructions use native `claude`, not `codemie-claude`.
:::

## Collection and publication are separate

Two independent decisions control what leaves the machine:

| Decision                | What it does                                                                 | Command                                    |
| ----------------------- | ---------------------------------------------------------------------------- | ------------------------------------------ |
| **Collection**          | CodeMie hooks record Claude Code activity locally for the chosen projects.   | `codemie proxy connect --claude-code-otlp` |
| **Publication consent** | A folder is authorized to publish its sessions to one named CodeMie project. | `codemie proxy analytics connect-folder`   |

Connecting a folder does not turn collection on. For a native Claude Code session with a personal subscription, collection alone does not publish session content to a project; both must be in place.

A personal Claude subscription and a project destination are also different things. The subscription only pays for the model usage. The project is where analytics are stored, and it is a separate choice: connecting a folder with `--project` names the project that receives that folder's session content. A project that is merely configured, for example in a profile or workspace, does not by itself grant the explicit folder consent that sharing conversation content requires. On CLI versions that include EPMCDME-17142, a session classified as Personal, or a confirmed subscription session whose classification is Unknown, does not send CLI Analytics telemetry without explicit `connect-folder` consent for its folder. Consent is not retroactive: sessions that ran before the folder was connected are not sent afterwards. On earlier versions, such a session without consent stays in owner-only personal analytics where available, and is not published to a shared project as a fallback if personal storage is unavailable.

:::note CodeMie Chats history sync is separate
This rule covers CLI Analytics telemetry only. The separate CodeMie Chats history sync is not changed by it or by `connect-folder`, so not all data stays on the device.
:::

## Prerequisites

- CodeMie CLI and Claude Code installed (see [CodeMie CLI](./index.md#installation)).
- A CodeMie SSO profile for the target CodeMie instance, created with `codemie setup` (provider CodeMie SSO). `codemie proxy connect --claude-code-otlp` accepts only an SSO-backed profile; a profile of another type, such as an Anthropic Subscription profile, is refused.
- Claude Code already signed in with the personal Claude account. This is the native Claude sign-in and is separate from the CodeMie SSO profile; CodeMie setup does not replace it.
- Access to the CodeMie project that will receive the sessions.
- CLI analytics enabled for that project. A project with CLI analytics disabled does not receive the session; a CodeMie admin can enable it.

## Set up a project

Run the steps from the folder of the repository to be tracked.

1. Create or select the CodeMie SSO profile. `codemie setup` signs in to CodeMie, so no separate login is needed. The folder connection is tied to this signed-in account and backend.

   ```bash
   codemie setup
   ```

2. Turn on Claude Code collection for this project only, naming the SSO profile explicitly. This is needed when the active profile is not SSO-backed, and is harmless otherwise:

   ```bash
   codemie proxy connect --claude-code-otlp --scope project --profile "<sso-profile-name>"
   ```

   The profile is used for this command only and does not change the active profile. The command asks for confirmation. The first setup needs a Claude Code restart. Running it in another repository adds that repository to the tracked list. Without `--scope project`, every project is tracked.

3. Authorize the folder to publish to the project:

   ```bash
   codemie proxy analytics connect-folder --project "<project-name>"
   ```

   Replace `<project-name>` with the exact CodeMie project name. The command prints the folder and project and asks for confirmation. In a non-interactive terminal, add `--yes` after reviewing the notice below.

   :::warning Conversation content becomes visible to project admins
   Connecting a folder shares the **content** of its sessions, including prompts, tool input and output, and transcripts, with the admins of the project. The connection covers every sub-folder that resolves to the same project. Connect only folders whose work may be shared this way.
   :::

   Project names must use Latin-1 characters; other names are rejected before anything is saved.

4. Check the result:

   ```bash
   codemie proxy analytics status
   ```

   Status shows whether the current folder is tracked and, if not, the command that fixes it.

## Verify in CLI Analytics

Connecting applies to sessions that start after the folder is connected. A session that was already open does not gain the consent.

1. Start a new Claude Code session in the connected folder with `claude` and send a prompt.
2. In CodeMie, open the **CLI Analytics** page of the project.
3. Find the new session. It can take a few minutes to arrive.

If nothing appears, run `codemie proxy analytics status` and confirm that collection is enabled, the folder is not excluded, and CLI analytics is enabled for the project.

## What changes and when

- **Connecting applies to new sessions.** A session started before the connection is not upgraded to share content with the project.
- **Disconnecting stops further publication.** It applies to every session that relies on the connection, including sessions that are already open.
- **Stored data stays.** Data already accepted by CodeMie is not removed by disconnecting.
- **A configured project does not grant consent.** A project set in a profile or workspace only proposes a name for `connect-folder`; it does not by itself grant explicit folder consent.

## Disconnect a folder

```bash
codemie proxy analytics disconnect-folder
```

Run the command from the folder, or pass the folder path. Sessions that rely on the connection stop publishing, including sessions that are open and data that is still queued. Data already stored in CodeMie is not removed. If a parent folder is also connected, the command names it and prints the exact command that withdraws it.

To pause collection for the whole integration or exclude one project, use `codemie proxy analytics disable` and `codemie proxy analytics exclude`. These controls apply to Claude Code hooks only and do not remove a folder connection.

## Troubleshooting

| Message or symptom                                              | Action                                                                                                                                                                                                                                                                                                    |
| --------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `... cannot be used for ... proxy because it is not SSO-backed` | Pass `--profile "<sso-profile-name>"` with a CodeMie SSO profile, or run `codemie setup` to create one.                                                                                                                                                                                                   |
| `No SSO credentials found for profile`                          | Run the `codemie profile login --url ...` command printed in the message, then repeat `proxy connect`.                                                                                                                                                                                                    |
| `Sign in to CodeMie first`                                      | The session expired or the account is not signed in. Run `codemie profile login`, then repeat `connect-folder`.                                                                                                                                                                                           |
| `No CodeMie project resolved for this folder`                   | Pass `--project "<project-name>"`.                                                                                                                                                                                                                                                                        |
| `Confirmation required: re-run with --yes`                      | The terminal is not interactive. Add `--yes` after reviewing the notice.                                                                                                                                                                                                                                  |
| Sessions do not show up in CLI Analytics                        | Check `codemie proxy analytics status`. A delivery warning such as `unhealthy` with pending data can have several causes. If CLI Analytics is disabled for the project, ask a CodeMie admin to enable it, then let the running proxy retry; the queued session is then delivered without being discarded. |
