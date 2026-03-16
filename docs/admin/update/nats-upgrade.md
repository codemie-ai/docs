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

## Pre-Upgrade Requirements

**Before proceeding with any upgrade, ensure you have:**

- Planned for potential downtime
- Tested the upgrade process in a non-production environment

## Upgrade Procedure

**Objective: Update the NATS Reloader image to a version without critical vulnerabilities.**

- Add the following reloader image tag to `codemie-nats/values-<CLOUD_NAME>.yaml`

```yaml
  reloader:
    tag: 0.22.3
```

## Enterprise Edition

<EnterpriseFeature />

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

## Troubleshooting

If you encounter issues during the upgrade:

1. Check pod logs for error messages
2. Verify resource availability (CPU, memory, storage)
3. Ensure network connectivity between components
4. Run the [codemie-plugins](https://pypi.org/project/codemie-plugins/) to ensure that you can successfully connect without any issues
