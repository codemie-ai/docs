---
id: observability
sidebar_position: 7
title: Observability
description: Install Fluentbit and Kibana Dashboards for logging and monitoring
---

# Observability

## Fluentbit

If you don't have your own logging system:

1. Create namespace:

   ```bash
   kubectl create ns fluentbit
   ```

2. Copy Elasticsearch credentials:

   ```bash
   kubectl get secret elasticsearch-master-credentials -n elastic -o yaml | sed '/namespace:/d' | kubectl apply -n fluentbit -f -
   ```

3. Install Fluentbit:

   ```bash
   helm upgrade --install fluent-bit fluent-bit/. \
     -n fluentbit \
     --values fluent-bit/values.yaml \
     --wait --timeout 900s \
     --dependency-update
   ```

4. Configure `codemie_infra_logs*` index in Kibana

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

After all components are installed, proceed to [Post-Installation Configuration](../../post-installation/) to complete required setup steps.
