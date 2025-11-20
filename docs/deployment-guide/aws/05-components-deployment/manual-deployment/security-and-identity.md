---
id: security-and-identity
sidebar_position: 4
title: Security and Identity
description: Install Keycloak and OAuth2 Proxy
---

# Security and Identity Installation

## Keycloak-operator

1. Create namespace and secret:

   ```bash
   kubectl create namespace security

   kubectl -n security create secret generic keycloak-admin \
     --from-literal=username=admin \
     --from-literal=password="$(openssl rand -base64 12)" \
     --type=Opaque \
     --dry-run=client -o yaml | kubectl apply -f -
   ```

2. Install operator:
   ```bash
   helm upgrade --install keycloak-operator-helm keycloak-operator-helm/. \
     -n security \
     --create-namespace \
     --values keycloak-operator-helm/values.yaml \
     --wait --timeout 900s \
     --dependency-update
   ```

## Keycloak

1. Configure domain in `keycloak-helm/values-aws.yaml` (replace `%%DOMAIN%%`)

2. Install Keycloak:
   ```bash
   helm upgrade --install keycloak keycloak-helm/. \
     -n security \
     --values keycloak-helm/values-aws.yaml \
     --wait --timeout 900s \
     --dependency-update
   ```

Access Keycloak at: `https://keycloak.<your-domain>/auth/admin`

## OAuth2 Proxy

1. Create namespace:

   ```bash
   kubectl create namespace oauth2-proxy
   ```

2. Create OAuth2 secret:

   ```bash
   kubectl create secret generic oauth2-proxy \
     --namespace=oauth2-proxy \
     --from-literal=client-id='codemie' \
     --from-literal=client-secret="$(openssl rand -base64 12)" \
     --from-literal=cookie-secret=$(dd if=/dev/urandom bs=32 count=1 2>/dev/null | base64 | tr -d -- '\n' | tr -- '+/' '-_' ; echo) \
     --type=Opaque
   ```

3. Copy Keycloak secret:

   ```bash
   kubectl get secret keycloak-admin -n security -o yaml | sed '/namespace:/d' | kubectl apply -n oauth2-proxy -f -
   ```

4. Configure domain in `oauth2-proxy/values-aws.yaml` (replace `%%DOMAIN%%`)

5. Install OAuth2 Proxy:
   ```bash
   helm upgrade --install oauth2-proxy oauth2-proxy/. \
     -n oauth2-proxy \
     --values oauth2-proxy/values-aws.yaml \
     --wait --timeout 900s \
     --dependency-update
   ```

## Next Steps

Proceed to [Plugin Engine](./plugin-engine) installation.
