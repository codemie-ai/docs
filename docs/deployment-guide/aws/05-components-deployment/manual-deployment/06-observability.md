---
id: observability
sidebar_position: 7
title: Observability
description: Install Fluent Bit and Kibana Dashboards for logging and monitoring
---

# Observability

## Fluent Bit

If you don't have your own logging system:

1. Create namespace:

   ```bash
   kubectl create ns fluentbit
   ```

2. Copy Elasticsearch credentials:

   ```bash
   kubectl get secret elasticsearch-master-credentials -n elastic -o yaml | sed '/namespace:/d' | kubectl apply -n fluentbit -f -
   ```

3. Install Fluent Bit:

   ```bash
   helm upgrade --install fluent-bit fluent-bit/. \
     -n fluentbit \
     --values fluent-bit/values.yaml \
     --wait --timeout 900s \
     --dependency-update
   ```

4. Configure `codemie_infra_logs*` index in Kibana

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

## Kibana Dashboards

Install custom dashboards for metrics and monitoring.

**With manual authentication:**

```bash
bash ./kibana-dashboards/manage-kibana-dashboards.sh --url "https://kibana.<your-domain>"
```

**With Kubernetes secret authentication (recommended):**

```bash
bash ./kibana-dashboards/manage-kibana-dashboards.sh --url "https://kibana.<your-domain>" --k8s-auth --non-interactive
```

This uses the `elasticsearch-master-credentials` secret from the `elastic` namespace by default.

For more information and additional options, use:

```bash
bash ./kibana-dashboards/manage-kibana-dashboards.sh --help
```

## Next Steps

After all components are installed, proceed to [Configuration](../../../../configuration-guide/) to complete required setup steps.
