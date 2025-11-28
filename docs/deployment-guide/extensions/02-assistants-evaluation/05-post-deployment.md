---
id: post-deployment
title: Post-Deployment Configuration
sidebar_label: Post-Deployment
sidebar_position: 6
description: Configure CodeMie integration and verify Langfuse deployment
---

# Post-Deployment Configuration

After successful deployment (using either method), you need to configure CodeMie API integration.

## Update CodeMie API Configuration

Add the following environment variables to your CodeMie API `values.yaml`:

```yaml
extraEnv:
  - name: LANGFUSE_TRACES
    value: 'true'
  - name: LANGFUSE_HOST
    value: https://langfuse.%DOMAIN%
  - name: LANGFUSE_SAMPLE_RATE
    value: '1.0'
  - name: LANGFUSE_TRACING_ENVIRONMENT
    value: <your_environment_name>
  - name: LANGFUSE_RELEASE
    value: '1.4.0' # AI/Run CodeMie current version
  - name: LANGFUSE_PUBLIC_KEY
    valueFrom:
      secretKeyRef:
        name: langfuse-integration
        key: langfuse-public-key
  - name: LANGFUSE_SECRET_KEY
    valueFrom:
      secretKeyRef:
        name: langfuse-integration
        key: langfuse-secret-key
```

## Redeploy CodeMie API

```bash title="Example Redeployment Command"
helm upgrade --install codemie-api oci://europe-west3-docker.pkg.dev/or2-msq-epmd-edp-anthos-t1iylu/helm-charts/codemie \
--version x.y.z \
--namespace "codemie" \
-f "./codemie-api/values-<cloud_name>.yaml" \
--wait --timeout 600s
```

## Verify Deployment

```bash
# Check Langfuse pods
kubectl get pods -n langfuse

# Check services
kubectl get svc -n langfuse

# Check ingress
kubectl get ingress -n langfuse
```

## Access Langfuse UI

Access the UI at `https://langfuse.%%DOMAIN%%`. Use the username and password from the `langfuse-init` secret.

```bash
# Retrieve the langfuse email and password from the Kubernetes secret.
kubectl get secret langfuse-init -n langfuse -o jsonpath='{.data.LANGFUSE_INIT_USER_EMAIL}' | base64 --decode; echo
kubectl get secret langfuse-init -n langfuse -o jsonpath='{.data.LANGFUSE_INIT_USER_PASSWORD}' | base64 --decode; echo
```
