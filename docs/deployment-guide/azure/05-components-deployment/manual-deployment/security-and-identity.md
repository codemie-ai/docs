---
id: security-and-identity
sidebar_position: 3
title: Security and Identity
sidebar_label: Security and Identity
---

# Security and Identity Installation

## Install Keycloak-operator Component

1. Create `security` namespace and `keycloak-admin` secret:

   ```bash
   kubectl create namespace security

   kubectl -n security create secret generic keycloak-admin \
     --from-literal=username=admin \
     --from-literal=password="$(openssl rand -base64 12)" \
     --type=Opaque \
     --dry-run=client -o yaml | kubectl apply -f -
   ```

2. Apply `keycloak-operator` helm chart with the command:

   ```bash
   helm upgrade --install keycloak-operator-helm keycloak-operator-helm/. -n security --create-namespace --values keycloak-operator-helm/values.yaml --wait --timeout 900s --dependency-update
   ```

## Install Keycloak Component

1. Fill in values in values.yaml and apply `keycloak` helm chart with the command:

   ```bash
   helm upgrade --install keycloak keycloak-helm/. -n security --values keycloak-helm/values-azure.yaml  --wait --timeout 900s --dependency-update
   ```

   Keycloak Admin UI can be accessed by the following URL: `https://codemie.private.lab.com/keycloak/admin`, e.g. `https://codemie.example.com/keycloak/admin`

## Install OAuth2 Proxy Component

Authentication middleware that provides secure authentication for the AI/Run CodeMie application by integrating with Keycloak

1. Create Kubernetes namespace, e.g. `oauth2-proxy` with the command:

   ```bash
   kubectl create namespace oauth2-proxy
   ```

2. Create `oauth2-secret` with keycloak client data:

   ```bash
   kubectl create secret generic oauth2-proxy \
   --namespace=oauth2-proxy \
   --from-literal=client-id='codemie' \
   --from-literal=client-secret="$(openssl rand -base64 12)" \
   --from-literal=cookie-secret=$(dd if=/dev/urandom bs=32 count=1 2>/dev/null | base64 | tr -d -- '\n' | tr -- '+/' '-_' ; echo) \
   --type=Opaque
   ```

   Secret example:

   ```yaml
   apiVersion: v1
   kind: Secret
   metadata:
     name: oauth2-proxy
     namespace: oauth2-proxy
   data:
     client-id: <base64-encoded-client-id>
     client-secret: <base64-encoded-client-secret>
     cookie-secret: <base64-encoded-cookie-secret>
   type: Opaque
   ```

3. Copy `keycloak` secret to `oauth2-proxy` namespace:

   ```bash
   kubectl get secret keycloak-admin -n security -o yaml | sed '/namespace:/d' | kubectl apply -n oauth2-proxy -f -
   ```

4. Install `oauth2-proxy` helm chart in created namespace with the command:

   ```bash
   helm upgrade --install oauth2-proxy oauth2-proxy/. -n oauth2-proxy --values oauth2-proxy/values-azure.yaml --wait --timeout 900s --dependency-update
   ```

## Next Steps

Proceed to [Plugin Engine](./plugin-engine) installation.
