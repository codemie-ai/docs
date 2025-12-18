---
id: configure-values
sidebar_label: Configure Values
sidebar_position: 3
title: Step 2 - Configure API and Proxy Values
description: Configure CodeMie API and LiteLLM values.yaml files
---

# Step 2: Configure CodeMie API and LiteLLM Values

This step is required for both Automated and Manual setups.

## Configure CodeMie API Values

Add the following environment variables to your CodeMie API `values.yaml`: `codemie-api/values-<cloud>.yaml`

:::note

MODELS_ENV must equal the cloud you use for deployment: `aws`, `azure`, or `gcp`.

:::

```yaml
extraEnv:
  - name: MODELS_ENV
    value: 'aws'
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

Continue to [Cloud Provider Authentication](./auth-secrets).
