---
id: configure-values
sidebar_label: Configure Values
sidebar_position: 2
title: Step 1 - Configure API and Proxy Values
description: Configure CodeMie API and LiteLLM values.yaml files
pagination_prev: admin/deployment/extensions/litellm-proxy/litellm-proxy-overview
pagination_next: null
---

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

### Enable Database Initialization Job

`dbInitJob` automatically creates the `postgres_litellm` database and user during Helm deployment. It is **disabled by default**.

```yaml
dbInitJob:
  # highlight-next-line
  enabled: true
  initImage: alpine/psql:18.3
  pgAdminSecret:
    name: codemie-postgresql  # Secret with PostgreSQL admin credentials
    userKey: PG_USER
    passwordKey: PG_PASS
```

:::info
When enabled, the deployment script (`helm-charts.sh`) automatically creates the `codemie-postgresql` secret using admin credentials from `deployment_outputs.env` — either `CODEMIE_POSTGRES_DATABASE_USER`/`CODEMIE_POSTGRES_DATABASE_PASSWORD` (shared database) or `LITELLM_POSTGRES_DATABASE_USER`/`LITELLM_POSTGRES_DATABASE_PASSWORD` (dedicated LiteLLM database). For manual deployment, create this secret before running Helm — see [Manual Deployment](./deployment/manual-deployment.md#step-52-create-secrets-and-configmaps).
:::

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

## Next Steps

Continue to [Cloud Provider Authentication](./auth-secrets.md).
