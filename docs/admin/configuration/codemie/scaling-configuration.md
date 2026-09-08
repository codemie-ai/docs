---
id: scaling-configuration
title: Scaling and Availability Configuration
sidebar_label: Scaling & Availability
sidebar_position: 6
pagination_prev: admin/configuration/codemie/code-executor-configuration
pagination_next: null
---

# Scaling and Availability Configuration

When CodeMie API is deployed on Kubernetes, the platform provides two built-in mechanisms to control how many pods run and how disruptions to those pods are handled:

- **Horizontal Pod Autoscaler (HPA)** — automatically adjusts the number of running pods up or down based on observed CPU utilization. Use it to handle variable load without manually changing replica counts.
- **Pod Disruption Budget (PDB)** — limits how many pods can be taken down at the same time during voluntary disruptions, such as node draining, cluster upgrades, etc. Use it to keep a minimum level of service available while the underlying infrastructure changes.

Both are disabled by default and can be enabled and tuned through the CodeMie API Helm chart values.

## Horizontal Pod Autoscaler (HPA)

When enabled, the HPA watches the CPU utilization of the CodeMie API pods and scales the number of replicas between a configured minimum and maximum to keep utilization near a target percentage.

### Configuration

Set the `hpa` block in your `values-<cloud>.yaml`:

```yaml
hpa:
  enabled: true
  minReplicas: 1
  maxReplicas: 2
  targetCPUUtilizationPercentage: 70
  scaleUpStabilizationWindowSeconds: 60
  scaleDownStabilizationWindowSeconds: 900
```

| Key                                   | Description                                                                                                                                | Default |
| ------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------ | ------- |
| `enabled`                             | Enables the HorizontalPodAutoscaler for the CodeMie API pods.                                                                              | `false` |
| `minReplicas`                         | Minimum number of pods to keep running, regardless of load.                                                                                | `1`     |
| `maxReplicas`                         | Maximum number of pods the autoscaler is allowed to create.                                                                                | `2`     |
| `targetCPUUtilizationPercentage`      | Target average CPU utilization, as a percentage of the pod's CPU request. Scaling activates when actual usage moves away from this target. | `70`    |
| `scaleUpStabilizationWindowSeconds`   | How long CPU usage must stay above the target before new pods are added. Prevents scaling up on brief spikes.                              | `60`    |
| `scaleDownStabilizationWindowSeconds` | How long CPU usage must stay below the target before pods are removed. Prevents flapping when load is temporarily low.                     | `900`   |

:::info
CPU utilization is measured against the CPU **request** set for the CodeMie API container (see `resources.requests.cpu`), not the limit. Set an appropriate CPU request before enabling the HPA, since it directly determines when scaling triggers.
:::

## Pod Disruption Budget (PDB)

When enabled, the PDB tells Kubernetes how many CodeMie API pods must stay available (or how many can be unavailable) during voluntary disruptions, so a node drain or cluster upgrade doesn't take down the service entirely.

### Configuration

Set the `pdb` block in your `values-<cloud>.yaml`, using **either** `minAvailable` **or** `maxUnavailable` — they are mutually exclusive:

```yaml
pdb:
  enabled: true
  minAvailable: 1
  maxUnavailable: ""
```

| Key              | Description                                                                                                              | Default |
| ---------------- | ------------------------------------------------------------------------------------------------------------------------ | ------- |
| `enabled`        | Enables the PodDisruptionBudget for the CodeMie API pods.                                                                | `false` |
| `minAvailable`   | Minimum number of pods that must remain available during a voluntary disruption.                                         | `1`     |
| `maxUnavailable` | Maximum number of pods that can be unavailable during a voluntary disruption. Leave empty to use `minAvailable` instead. | `""`    |

:::warning
Set only one of `minAvailable` or `maxUnavailable`. If `maxUnavailable` is set, it takes precedence over `minAvailable`.
:::

If `maxReplicas` (HPA) is set close to `minAvailable` (PDB), disruptions can be blocked because Kubernetes cannot evict enough pods to satisfy both constraints at once. Keep some margin between the two when running with a small number of replicas.

## Applying Changes

After updating `hpa` and/or `pdb` in your values file, apply it with Helm:

```bash
helm upgrade codemie-api \
  oci://europe-west3-docker.pkg.dev/or2-msq-epmd-edp-anthos-t1iylu/helm-charts/codemie \
  --version <version> \
  -f codemie-api/values-<cloud>.yaml \
  --namespace codemie
```

Verify the resources were created as expected:

```bash
kubectl get hpa,pdb -n codemie
```
