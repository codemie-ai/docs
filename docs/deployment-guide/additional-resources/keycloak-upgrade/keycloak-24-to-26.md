---
id: keycloak-24-to-26
sidebar_position: 8
title: Keycloak Upgrade 24.0.4 → 26.4.5
description: Upgrade Keycloak from 24.0.4 to 26.4.5
---

# Upgrade Keycloak from 24.0.4 to 26.4.5

The full description of Keycloak migration changes available [here](https://www.keycloak.org/docs/latest/upgrading/index.html#migration-changes).

## Changes for `keycloak-helm/Chart.yaml`

| Parameter              | Current Value | New Value |
| ---------------------- | ------------- | --------- |
| version                | 2.3.0         | 7.1.5     |
| appVersion             | 24.0.4        | 26.4.5    |
| dependencies[].version | 2.3.0         | 7.1.5     |

## Changes for `keycloak-helm/values-<cloud_name>.yaml`

:::warning IMPORTANT
Keycloak deployment values for version 24.0.4 contains hardcoded version definition which needs to be removed to use the version defined by Helm chart.
:::

### Settings to be removed

```yaml
keycloakx.image.tag: '24.0.4'
```

### Settings to be changed

| Parameter            | Current Value | New Value  |
| -------------------- | :-----------: | :--------: |
| keycloakx.proxy.mode |     edge      | xforwarded |

### Environment variables changes `keycloakx.extraEnv[]`

| Variable Name                   |   Current Value   |         New Value         | Comment                                                             |
| ------------------------------- | :---------------: | :-----------------------: | ------------------------------------------------------------------- |
| KC_HOSTNAME                     | keycloak.fqdn.com | https://keycloak.fqdn.com | Value can be domain name or URL                                     |
| KC_HOSTNAME_ADMIN               |       UNSET       | https://keycloak.fqdn.com | New variable. The URL to access admin console                       |
| KC_HOSTNAME_STRICT_HTTPS        |       false       |           UNSET           | Not longer supported                                                |
| KC_HOSTNAME_BACKCHANNEL_DYNAMIC |       UNSET       |           true            | New variable. Allows clients to access Keycloak by backchannel link |
| HTTP_ADDRESS_FORWARDING         |       true        |           UNSET           | Not longer supported                                                |
| PROXY_ADDRESS_FORWARDING        |       true        |           UNSET           | Not longer supported                                                |

### Environment variables renamed `keycloakx.extraEnv[]`

No value changes required.

| Current Name            | New Name                    |
| ----------------------- | --------------------------- |
| KEYCLOAK_ADMIN          | KC_BOOTSTRAP_ADMIN_USERNAME |
| KEYCLOAK_ADMIN_PASSWORD | KC_BOOTSTRAP_ADMIN_PASSWORD |
