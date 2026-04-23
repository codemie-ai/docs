---
id: keycloak-theme-setup
sidebar_position: 9
title: Keycloak Theme Setup
description: Apply the CodeMie login theme to an existing Keycloak deployment
pagination_prev: admin/update/update-overview
pagination_next: null
---

# Keycloak Theme Setup

This guide applies the CodeMie login theme to an existing Keycloak deployment.

:::info
For new installations, the theme is configured automatically. This guide is only required for environments deployed before the theme was introduced.
:::

## Prerequisites

- `kubectl` access to the cluster
- `helm` with access to the `codemie-helm-charts` repository

## Step 1: Upgrade the Keycloak Helm Chart

```bash
helm upgrade --install keycloak keycloak-helm/. \
  -n security \
  --values keycloak-helm/values-<cloud_name>.yaml \
  --wait \
  --timeout 900s \
  --dependency-update
```

Verify the theme JAR was copied:

```bash
kubectl exec -n security keycloakx-0 -- ls /opt/keycloak/providers/
# Expected: keycloak-theme-codemie.jar
```

## Step 2: Upgrade the OAuth2 Proxy Helm Chart

```bash
helm upgrade --install oauth2-proxy oauth2-proxy/. \
  -n oauth2-proxy \
  --values oauth2-proxy/values-<cloud_name>.yaml \
  --wait \
  --timeout 900s \
  --dependency-update
```

Verify the theme was applied to the realm:

```bash
kubectl get keycloakrealm codemie-prod -n oauth2-proxy -o jsonpath='{.spec.themes}'
# Expected: {"loginTheme":"codemie"}
```

## Step 3: Verify

Open the Keycloak login page in the browser. The CodeMie branding should be visible instead of the default Keycloak theme.
