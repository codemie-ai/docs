---
id: configure-values
sidebar_label: Configure Values
sidebar_position: 2
title: Step 1 - Configure API and Proxy Values
description: Configure CodeMie API and LiteLLM values.yaml files
pagination_prev: admin/deployment/extensions/litellm-proxy/litellm-proxy-overview
pagination_next: null
---

import Tabs from '@theme/Tabs';
import TabItem from '@theme/TabItem';

# Step 1: Configure CodeMie API and LiteLLM Values

This step is required for both Automated and Manual setups.

## Configure CodeMie API Values

Add the following environment variables to your CodeMie API `values.yaml`: `codemie-api/values-<cloud>.yaml`

```yaml
extraEnv:
  - name: LLM_PROXY_MODE
    value: 'lite_llm'
  - name: LLM_PROXY_ENABLED
    value: 'true'
  - name: LITE_LLM_URL
    value: 'http://litellm.litellm:4000'
  - name: LITE_LLM_TAGS_HEADER_VALUE
    value: 'global'
  - name: LITE_LLM_APP_KEY
    valueFrom:
      secretKeyRef:
        name: litellm-integration
        key: litellm-app-key
  - name: LITE_LLM_MASTER_KEY
    valueFrom:
      secretKeyRef:
        name: litellm-integration
        key: litellm-master-key
```

## Configure LiteLLM Values

Configure `litellm/values-<cloud_name>.yaml`

```yaml
litellm-helm:
  ingress:
    enabled: true
    annotations: {}
    className: 'nginx'
    hosts:
      - host: litellm.%%DOMAIN%% # Replace with your domain
        paths:
          - path: /
            pathType: ImplementationSpecific
    tls: []

  redis:
    global:
      # Storage Class Configuration
      defaultStorageClass: 'your-storage-class' # e.g., "gp3", "standard", etc.
    enabled: false # Redis is disabled by default
```

### Database Configuration

Configure the database initialization job based on your PostgreSQL deployment:

<Tabs groupId="database-setup">
  <TabItem value="shared" label="Shared Database (Default)" default>

By default, LiteLLM shares the main CodeMie PostgreSQL instance. In this mode, a dedicated `litellm` database and user must be created inside that instance.

Set `dbInitJob.enabled: true` in `litellm/values-<cloud>.yaml`:

```yaml
dbInitJob:
  # highlight-next-line
  enabled: true
  initImage: alpine/psql:18.3
  pgAdminSecret:
    name: codemie-postgresql
    userKey: PG_USER
    passwordKey: PG_PASS
```

:::info
When enabled, the deployment script automatically creates the `codemie-postgresql` secret using `CODEMIE_POSTGRES_DATABASE_USER` and `CODEMIE_POSTGRES_DATABASE_PASSWORD` from `deployment_outputs.env`. For manual deployment, create this secret before running Helm. See [Manual Deployment](./deployment/manual-deployment.md#step-52-create-secrets-and-configmaps).
:::

  </TabItem>
  <TabItem value="dedicated" label="Dedicated Database">

If you provisioned a dedicated RDS instance for LiteLLM via `TF_VAR_litellm_db_config`, Terraform already created the `litellm` database and `litellm_admin` master user.

Keep `dbInitJob.enabled: false` in `litellm/values-<cloud>.yaml`. The initialization job is not needed.

```yaml
dbInitJob:
  enabled: false
```

  </TabItem>
</Tabs>

### Redis Configuration

By default, Redis deployment is **disabled** (`enabled: false`). Redis is an optional component that enhances LiteLLM proxy capabilities for specific use cases.

#### When to Enable Redis

Set `enabled: true` if you need any of the following features:

**1. Response Caching**

Cache LLM API responses to reduce costs and latency. Redis stores responses for identical queries, enabling faster response times and lower API costs.

Learn more: [LiteLLM Caching Documentation](https://litellm.vercel.app/docs/proxy/caching)

**2. Distributed Rate Limiting and Load Balancing**

When running multiple LiteLLM proxy instances (e.g., multiple Kubernetes pods), Redis synchronizes rate limits and load balancing state across all instances. This ensures consistent TPM/RPM enforcement and proper request distribution.

Learn more: [LiteLLM Load Balancing Documentation](https://docs.litellm.ai/docs/proxy/load_balancing)

### Autoscaling Configuration

The `litellm-helm` chart supports a Kubernetes Horizontal Pod Autoscaler (HPA) that adds or removes LiteLLM Proxy replicas based on CPU utilization, so the proxy can absorb request bursts without permanently running at peak capacity.

Autoscaling is **disabled by default**. Enable it under `litellm-helm.autoscaling` in `litellm/values-<cloud>.yaml`:

```yaml
litellm-helm:
  autoscaling:
    enabled: true
    minReplicas: 2
    maxReplicas: 10
    targetCPUUtilizationPercentage: 60
```

| Key                              | Description                                                               | Default |
| -------------------------------- | ------------------------------------------------------------------------- | ------- |
| `enabled`                        | Enables the HorizontalPodAutoscaler for LiteLLM Proxy pods.               | `false` |
| `minReplicas`                    | Minimum number of proxy pods to keep running.                             | `1`     |
| `maxReplicas`                    | Maximum number of proxy pods the autoscaler is allowed to create.         | `100`   |
| `targetCPUUtilizationPercentage` | Target average CPU utilization, as a percentage of the pod's CPU request. | `60`    |

:::warning
Autoscaling requires a CPU request on the LiteLLM Proxy container (`litellm-helm.resources.requests.cpu`) — utilization is measured against it. Without a CPU request, the HPA cannot compute utilization and will not scale correctly.
:::

## Next Steps

Continue to [Cloud Provider Authentication](./auth-secrets.md).
