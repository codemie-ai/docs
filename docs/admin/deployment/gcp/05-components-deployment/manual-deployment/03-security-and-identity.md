---
id: security-and-identity
sidebar_position: 3
title: Security and Identity Components
sidebar_label: Security and Identity
---

# Security and Identity Installation

This guide covers the installation of security components that provide user authentication, authorization, and access control for AI/Run CodeMie.

## Overview

This step installs three critical security components:

- **Keycloak Operator** - Kubernetes operator for managing Keycloak lifecycle
- **Keycloak** - Identity and access management (IAM) server
- **OAuth2 Proxy** - Authentication proxy for web applications

## Keycloak Operator Installation

The Keycloak Operator automates the deployment and management of Keycloak instances in Kubernetes.

### Step 1: Create Security Namespace and Admin Secret

Create the security namespace and Keycloak admin credentials:

```bash
kubectl create namespace security

kubectl -n security create secret generic keycloak-admin \
  --from-literal=username=admin \
  --from-literal=password="$(openssl rand -base64 12)" \
  --type=Opaque \
  --dry-run=client -o yaml | kubectl apply -f -
```

:::tip Retrieve Admin Password
To retrieve the generated admin password later:

```bash
kubectl get secret keycloak-admin -n security -o jsonpath='{.data.password}' | base64 -d
```

:::

### Step 2: Install Keycloak Operator Helm Chart

Deploy the Keycloak Operator using Helm:

```bash
helm upgrade --install keycloak-operator-helm keycloak-operator-helm/. \
  -n security \
  --create-namespace \
  --values keycloak-operator-helm/values.yaml \
  --wait \
  --timeout 900s \
  --dependency-update
```

### Step 3: Verify Keycloak Operator Deployment

Check that the operator is running:

```bash
# Check pod status
kubectl get pods -n security | grep keycloak-operator

# Check operator logs
kubectl logs -n security -l app=keycloak-operator
```

Wait for the operator pod to reach `Running` state before proceeding.

## Keycloak Installation

Keycloak provides identity and access management for user authentication and authorization.

### Step 1: Configure Domain Name

Fill in values in `keycloak-helm/values-gcp.yaml` file by replacing `%%DOMAIN%%` with your domain name, e.g., `example.com`

:::tip Domain Configuration
If you followed the Getting Started steps in the [overview](./), this should already be configured.
:::

### Step 2: Install Keycloak Helm Chart

Deploy Keycloak using Helm:

```bash
helm upgrade --install keycloak keycloak-helm/. \
  -n security \
  --values keycloak-helm/values-gcp.yaml \
  --wait \
  --timeout 900s \
  --dependency-update
```

### Step 3: Verify Keycloak Deployment

Check that Keycloak is running:

```bash
# Check pod status
kubectl get pods -n security | grep keycloak

# Check Keycloak service
kubectl get svc -n security | grep keycloak

# Check Keycloak ingress
kubectl get ingress -n security
```

### Step 4: Access Keycloak Admin Console

Keycloak Admin UI can be accessed by the following URL: `https://keycloak.%%DOMAIN%%/auth/admin`, e.g., `https://keycloak.example.com/auth/admin`

Use the admin credentials created in Step 1 to log in.

## OAuth2 Proxy Installation

OAuth2 Proxy provides authentication middleware that integrates with Keycloak to secure AI/Run CodeMie applications.

### Step 1: Create OAuth2 Proxy Namespace

Create a dedicated namespace for OAuth2 Proxy:

```bash
kubectl create namespace oauth2-proxy
```

### Step 2: Create OAuth2 Proxy Secret

Create the OAuth2 Proxy secret with Keycloak client data:

```bash
kubectl create secret generic oauth2-proxy \
  --namespace=oauth2-proxy \
  --from-literal=client-id='codemie' \
  --from-literal=client-secret="$(openssl rand -base64 12)" \
  --from-literal=cookie-secret=$(dd if=/dev/urandom bs=32 count=1 2>/dev/null | base64 | tr -d -- '\n' | tr -- '+/' '-_' ; echo) \
  --type=Opaque
```

**Secret Example**:

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

:::info Client Secret
The `client-secret` value must match the secret configured in Keycloak for the `codemie` client. You'll need to update this in Keycloak after installation or regenerate and update both.
:::

### Step 3: Copy Keycloak Admin Secret

Copy the Keycloak admin secret to the OAuth2 Proxy namespace:

```bash
kubectl get secret keycloak-admin -n security -o yaml | sed '/namespace:/d' | kubectl apply -n oauth2-proxy -f -
```

### Step 4: Configure Domain Name

Fill in missing values in `oauth2-proxy/values-gcp.yaml` file by replacing `%%DOMAIN%%` with your domain name, e.g., `example.com`

:::tip Domain Configuration
If you followed the Getting Started steps in the [overview](./), this should already be configured.
:::

### Step 5: Install OAuth2 Proxy Helm Chart

Deploy OAuth2 Proxy using Helm:

```bash
helm upgrade --install oauth2-proxy oauth2-proxy/. \
  -n oauth2-proxy \
  --values oauth2-proxy/values-gcp.yaml \
  --wait \
  --timeout 900s \
  --dependency-update
```

### Step 6: Verify OAuth2 Proxy Deployment

Check that OAuth2 Proxy is running:

```bash
# Check pod status
kubectl get pods -n oauth2-proxy

# Check OAuth2 Proxy service
kubectl get svc -n oauth2-proxy

# Check OAuth2 Proxy logs
kubectl logs -n oauth2-proxy -l app=oauth2-proxy
```

## Post-Installation Validation

After completing this step, verify all security components:

```bash
# Check all security namespace pods
kubectl get pods -n security

# Check OAuth2 Proxy namespace
kubectl get pods -n oauth2-proxy

# Verify Keycloak is accessible
curl -k https://keycloak.example.com/auth/
```

All pods should be in `Running` state before proceeding.

## Troubleshooting

### Keycloak Fails to Start

**Symptom**: Keycloak pods remain in `CrashLoopBackOff` or `Error` state

**Solution**:

- Check Keycloak logs: `kubectl logs -n security <keycloak-pod-name>`
- Verify database connectivity (if using external database)
- Check resource limits: `kubectl describe pod -n security <keycloak-pod-name>`
- Ensure admin secret exists: `kubectl get secret keycloak-admin -n security`

### OAuth2 Proxy Authentication Errors

**Symptom**: OAuth2 Proxy fails to authenticate with Keycloak

**Solution**:

- Verify Keycloak is running and accessible
- Check OAuth2 Proxy configuration: `kubectl get configmap -n oauth2-proxy`
- Review OAuth2 Proxy logs: `kubectl logs -n oauth2-proxy <oauth2-proxy-pod-name>`
- Ensure client secret matches Keycloak configuration

### Ingress Not Working

**Symptom**: Cannot access Keycloak via browser

**Solution**:

- Check ingress status: `kubectl get ingress -n security`
- Verify Nginx Ingress Controller is running: `kubectl get pods -n ingress-nginx`
- Check DNS resolution: `nslookup keycloak.example.com`
- Review ingress logs: `kubectl logs -n ingress-nginx <ingress-controller-pod>`

## Next Steps

Once security and identity components are deployed and validated, proceed to **[Plugin Engine](./plugin-engine)** installation to deploy NATS messaging system.
