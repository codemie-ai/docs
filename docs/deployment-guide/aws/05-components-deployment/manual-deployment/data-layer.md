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

## Kibana

1. Configure domain in `kibana/values-aws.yaml` (replace `%%DOMAIN%%`)

2. Create encryption keys secret:

   ```bash
   kubectl create secret generic "kibana-encryption-keys" \
     --namespace="elastic" \
     --from-literal=encryptedSavedObjects.encryptionKey="$(openssl rand -hex 16)" \
     --from-literal=reporting.encryptionKey="$(openssl rand -hex 16)" \
     --from-literal=security.encryptionKey="$(openssl rand -hex 16)" \
     --type=Opaque
   ```

3. Install Kibana:
   ```bash
   helm upgrade --install kibana kibana/. \
     -n elastic \
     --values kibana/values-aws.yaml \
     --wait --timeout 900s \
     --dependency-update
   ```

Access Kibana at: `https://kibana.<your-domain>`

## Postgres-operator

```bash
helm upgrade --install postgres-operator postgres-operator-helm/. \
  -n postgres-operator \
  --create-namespace \
  --wait --timeout 900s \
  --dependency-update
```

## PostgreSQL

Create PostgreSQL secret for cloud-managed database (AWS RDS):

```bash
kubectl create secret generic codemie-postgresql \
  --from-literal=password=%%YOUR_PASSWORD%% \
  --namespace codemie
```

## Next Steps

Proceed to [Security and Identity](./security-and-identity) installation.
