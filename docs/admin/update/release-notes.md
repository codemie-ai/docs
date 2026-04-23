---
id: release-notes
title: Release Notes
sidebar_label: Release Notes
sidebar_position: 1
pagination_prev: admin/update/update-overview
pagination_next: null
---

# Release Notes

This page provides information about updated third-party components and configuration changes available in new CodeMie releases.

---

<details>
<summary><strong>CodeMie 2.24.0</strong></summary>

**Release Date:** April 23, 2026 · [GitHub Tag ↗](https://github.com/codemie-ai/codemie/releases/tag/2.24.0)

<h3>Third-Party Component Updates</h3>

No third-party component updates in this release.

<h3>Configuration Changes</h3>

#### **[BREAKING]** Fluent Bit: Remove `span_id` and `trace_id` from Metrics Logs

:::danger Breaking Change
Without this configuration update, **no metrics will be written** to the `codemie_metrics_logs` Elasticsearch index. Apply this change before or during the upgrade to CodeMie 2.24.0.
:::

A new `[FILTER]` block must be added to `fluent-bit/values.yaml` to strip `span_id` and `trace_id` fields from CodeMie metrics logs before they are forwarded to Elasticsearch.

**Why:** Starting with CodeMie 2.24.0, the backend includes `span_id` and `trace_id` fields in its log output. These fields are not accepted by the `codemie_metrics_logs` Elasticsearch index, causing all metrics ingestion to fail.

**Required change in `fluent-bit/values.yaml`:**

```ini
[FILTER]
    Name         record_modifier
    Match        kube.codemie-metrics.*
    Remove_key   span_id
    Remove_key   trace_id
```

This filter is included in the updated `codemie-helm-charts`. No manual action is required if you are upgrading using the provided Helm charts.

</details>

<details>
<summary><strong>CodeMie 2.23.0</strong></summary>

**Release Date:** April 15, 2026 · [GitHub Tag ↗](https://github.com/codemie-ai/codemie/releases/tag/2.23.0)

<h3>Third-Party Component Updates</h3>

No third-party component updates in this release.

<h3>Configuration Changes</h3>

#### Budget Enforcement Environment Variables

Three new environment variables have been introduced to control LLM budget enforcement. All default to `false` (disabled):

| Variable                            | Default | Description                                                                      |
| ----------------------------------- | ------- | -------------------------------------------------------------------------------- |
| `LLM_PROXY_BUDGET_CHECK_ENABLED`    | `false` | Enables budget limit checking for LLM proxy requests                             |
| `LLM_PROXY_BUDGET_SYNC_ENABLED`     | `false` | Syncs predefined budgets from `budgets-config.yaml` into the database on startup |
| `LLM_PROXY_BUDGET_BACKFILL_ENABLED` | `false` | Backfills user budget assignments from LiteLLM on startup for existing users     |

See [Budget Configuration](../configuration/extensions/litellm-proxy/budget-configuration) and [API Configuration](../configuration/codemie/api-configuration) for details.

#### Deprecated Budget Environment Variables

The following environment variables are deprecated and will be removed in a future release. Replace them with the corresponding `budgets-config.yaml` fields:

| Deprecated Variable                  | Type   | Default     | Replacement in `budgets-config.yaml` |
| ------------------------------------ | ------ | ----------- | ------------------------------------ |
| `DEFAULT_SOFT_BUDGET_LIMIT`          | float  | `200`       | `soft_budget`                        |
| `DEFAULT_HARD_BUDGET_LIMIT`          | float  | `500`       | `max_budget`                         |
| `DEFAULT_BUDGET_DURATION`            | string | `"30d"`     | `budget_duration`                    |
| `DEFAULT_BUDGET_ID`                  | string | `"default"` | `budget_id`                          |
| `LITELLM_PREMIUM_MODELS_BUDGET_NAME` | string | `""`        | `premium_models` category entry      |
| `LITELLM_CLI_BUDGET_NAME`            | string | `""`        | `cli` category entry                 |

See [Budget Configuration](../configuration/extensions/litellm-proxy/budget-configuration) for migration details.

<h3>Hotfixes</h3>

- **2.23.1** · [GitHub Tag ↗](https://github.com/codemie-ai/codemie/releases/tag/2.23.1) – April 15, 2026
- **2.23.2** · [GitHub Tag ↗](https://github.com/codemie-ai/codemie/releases/tag/2.23.2) – April 16, 2026
- **2.23.3** · [GitHub Tag ↗](https://github.com/codemie-ai/codemie/releases/tag/2.23.3) – April 21, 2026
- **2.23.4** · [GitHub Tag ↗](https://github.com/codemie-ai/codemie/releases/tag/2.23.4) – April 20, 2026

</details>

<details>
<summary><strong>CodeMie 2.22.0</strong></summary>

**Release Date:** April 9, 2026 · [GitHub Tag ↗](https://github.com/codemie-ai/codemie/releases/tag/2.22.0)

<h3>Third-Party Component Updates</h3>

No third-party component updates in this release.

<h3>Configuration Changes</h3>

No breaking configuration changes were introduced in this release.

<h3>Hotfixes</h3>

- **2.22.1** · [GitHub Tag ↗](https://github.com/codemie-ai/codemie/releases/tag/2.22.1) – April 9, 2026

</details>

<details>
<summary><strong>CodeMie 2.21.0</strong></summary>

**Release Date:** April 8, 2026 · [GitHub Tag ↗](https://github.com/codemie-ai/codemie/releases/tag/2.21.0)

<h3>Third-Party Component Updates</h3>

---

<h4>oauth2-proxy 7.15.1 (Chart 10.4.2)</h4>

Updated oauth2-proxy from 7.14.2 to 7.15.1 (Helm chart 10.1.0 to 10.4.2). For details, see the [oauth2-proxy 7.15.1 Release Notes ↗](https://github.com/oauth2-proxy/oauth2-proxy/releases/tag/v7.15.1).

<h3>Configuration Changes</h3>

No breaking configuration changes were introduced in this release.

</details>

<details>
<summary><strong>CodeMie 2.20.0</strong></summary>

**Release Date:** April 2, 2026 · [GitHub Tag ↗](https://github.com/codemie-ai/codemie/releases/tag/2.20.0)

<h3>Third-Party Component Updates</h3>

---

<h4>ElasticSearch / Kibana 8.19.12</h4>

Updated from 8.18.4. For details, see the [Elastic 8.19.12 Release Notes ↗](https://www.elastic.co/guide/en/security/8.19/release-notes-header-8.19.0.html#release-notes-8.19.12).

**Upgrade instructions:** [ElasticSearch and Kibana Upgrade Guide](./elasticsearch-kibana-upgrade)

---

<h4>NATS Chart 1.3.0 (NATS 2.11.0, Reloader 0.22.3)</h4>

Updated NATS Helm chart from 1.2.6 to 1.3.0, which includes NATS server 2.11.0 (up from 2.10.22) and NATS Reloader 0.22.3 (up from 0.16.0).

**Upgrade instructions:** [NATS Upgrade Guide](./nats-upgrade)

---

<h4>Keycloak 26.5.6 (keycloakx 7.1.9)</h4>

Updated Keycloak to 26.5.6 (up from 26.4.5) and keycloakx chart to 7.1.9 (up from 7.1.5). For details, see the [Keycloak 26.5 Release Notes ↗](https://www.keycloak.org/docs/latest/release_notes/).

**Upgrade instructions:** [Keycloak Upgrade Guide](./keycloak/keycloak-upgrade/)

---

<h4>Nginx 1.15.1</h4>

Updated nginx ingress controller to version 1.15.1 (up from 1.14.3).

<h3>Configuration Changes</h3>

No breaking configuration changes were introduced in this release.

</details>

<details>
<summary><strong>CodeMie 2.19.0</strong></summary>

**Release Date:** March 27, 2026 · [GitHub Tag ↗](https://github.com/codemie-ai/codemie/releases/tag/2.19.0)

<h3>Third-Party Component Updates</h3>

<h4>Postgres Operator Removed</h4>

CodeMie 2.19.0 removes the `postgres-operator` Helm chart (PGO 5.4.3) used for Keycloak's in-cluster PostgreSQL. It is replaced by two new database options:

- **Dedicated database instance** — a separate, Terraform-provisioned database instance for Keycloak (default for Terraform deployments)
- **Shared CodeMie database** — Keycloak reuses the existing CodeMie database instance; a Helm hook Job automatically creates the required database and user on first install

See the [Keycloak Database Migration Guide](./keycloak/keycloak-database-migration) for upgrade instructions.

:::note
Migration to an external database is optional. If you prefer to continue using the in-cluster PostgreSQL, no migration is required when upgrading to 2.19.0.
:::

<h3>Configuration Changes</h3>

No breaking configuration changes were introduced in this release.

</details>

<details>
<summary><strong>CodeMie 2.18.0</strong></summary>

**Release Date:** March 24, 2026 · [GitHub Tag ↗](https://github.com/codemie-ai/codemie/releases/tag/2.18.0)

<h3>Third-Party Component Updates</h3>

No third-party component updates in this release.

<h3>Configuration Changes</h3>

No breaking configuration changes were introduced in this release.

</details>

<details>
<summary><strong>CodeMie 2.17.0</strong></summary>

**Release Date:** March 20, 2026 · [GitHub Tag ↗](https://github.com/codemie-ai/codemie/releases/tag/2.17.0)

<h3>Third-Party Component Updates</h3>

No third-party component updates in this release.

<h3>Configuration Changes</h3>

No breaking configuration changes were introduced in this release.

</details>

<details>
<summary><strong>CodeMie 2.16.0</strong></summary>

**Release Date:** March 18, 2026 · [GitHub Tag ↗](https://github.com/codemie-ai/codemie/releases/tag/2.16.0)

<h3>Third-Party Component Updates</h3>

No third-party component updates in this release.

<h3>Configuration Changes</h3>

No breaking configuration changes were introduced in this release.

</details>

<details>
<summary><strong>CodeMie 2.15.0</strong></summary>

**Release Date:** March 16, 2026 · [GitHub Tag ↗](https://github.com/codemie-ai/codemie/releases/tag/2.15.0)

<h3>Third-Party Component Updates</h3>

<h4>Fluent Bit 4.2.3.1</h4>

CodeMie 2.15.0 includes Fluent Bit version 4.2.3.1, providing improved log collection and processing capabilities.

**What's new:**

For detailed information about changes, improvements, and bug fixes, see the [Fluent Bit 4.2.3.1 Release Notes](https://github.com/fluent/fluent-bit/releases/tag/v4.2.3.1).

**Upgrade instructions:**

To upgrade Fluent Bit to version 4.2.3.1, follow the [Fluent Bit Upgrade Guide](./fluent-bit-upgrade).

<h3>Configuration Changes</h3>

No breaking configuration changes were introduced in this release. All existing Fluent Bit configurations remain compatible.

</details>
