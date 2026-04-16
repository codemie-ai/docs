---
id: keycloak-database-migration
title: Keycloak Database Migration
sidebar_label: Keycloak Database Migration
description: Migrate Keycloak from in-cluster PostgreSQL (PGO) to a cloud-managed PostgreSQL instance.
pagination_prev: admin/update/update-overview
pagination_next: null
---

import Tabs from '@theme/Tabs';
import TabItem from '@theme/TabItem';

# Keycloak Database Migration

This guide covers migrating Keycloak's database from the in-cluster PostgreSQL (Crunchy PGO) to a cloud-managed PostgreSQL instance. Two target options are supported:

- **Shared database** — Keycloak reuses the existing CodeMie PostgreSQL instance. No infrastructure changes required.
- **Dedicated database** — Keycloak gets its own PostgreSQL instance provisioned by Terraform.

:::warning Plan Downtime
Keycloak will be unavailable during the migration.
:::

## What Changes

| Component           | Before (PGO)                                                    | After (Cloud-Managed)                        |
| ------------------- | --------------------------------------------------------------- | -------------------------------------------- |
| Database host       | `keycloak-primary.security.svc`                                 | Cloud PostgreSQL endpoint                    |
| Database user       | `admin`                                                         | `keycloak_admin`                             |
| Kubernetes secret   | `keycloak-pguser-admin` (auto-created by PGO)                   | `keycloak-postgresql` (manually created)     |
| Secret keys         | `password`, `host`, `port`, `dbname`, `user`, `uri`, `jdbc-uri` | `password` only                              |
| Helm values section | `pgo.enabled: true`                                             | `sharedDatabaseInstance.enabled: true/false` |
| Operator            | Postgres Operator in `postgres-operator` namespace              | Not required                                 |

## Prerequisites

- `kubectl` access to the cluster (`security` and `postgres-operator` namespaces)
- Updated `codemie-helm-charts` repository with the new Keycloak configuration
- `deployment_outputs.env` with target database connection details

:::info Dedicated database only

1. Update the Terraform repository and set `TF_VAR_keycloak_db_config='{"enabled":true}'` in `deployment.conf`.
2. Apply Terraform to provision a dedicated PostgreSQL instance.
3. Copy `deployment_outputs.env` to `codemie-helm-charts`.

:::

## Step 1: Stop Keycloak

```bash
kubectl scale statefulset keycloakx -n security --replicas=0
kubectl get pods -n security -l app.kubernetes.io/name=keycloakx
```

## Step 2: Dump the PGO Database

Launch a temporary pod and dump the database. The pod will be reused in Step 5 for restoring.

```bash
KC_PGO_PASSWORD=$(kubectl get secret keycloak-pguser-admin -n security \
  -o jsonpath='{.data.password}' | base64 -d)
```

```bash
kubectl run pg-tmp \
  --image=postgres:17-alpine \
  --restart=Never \
  -n security \
  -- sleep 3600
```

```bash
kubectl wait pod/pg-tmp -n security \
  --for=condition=Ready --timeout=60s
```

```bash
kubectl exec pg-tmp -n security -- sh -c \
  "PGPASSWORD='${KC_PGO_PASSWORD}' pg_dump \
    --host=keycloak-primary.security.svc \
    --port=5432 \
    --username=admin \
    --dbname=keycloak \
    --no-owner \
    --no-privileges \
    --format=plain \
    --file=/tmp/keycloak-dump.sql"
```

```bash
# Save a local backup copy
kubectl cp security/pg-tmp:/tmp/keycloak-dump.sql ./keycloak-dump.sql
```

## Step 3: Create Kubernetes Secrets

<Tabs groupId="keycloak-db-option">
  <TabItem value="dedicated" label="Dedicated Database" default>

```bash
source deployment_outputs.env
```

```bash
# Password for the keycloak_admin database user
kubectl create secret generic keycloak-postgresql \
  --from-literal=password="${KEYCLOAK_POSTGRES_DATABASE_PASSWORD}" \
  --namespace security
```

  </TabItem>
  <TabItem value="shared" label="Shared Database">

```bash
source deployment_outputs.env
```

```bash
KEYCLOAK_DB_PASSWORD=$(openssl rand -base64 16 | tr -d '=+/' | head -c 16)
```

