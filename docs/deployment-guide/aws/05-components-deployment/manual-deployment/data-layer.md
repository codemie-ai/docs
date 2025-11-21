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

```bash
kubectl create secret generic codemie-postgresql \
  --from-literal=password=%%YOUR_PASSWORD%% \
  --namespace codemie
```

## Next Steps

Proceed to [Security and Identity](./security-and-identity) installation.
