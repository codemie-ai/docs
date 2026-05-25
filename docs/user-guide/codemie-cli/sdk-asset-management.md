---
id: sdk-cli-reference
title: SDK CLI Reference
sidebar_label: SDK CLI Reference
sidebar_position: 5
pagination_prev: user-guide/codemie-cli/codemie-claude-skills
pagination_next: null
---

# SDK CLI Reference

Reference for `codemie sdk` commands. These commands are invoked automatically by the
[`codemie-sdk` skill](./codemie-claude-skills.md) when you describe what you need in Claude
Code, or you can run them directly in the terminal.

## Common Flags

| Flag                | Description                                 |
| ------------------- | ------------------------------------------- |
| `--json`            | Output as JSON instead of a formatted table |
| `--data '<json>'`   | Pass creation/update payload inline         |
| `--json <file>`     | Pass creation/update payload from a file    |
| `--search <text>`   | Filter results by name                      |
| `--projects <name>` | Filter results by project                   |
| `--page <n>`        | Page number (0-indexed)                     |
| `--per-page <n>`    | Results per page                            |

:::tip
All asset IDs are UUIDs, e.g. `bc1a4b75-955c-48a5-b26d-bf702c1fee5d`. After creating an
asset, use `list --search` to find its ID.
:::

:::warning
**Update replaces arrays and objects in full.** If you update a field like `context` or
`toolkits`, the value you provide replaces the entire field — it is not merged. To add
items without losing existing ones, fetch the current state first (`get <id> --json`),
merge locally, then send the full updated value.
:::

## Assistants

```bash
codemie sdk assistants list [--scope visible_to_user|marketplace] [--search <text>] [--projects <name>] [--page <n>] [--per-page <n>] [--json]
codemie sdk assistants get <id> [--json]
codemie sdk assistants get-tools [--json]
codemie sdk assistants create --data '<json>' | --json <file>
codemie sdk assistants update <id> --data '<json>' | --json <file>
codemie sdk assistants delete <id>
```

**Required fields on create:** `name`, `project`, `system_prompt`

**Create example:**

```bash
codemie sdk assistants create --data '{
  "name": "Code Reviewer",
  "project": "Engineering",
  "system_prompt": "You are a senior engineer performing code reviews. Focus on correctness, security, and performance.",
  "llm_model_type": "claude-3-5-sonnet",
  "shared_with_project": true
}'
```

**List scopes:**

| Scope                       | Returns                       |
| --------------------------- | ----------------------------- |
| `visible_to_user` (default) | Assistants accessible to you  |
| `marketplace`               | Publicly published assistants |

:::tip
Use `get-tools` to see all available tools and toolkit IDs that can be attached to an
assistant.
:::

### Assistant Categories

Assistant categories are labels for organizing assistants in the marketplace. Creating and
managing them requires admin access.

```bash
codemie sdk assistant-categories list [--paginated] [--page <n>] [--per-page <n>] [--json]
codemie sdk assistant-categories get <id> [--json]
codemie sdk assistant-categories create --data '<json>' | --json <file>
codemie sdk assistant-categories update <id> --data '<json>' | --json <file>
codemie sdk assistant-categories delete <id>
```

**Required fields on create:** `name` (1–255 chars)

**Create example:**

```bash
codemie sdk assistant-categories create --data '{"name":"DevOps","description":"Assistants for CI/CD, deployment, and infrastructure tasks"}'
```

**Assign categories to an assistant:**

```bash
# Get category IDs
codemie sdk assistant-categories list --json | jq -r '.[] | "\(.id) \(.name)"'

# Set categories on an assistant
codemie sdk assistants update <assistant-id> --data '{"categories":["<category-id>"]}'
```

## Workflows

```bash
codemie sdk workflows list [--search <text>] [--projects <name>] [--page <n>] [--per-page <n>] [--json]
codemie sdk workflows get <id> [--json]
codemie sdk workflows create --data '<json>' --config '<yaml>' | --config path/to/config.yaml
codemie sdk workflows update <id> --data '<json>' [--config '<yaml>' | --config path/to/config.yaml]
codemie sdk workflows delete <id>
```

