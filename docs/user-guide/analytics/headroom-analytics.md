---
id: headroom-analytics
title: Context Compression (Headroom) Analytics
sidebar_label: Headroom Analytics
sidebar_position: 3
description: Understand how many tokens Headroom context compression saved, over time and by strategy
pagination_prev: user-guide/analytics/analytics-overview
pagination_next: null
---

# Context Compression (Headroom) Analytics

Headroom Analytics shows how many tokens context compression saved and which compression
strategies contributed most. It appears in the [Analytics Dashboard](./index.md) when the
`features:headroom` customer feature is enabled for the instance. The figures are based on
recorded compression events, so they do not represent all LLM usage.

Data is recorded once for each completed chat turn or workflow execution, and only when
compression saved tokens. Requests that were not compressed do not appear in these figures.

## Viewing Headroom Analytics

Open **Analytics** from the left navigation, switch to the **Insights** tab, and find the
**Context Compression** section. The dashboard's time, user, and project filters narrow the
data. The section includes:

- **Headroom Summary** — **Original Tokens**, **Compacted Tokens**, **Tokens Saved**,
  **Saved Share (%)**, **Compacted Requests**, and **Unique Sessions**. One session can contain
  multiple compacted requests.
- **Savings Over Time** — a stacked bar chart of compacted and saved tokens in 3-hour buckets.
  The full height of a bar is the original token count.
- **Savings by Strategy** — a table with the columns **Strategy**, **Requests**,
  **Original Tokens**, **Compacted Tokens**, **Tokens Saved**, and **Saved Share (%)**. Rows are
  sorted by tokens saved, highest first.

**Saved Share (%)** is the tokens saved divided by the original tokens, expressed as a
percentage. In the **Savings by Strategy** table it is calculated for each row separately and is
intentionally not totalled across rows.

The **Strategy** column contains `lossless`, `balanced`, `aggressive`, or `mixed`. The `mixed`
row groups events that combine several strategies, for example a workflow whose nodes use
different strategies.

:::note About token counts
Saved tokens are counted by CodeMie on the messages that are actually sent to the model, so the
figures reflect the compression that was applied and not the compressor's own estimate.
:::

Headroom Analytics requires the `features:headroom` customer feature. For setup, see
[Headroom Context Compression](../../admin/configuration/codemie/headroom-context-compression.md).
