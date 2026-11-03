---
id: project-budget-management
title: Project Budget Management
sidebar_label: Project Budget Management
sidebar_position: 5
pagination_prev: admin/configuration/codemie/platform-administration
pagination_next: null
---

import EnterpriseFeature from '@site/src/components/EnterpriseFeature';

# Project Budget Management

<EnterpriseFeature />

This page describes the platform configuration required to enable project budgets in CodeMie. For a guide on working with budgets from the UI, see [Budget Management](../../../user-guide/budget-management/index.md) and [Project Budgets](../../../user-guide/budget-management/project-budgets.md).

## Prerequisites

Before managing project budgets, ensure the following are configured:

- LiteLLM Proxy is deployed and connected to CodeMie.
- Budget enforcement is enabled. See [LiteLLM Budget Configuration](../../extensions/litellm-proxy/budget-configuration) for the required environment variables (`LLM_PROXY_BUDGET_CHECK_ENABLED`, `LLM_PROXY_BUDGET_RECONCILIATION_ENABLED`).

## Enabling Budget Management UI

In the `codemie-ui` Helm chart `values.yaml`, set:

```yaml
viteEnableBudgetManagement: true
```

`viteEnableBudgetManagement` enables budget columns and the budget management section on
project detail pages. Set it to `false` if your deployment does not use budget tracking.

## Background Jobs and Environment Variables