```bash
# Password for the keycloak_admin database user
kubectl create secret generic keycloak-postgresql \
  --from-literal=password="${KEYCLOAK_DB_PASSWORD}" \
  --namespace security
```

```bash
# CodeMie RDS admin credentials (used by the Helm hook Job to create the keycloak DB and user)
kubectl create secret generic codemie-postgresql \
  --from-literal=PG_USER="${CODEMIE_POSTGRES_DATABASE_USER}" \
  --from-literal=PG_PASS="${CODEMIE_POSTGRES_DATABASE_PASSWORD}" \
  --namespace security
```

  </TabItem>
</Tabs>

## Step 4: Prepare the Target Database

<Tabs groupId="keycloak-db-option">
  <TabItem value="dedicated" label="Dedicated Database" default>

Edit `keycloak-helm/values-<cloud_name>.yaml`:

```yaml
  database:
    hostname: "<KEYCLOAK_POSTGRES_DATABASE_HOST value>"
# ...
sharedDatabaseInstance:
  enabled: false
  initImage: alpine/psql:18.3
```

  </TabItem>
  <TabItem value="shared" label="Shared Database">

Edit `keycloak-helm/values-<cloud_name>.yaml` with the CodeMie database hostname:

```yaml
  database:
    hostname: "<CODEMIE_POSTGRES_DATABASE_HOST value>"
# ...
sharedDatabaseInstance:
  enabled: true
  initImage: alpine/psql:18.3
```

Deploy the Keycloak chart with `replicas=0` to trigger the init Job that creates the `keycloak` database and `keycloak_admin` user:

```bash
helm upgrade --install keycloak keycloak-helm/. \
  -n security \
  --values keycloak-helm/values-<cloud_name>.yaml \
  --set keycloakx.replicas=0 \
  --wait \
  --timeout 900s \
  --dependency-update
```

The init Job is automatically deleted after successful completion.

  </TabItem>
</Tabs>

## Step 5: Restore the Dump

Restore from the dump file that is already inside `pg-tmp` (created in Step 2).

<Tabs groupId="keycloak-db-option">
  <TabItem value="dedicated" label="Dedicated Database" default>

```bash
kubectl exec pg-tmp -n security -- sh -c \
  "PGPASSWORD='${KEYCLOAK_POSTGRES_DATABASE_PASSWORD}' psql \
    --host='${KEYCLOAK_POSTGRES_DATABASE_HOST}' \
    --port=5432 \
    --username=keycloak_admin \
    --dbname=keycloak \
    --file=/tmp/keycloak-dump.sql"
```

  </TabItem>
  <TabItem value="shared" label="Shared Database">

```bash
KEYCLOAK_DB_PASSWORD=$(kubectl get secret keycloak-postgresql -n security \
  -o jsonpath='{.data.password}' | base64 -d)

kubectl exec pg-tmp -n security -- sh -c \
  "PGPASSWORD='${KEYCLOAK_DB_PASSWORD}' psql \
    --host='${CODEMIE_POSTGRES_DATABASE_HOST}' \
    --port=5432 \
    --username=keycloak_admin \
    --dbname=keycloak \
    --file=/tmp/keycloak-dump.sql"
```

  </TabItem>
</Tabs>

Clean up the temporary pod:

```bash
kubectl delete pod pg-tmp -n security
```

## Step 6: Deploy Updated Keycloak

```bash
helm upgrade --install keycloak keycloak-helm/. \
  -n security \
  --values keycloak-helm/values-<cloud_name>.yaml \
  --wait \
  --timeout 900s \
  --dependency-update
```

## Step 7: Verify

```bash
kubectl get pods -n security -l app.kubernetes.io/name=keycloakx
kubectl logs -n security -l app.kubernetes.io/name=keycloakx --tail=20
```

Then verify in the browser:

1. Open the Keycloak admin console
2. Check that realms, clients, and users are present
3. Test an SSO login flow

## Step 8: Clean Up PGO Resources

The PGO PostgreSQL pods and secrets in the `security` namespace are removed automatically by `helm upgrade` (the `postgres-cluster.yaml` template no longer exists in the chart). Only the Postgres Operator itself remains in a separate namespace:

```bash
helm uninstall postgres-operator -n postgres-operator
kubectl delete namespace postgres-operator
```
