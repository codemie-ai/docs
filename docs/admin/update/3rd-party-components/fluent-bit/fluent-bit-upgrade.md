---
id: fluent-bit-upgrade
title: Fluent Bit Upgrade
sidebar_label: Fluent Bit
description: Fluent Bit upgrade guide
pagination_prev: admin/update/3rd-party-components/3rd-party-components
pagination_next: null
---

# Fluent Bit Upgrade

This guide describes how to upgrade the Fluent Bit component used by AI/Run CodeMie.

It is based on the manual deployment procedure for the observability stack and focuses on the changes required for an in-place upgrade of an existing installation.

## Upgrade planning checklist

Before proceeding, make sure that:

- you know the currently deployed Fluent Bit chart, application, and image versions
- you have selected the target Fluent Bit and Helm chart versions
- you have reviewed the upstream release notes for breaking changes between your current and target versions
- Elasticsearch is healthy and reachable from Fluent Bit
- you have tested the upgrade in a non-production environment
- you have a rollback plan in case the new version introduces parser, filter, or output incompatibilities

## What typically changes during the upgrade

The exact files depend on your repository layout, but in `codemie-helm-charts` the upgrade usually requires updating the following values:

| File                     | Parameter                              | Description                                                                                |
| ------------------------ | -------------------------------------- | ------------------------------------------------------------------------------------------ |
| `fluent-bit/Chart.yaml`  | `version`                              | Helm chart package version for this local chart; used to version the chart artifact.       |
| `fluent-bit/Chart.yaml`  | `appVersion`                           | Informational application version shown in Helm metadata; does not control upgrade logic.  |
| `fluent-bit/Chart.yaml`  | dependency `fluent-bit.version`        | Version or version range constraint for the dependent upstream `fluent-bit` chart.         |
| `fluent-bit/values.yaml` | `fluent-bit.image.tag`                 | Value override passed to templates to select the Fluent Bit container image tag.           |
| override values files    | environment-specific image or settings | Additional per-environment value overrides merged on top of base values during deployment. |

## Upgrade procedure

### 1. Record the current version

Before making changes, capture the currently deployed version so you can validate the result or roll back if needed.

```bash
helm list -n fluentbit
helm status fluent-bit -n fluentbit
kubectl get pods -n fluentbit -o jsonpath='{range .items[*]}{.metadata.name}{" => "}{range .spec.containers[*]}{.image}{" "}{end}{"\n"}{end}'
```

### 2. Remove old dependency artifacts

Before upgrading, remove the existing lock file and vendored chart package so Helm can resolve the updated dependency version cleanly.

```bash
rm -f fluent-bit/Chart.lock
rm -rf fluent-bit/charts/
```

### 3. Update `fluent-bit/Chart.yaml`

Set the target chart and application versions.

<pre>
  <code className="language-yaml">
{`apiVersion: v2
name: fluent-bit
description: A Helm chart for Fluent-Bit

type: application
version: `}<span style={{ color: 'red' }}>{`<TARGET_CHART_VERSION>`}</span>{`
appVersion: "`}<span style={{ color: 'red' }}>{`<TARGET_APP_VERSION>`}</span>{`"

dependencies:
  - name: fluent-bit
    version: `}<span style={{ color: 'red' }}>{`<TARGET_CHART_VERSION>`}</span>{`
    repository: https://fluent.github.io/helm-charts`}
  </code>
</pre>

Replace the placeholders with the exact versions you want to deploy. In most cases, the dependency version should match the chart version you intend to consume from the upstream Fluent Bit Helm repository.

### 4. Update `fluent-bit/values.yaml`

Set the image tag override so the deployment uses the target Fluent Bit image version:

<pre>
  <code className="language-yaml">
{`fluent-bit:
  testFramework:
    enabled: false

  image:
    tag: `}<span style={{ color: 'red' }}>{`<TARGET_IMAGE_TAG>`}</span>
  </code>
</pre>

### 4. Upgrade the Helm release

Run the upgrade from the root of the `codemie-helm-charts` repository:

```bash
helm upgrade --install fluent-bit fluent-bit/. \
  --namespace fluentbit \
  --values fluent-bit/values.yaml \
  --wait \
  --timeout 900s \
  --dependency-update
```

## Post-upgrade verification

After the upgrade completes, verify the deployment:

```bash
helm list -n fluentbit
helm status fluent-bit -n fluentbit
kubectl get daemonset fluent-bit -n fluentbit
kubectl get pods -n fluentbit
kubectl logs -n fluentbit daemonset/fluent-bit --tail=50
```

Confirm that the running image tag is correct:

```bash
kubectl get pods -n fluentbit -o jsonpath='{range .items[*]}{.metadata.name}{" => "}{range .spec.containers[*]}{.image}{" "}{end}{"\n"}{end}'
```

Validate that new logs continue to arrive in Elasticsearch and that there are no parser or output errors in the Fluent Bit logs.

To verify this end to end, create a test assistant in Codemie and trigger a short interaction so the platform generates fresh application logs and related telemetry.
Then open Kibana and confirm that the new records are visible for the relevant services and that all expected logs and metrics for that interaction are present.

## Notes

- Some upgrades may require additional configuration changes beyond version bumps if upstream defaults changed.
- Kibana or dashboard changes are usually not required unless the upgraded Fluent Bit version changes the shape of indexed records.
