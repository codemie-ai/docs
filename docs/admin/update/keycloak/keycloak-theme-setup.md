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
- Keycloak 26 or above

## Step 1: Update Values File

In `keycloak-helm/values-<cloud_name>.yaml`, ensure the `extraInitContainers`, `extraVolumeMounts`, and `extraVolumes` blocks are present and uncommented:

```yaml
extraInitContainers: |
  - name: theme-provider
    image: codemie/codemie-keycloak-theme:2.15.2
    imagePullPolicy: IfNotPresent
    command:
      - sh
    args:
      - -c
      - |
        echo "Copying theme..."
        cp -R /opt/keycloak-theme/* /keycloak-theme
    volumeMounts:
      - name: theme
        mountPath: /keycloak-theme

extraVolumeMounts: |
  - name: theme
    mountPath: /opt/keycloak/providers/

extraVolumes: |
  - name: theme
    emptyDir: {}
```

## Step 2: Upgrade the Keycloak Helm Chart

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

## Step 3: Update OAuth2 Proxy KeycloakRealm Template

In `oauth2-proxy/templates/keycloakrealm.yaml`, add the `themes` block to the spec:

```yaml
spec:
  keycloakRef:
    kind: Keycloak
    name: keycloak
  realmName: codemie-prod
  # highlight-start
  themes:
    loginTheme: codemie
  # highlight-end
```

## Step 4: Upgrade the OAuth2 Proxy Helm Chart

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

## Step 5: Verify

Open the CodeMie at `https://codemie.<your-domain>` — it will redirect to the Keycloak login page. The CodeMie branding should be visible instead of the default Keycloak theme.

:::tip
You can also verify via Keycloak Admin Console at `https://keycloak.<your-domain>/auth/admin/`: switch to the `codemie-prod` realm, then go to **Realm Settings → Themes → Login Theme** — it should show `codemie`.
:::
