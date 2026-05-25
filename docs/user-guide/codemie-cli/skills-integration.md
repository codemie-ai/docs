---
id: skills-integration
title: Access CodeMie Skills from CLI
sidebar_label: Skills
sidebar_position: 3
pagination_prev: user-guide/codemie-cli/assistants-integration
pagination_next: user-guide/codemie-cli/codemie-claude-skills
---

import EnterpriseFeature from '@site/src/components/EnterpriseFeature';

# Access CodeMie Skills from CLI

<EnterpriseFeature />

CodeMie CLI lets you install any CodeMie skill into Claude Code so you can invoke it directly
as a slash command from your coding session.

## Prerequisites

- CodeMie CLI installed and configured (`codemie setup` completed)

## Step 1: Register Skills

Run the setup wizard to select which skills you want to use:

```bash
codemie setup skills
```

### Read the Disclaimer

The wizard opens with an important notice:

![Disclaimer screen and scope selection showing Global and Local options](./images/skills-setup-disclaimer-scope.png)

:::warning
Skills are installed without tools or MCP servers. If your skill requires tools or MCP
servers, attach it to an assistant instead and use `codemie setup assistants`.
:::

If you need tools or MCP servers with your skill:

1. Go to your CodeMie platform and create an assistant
2. Attach your skill to that assistant
3. Run `codemie setup assistants` to install the assistant as a skill

Press **Enter** to continue or **Ctrl+C** to exit.

### Choose Scope

After the disclaimer, select where to save the skills configuration:

| Scope      | Saved to                             | Use when                                   |
| ---------- | ------------------------------------ | ------------------------------------------ |
| **Global** | `~/.codemie/codemie-cli.config.json` | Skills should be available in all projects |
| **Local**  | `./.codemie/codemie-cli.config.json` | Skills are specific to this repository     |

Local configuration overrides global for the current directory.

Use `↑`/`↓` to navigate, **Enter** to confirm.

### Select Skills

A selection screen lists all available skills across four tabs:

![Skills selection screen showing tabs, search bar, and paginated skill list](./images/skills-setup-selection.png)

- **Skills** — all skills available to you
- **Registered** — skills you have already set up
- **Project** — skills shared within your project
- **Marketplace** — skills available from the marketplace

Use `←`/`→` to switch between tabs, `↑`/`↓` to move through the list, **Space** to select or
deselect, and **Enter** to confirm.

After confirming, the CLI registers the selected skills and shows a summary:

```
✓ Registered 1 skill(s)

Skills saved to: global (~/.codemie/codemie-cli.config.json)
Skills are available in Claude Code as /skill-name commands.
```

## Step 2: Use Skills in Claude Code

Once registered, the skill appears in the **Registered** tab and is available as a slash command:

![Registered tab showing one installed skill](./images/skills-setup-registered.png)

Launch Claude Code as usual:

```bash
codemie-claude
```

Then invoke a skill by typing `/` followed by its name:

```
/prd-generator Transform my feature idea into a structured PRD
```

![Claude Code session showing a registered skill being invoked as a slash command](./images/skills-invocation.png)

:::tip
Not sure of the skill's name? Re-run `codemie setup skills` and check the **Registered** tab,
or type `/` in Claude Code to see all available slash commands.
:::

## Managing Registered Skills

Re-run `codemie setup skills` at any time to add or remove skills. To remove a skill, open
the wizard again and deselect it — this removes it from the list and cleans up its
configuration files.

:::note
Skills registered via `codemie setup skills` are always exposed as slash commands
(`/skill-name`). If you need a skill available as a subagent (`@name`), attach it to an
assistant and use [`codemie setup assistants`](./assistants-integration.md) instead.
:::
