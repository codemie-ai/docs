---
id: code-executor-configuration
title: Code Executor Configuration
sidebar_label: Code Executor
sidebar_position: 5
---

import Tabs from '@theme/Tabs';
import TabItem from '@theme/TabItem';

# Code Executor Configuration

The Code Executor runs Python code in isolated Kubernetes sandbox pods with enforced resource limits and security policies. Every execution request is dispatched to a dedicated sandbox pod, keeping user-supplied code isolated from the CodeMie API.

You choose where those sandbox pods run: in the same cluster as CodeMie API sharing its namespace, in the same cluster in a dedicated namespace, or in a separate dedicated cluster.

## Enabling the Code Executor

The Code Executor is disabled by default. To make it available, set `CODE_EXECUTOR_ENABLED=true` in the CodeMie API environment:

```yaml
extraEnv:
  - name: CODE_EXECUTOR_ENABLED
    value: "true"
```

While disabled, the tool is neither listed in the tools catalog nor executed at runtime.

## Choosing a Deployment Topology

| Topology                              | When to use                           | Isolation                        | RBAC required         |
| ------------------------------------- | ------------------------------------- | -------------------------------- | --------------------- |
| **Same cluster, shared namespace**    | Standard production setup             | Separate pod                     | Yes                   |
| **Same cluster, dedicated namespace** | Namespace-level workload isolation    | Separate pod, separate namespace | Yes (cross-namespace) |
| **Dedicated cluster**                 | Compliance, multi-tenant environments | Full cluster isolation           | No (kubeconfig)       |

## Deployment Topologies

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
        enabled: true
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

:::info
If you cannot manage the existing service account, or need to use a separate one instead of the CodeMie API service account, consider configuring `kubeconfig` credentials as described in the [Dedicated Cluster](#dedicated-cluster) section.
:::

### Dedicated Cluster

**1. Create the executor namespace in the dedicated cluster:**

```bash
kubectl create namespace codemie-runtime
```

**2. Create a kubeconfig secret in the CodeMie API namespace:**

```bash
kubectl create secret generic codemie-executor-kubeconfig \
  --from-file=kubeconfig=<path-to-kubeconfig> \
  --namespace codemie
```

**3. Set in CodeMie API values:**

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

## Applying CodeMie API Settings

The Code Executor is disabled by default, so `CODE_EXECUTOR_ENABLED` must be set to `true` to make the tool available. Tune the remaining Code Executor settings as needed and apply the chart:

```yaml
extraEnv:
  - name: CODE_EXECUTOR_ENABLED
    value: "true"
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

To control how many pods are kept ready, set `replicaCount` in your `codemie-runtime/values.yaml`:

```yaml
replicaCount: 5
```

## Environment Variables Reference

For the full list of available environment variables, see [API Configuration — Code Executor & Python Sandbox](./api-configuration.md#code-executor--python-sandbox).
