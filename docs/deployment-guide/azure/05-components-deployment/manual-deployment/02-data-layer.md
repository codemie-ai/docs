---
id: data-layer
sidebar_position: 2
title: Data Layer
sidebar_label: Data Layer
---

# Data Layer Installation

## Install Elasticsearch Component

1. Create Kubernetes namespace, e.g. `elastic` with the command:

   ```bash
   kubectl create namespace elastic
   ```

2. Create Kubernetes secret:

   ```bash
   kubectl -n elastic create secret generic elasticsearch-master-credentials \
     --from-literal=username=elastic \
     --from-literal=password="$(openssl rand -base64 12)" \
     --type=Opaque \
     --dry-run=client -o yaml | kubectl apply -f -
   ```

   Secret example:

   ```yaml
   apiVersion: v1
   kind: Secret
   metadata:
     name: elasticsearch-master-credentials
   type: Opaque
   data:
     username: <base64-encoded-username>
     password: <base64-encoded-password>
   ```

3. Install `elasticsearch` helm chart in created namespace with the command:

   ```bash
   helm upgrade --install elastic elasticsearch/. -n elastic --values elasticsearch/values-azure.yaml --wait --timeout 900s --dependency-update
   ```

## Install Postgres-operator Component

Apply `postgres-operator` chart:

```bash
helm upgrade --install postgres-operator postgres-operator-helm/. -n postgres-operator --create-namespace --wait --timeout 900s --dependency-update
```

## Install PostgreSQL Component

### Configure cloud-managed PostgreSQL

Create `codemie-postgresql` secret:

```bash
kubectl create secret generic codemie-postgresql \
        --from-literal=PG_PASS=<CODEMIE_POSTGRES_DATABASE_PASSWORD> \
        --from-literal=PG_USER=<CODEMIE_POSTGRES_DATABASE_USER> \
        --from-literal=PG_HOST=<CODEMIE_POSTGRES_DATABASE_HOST> \
        --from-literal=PG_NAME=<CODEMIE_POSTGRES_DATABASE_NAME> \
        --namespace codemie
```

:::note
Replace `<CODEMIE_POSTGRES_DATABASE_*>` placeholders with actual values from your `deployment_outputs.env` file (see [Infrastructure Deployment](../../infrastructure-deployment/infrastructure-scripted-deployment#usage)).
:::

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

## Next Steps

Proceed to [Security and Identity](./security-and-identity) installation.