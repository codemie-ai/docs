---
id: add-xwiki-data-source
title: Add and Index xWiki Data Source
sidebar_label: Add and Index xWiki Data Source
pagination_prev: user-guide/data-source/datasources-types/add-azure-devops-work-items-data-source
pagination_next: user-guide/data-source/datasources-types/add-provider-datasource
---

# Add and Index xWiki Data Source

Connect and index xWiki space pages as a data source.

An xWiki data source lets assistants search and retrieve content from a self-hosted xWiki instance. The configured space and all of its descendant spaces are indexed, so an assistant with this data source can answer questions from that wiki's content. This guide walks through the process of adding and indexing an xWiki data source.

## Prerequisites

:::note Required Integration
This data source requires at least one xWiki integration added to AI/Run CodeMie. The integration stores the instance URL and HTTP Basic credentials. For more details, refer to the [Integrations Overview](../../tools_integrations/integrations/index.md) guidelines.
:::

Before adding an xWiki data source, ensure the following:

- Access to a running xWiki instance and its base URL
- A user account on that instance with read access to the target space
- An xWiki integration created in CodeMie with the instance URL and credentials

## Adding an xWiki Data Source

### Step-by-Step Process

#### 1. Preparation

Before adding a new data source, create an xWiki integration on the **Integrations** tab.

The integration must include the instance base URL and HTTP Basic credentials (username and token or password). Refer to the [Integrations Overview](../../tools_integrations/integrations/index.md) guidelines for detailed setup instructions.

:::warning Authentication Requirements
HTTP Basic authentication is used — a **username is always required** alongside the token or password. Bearer-token authentication is intentionally not supported: it requires an additional server-side xWiki plugin that is not available by default. A token provided without a username will fail.
:::

#### 2. Navigate to Data Sources

Navigate to the **Data Sources** section in AI/Run CodeMie.

#### 3. Create New Data Source

Click the **+ Create Datasource** button.

#### 4. Configure the Data Source

Fill in the required fields:

- **Select Project**: Choose the CodeMie project to associate with this data source.
- **Name**: A short alias for quick identification in the data source list.
- **Description**: Optional description of what this data source contains.
- **Choose Datasource Type**: Select **xWiki**.

Configure the xWiki-specific fields:

| Field                         | Required | Description                                                                                                                    |
| ----------------------------- | -------- | ------------------------------------------------------------------------------------------------------------------------------ |
| **Space**                     | Required | The space key to index (e.g., `KB`). The selected space and all of its descendant spaces are included.                         |
| **Wiki**                      | Optional | The wiki identifier. Defaults to `xwiki` when left empty — most single-wiki installations do not need to change this value.    |
| **Integration for xWiki**     | Required | Select the xWiki integration holding the instance URL and credentials. A new integration can be created inline from this form. |
| **Model used for embeddings** | Required | Embedding model for indexing the content.                                                                                      |

:::info Instance URL Format
The base URL in the integration must include the path prefix the instance actually uses. If the xWiki instance is deployed under `/xwiki` (the default), the URL should be `https://wiki.example.com/xwiki` — not `https://wiki.example.com`. A 404 error when connecting usually means the prefix is missing or incorrect.
:::

:::tip HTTPS Recommended
HTTPS is strongly recommended. HTTP Basic credentials travel in cleartext over a plain `http://` connection. Most self-hosted xWiki deployments are on an internal network, but HTTPS eliminates the risk of credential exposure during transmission.
:::

#### 5. Configure Reindex Schedule (Optional)

In the **Reindex Type** section, configure automatic reindexing:

- **No schedule (manual only)** — Default, requires manual reindexing
- **Every hour** — For wikis with frequent updates
- **Daily at midnight** — For wikis with regular daily changes
- **Weekly on Sunday at midnight** — For less active wikis
- **Monthly on the 1st at midnight** — For archived wikis
- **Custom cron expression** — Enter a custom schedule (e.g., `0 */4 * * *` for every 4 hours)

#### 6. Create Data Source

Click the **+ Create** button. Indexing begins automatically.

## What Gets Indexed

### Page Content

The full content of each wiki page in the configured space and all descendant spaces is indexed. Each indexed document carries the page title, a direct link to the page, and the space and wiki identifiers, so assistants can cite the source when answering questions. Page names with spaces and non-ASCII characters are handled correctly.

:::warning Page Limit
A single index run processes up to **5,000 pages**. If a space exceeds this limit, the run is truncated and the excess pages stay unindexed — subsequent runs walk the space from the start and truncate at the same point, so the remaining pages are never picked up automatically. To index content beyond the limit, add a separate data source targeting a descendant space that contains the pages of interest.
:::

### Indexing Failures and Skipped Pages

The indexing run distinguishes between two outcomes for individual pages:

- **Failures** — a page raises an error during loading. Each failure consumes the failure budget. The run is aborted immediately if every page walked so far has failed, and is otherwise marked as failed when failures exceed the greater of **5 pages or 10 % of the pages in the space**.
- **Skipped pages** — a page loads successfully but has no indexable content (empty body). Skipped pages do not count against the failure budget and do not affect run status.

## Using the xWiki Data Source in Assistants

After creating and indexing the data source, connect it to an assistant to enable wiki search.

1. Navigate to the **Assistants** section.
2. Click **+ Create Assistant** or edit an existing one.
3. In the **Data Source Context** section, select the xWiki data source.
4. Save the assistant configuration.

The assistant can now answer questions using indexed wiki content, with source citations linking back to the original xWiki page.