:::note Version availability
This section describes CodeMie **2.65.0** and later, where the spend ledger replaces the spend collector and the budget reset tracker. For earlier versions, see [Legacy Spend Collector (before 2.65.0)](#legacy-spend-collector-before-2650).
:::

Background jobs maintain budget and spend state. All jobs use PostgreSQL advisory locks so only one pod runs each job in a multi-replica deployment.

| Job                                           | Purpose                                                                                                                |
| --------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------- |
| **Spend uploader** (`litellm_spend_uploader`) | Copies LiteLLM spend logs into the `litellm_spend_logs` ledger, which serves all spend, budget, and limit figures      |
| **Daily reset reconciliation**                | Re-syncs budget reset state with LiteLLM once a day, shortly after midnight UTC                                        |
| **Startup reconciliation**                    | One-time on pod start: aligns DB state with LiteLLM (predefined budgets, user assignments, project budget assignments) |

### Environment variables

| Variable                                          | Default                | Description                                                                                                                                                                                                   |
| ------------------------------------------------- | ---------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `LITELLM_SPEND_UPLOADER_ENABLED`                  | `false`                | Enable the spend uploader background job                                                                                                                                                                      |
| `LITELLM_SPEND_UPLOADER_SCHEDULE`                 | `*/2 * * * *`          | Cron expression (UTC) for the spend uploader                                                                                                                                                                  |
| `LITELLM_SPEND_UPLOADER_LITELLM_DB_URL`           | `""`                   | Connection URL of the LiteLLM database, or use the `_HOST`, `_PORT`, `_NAME`, `_USER`, `_PASSWORD`, and `_SSLMODE` variants. See [API Configuration](./api-configuration.md#litellm-spend-ledger) for details |
| `SPEND_LEDGER_COVERAGE_FLOOR`                     | `2026-11-01T00:00:00Z` | Start of the period fully covered by the ledger. Set it after the first uploader load completes                                                                                                               |
| `LITELLM_BUDGET_RESET_RECONCILIATION_ENABLED`     | `false`                | Enable the daily reset reconciliation job                                                                                                                                                                     |
| `LLM_PROXY_BUDGET_RECONCILIATION_ENABLED`         | `false`                | Enable one-time startup reconciliation on pod start                                                                                                                                                           |
| `LLM_PROXY_BUDGET_RECONCILIATION_TIMEOUT_SECONDS` | `600`                  | Timeout in seconds for the startup reconciliation job                                                                                                                                                         |

In the `codemie-api` Helm chart, add to the `extraEnv` list:

```yaml
extraEnv:
  - name: LITELLM_SPEND_UPLOADER_ENABLED
    value: 'true'
  - name: LITELLM_SPEND_UPLOADER_LITELLM_DB_URL
    valueFrom:
      secretKeyRef:
        name: litellm-db-credentials
        key: url
  - name: LITELLM_BUDGET_RESET_RECONCILIATION_ENABLED
    value: 'true'
  - name: LLM_PROXY_BUDGET_RECONCILIATION_ENABLED
    value: 'true'
```

:::warning
Without `LITELLM_SPEND_UPLOADER_ENABLED=true` and a configured LiteLLM database connection, the ledger is not filled, so spend and budget consumption figures are missing or incomplete in the UI. The complete list of spend ledger parameters is in the [API Configuration Reference](./api-configuration.md#litellm-spend-ledger).
:::

## Budget Soft-Limit Notifications

When a budget's spending crosses its soft limit, the platform can send an email notification to a designated owner. Two independent flags control this behavior, making it possible to expose the configuration UI without enabling actual email dispatch.

### Configuration Flags

| Variable                                 | Default | Description                                                                                                                        |
| ---------------------------------------- | ------- | ---------------------------------------------------------------------------------------------------------------------------------- |
| `BUDGET_SOFT_LIMIT_NOTIFICATION_ENABLED` | `false` | Enables the soft-limit notification system and exposes the notification owner email and toggle fields in the UI                    |
| `BUDGET_SOFT_LIMIT_EMAIL_ENABLED`        | `false` | Enables actual email dispatch when the soft limit is reached. Has no effect if `BUDGET_SOFT_LIMIT_NOTIFICATION_ENABLED` is `false` |

**Deployment modes**:

- **UI-only mode** — `BUDGET_SOFT_LIMIT_NOTIFICATION_ENABLED=true`, `BUDGET_SOFT_LIMIT_EMAIL_ENABLED=false`: per-budget notification owner email and toggle fields are visible and editable in the UI, but no email is sent. Use this mode to prepare per-budget configuration before SMTP is ready.
- **Full email mode** — both flags set to `true`: an email is dispatched to the configured owner address the first time spending crosses the soft limit in a budget period.

:::warning
Setting `BUDGET_SOFT_LIMIT_EMAIL_ENABLED=true` while `BUDGET_SOFT_LIMIT_NOTIFICATION_ENABLED=false` has no effect — the dispatch is skipped and a warning is logged recommending that `BUDGET_SOFT_LIMIT_NOTIFICATION_ENABLED` be enabled.
:::

### SMTP Configuration

Full email mode requires SMTP to be configured on the API deployment:

| Variable              | Description                  |
| --------------------- | ---------------------------- |
| `EMAIL_SMTP_HOST`     | SMTP server hostname         |
| `EMAIL_SMTP_PORT`     | SMTP server port             |
| `EMAIL_SMTP_USERNAME` | SMTP authentication username |
| `EMAIL_SMTP_PASSWORD` | SMTP authentication password |
| `EMAIL_FROM_ADDRESS`  | Sender email address         |
| `EMAIL_FROM_NAME`     | Sender display name          |
| `EMAIL_USE_TLS`       | Set to `true` to enable TLS  |

In the `codemie-api` Helm chart, add to the `extraEnv` list:

```yaml
extraEnv:
  - name: BUDGET_SOFT_LIMIT_NOTIFICATION_ENABLED
    value: 'true'
  - name: BUDGET_SOFT_LIMIT_EMAIL_ENABLED
    value: 'true'
  - name: EMAIL_SMTP_HOST
    value: 'smtp.example.com'
  - name: EMAIL_SMTP_PORT
    value: '587'
  - name: EMAIL_SMTP_USERNAME
    value: 'notifications@example.com'
  - name: EMAIL_SMTP_PASSWORD
    valueFrom:
      secretKeyRef:
        name: smtp-credentials
        key: password
  - name: EMAIL_FROM_ADDRESS
    value: 'notifications@example.com'
  - name: EMAIL_FROM_NAME
    value: 'CodeMie Platform'
  - name: EMAIL_USE_TLS
    value: 'true'
```

### Notification Deduplication

A notification is sent once per budget period — triggered the first time spending crosses the soft limit. No further emails are dispatched until the budget period resets.

### Per-Budget Configuration

After the feature flags are enabled, each budget can be independently configured with a notification owner email and an opt-in toggle. This is done via the budget management UI or API. For the user-facing configuration steps, see [Soft-Limit Notifications](../../../user-guide/budget-management/index.md#soft-limit-notifications).

## Spend Tracking

CodeMie uses the LiteLLM spend logs as a **ledger** for project and member spend. The spend uploader job copies each request's cost and attribution from the LiteLLM database into the `litellm_spend_logs` table, and every spend, budget, and limit figure in the UI and analytics is calculated from that single table.

### How spend is calculated

A budget's consumed amount is the sum of ledger rows over the budget period, which ends at the budget's reset instant. Budget resets do not clear any stored counter: a new period simply covers a new range of rows, so the full history stays available for analytics.

Spend that cannot be answered completely is reported as **unavailable** or **partial** rather than as zero. This happens, for example, when the ledger is not yet activated (`SPEND_LEDGER_COVERAGE_FLOOR` is empty), when the ledger is marked not ready (`SPEND_LEDGER_READY=false`), or when a report reaches before the period covered by the ledger and legacy fallback is disabled (`SPEND_LEDGER_LEGACY_BELOW_FLOOR=false`).

### Activating the ledger

1. Enable the spend uploader and configure the LiteLLM database connection (see [Environment variables](#environment-variables)).
2. Wait for the first run to finish loading the historical spend logs.
3. Set `SPEND_LEDGER_COVERAGE_FLOOR` to the timestamp of the earliest request contained in the completed load and restart the API pods.

Periods before this timestamp are served from the legacy Elasticsearch metrics unless `SPEND_LEDGER_LEGACY_BELOW_FLOOR` is `false`.

:::warning
If LiteLLM spend log retention deletes rows at or after `SPEND_LEDGER_COVERAGE_FLOOR`, or per-request spend logging in LiteLLM is stopped, set `SPEND_LEDGER_READY=false` so figures are reported as unavailable instead of understated.
:::

### Per-project member tracking

Member-level spend attribution is controlled by the `project_member_budget_tracking_enabled` feature flag, which can be toggled per project.

| Flag state        | Enforcement mode                      | Behavior                                                                     |
| ----------------- | ------------------------------------- | ---------------------------------------------------------------------------- |
| Enabled (default) | `PROJECT_BUDGET_WITH_MEMBER_TRACKING` | Project cap + per-member allocation both enforced                            |
| Disabled          | `PROJECT_BUDGET_PROJECT_ONLY`         | Only the project-level cap is enforced; individual member limits are ignored |

When the flag is disabled, all members share the project budget without individual caps.

:::note Spend data latency
Spend data updates on the spend uploader schedule (every 2 minutes by default). Spend appears in the UI after the uploader copies the request from LiteLLM, which is typically a few minutes after the request completes.
:::

## Legacy Spend Collector (before 2.65.0)

:::warning
This section applies only to CodeMie versions **before 2.65.0**. In 2.65.0 the spend collector, the budget reset tracker, and the `project_spend_tracking` table are replaced by the spend ledger described above, and their environment variables are no longer read.
:::

Two background jobs maintain budget state. All jobs use PostgreSQL advisory locks so only one pod runs each job in a multi-replica deployment.

| Job                                                       | Purpose                                                                                                                |
| --------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------- |
| **Spend collector** (`litellm_spend_collector`)           | Polls LiteLLM for spend data and writes deltas to `project_spend_tracking`                                             |
| **Budget reset tracker** (`litellm_budget_reset_tracker`) | Detects budget period rollovers and adjusts spend records accordingly                                                  |
| **Startup reconciliation**                                | One-time on pod start: aligns DB state with LiteLLM (predefined budgets, user assignments, project budget assignments) |

### Legacy environment variables

| Variable                                          | Default        | Description                                                                                                                                             |
| ------------------------------------------------- | -------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `LITELLM_SPEND_COLLECTOR_ENABLED`                 | `false`        | Enable the spend collector background job                                                                                                               |
| `LITELLM_SPEND_COLLECTOR_SCHEDULE`                | `0 1 * * *`    | Cron expression (UTC) for the spend collector. See [API Configuration](./api-configuration.md#legacy-spend-collector-settings-before-2650) for details. |
| `LITELLM_BUDGET_RESET_TRACKER_ENABLED`            | `false`        | Enable the budget reset tracker background job                                                                                                          |
| `LITELLM_BUDGET_RESET_TRACKER_SCHEDULE`           | `*/10 * * * *` | Cron expression (UTC) for the reset tracker                                                                                                             |
| `LLM_PROXY_BUDGET_RECONCILIATION_ENABLED`         | `false`        | Enable one-time startup reconciliation on pod start                                                                                                     |
| `LLM_PROXY_BUDGET_RECONCILIATION_TIMEOUT_SECONDS` | `600`          | Timeout in seconds for the startup reconciliation job                                                                                                   |

In the `codemie-api` Helm chart, add to the `extraEnv` list:

```yaml
extraEnv:
  - name: LITELLM_SPEND_COLLECTOR_ENABLED
    value: 'true'
  - name: LITELLM_SPEND_COLLECTOR_SCHEDULE
    value: '0 1 * * *'
  - name: LITELLM_BUDGET_RESET_TRACKER_ENABLED
    value: 'true'
  - name: LITELLM_BUDGET_RESET_TRACKER_SCHEDULE
    value: '0 0 * * *'
  - name: LLM_PROXY_BUDGET_RECONCILIATION_ENABLED
    value: 'true'
```

:::warning
Without `LITELLM_SPEND_COLLECTOR_ENABLED=true`, spend data will not be collected and budget consumption will not be visible in the UI.
:::

### Legacy spend tracking

CodeMie tracks project and member spend through a background polling job that reads usage data from LiteLLM and records it in the `project_spend_tracking` table.

#### Legacy spend calculation

On each collection run:

1. The job fetches `current_period_spend` from LiteLLM for each tracked entity (project virtual key, per-member customer record).
2. It calculates the **delta** — the difference from the previous snapshot.
3. The **daily** value equals the delta for that run.
4. The **cumulative** value accumulates across all runs and periods.

If no previous snapshot exists (first run), the current spend value is used directly as both daily and cumulative.

#### Legacy budget reset detection

LiteLLM resets a budget's spend counter when its reset period elapses. CodeMie detects this by comparing the budget's last reset timestamp against the previous snapshot date. When a reset is detected:

- The daily value reflects the new-period spend only.
- The cumulative value continues to grow — it is not cleared on reset, preserving the full historical record.

:::note Spend data latency
In these versions spend data updates on the collect schedule (nightly by default), so there is typically up to a one-day lag between request completion and spend appearing in the UI.
:::

## See Also

- [Budget Management](../../../user-guide/budget-management/index.md) — user guide for working with budgets in the UI
- [Project Budgets](../../../user-guide/budget-management/project-budgets.md) — creating budgets, tracking spend, and member allocations
- [Chargeback and Cost Centers](../../../user-guide/budget-management/chargeback-cost-centers.md) — internal billing and cost center rollup
- [LiteLLM Budget Configuration](../../extensions/litellm-proxy/budget-configuration) — predefined global budgets and enforcement flags
- [API Configuration Reference](../api-configuration) — full environment variable reference
- [Platform Administration](../platform-administration) — creating and managing projects
- [ServiceNow Budget Integration](./servicenow-budget-integration.md) — requesting, adjusting, and cancelling project budgets from ServiceNow
