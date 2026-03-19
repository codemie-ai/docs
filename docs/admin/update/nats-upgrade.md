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

## Enterprise Edition

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

- Once you identify the target version, you can inspect which container image tags are used by that release:

```bash
  helm show values nats/nats --version <TARGET_CHART_VERSION> | grep -A 3 image:
```

> This helps verify the underlying images before proceeding with the upgrade.

- If you want to use a custom NATS-Reloader image tag, add the following to `codemie-nats/values-<CLOUD_NAME>.yaml`:

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

- Apply changes by running `helm-charts.sh` script or manually using the following command:

```shell
  helm upgrade --install codemie-nats nats/nats
    --version <TARGET_CHART_VERSION> \
    --namespace codemie \
    --values ./codemie-nats/values-<CLOUD_NAME>.yaml \
    --wait --timeout 900s
```

> Replace `<TARGET_CHART_VERSION>` with the desired NATS chart version.

## Post-upgrade verification

After the upgrade completes, verify the deployment:

1. Check pod logs for error messages
2. Ensure network connectivity between components
3. Run the [codemie-plugins](https://pypi.org/project/codemie-plugins/) to ensure that you can successfully connect without any issues
