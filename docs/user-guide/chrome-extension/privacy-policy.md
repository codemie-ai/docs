---
id: privacy-policy
title: Chrome Extension Privacy Policy
sidebar_label: Privacy Policy
pagination_prev: user-guide/chrome-extension/index
pagination_next: null
sidebar_position: 2
---

# Chrome Extension Privacy Policy

**Last updated: 8 September 2026**

**Applies to:** the EPAM AI/Run CodeMie browser extension for Google Chrome, version 0.3.2 and later.

This policy covers the browser extension specifically. For how the CodeMie platform itself processes and
stores data, see [Data Processing and Storage Architecture](../../admin/security/data-processing-storage.md).

---

## 1. Who we are

The EPAM AI/Run CodeMie browser extension ("the Extension") is published by **EPAM Systems, Inc.**
("EPAM", "we", "us").

The Extension is a client for the CodeMie platform. It does not operate a backend of its own. All
server-side processing happens on the CodeMie instance your organization configures — for enterprise
deployments, that instance is operated by your organization, or by us under your organization's agreement
with us.

In most enterprise deployments your organization is the data controller for the content you send through
the Extension, and EPAM acts as a processor under the agreement between you. Where that is the case,
requests about your personal data are handled first by your own organization.

Contact for privacy questions about the Extension: **[AskCodeMie@epam.com](mailto:AskCodeMie@epam.com)**

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

Page context can also include text extracted from a direct HTTP(S) PDF, selected text, and content from
other open tabs you explicitly attach. The Extension fetches supported PDF URLs and extracts text locally
before including it in the request.

**Screenshots.** When the assistant needs to interpret something visual, such as a chart, an image, or a
layout the page structure cannot describe, it can capture an image of the visible area of the current tab.
A screenshot captures whatever is on screen at that moment, which may include content unrelated to your
request. With the default approval setting, the Extension shows a preview and asks before sending the
screenshot to the model. If you enable Auto-approve, screenshots and page actions can proceed without that
separate review. Captured screenshots are used for the current request and are not written to persistent
extension storage.

:::warning
Do not use the assistant on pages showing information you do not want transmitted to your CodeMie instance
and its model provider — online banking, health records, private messages, or credential managers. The
Extension does not detect sensitive pages automatically.
:::

Page content and screenshots are processed to answer your request. They are transmitted, not stored, by the
Extension itself; retention on the server is governed by your CodeMie instance's own policy.

### 3.2 Your prompts and conversations

Messages, replies, and tool-action records in chats tied to a selected assistant are synchronized to your
CodeMie instance so those conversations can be available across devices. The current panel message list is
also cached in Chrome's session storage for the current browser session.

A chat without an assistant is not synchronized to CodeMie and is only cached for the current browser
session. A temporary chat is not saved to history or synchronized server-side, and is not written to the
panel's session message cache.

### 3.3 Authentication data

Sign-in uses your organization's single sign-on through the CodeMie platform. The Extension receives the
resulting CodeMie session data from a fixed loopback callback and stores it in Chrome's session storage. It
sends that session data only to the configured CodeMie instance for authenticated API requests. Session
storage is cleared when the browser closes, and sessions are not refreshed automatically — sign in again
after a browser restart or session expiry.

The Extension does not receive or store the password you enter on your organization's SSO page. Text or
credentials you separately provide in a prompt, or ask the assistant to type into another page, are
page-action data and are not covered by that statement.

### 3.4 Usage analytics

The Extension sends one usage record per assistant turn to your CodeMie instance. **This telemetry is
always on and cannot be switched off in the Extension.** The settings page states this and lists what each
record contains.

Each record contains:

- Which feature was used — chat, agent mode, summarize, quick action, or flow replay — along with which
  options were enabled, the model name, iteration limits, and the extension version
- Counts and outcomes: number of tool calls, successes, failures, turn duration, and whether the turn
  errored
- Identifiers: a random per-turn session id, a panel session id, conversation and assistant ids when
  present, and a pseudonymous analytics id the Extension generates and stores itself
- Hostnames of additional browser tabs you attached as context. Only `http` and `https` hosts are included,
  and hosts recognized as internal or private are replaced with a placeholder
- Configuration inventory: counts and the names you gave your saved prompts, recorded flows, and MCP
  servers

It does **not** contain your prompts, the assistant's replies, page content, screenshots, or your email
address. However, because the request is authenticated with your session, the receiving CodeMie instance
can associate the record with your account. **This telemetry is not anonymous.**

Records are queued locally if the network is unavailable, capped at 100 records, and discarded after seven
days.

### 3.5 Settings and local data

Your preferences, the last successful login address, saved prompts, recorded flows, per-site rules, saved
Knowledge pages and notes, and MCP server configurations are stored in the Extension's local browser
storage. Saved Knowledge is not sent anywhere merely because it is stored; when you enable **Knowledge**,
matching snippets may be included in requests to CodeMie and its model provider.

Sensitive MCP header values are encrypted at rest. The encryption key is session-scoped, so those values
cannot be recovered after the browser closes and must be re-entered. Header names and other non-sensitive
MCP configuration remain in local storage.

---

## 4. Where your data goes

