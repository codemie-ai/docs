---
id: data-layer
sidebar_position: 3
title: Data Layer
description: Install Elasticsearch, Kibana, and PostgreSQL
---

# Data Layer Installation

## Elasticsearch

1. Create namespace:

   ```bash
   kubectl create namespace elastic
   ```

2. Create credentials secret:

   ```bash
   kubectl -n elastic create secret generic elasticsearch-master-credentials \
     --from-literal=username=elastic \
     --from-literal=password="$(openssl rand -base64 12)" \
     --type=Opaque \
     --dry-run=client -o yaml | kubectl apply -f -
   ```

3. Install Elasticsearch:
   ```bash
   helm upgrade --install elastic elasticsearch/. \
     -n elastic \
     --values elasticsearch/values-aws.yaml \
     --wait --timeout 900s \
     --dependency-update
   ```

## Postgres-operator

```bash
helm upgrade --install postgres-operator postgres-operator-helm/. \
  -n postgres-operator \
  --create-namespace \
  --wait --timeout 900s \
  --dependency-update
```

## PostgreSQL secret for RDS

Create `codemie-postgresql` secret:

```bash
kubectl create secret generic codemie-postgresql \
        --from-literal=PG_PASS=`<CODEMIE_POSTGRES_DATABASE_PASSWORD>` \
        --from-literal=PG_USER=`<CODEMIE_POSTGRES_DATABASE_USER>` \
        --from-literal=PG_HOST=`<CODEMIE_POSTGRES_DATABASE_HOST>` \
        --from-literal=PG_NAME=`<CODEMIE_POSTGRES_DATABASE_NAME>` \
        --namespace codemie
```

Secret example:

```bash
apiVersion: v1
kind: Secret
metadata:
  name: codemie-postgresql
  namespace: codemie
data:
  PG_HOST: <base64-encoded-host>
  PG_NAME: <base64-encoded-db-name>
  PG_PASS: <base64-encoded-password>
  PG_USER: <base64-encoded-user>
type: Opaque
```

:::note
The values for `CODEMIE_POSTGRES_DATABASE_*` environment variables can be taken from `deployment_outputs.env` file (see [Infrastructure Deployment](../../infrastructure-deployment/infrastructure-scripted-deployment#3-generate-outputs)).
:::

## Next Steps

Proceed to [Security and Identity](./security-and-identity) installation.
