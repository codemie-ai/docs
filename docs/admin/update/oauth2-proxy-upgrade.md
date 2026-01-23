---
id: oauth2-proxy-upgrade
sidebar_position: 1
title: OAuth2 Proxy Upgrade
description: OAuth2 Proxy upgrade guide
pagination_next: null
pagination_prev: admin/update/update-overview
---

# OAuth2 Proxy Upgrade

## Pre-Upgrade Requirements

**Before proceeding with any upgrade, ensure you have:**

- Planned for potential downtime
- Considered all user sessions will be terminated that increase requests count to Keycloak instance
- Tested the upgrade process in a non-production environment

## Upgrade Procedure

- Delete the file `oauth2-proxy/Chart.lock` if present and the directory `oauth2-proxy/charts/` recursively.
- Make changes in `oauth2-proxy/Chart.yaml` and `oauth2-proxy/values-<CLOUD_NAME>.yaml` files accordingly to desired version.
- Apply changes by running `helm-charts.sh` script or manually using the following command:

```shell
helm upgrade --install oauth2-proxy oauth2-proxy/. \
  --namespace oauth2-proxy \
  --values oauth2-proxy/values-<CLOUD_NAME>.yaml \
  --wait \
  --timeout 900s \
  --dependency-update
```

## Upgrade from 7.13.0 to 7.14.2

Update `oauth2-proxy/Chart.yaml`:

```yaml
apiVersion: v2
name: oauth2-proxy
description: A Helm chart for Oauth2 Stack

version: 10.1.0
appVersion: 7.14.2

dependencies:
- name: oauth2-proxy
  version: 10.1.0
  repository: https://oauth2-proxy.github.io/manifests
```

Update `oauth2-proxy/values-<CLOUD_NAME>.yaml` file by adding image tag definition:

```yaml
oauth2-proxy:
  image:
    tag: "v7.14.2"
```

## Upgrade from 7.6.0 to 7.13.0

Update `oauth2-proxy/Chart.yaml` file by setting the new version of the chart:

```yaml
apiVersion: v2
name: oauth2-proxy
description: A Helm chart for Oauth2 Stack

version: 10.1.0
appVersion: 7.13.0

dependencies:
- name: oauth2-proxy
  version: 10.1.0
  repository: https://oauth2-proxy.github.io/manifests
```
