---
id: metrics-index-rotation
title: Metrics Index Rotation Update
sidebar_label: Metrics Index Rotation
sidebar_position: 8
pagination_prev: admin/update/update-overview
pagination_next: null
---

This guide explains how to migrate an existing AI/Run CodeMie deployment to quarterly
Elasticsearch indexes for user and usage metrics.

The migration is designed to preserve access to existing metrics. The legacy
`codemie_metrics_logs` index remains readable, while new metrics are written through the
`codemie_metrics_logs_write` alias to a quarterly index.

:::danger Do not enable the feature before completing the migration
The CodeMie API rotation scheduler requires `codemie_metrics_logs_write` to point to
exactly one explicit write index. Complete the Elasticsearch and Fluent Bit changes
below before setting `METRICS_ROTATION_ENABLED=true`.
:::

## Before you begin

Make sure that you have:

- administrator access to the Elasticsearch cluster or Kibana **Dev Tools**;
- access to the `fluent-bit/values.yaml` configuration used by the deployment;
- permission to update the CodeMie API environment variables;
- a backup or recovery plan for the Elasticsearch metrics data;
- a tested maintenance procedure for your deployment.

No data copy is required. Analytics queries use `codemie_metrics_logs*`, which includes
the legacy index and quarterly indexes.

## Step 1: Determine the current UTC quarter

Use the following calendar to determine the index name:

| UTC dates             | Index suffix |
| --------------------- | ------------ |
| January 1–March 31    | `q1`         |
| April 1–June 30       | `q2`         |
| July 1–September 30   | `q3`         |
| October 1–December 31 | `q4`         |

The target index name follows this format:

```text
codemie_metrics_logs-YYYY-qN
```

For example, metrics collected during the third quarter of 2026 use
`codemie_metrics_logs-2026-q3`.

## Step 2: Create the quarterly index and write alias

In Kibana **Dev Tools** or through the authenticated Elasticsearch API, create the
current-quarter index with the write alias. Replace `YYYY-qN` with the quarter selected
in Step 1:

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

If the target quarterly index already exists, add the alias to that index instead of
creating it again. Before continuing, verify the alias:

```http
GET /_alias/codemie_metrics_logs_write
```

The response must show exactly one index with
`"is_write_index": true`. If the alias is missing or has zero or multiple write indexes,
correct it before proceeding.

:::note No index template is required
The rotation service creates a quarterly index with Elasticsearch dynamic mappings. Do
not copy the legacy mapping or add an ILM policy or index template solely for rotation.
Keep existing metric field JSON types and object/array shapes stable; additive fields are
dynamically mapped.
:::

## Step 3: Point Fluent Bit to the write alias

In the metrics Elasticsearch output in `fluent-bit/values.yaml`, replace the legacy
metrics index:

```text
codemie_metrics_logs
```

with the write alias:

```text
codemie_metrics_logs_write
```

Change only the metrics output. Keep the infrastructure-log output and its
`logs-codemie-infra` index configuration unchanged.

The cloud-specific deployment guides provide more information about the two output
types: [AWS](../../deployment/aws/kubernetes/components-deployment/manual-deployment/observability),
[Azure](../../deployment/azure/kubernetes/components-deployment/manual-deployment/observability), or
[GCP](../../deployment/gcp/kubernetes/components-deployment/manual-deployment/observability).

## Step 4: Enable the rotation scheduler

Set the following environment variable in the CodeMie API deployment:

```dotenv
METRICS_ROTATION_ENABLED=true
```

The default is `false`. Deploy or restart the CodeMie API after updating the variable.
The scheduler is then registered for the fixed UTC quarter-boundary schedule:

- 00:00 UTC on January 1;
- 00:00 UTC on April 1;
- 00:00 UTC on July 1;
- 00:00 UTC on October 1.

The initial alias bootstrap in Step 2 is required because enabling the flag does not
perform an immediate rotation.

## Step 5: Verify the migration

After Fluent Bit and the CodeMie API are running, verify the alias and the target index:

```http
GET /_alias/codemie_metrics_logs_write
GET /codemie_metrics_logs-YYYY-qN/_count
```

Confirm that:

- the alias has exactly one `is_write_index: true` target;
- the current-quarter index exists;
- the current-quarter document count increases after new user activity;
- CodeMie API logs show that the metrics rotation scheduler started;
- Kibana dashboards and analytics continue to display metrics.

For multi-pod deployments, the scheduler uses a PostgreSQL advisory lock so that only
one pod performs each rotation.

## Rollback and follow-up

To disable automatic future rotations, set `METRICS_ROTATION_ENABLED=false` and redeploy.
The write alias remains valid and can continue receiving metrics; do not delete the
quarterly index or alias as part of the rollback.

Existing quarterly indexes are not deleted automatically. Plan retention and cleanup
separately if the Elasticsearch cluster requires it.

For scheduler behavior, validation rules, and troubleshooting, see
[Metrics Index Rotation](../../configuration/observability/metrics-index-rotation).
