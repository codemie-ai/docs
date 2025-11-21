---
id: observability
sidebar_position: 6
title: Observability
sidebar_label: Observability
---

# Observability Installation

## Install Fluentbit Component

If you do not have your own logging system then consider installing Fluentbit component to store historical log data.

1. Create `fluentbit` namespace:

   ```bash
   kubectl create ns fluentbit
   ```

2. Copy Elasticsearch credentials to the `fluentbit` namespace with the command:

   ```bash
   kubectl get secret elasticsearch-master-credentials -n elastic -o yaml | sed '/namespace:/d' | kubectl apply -n fluentbit -f -
   ```

3. Install `fluentbit` with the command:

   ```bash
   helm upgrade --install fluent-bit fluent-bit/. -n fluentbit --values fluent-bit/values.yaml --wait --timeout 900s --dependency-update
   ```

4. Go to Kibana and setup `codemie_infra_logs*` index to view historical logs.

## Install Kibana Component

1. Create `kibana-encryption-keys` Kubernetes secret:

   ```bash
   kubectl create secret generic "kibana-encryption-keys" \
     --namespace="elastic" \
     --from-literal=encryptedSavedObjects.encryptionKey="$(openssl rand -hex 16)" \
     --from-literal=reporting.encryptionKey="$(openssl rand -hex 16)" \
     --from-literal=security.encryptionKey="$(openssl rand -hex 16)" \
     --type=Opaque
   ```

   Secret example:

   ```yaml
   apiVersion: v1
   kind: Secret
   metadata:
     name: kibana-encryption-keys
     namespace: elastic
   data:
     encryptedSavedObjects.encryptionKey: <base64-encoded-32-byte-long-strong-encryption-key>
     reporting.encryptionKey: <base64-encoded-32-byte-long-strong-encryption-key>
     security.encryptionKey: <base64-encoded-32-byte-long-strong-encryption-key>
   type: Opaque
   ```

2. Install `kibana` helm chart with the command:

   ```bash
   helm upgrade --install kibana kibana/. -n elastic --values kibana/values-azure.yaml --wait --timeout 900s --dependency-update
   ```

3. Kibana can be accessed by the following URL: `https://codemie.private.lab.com/kibana`, e.g. `https://codemie.example.com/kibana`

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

Complete the deployment by going to [Post-Installation Configuration](../../post-installation).
