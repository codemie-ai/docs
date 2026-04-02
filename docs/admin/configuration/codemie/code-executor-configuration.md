---
id: code-executor-configuration
title: Code Executor Configuration
sidebar_label: Code Executor
sidebar_position: 5
---

import Tabs from '@theme/Tabs';
import TabItem from '@theme/TabItem';

# Code Executor Configuration

The Code Executor runs Python code in isolated Kubernetes pods with enforced resource limits and security policies.

It supports three deployment modes: local execution inside the API pod, sandbox pods in the same cluster, or sandbox pods in a dedicated cluster.

## Deployment Options

### Local Mode

The default mode. Code is executed directly inside the CodeMie API pod via subprocess. No Kubernetes resources needed.

No changes required. The default value of `CODE_EXECUTOR_EXECUTION_MODE` is `local`.

### Same Cluster as CodeMie API

Executor pods run in the same Kubernetes cluster as CodeMie API.

<Tabs>
<TabItem value="shared" label="Shared namespace" default>

Executor pods are deployed in the same namespace as CodeMie API (e.g. `codemie`).

**Set in CodeMie API values:**

```yaml
features:
  tools:
    code_executor:
      rbac:
        enabled: true  # Creates role and assign it to the service account configured for codemie-api
        namespace: ""  # defaults to the CodeMie release namespace

extraEnv:
  - name: CODE_EXECUTOR_NAMESPACE
    value: "codemie"
```

</TabItem>
<TabItem value="dedicated" label="Dedicated namespace">

Executor pods are deployed in a separate namespace (e.g. `codemie-runtime`).

**Set in CodeMie API values:**

```yaml
features:
  tools:
    code_executor:
      rbac:
        enabled: true
        namespace: "codemie-runtime"

extraEnv:
  - name: CODE_EXECUTOR_NAMESPACE
    value: "codemie-runtime"
```

</TabItem>
</Tabs>

### Dedicated Cluster

**1. Create a kubeconfig secret in the CodeMie API namespace:**

```bash
kubectl create secret generic codemie-executor-kubeconfig \
  --from-file=kubeconfig=<path-to-kubeconfig> \
  --namespace codemie
```

**2. Set in CodeMie API values:**

```yaml
extraVolumeMounts: |
  - name: executor-kubeconfig
    mountPath: "/secrets/kubeconfig"
    subPath: kubeconfig
    readOnly: true

extraVolumes: |
  - name: executor-kubeconfig
    secret:
      secretName: codemie-executor-kubeconfig

extraEnv:
  - name: CODE_EXECUTOR_NAMESPACE
    value: "codemie-runtime"
  - name: CODE_EXECUTOR_KUBECONFIG_PATH
    value: "/secrets/kubeconfig"
```

## Updating CodeMie API

After configuring any sandbox option, add the following common environment variables and apply the chart:

```yaml
extraEnv:
  - name: CODE_EXECUTOR_EXECUTION_MODE
    value: "sandbox"
  - name: CODE_EXECUTOR_MAX_POD_POOL_SIZE
    value: "5"
  - name: CODE_EXECUTOR_DOCKER_IMAGE
    value: "codemie/codemie-python:<version>"
```

```bash
helm upgrade codemie-api \
  oci://europe-west3-docker.pkg.dev/or2-msq-epmd-edp-anthos-t1iylu/helm-charts/codemie \
  --version <version> \
  -f codemie-api/values-<cloud>.yaml \
  --namespace codemie
```

## Pre-warming the Pod Pool (Optional)

By default, CodeMie API creates executor pods on demand.
The first execution request waits for a pod to start.
To avoid this, deploy the `codemie-runtime` chart to keep pods running and ready:

```bash
helm upgrade --install codemie-runtime \
  oci://europe-west3-docker.pkg.dev/or2-msq-epmd-edp-anthos-t1iylu/helm-charts/codemie-runtime \
  --version <version> \
  -f codemie-runtime/values.yaml \
  --namespace <executor-namespace>
```

## Environment Variables Reference

For the full list of available environment variables, see [API Configuration — Code Executor & Python Sandbox](./api-configuration#code-executor--python-sandbox).
