---
id: codemie-claude-skills
title: Claude Code Skills for CodeMie
sidebar_label: Claude Code Skills
sidebar_position: 4
pagination_prev: user-guide/codemie-cli/skills-integration
pagination_next: user-guide/codemie-cli/sdk-cli-reference
---

import EnterpriseFeature from '@site/src/components/EnterpriseFeature';

# Claude Code Skills for CodeMie

<EnterpriseFeature />

When you launch Claude Code with `codemie-claude`, six pre-built skills are available
automatically — no additional setup required. Each skill activates when you describe what
you need in natural language.

| Skill                                         | What it does                                                                     |
| --------------------------------------------- | -------------------------------------------------------------------------------- |
| [`codemie-sdk`](#codemie-sdk)                 | Manage platform assets: assistants, workflows, datasources, integrations, skills |
| [`codemie-analytics`](#codemie-analytics)     | Usage data, spending reports, and AI adoption leaderboards                       |
| [`codemie-html-report`](#codemie-html-report) | Generate HTML reports and dashboards in the CodeMie UI style                     |
| [`claude-setup-audit`](#claude-setup-audit)   | Audit and grade your Claude Code configuration                                   |
| [`report-issue`](#report-issue)               | File bug reports and feature requests to GitHub                                  |
| [`msgraph`](#msgraph)                         | Access Microsoft 365 — email, calendar, Teams, SharePoint, OneDrive              |

## Prerequisites

- CodeMie CLI installed and configured (`codemie setup` completed)

## codemie-sdk

Manages all CodeMie platform assets via the `codemie sdk` CLI.

**Supported assets:** assistants, workflows, datasources, integrations, skills, users,
assistant categories, LLM models

```
Create an assistant called "Code Reviewer" in Engineering
List my datasources in the Support project
Add a Confluence datasource for space=ENG
Delete workflow <id>
Update the sql-helper skill description
List all project integrations
```

For the full list of available commands and fields, see the
[SDK CLI Reference](./sdk-asset-management.md).

## codemie-analytics

Retrieves platform usage data and generates self-contained HTML reports saved to `reports/`
in your working directory.

### Leaderboard and AI Champions

Ranks users through a scoring framework with six dimensions: platform usage, asset creation,
workflow usage, workflow authoring, CLI and agentic engineering, and knowledge sharing. Tiers:
pioneer, expert, advanced, practitioner, newcomer.

```
Show me the AI adoption leaderboard for Q1 2026
Who are the top 10 performers this month?
Give me the full champion profile for alice@company.com
What's the tier distribution across the organization?
```

### CLI Insights

Analyzes how teams use Claude Code — session depth, tool usage, model preferences, top
repositories, and user classification by behavior type.

```
Show CLI insights for the last 30 days
Who are the top CLI users by cost?
Give me a detailed CLI profile for John_Doe
What are the usage patterns by hour and weekday?
```

### Spending and Budget

Monitors platform costs and budget utilization at the user, project, and organization level.

```
How much has Engineering spent this month?
Show me per-user spending for the last 30 days
Are any users close to their budget limits?
What's my current spend and remaining budget?
```

### General Usage Analytics

Platform activity summaries: conversations, assistant usage, workflow executions, tool usage,
model breakdown, and engagement patterns.

```
Give me a platform usage summary for last week
Which LLM models are used most?
Show workflow execution analytics
```

### HTML Reports

```
Build a leaderboard dashboard for Q1 2026
Generate a spending report for the last 30 days and save it
Create an HTML report showing CLI adoption trends
```

Reports are saved to `reports/<descriptive-name>.html` in your current working directory.

## codemie-html-report

Generates standalone HTML pages, reports, and dashboards that match the CodeMie UI design
system — dark-first theme, Inter font, semantic color tokens, Chart.js visualizations.

Use this skill any time you need an HTML artifact that looks like a native CodeMie screen:
analytics dashboards, status pages, data visualizations, or mockups.

```
Create an HTML dashboard for this JSON data
Build a status page for our deployment pipeline
Generate a dark-themed analytics report
Make this look like a CodeMie UI page
```

The `codemie-analytics` skill delegates to `codemie-html-report` automatically when
generating leaderboard and spending dashboards.

## claude-setup-audit

Performs a comprehensive quality assessment of your Claude Code configuration and produces
a graded health report (A–F per component) with prioritized recommendations.

**What it evaluates:**

| Component  | What's checked                                   |
| ---------- | ------------------------------------------------ |
| Skills     | Trigger clarity, tool scope, instruction quality |
| Agents     | Specialization, tool access, handoff patterns    |
| CLAUDE.md  | Coverage, actionability, rule quality            |
| Commands   | Naming, scope, usefulness                        |
| Hooks      | Safety, correctness, side effects                |
| MCP config | Server definitions, tool availability            |

```
Audit my Claude setup
Check my Claude configuration
Review my .claude folder
How good is my Claude setup?
Validate my hooks
```

## report-issue

Files structured bug reports and feature requests to the
[codemie-ai/codemie-code](https://github.com/codemie-ai/codemie-code) GitHub repository.
Automatically collects diagnostic context (OS, Node.js version, CLI version, installed
agents, active profile, recent debug logs) and shows you a preview before submitting.

```
Report a bug in CodeMie
Something is broken in codemie-claude
Submit a feature request
File a GitHub issue for CodeMie
```

## msgraph

Accesses Microsoft 365 services on your behalf via the Microsoft Graph API. Uses a local
Node.js CLI that handles authentication and token caching — no Python or extra packages
required.

**Supported services:** Outlook, Teams, SharePoint, OneDrive, OneNote, contacts, org chart

```
Show my unread emails
What meetings do I have today?
Find the latest message from Alice in Teams
List files in my OneDrive
Show my direct reports
Get the SharePoint pages from the Engineering site
```
