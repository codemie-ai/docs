---
id: privacy-policy
title: Chrome Extension Privacy Policy
sidebar_label: Privacy Policy
pagination_prev: user-guide/chrome-extension/index
pagination_next: null
sidebar_position: 2
---

# Chrome Extension Privacy Policy

:::warning Pending review — remove this notice before publishing
This policy is awaiting legal review, and the bracketed placeholders below must be filled in. Do not merge
this page or submit its URL to the Chrome Web Store until both are done.
:::

**Last updated: 4 August 2026**

**Applies to:** the EPAM AI/Run CodeMie browser extension for Google Chrome, version 0.3.2 and later.

This policy covers the browser extension specifically. For how the CodeMie platform itself processes and
stores data, see [Data Processing and Storage Architecture](../../admin/security/data-processing-storage.md).

---

## 1. Who we are

The EPAM AI/Run CodeMie browser extension ("the Extension") is published by **[LEGAL ENTITY NAME]**
("we", "us").

The Extension is a client for the CodeMie platform. It does not operate a backend of its own. All
server-side processing happens on the CodeMie instance your organization configures — for enterprise
deployments, that instance is operated by your organization, or by us under your organization's agreement
with us.

Contact for privacy questions: **[PRIVACY CONTACT EMAIL]**

## 2. What the Extension does

The Extension adds an AI assistant side panel to Chrome. It can read the page you are viewing, answer
questions about it, and — when you ask it to — perform actions on that page such as clicking, typing, and
filling forms.

---

## 3. Data the Extension processes

### 3.1 Page content

When you use a feature that needs page context, the Extension reads the current tab's content — text, DOM
structure, link and form labels — and sends it to your configured CodeMie instance, which forwards it to
the large language model that answers you.

**Screenshots.** When the assistant needs to interpret something visual, such as a chart, an image, or a
layout the page structure cannot describe, it captures an image of the visible area of the current tab and
sends it to the model for analysis. A screenshot captures whatever is on screen at that moment, which may
include content unrelated to your request.

:::warning
Do not use the assistant on pages showing information you do not want transmitted to your CodeMie instance
and its model provider — online banking, health records, private messages, or credential managers. The
Extension does not detect sensitive pages automatically.
:::

Page content and screenshots are processed to answer your request. They are transmitted, not stored, by the
Extension itself; retention on the server is governed by your CodeMie instance's own policy.

### 3.2 Your prompts and conversations

Messages you send, the assistant's replies, and records of tool actions are stored locally in the browser
and, unless you use a temporary chat, synchronized to your CodeMie instance so conversations are available
across devices.

Choosing a temporary chat keeps that conversation local — it is not created or synchronized server-side.

### 3.3 Authentication data

Sign-in uses your organization's single sign-on through the CodeMie platform. The Extension stores the
resulting session cookies and replays them on requests to your CodeMie instance. Sessions are not
refreshed; when one expires you sign in again.

The Extension does not receive, store, or transmit your password.

### 3.4 Usage analytics

The Extension sends one usage record per assistant turn to your CodeMie instance. **This telemetry is
always on and cannot be switched off in the Extension.** The settings page states this and lists what each
record contains.

Each record contains:

- Which feature was used — chat, agent mode, summarize, quick action, or flow replay — along with which
  options were enabled, the model name, iteration limits, and the extension version
- Counts and outcomes: number of tool calls, successes, failures, turn duration, and whether the turn
  errored
- Identifiers: a random per-turn session id, a panel session id, conversation and assistant ids, and a
  project value — your pseudonymous analytics id if one was generated, otherwise your CodeMie project name
- Hostnames of additional browser tabs you attached as context. Only `http` and `https` hosts are included,
  and hosts recognized as internal or private are replaced with a placeholder
- Names you gave to your own configurations: MCP server names, saved prompt names, recorded flow names, and
  quick action names, plus counts of each

It does **not** contain your prompts, the assistant's replies, page content, screenshots, or your email
address. However, because the request is authenticated with your session, the receiving CodeMie instance
can associate the record with your account. **This telemetry is not anonymous.**

Records are queued locally if the network is unavailable, capped at 100 records, and discarded after seven
days.

### 3.5 Settings and local data

Your settings, saved prompts, recorded flows, quick actions, and MCP server configurations — including any
authentication headers you enter for them — are stored locally in the browser on your device.

---

## 4. Where your data goes

| Destination                                     | What is sent                                                                | When                                                                   |
| ----------------------------------------------- | --------------------------------------------------------------------------- | ---------------------------------------------------------------------- |
| Your configured CodeMie instance                | Page content, screenshots, prompts, replies, conversations, usage analytics | Whenever you use the assistant                                         |
| The model provider behind your CodeMie instance | Page content, screenshots, and prompts, forwarded by CodeMie                | Whenever you use the assistant                                         |
| MCP servers you configure                       | The tool arguments for tools you invoke on that server                      | Only if you add an MCP server and the assistant calls one of its tools |
| Web search and scraping tools                   | Your search query, or the URL to fetch                                      | Only when you use those features                                       |

The Extension has no hardcoded third-party endpoint and cannot be pointed at an arbitrary model provider —
both of its connection modes target a CodeMie instance. The address of that instance is a setting, so which
server receives your data is determined by the URL you or your administrator configure. Beyond that, it
talks only to MCP servers you add yourself.

We do not sell your data, share it with data brokers, or use it for advertising. It is not used to determine
creditworthiness or for lending.

:::note
MCP servers are third parties you choose. Anything the assistant sends to a server you configured is
governed by that server operator's terms, not by this policy.
:::

---

## 5. Browser permissions and why they are needed

| Permission             | Why it is needed                                                                                                                                         |
| ---------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `sidePanel`            | Renders the assistant panel, which is the Extension's main interface                                                                                     |
| `storage`              | Stores settings, conversations, and queued analytics locally                                                                                             |
| `scripting`            | Injects the page-analysis script that builds the structural snapshot the assistant acts on                                                               |
| `activeTab`            | Reads the tab you invoked the assistant on                                                                                                               |
| `tabs`                 | Completes sign-in by detecting the callback address, and lets you attach other open tabs as context                                                      |
| `cookies`              | Reads the session cookies used to authenticate CodeMie API calls                                                                                         |
| `contextMenus`         | Adds the right-click "Ask CodeMie" action on selected text                                                                                               |
| `alarms`               | Runs the periodic timer that uploads queued analytics                                                                                                    |
| `webRequest`           | Observation only. Counts in-flight requests on the active tab so automation can wait for a page to settle. It cannot block, redirect, or modify requests |
| Access to all websites | The assistant must be able to read and act on whatever page you invoke it on                                                                             |

---

## 6. Data retention

- **On your device:** settings and conversations persist until you clear them or remove the Extension.
  Queued analytics are deleted after seven days.
- **On the server:** governed by your CodeMie instance's retention policy. See
  [Data Processing and Storage Architecture](../../admin/security/data-processing-storage.md).

Removing the Extension deletes all local data. It does not delete conversations already synchronized to
your CodeMie instance — request deletion through your CodeMie administrator.

---

## 7. Your rights

Depending on your jurisdiction, including under the GDPR, you may have the right to access, correct,
delete, export, or restrict processing of your personal data, and to object to processing. Because most
server-side data is held by your CodeMie instance, exercise these rights through your organization's
CodeMie administrator, or by contacting us at **[PRIVACY CONTACT EMAIL]**.

## 8. Children

The Extension is a workplace tool and is not directed at children under 16.

## 9. Changes to this policy

We will update this page and revise the date above when practices change. Material changes will be
communicated through the Extension or by your CodeMie administrator.