**Required fields on create:** `name`, `project_name`, `mode` (`"Sequential"`), `shared`
(boolean), plus `--config` with a YAML graph definition.

**Create example:**

```bash
codemie sdk workflows create \
  --data '{"name":"review-pipeline","project_name":"Engineering","mode":"Sequential","shared":true}' \
  --config path/to/workflow.yaml
```

## Datasources

Datasources have a **type subcommand** for create and update. The name must match
`^[a-zA-Z0-9][\w-]*$` — no spaces, use hyphens (e.g. `my-wiki`, not `My Wiki`).

```bash
codemie sdk datasources list [--search <text>] [--projects <name>] [--status <status>] [--datasource-types <types>] [--sort-key date|update_date] [--sort-order asc|desc] [--page <n>] [--per-page <n>] [--json]
codemie sdk datasources get <id> [--json]
codemie sdk datasources create <type> --data '<json>' | --json <file>
codemie sdk datasources update <type> <id> --data '<json>' | --json <file>
codemie sdk datasources delete <id>
```

**Supported types:** `confluence`, `jira`, `file`, `code`, `google`, `azure-devops-wiki`,
`azure-devops-work-item`, `xray`, `sharepoint`, `provider`

**Status filter values:** `completed`, `failed`, `fetching`, `in_progress`

**Base fields (required for all types):** `name`, `project_name`

**Type examples:**

```bash
# Confluence — requires a Confluence integration in the project
codemie sdk datasources create confluence --data '{
  "name": "company-wiki",
  "project_name": "Engineering",
  "cql": "space=ENG AND type=page",
  "shared_with_project": true
}'

# Jira — requires a Jira integration in the project
codemie sdk datasources create jira --data '{
  "name": "open-tickets",
  "project_name": "Support",
  "jql": "project=SUP AND status != Done",
  "shared_with_project": true
}'

# Code repository
codemie sdk datasources create code --data '{
  "name": "backend-api",
  "project_name": "Engineering",
  "link": "https://github.com/org/repo",
  "branch": "main",
  "index_type": "code"
}'

# Local files (max 10 files per call)
codemie sdk datasources create file \
  --file ./doc1.pdf --file ./doc2.docx \
  --data '{"name":"team-docs","project_name":"Engineering"}'

# SharePoint — requires a SharePoint integration in the project
codemie sdk datasources create sharepoint --data '{
  "name": "sharepoint-docs",
  "project_name": "Engineering",
  "site_url": "https://company.sharepoint.com/sites/team",
  "include_pages": true,
  "include_documents": true,
  "shared_with_project": true
}'
```

**Update reindex flags** (add to any update payload):

| Flag                  | Description                                        |
| --------------------- | -------------------------------------------------- |
| `skip_reindex`        | Update metadata only — does not trigger reindexing |
| `incremental_reindex` | Only fetch content changed since last run          |
| `full_reindex`        | Discard existing index and re-fetch everything     |
| `resume_indexing`     | Resume a previously interrupted indexing job       |

```bash
# Rename without reindexing
codemie sdk datasources update confluence <id> --data '{
  "name": "new-name",
  "project_name": "Engineering",
  "cql": "space=ENG",
  "skip_reindex": true
}'
```

## Integrations

Integrations store credentials for external services (Jira, Confluence, Git, Azure DevOps,
SharePoint, etc.) used by datasources and assistants.

```bash
codemie sdk integrations list [--setting-type user|project] [--search <text>] [--projects <name>] [--page <n>] [--per-page <n>] [--json]
codemie sdk integrations get <id> [--setting-type user|project] [--json]
codemie sdk integrations get-by-alias <alias> [--setting-type user|project] [--json]
codemie sdk integrations create --data '<json>' | --json <file>
codemie sdk integrations update <id> --data '<json>' | --json <file>
codemie sdk integrations delete <id> [--setting-type user|project]
```

**Required fields on create:** `credential_type`, `project_name`, `credential_values`
(array of `{"key":"...","value":"..."}` pairs — **must include an `alias` key**).

