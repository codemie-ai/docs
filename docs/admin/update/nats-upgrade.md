---
id: nats-upgrade
sidebar_position: 1
title: NATS Upgrade
description: NATS upgrade guide
pagination_next: null
pagination_prev: admin/update/update-overview
---

import EnterpriseFeature from '@site/src/components/EnterpriseFeature';

# NATS Upgrade

<EnterpriseFeature />

## Pre-Upgrade Requirements

**Before proceeding with any upgrade, ensure you have:**

- Planned for potential downtime
- Tested the upgrade process in a non-production environment

**Before starting the upgrade**

- Check the list of available chart versions:

```bash
  helm search repo nats/nats --versions
```

:::info

> The Helm chart version and the application version may differ.
> All the component's versions (eg. nats-server-config-reloader) included in the helm chart might be different from **APP VERSION**.
> Always rely on the **Chart version** when determining compatibility and deployment behavior.

:::

| NAME        | CHART VERSION | APP VERSION | DESCRIPTION                                        |
| ----------- | ------------- | ----------- | -------------------------------------------------- |
| `nats/nats` | `2.12.5`      | `2.12.5`    | A Helm chart for the NATS.io High Speed Cloud N... |
| `nats/nats` | `1.3.16`      | `2.11.10`   | A Helm chart for the NATS.io High Speed Cloud N... |

- Once you identify the target chart version, you can inspect the container image tags (nats, nats-server-config-reloader, etc.) used in that release:

```bash
  helm show values nats/nats --version <TARGET_CHART_VERSION> | grep -A 3 image:
```

> This helps verify the underlying images before proceeding with the upgrade.

- If you want to use a custom NATS-Reloader image tag, add the following configuration to the `codemie-nats/values-<CLOUD_NAME>.yaml` file:

```yaml
  reloader:
    tag: 0.22.3
```

## Upgrade Procedure

- Change the NATS version in `helm-charts.sh`

```shell
  helm upgrade --install codemie-nats nats/nats \
    --version <TARGET_CHART_VERSION> \
    --namespace $namespace \
    --values "./codemie-nats/values-<CLOUD_NAME>.yaml" \
    --wait --timeout 900s > /dev/null
```

- Now you have to execute `helm-charts.sh` script or manually run the command above with namespace (`$namespace`) in which CodeMie is deployed

> Replace `<TARGET_CHART_VERSION>` with the desired NATS chart version.

## Post-upgrade verification

After the upgrade completes, verify the deployment:

1. Run the [codemie-plugins](https://pypi.org/project/codemie-plugins/) to ensure that you can successfully connect without any issues
2. Check pod logs for error messages
