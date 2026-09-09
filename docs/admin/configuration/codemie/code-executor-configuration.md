---
id: code-executor-configuration
title: Code Executor Configuration
sidebar_label: Code Executor
sidebar_position: 5
---

import Tabs from '@theme/Tabs';
import TabItem from '@theme/TabItem';

# Code Executor Configuration

The Code Executor runs Python code in isolated Kubernetes sandbox pods with enforced resource limits and security policies. Every execution request is dispatched to a sandbox pod, keeping user-supplied code isolated from the CodeMie API.

There are two sandbox modes: **jobs** and **shared**, selected with `CODE_EXECUTOR_SANDBOX_MODE`.

## Sandbox Modes

<Tabs>
<TabItem value="jobs" label="sandbox-jobs (default)" default>

Each execution is submitted as a Kubernetes `Job`. A fresh pod runs the user code and is torn down afterwards.

```yaml
extraEnv:
  - name: CODE_EXECUTOR_SANDBOX_MODE
    value: "sandbox-jobs"
```

</TabItem>
<TabItem value="shared" label="sandbox-shared">

CodeMie API discovers and reuses long-lived pods from a pool, or creates a new one on demand up to `CODE_EXECUTOR_MAX_POD_POOL_SIZE`. The same pod can be reused across many executions.

:::warning Will be deprecated
`sandbox-shared` is no longer supported and not recommended to use in production environments. Switch to `sandbox-jobs`.
:::

```yaml
extraEnv:
  - name: CODE_EXECUTOR_SANDBOX_MODE
    value: "sandbox-shared"
```

</TabItem>
</Tabs>

## Enabling the Code Executor

The Code Executor is disabled by default. To make it available, set `CODE_EXECUTOR_ENABLED=true` in the CodeMie API environment:

```yaml
extraEnv:
  - name: CODE_EXECUTOR_ENABLED
    value: "true"
  - name: CODE_EXECUTOR_DOCKER_IMAGE
    value: "codemie/codemie-python:<codemie-version>"  # must match codemie version
```

While disabled, the tool is neither listed in the tools catalog nor executed at runtime.

## Namespace Configuration

By default, code executor run in a separate namespace from CodeMie API: `codemie-code-executor`. Create it before enabling RBAC:

```bash
kubectl create namespace codemie-code-executor
```

Then set:

```yaml
features:
  tools:
    code_executor:
      rbac:
        enabled: true
        namespace: "codemie-code-executor"

extraEnv:
  - name: CODE_EXECUTOR_NAMESPACE
    value: "codemie-code-executor"
```

`features.tools.code_executor.rbac.namespace` (Helm value) and `CODE_EXECUTOR_NAMESPACE` (env var) **must be set to the same namespace**.

A different namespace than `codemie-code-executor` can also be used — just create it and set both values to match it.

## Applying CodeMie API Settings

```bash
helm upgrade codemie-api \
  oci://europe-west3-docker.pkg.dev/or2-msq-epmd-edp-anthos-t1iylu/helm-charts/codemie \
  --version <version> \
  -f codemie-api/values-<cloud>.yaml \
  --namespace codemie
```

## Environment Variables Reference

For the full list of available environment variables, see [API Configuration — Code Executor & Python Sandbox](./api-configuration.md#code-executor--python-sandbox).

## Legacy Topics

The topics below only apply to niche or deprecated setups. Most deployments can skip this section.

<details>
<summary>Dedicated Cluster via kubeconfig (will be deprecated)</summary>

It is also possible to point Code Executor at a namespace in a different cluster by mounting a `kubeconfig` secret instead of relying on in-cluster RBAC:

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
    value: "codemie-code-executor"
  - name: CODE_EXECUTOR_KUBECONFIG_PATH
    value: "/secrets/kubeconfig"
```

</details>

<details>
<summary>Pre-warming the Pod Pool (sandbox-shared only)</summary>

Pre-warming only applies to the deprecated `sandbox-shared` mode. `sandbox-jobs` always creates a fresh Job pod per execution, so there is no pool to pre-warm.

In `sandbox-shared` mode, CodeMie API creates executor pods on demand by default, and the first execution request waits for a pod to start. To avoid this, deploy the `codemie-code-executor` chart to keep pods running and ready for discovery, into the **same namespace** as `CODE_EXECUTOR_NAMESPACE`:

```bash
helm upgrade --install codemie-code-executor \
  oci://europe-west3-docker.pkg.dev/or2-msq-epmd-edp-anthos-t1iylu/helm-charts/codemie-code-executor \
  --version <version> \
  -f codemie-code-executor/values.yaml \
  --namespace <executor-namespace>
```

To control how many pods are kept ready, set `replicaCount` in your `codemie-code-executor/values.yaml`:

```yaml
replicaCount: 5
```

</details>