**Setting types:**

| Type             | Scope                                        |
| ---------------- | -------------------------------------------- |
| `user` (default) | Personal — visible only to you               |
| `project`        | Team-shared — visible to all project members |

**Supported `credential_type` values:** `Jira`, `Confluence`, `Git`, `Kubernetes`, `AWS`,
`GCP`, `Azure`, `Keycloak`, `Elastic`, `OpenAPI`, `Plugin`, `FileSystem`, `Scheduler`,
`Webhook`, `Email`, `AzureDevOps`, `Sonar`, `SQL`, `Telegram`, `ZephyrScale`,
`ZephyrSquad`, `ServiceNow`, `DIAL`, `A2A`, `MCP`, `LiteLLM`, `ReportPortal`, `Xray`,
`SharePoint`

**Create example (Jira):**

```bash
codemie sdk integrations create --data '{
  "credential_type": "Jira",
  "project_name": "Engineering",
  "alias": "jira-main",
  "setting_type": "project",
  "credential_values": [
    {"key": "url", "value": "https://company.atlassian.net"},
    {"key": "token", "value": "your-api-token"},
    {"key": "username", "value": "bot@company.com"},
    {"key": "alias", "value": "jira-main"}
  ]
}'
```

:::warning
`credential_values` must always include `{"key": "alias", "value": "<alias>"}`. Omitting
it will cause an API error.

Sensitive credential values are masked as `**********` in all output.
:::

## Skills

```bash
codemie sdk skills list [--scope marketplace|project|project_with_marketplace] [--page <n>] [--per-page <n>] [--json]
codemie sdk skills get <id> [--json]
codemie sdk skills create --data '<json>' | --json <file>
codemie sdk skills update <id> --data '<json>' | --json <file>
codemie sdk skills delete <id>
codemie sdk skills import <file.md> --project <name> [--visibility private|project|public]
codemie sdk skills export <id>
codemie sdk skills attach <assistant-id> <skill-id>
codemie sdk skills detach <assistant-id> <skill-id>
codemie sdk skills list-assistant-skills <assistant-id> [--json]
codemie sdk skills bulk-attach <skill-id> --assistant-ids <id1>,<id2>,...
codemie sdk skills get-assistants <skill-id> [--json]
codemie sdk skills publish <id> [--categories <cat1>,<cat2>]
codemie sdk skills unpublish <id>
codemie sdk skills list-categories [--json]
```

**Required fields on create:** `name` (kebab-case, 3–64 chars), `description`
(10–1000 chars), `content` (markdown, min 100 chars), `project`

**Visibility values:** `private` (default), `project`, `public`

**Create example:**

```bash
codemie sdk skills create --data '{
  "name": "sql-helper",
  "description": "Helps write and optimize SQL queries for common database tasks.",
  "content": "# SQL Helper\n\nYou are an expert in writing SQL queries...",
  "project": "Engineering",
  "visibility": "project"
}'
```

**Import / Export:**

```bash
# Import from a markdown file with YAML front matter
codemie sdk skills import ./my-skill.md --project Engineering --visibility project

# Export a skill to markdown
codemie sdk skills export <id> > my-skill.md
```

The import file must have YAML front matter with `name` and `description`:

```markdown
---
name: my-skill
description: What this skill does
---

# Instructions
...
```

**Publish to marketplace:**

```bash
# Publish with categories (use list-categories to get valid values)
codemie sdk skills list-categories --json
codemie sdk skills publish <id> --categories development,testing
codemie sdk skills unpublish <id>
```

## LLM Models

List available language and embedding models. Use the `base_name` field when setting
`llm_model_type` on an assistant or `embeddings_model`/`summarization_model` on a
datasource.

```bash
codemie sdk llm list [--json]               # Language models
codemie sdk llm list --embeddings [--json]  # Embedding models
```

## Users

Retrieve your profile and account data, including your user ID, admin status, and the
projects you have access to.

```bash
codemie sdk users me [--json]    # Your profile: user_id, email, is_admin, applications
codemie sdk users data [--json]  # Extended user data
```
