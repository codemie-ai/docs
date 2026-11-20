---
id: keycloak-operator-upgrade
sidebar_position: 1
title: Keycloak Operator Upgrade
description: Keycloak Operator upgrade guide
pagination_next: null
pagination_prev: admin/update/3rd-party-components/keycloak/keycloak
---

# Keycloak Operator Upgrade

## Upgrade Keycloak Operator from 1.35.0 to 1.36.0

Keycloak Operator 1.36.0 no longer rewrites client scope protocol mappers on every reconcile. Verified with Keycloak 26.5.7 and 26.8.2.

:::warning IMPORTANT
Review the [Keycloak Operator 1.36.0 release notes](https://github.com/epam/edp-keycloak-operator/releases/tag/v1.36.0) if the cluster has custom Keycloak resources. The CodeMie Helm charts do not use the fields with breaking changes.
:::

#### Update version number in `keycloak-operator-helm/Chart.yaml` file

| Parameter              | Current Value | New Value |
| ---------------------- | ------------- | --------- |
| version                | 1.35.0        | 1.36.0    |
| appVersion             | 1.35.0        | 1.36.0    |
| dependencies[].version | 1.35.0        | 1.36.0    |

#### Update Custom Resource definitions

:::note
Applicable for existing deployments only.
:::

Helm does not update CRDs on upgrade, and 1.36.0 changes all of them. Apply the CRDs shipped in the chart:

```shell
kubectl apply --server-side --force-conflicts -f keycloak-operator-helm/crds/1.36.0/
```

:::warning IMPORTANT
Ensure `keycloak-operator-helm/Chart.lock` file and `keycloak-operator-helm/charts/` directory do not exist before apply changes.
:::

#### Verification

```shell
kubectl -n security logs deploy/keycloak-operator | grep -m1 'Starting the Keycloak Operator'
```

The output shows `"version": "1.36.0"`.

## Upgrade Keycloak Operator from 1.32.0 to 1.35.0

#### Update version number in `keycloak-operator-helm/Chart.yaml` file

| Parameter  | Current Value | New Value |
| ---------- | ------------- | --------- |
| version    | 1.32.0        | 1.35.0    |
| appVersion | 1.32.0        | 1.35.0    |

#### Update Custom Resource definitions

:::note
Applicable for existing deployments only.
:::

```shell
for crd_file in keycloak-operator-helm/crds/*.yaml; do
    kubectl apply -f "$crd_file"
done
```

:::warning IMPORTANT
Ensure `keycloak-operator-helm/Chart.lock` file and `keycloak-operator-helm/charts/` directory do not exist before apply changes.
:::

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
