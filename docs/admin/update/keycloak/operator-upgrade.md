---
id: keycloak-operator-upgrade
sidebar_position: 1
title: Keycloak Operator Upgrade
description: Keycloak Operator upgrade guide
pagination_next: null
pagination_prev: admin/update/update-overview
---

# Keycloak Operator Upgrade

## Upgrade Keycloak Operator from 1.23.0 to 1.32.0

#### Update version number in `keycloak-operator-helm/Chart.yaml` file

| Parameter  | Current Value | New Value |
| ---------- | ------------- | --------- |
| version    | 1.23.0        | 1.32.0    |
| appVersion | 1.23.0        | 1.32.0    |

Ensure web hooks disabled in `keycloak-operator-helm/values.yaml` file

```yaml
keycloak-operator:
  clusterReconciliationEnabled: true
// highlight-next-line
  enableWebhooks: false
```

#### Set `type` in `spec` for `KeycloakClientScope` definitions

In `oauth2-proxy/templates/keycloakclientscope.yaml` set

```yaml
spec:
  description: default scope required for oauth2-proxy
  name: codemie
// highlight-next-line
  type: none
  protocol: openid-connect
  protocolMappers:
    # ... protocol mappers configuration
```

In `oauth2-proxy/templates/keycloakclientscope-profile.yaml` set

```yaml
spec:
  description: default scope required for oauth2-proxy
  name: profile
// highlight-next-line
  type: default
  protocol: openid-connect
  protocolMappers:
    # ... protocol mappers configuration
```

:::warning IMPORTANT
Ensure `keycloak-operator-helm/Chart.lock` file and `keycloak-operator-helm/charts/` directory do not exist before apply changes.
:::