| Destination                                     | What may be sent                                                                                                                                                                          | When                                                                                |
| ------------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | ------------------------------------------------------------------------------------ |
| Your configured CodeMie instance                | Prompts, conversation messages and tool traces, current-page/selection/PDF context, attached-tab content, approved screenshots, saved Knowledge snippets selected for the request, MCP and web-tool inputs/results, and usage analytics | According to the features used for a request; analytics is sent for tracked turns    |
| The model provider behind your CodeMie instance | The model conversation assembled for the request, which may include prompts, prior messages, page/PDF/tab context, approved screenshots, Knowledge snippets, and MCP/web-tool results       | Whenever CodeMie invokes the configured model                                        |
| MCP servers attached to your assistant           | Tool name, tool arguments, and MCP protocol/session messages                                                                                                                                 | Only when the assistant calls one of that server's tools                             |
| CodeMie web search and scraping tools            | Your search query, or the URL to fetch                                                                                                                                                       | Only when those CodeMie platform tools are invoked                                   |

Results returned by MCP, web search, and scraping tools may be added to the model conversation and
therefore sent through your CodeMie instance to its model provider.

The Extension has no hardcoded third-party endpoint and cannot be pointed at an arbitrary model provider —
both of its connection modes target a CodeMie instance. The address of that instance is a setting, so which
server receives your data is determined by the URL you or your administrator configure. Beyond that, it
talks only to MCP servers attached to the assistants you use.

We do not sell your data, share it with data brokers, or use it for advertising. It is not used to determine
creditworthiness or for lending.

:::note
MCP servers are third parties chosen by whoever configured your assistant. Anything the assistant sends to
one of those servers is governed by that server operator's terms, not by this policy.
:::

---

## 5. Browser permissions and why they are needed

| Permission             | Why it is needed                                                                                                                                         |
| ---------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `sidePanel`            | Renders the assistant panel, which is the Extension's main interface                                                                                     |
| `storage`              | Stores persistent preferences, saved content, recorded flows, and queued analytics in local storage; stores authentication data and the current panel message cache in session storage |
| `scripting`            | Injects the page-analysis script that builds the structural snapshot the assistant acts on                                                               |
| `activeTab`            | Reads the tab you invoked the assistant on                                                                                                               |
| `tabs`                 | Completes sign-in by detecting the fixed local callback address, and lets you attach other open tabs as context                                          |
| `contextMenus`         | Adds the right-click "Explain selection with CodeMie" and "Remember selection (CodeMie)" actions on selected text                                        |
| `alarms`               | Runs the periodic timer that uploads queued analytics                                                                                                    |
| `webRequest`           | Observation only. Counts in-flight requests on the active tab so automation can wait for a page to settle. It cannot block, redirect, or modify requests |
| Access to all websites | Lets the Extension read supported HTTP(S) pages, fetch direct HTTP(S) PDFs, and perform user-requested actions. Chrome still blocks restricted pages such as `chrome://` and the Chrome Web Store |

:::note
The Extension does not request the `cookies` or `identity` permissions. Your CodeMie session is obtained
from a fixed local callback during sign-in, not by reading browser cookies.
:::

---

## 6. Data retention

- **Persistent on-device data:** preferences, the last successful login address, saved prompts, saved
  Knowledge, recorded flows, per-site rules, MCP configuration metadata, and queued analytics remain in
  local storage until deleted, replaced, or the Extension is removed. Queued analytics are capped at 100
  entries, and entries older than seven days are discarded.
- **Session on-device data:** CodeMie authentication data and the current non-temporary panel message
  cache use Chrome session storage and are cleared when the browser closes. Temporary-chat messages are
  never written to that cache.
- **On the server:** conversations tied to an assistant, and other data sent to CodeMie, follow your
  CodeMie instance's retention policy. See
  [Data Processing and Storage Architecture](../../admin/security/data-processing-storage.md).

Removing the Extension deletes all local data. It does not delete conversations already synchronized to
your CodeMie instance — request deletion through your CodeMie administrator.

---

## 7. Your rights

Depending on your jurisdiction, including under the GDPR, you may have the right to access, correct,
delete, export, or restrict processing of your personal data, and to object to processing. Because most
server-side data is held by your CodeMie instance, exercise these rights through your organization's
CodeMie administrator, or by contacting us at
[AskCodeMie@epam.com](mailto:AskCodeMie@epam.com).

## 8. Children

The Extension is a workplace tool and is not directed at children under 16.

## 9. Changes to this policy

We will update this page and revise the date above when practices change. Material changes will be
communicated through the Extension or by your CodeMie administrator.

## 10. Contact

| Purpose                                     | Contact                                             |
| ------------------------------------------- | --------------------------------------------------- |
| Privacy questions and data subject requests | [AskCodeMie@epam.com](mailto:AskCodeMie@epam.com)   |
| General questions about CodeMie             | [AskCodeMie@epam.com](mailto:AskCodeMie@epam.com)   |
| Product demos and evaluations               | [CodeMieDemo@epam.com](mailto:CodeMieDemo@epam.com) |

If your organization runs its own CodeMie instance, contact your CodeMie administrator first — they
control the deployment that holds your data.

© 2026 EPAM Systems, Inc.
