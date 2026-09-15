---
id: metrics-index-rotation
title: Metrics Index Rotation
sidebar_label: Metrics Index Rotation
sidebar_position: 3
pagination_prev: admin/configuration/observability/logs-retention
pagination_next: null
---

This guide describes quarterly rotation for the Elasticsearch index that stores
CodeMie's user and usage metrics.

Metrics index rotation is opt-in. When enabled, CodeMie writes new metrics through the
`codemie_metrics_logs_write` alias and rotates that alias to a new index at the beginning
of each UTC calendar quarter.

:::warning Complete the prerequisites before enabling rotation
The rotation scheduler expects the write alias to exist and to point to exactly one
write index. Bootstrap the alias and configure Fluent Bit before setting
`METRICS_ROTATION_ENABLED=true`. If the alias is missing or invalid, rotation fails
closed and does not modify Elasticsearch.
:::

## Index layout

| Elasticsearch resource         | Purpose                                                                   |
| ------------------------------ | ------------------------------------------------------------------------- |
| `codemie_metrics_logs`         | Legacy metrics index. Existing data remains readable after migration.     |
| `codemie_metrics_logs-YYYY-qN` | Quarterly metrics index, for example `codemie_metrics_logs-2026-q3`.      |
| `codemie_metrics_logs_write`   | Write alias used by Fluent Bit. It points to the current quarter's index. |

Analytics queries use the `codemie_metrics_logs*` pattern, so they can read the legacy
index and all quarterly indexes. Rotation changes only the write destination; it does not
copy or delete existing metrics.

## Prerequisites

Before enabling the scheduler:

1. Ensure Elasticsearch and Kibana are available to the deployment administrator.
2. Decide which current-quarter index should receive new metrics.
3. Ensure the metrics Elasticsearch output in Fluent Bit uses
   `codemie_metrics_logs_write` as its index or alias.
4. Keep the JSON types and object/array shapes of existing metric fields stable.
   New fields are handled by Elasticsearch dynamic mappings.

For an existing deployment, follow the [Metrics Index Rotation Update](../../../update/metrics-index-rotation)
procedure to complete the migration.

## Bootstrap the write alias

Create the current-quarter index and its write alias in Kibana **Dev Tools** or through
the authenticated Elasticsearch API. Replace `YYYY-qN` with the current UTC quarter.

```http
PUT /codemie_metrics_logs-YYYY-qN
{
  "aliases": {
    "codemie_metrics_logs_write": {
      "is_write_index": true
    }
  }
}
```

The request creates an empty index with Elasticsearch dynamic mappings. No copied mapping,
ILM policy, or index template is required for rotation.

Verify that the alias has exactly one explicit write index:

```http
GET /_alias/codemie_metrics_logs_write
```

The response must contain one index whose alias metadata includes
`"is_write_index": true`. Do not enable rotation if the alias is missing or has zero or
multiple write indexes.

:::tip Existing quarterly index
If the target quarterly index already exists, do not run the `PUT` request again. Add
the alias to the existing index with the Elasticsearch aliases API, then verify that it
is the only write index for `codemie_metrics_logs_write`.
:::

## Configure Fluent Bit

In the metrics Elasticsearch output in `fluent-bit/values.yaml`, replace the legacy
metrics index with the write alias:

```text
codemie_metrics_logs_write
```

Do not change the output used for infrastructure logs. User metrics must continue to be
collected for Kibana dashboards and usage analytics.

The cloud-specific deployment guides describe the metrics and infrastructure-log
outputs: [AWS](../../../deployment/aws/kubernetes/components-deployment/manual-deployment/observability),
[Azure](../../../deployment/azure/kubernetes/components-deployment/manual-deployment/observability), or
[GCP](../../../deployment/gcp/kubernetes/components-deployment/manual-deployment/observability).

## Enable rotation

Set the following environment variable in the CodeMie API deployment:

```dotenv
METRICS_ROTATION_ENABLED=true
```

The default value is `false`. The scheduler starts when the API starts and stops when the
API shuts down. Enabling the flag does not perform an immediate rotation; the bootstrap
step selects the initial current-quarter index.

The variable is also listed in the [API Configuration Reference](../../codemie/api-configuration).

## Rotation schedule

The scheduler runs at **00:00 UTC** on the first day of every calendar quarter:

| UTC date  | Quarter |
| --------- | ------- |
| January 1 | Q1      |
| April 1   | Q2      |
| July 1    | Q3      |
| October 1 | Q4      |

At the quarter boundary, the scheduler:

1. Calculates the current UTC-quarter index name.
2. Creates the index if it does not exist.
3. Atomically removes `codemie_metrics_logs_write` from the previous write index and
   adds it to the new index with `is_write_index: true`.

In a multi-pod deployment, a PostgreSQL advisory lock ensures that only one pod performs
the rotation. There is no user-configurable rotation schedule.

## Failure behavior and troubleshooting

Rotation fails closed in the following cases:

- `codemie_metrics_logs_write` does not exist;
- the alias has no explicit write index;
- the alias has more than one explicit write index;
- Elasticsearch cannot create the target index or update the aliases.

When validation fails, the service does not create an index or update the alias. Check
the CodeMie API logs for `Metrics index rotation` messages and verify the alias again:

```http
GET /_alias/codemie_metrics_logs_write
```

If the alias already points to the current-quarter index, the scheduler skips the alias
swap. Existing quarterly indexes are not removed automatically. Configure any required
retention or cleanup process separately.

## Related documentation

- [Metrics Index Rotation Update](../../../update/metrics-index-rotation) — migrate an existing deployment
- [Observability Overview](..) — overview of Elasticsearch, Fluent Bit, Kibana, and Langfuse
- [API Configuration Reference](../../codemie/api-configuration) — environment variable reference
