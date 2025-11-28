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
```

## Next Steps

Continue to [Cloud Provider Authentication](./auth-secrets).
