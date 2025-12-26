---
id: security-and-identity
sidebar_position: 3
title: Security and Identity
sidebar_label: Security and Identity
pagination_next: admin/deployment/azure/components-deployment/manual-deployment/plugin-engine
---

# Security and Identity Installation

This guide covers the installation of authentication and authorization components that provide secure access control for AI/Run CodeMie.

## Overview

The security layer consists of three components:

- **Keycloak Operator** - Kubernetes operator for managing Keycloak lifecycle
- **Keycloak** - Identity and access management (IAM) system providing authentication, authorization, and user management
- **OAuth2 Proxy** - Authentication proxy that secures application endpoints by integrating with Keycloak

:::info Installation Order
These components must be installed in the order presented. Keycloak requires the operator, and OAuth2 Proxy requires Keycloak to be running.
:::

## Keycloak Operator Installation

The Keycloak Operator manages the Keycloak deployment lifecycle, handling updates, scaling, and configuration management.

### Step 1: Create Security Namespace and Admin Secret

Create a dedicated namespace for security components and generate Keycloak admin credentials:

```bash
# Create namespace
kubectl create namespace security

# Create admin secret with random password
kubectl -n security create secret generic keycloak-admin \
  --from-literal=username=admin \
  --from-literal=password="$(openssl rand -base64 12)" \
  --type=Opaque \
  --dry-run=client -o yaml | kubectl apply -f -
```

**Command Breakdown**:

- `--from-literal=username=admin` - Sets Keycloak admin username
- `--from-literal=password="$(openssl rand -base64 12)"` - Generates random 12-character password
- `--dry-run=client -o yaml` - Creates YAML without applying
- `kubectl apply -f -` - Applies the generated secret (idempotent)

:::tip Retrieve Admin Password
Save the admin password for later use: `kubectl get secret keycloak-admin -n security -o jsonpath='{.data.password}' | base64 -d`
:::

### Step 2: Install Keycloak Operator Helm Chart

Deploy the Keycloak Operator:

```bash
helm upgrade --install keycloak-operator-helm keycloak-operator-helm/. \
  -n security \
  --create-namespace \
  --values keycloak-operator-helm/values.yaml \
  --wait \
  --timeout 900s \
  --dependency-update
```

**Command Breakdown**:

- `keycloak-operator-helm` - Release name
- `-n security` - Deploys to the security namespace
- `--create-namespace` - Creates namespace if it doesn't exist
- `--values keycloak-operator-helm/values.yaml` - Uses operator-specific configuration

### Step 3: Verify Keycloak Operator Deployment

Check that the operator is running:

```bash
# Check pod status
kubectl get pods -n security

# Check operator logs
kubectl logs -n security deployment/keycloak-operator --tail=50
```

Expected output:

- Operator pod should be in `Running` state
- Logs should indicate successful controller startup

## Keycloak Installation

Keycloak provides centralized authentication and user management for AI/Run CodeMie.

### Step 1: Install Keycloak Helm Chart

Deploy Keycloak using Helm:

```bash
helm upgrade --install keycloak keycloak-helm/. \
  -n security \
  --values keycloak-helm/values-azure.yaml \
  --wait \
  --timeout 900s \
  --dependency-update
```

**Command Breakdown**:

- `keycloak` - Release name
- `-n security` - Deploys to the security namespace
- `--values keycloak-helm/values-azure.yaml` - Uses Azure-specific configuration including PostgreSQL connection

### Step 2: Verify Keycloak Deployment

Check that Keycloak is running:

```bash
# Check Keycloak custom resource
kubectl get keycloak -n security

# Check Keycloak pods
kubectl get pods -n security | grep keycloak

# Check Keycloak logs
kubectl logs -n security deployment/keycloak --tail=50
```

Expected output:

- Keycloak custom resource should show `Ready` status
- Keycloak pods should be in `Running` state
- Logs should indicate successful startup

### Step 3: Access Keycloak Admin Console

Keycloak Admin UI can be accessed at:

```
https://<your-domain>/keycloak/admin
```

**Example URLs**:

- `https://codemie.example.com/keycloak/admin`

**Login Credentials**:

- Username: `admin`
- Password: Retrieved from secret (Step 1 of Keycloak Operator section)

:::tip First Login
You may need to wait 1-2 minutes after deployment for Keycloak to be fully ready. If the admin console is not immediately accessible, wait and try again.
:::

## OAuth2 Proxy Installation

OAuth2 Proxy acts as an authentication middleware, securing access to CodeMie applications by validating user sessions with Keycloak.

### Step 1: Create OAuth2 Proxy Namespace

Create a dedicated namespace:

```bash
kubectl create namespace oauth2-proxy
```

### Step 2: Create OAuth2 Proxy Secret

Generate OAuth2 Proxy credentials and secrets:

```bash
kubectl create secret generic oauth2-proxy \
  --namespace=oauth2-proxy \
  --from-literal=client-id='codemie' \
  --from-literal=client-secret="$(openssl rand -base64 12)" \
  --from-literal=cookie-secret=$(dd if=/dev/urandom bs=32 count=1 2>/dev/null | base64 | tr -d -- '\n' | tr -- '+/' '-_' ; echo) \
  --type=Opaque
```

**Command Breakdown**:

- `client-id='codemie'` - OAuth2 client ID matching Keycloak configuration
- `client-secret="$(openssl rand -base64 12)"` - Generates random client secret
- `cookie-secret=$(...)` - Generates URL-safe base64-encoded 32-byte secret for cookie encryption

**Secret Structure**:

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: oauth2-proxy
  namespace: oauth2-proxy
type: Opaque
data:
  client-id: <base64-encoded-client-id>
  client-secret: <base64-encoded-client-secret>
  cookie-secret: <base64-encoded-cookie-secret>
```

:::tip Save Client Secret
Save the client secret for Keycloak configuration: `kubectl get secret oauth2-proxy -n oauth2-proxy -o jsonpath='{.data.client-secret}' | base64 -d`
:::

### Step 3: Copy Keycloak Admin Secret

OAuth2 Proxy needs Keycloak admin credentials for setup. Copy the secret:

```bash
kubectl get secret keycloak-admin -n security -o yaml | \
  sed '/namespace:/d' | \
  kubectl apply -n oauth2-proxy -f -
```

**Command Breakdown**:

- `kubectl get secret keycloak-admin -n security -o yaml` - Exports secret as YAML
- `sed '/namespace:/d'` - Removes namespace field to allow cross-namespace copy
- `kubectl apply -n oauth2-proxy -f -` - Applies to oauth2-proxy namespace

### Step 4: Install OAuth2 Proxy Helm Chart

Deploy OAuth2 Proxy:

```bash
helm upgrade --install oauth2-proxy oauth2-proxy/. \
  -n oauth2-proxy \
  --values oauth2-proxy/values-azure.yaml \
  --wait \
  --timeout 900s \
  --dependency-update
```

**Command Breakdown**:

- `oauth2-proxy` - Release name
- `-n oauth2-proxy` - Deploys to the oauth2-proxy namespace
- `--values oauth2-proxy/values-azure.yaml` - Uses Azure-specific configuration

### Step 5: Verify OAuth2 Proxy Deployment

Check that OAuth2 Proxy is running:

```bash
# Check pod status
kubectl get pods -n oauth2-proxy

# Check service
kubectl get service -n oauth2-proxy

# Check logs
kubectl logs -n oauth2-proxy deployment/oauth2-proxy --tail=50
```

Expected output:

- OAuth2 Proxy pod should be in `Running` state
- Service should be available
- Logs should show successful connection to Keycloak

## Post-Installation Validation

After completing all security component installations, verify the following:

```bash
# Keycloak Operator is running
kubectl get pods -n security | grep keycloak-operator

# Keycloak is running
kubectl get keycloak -n security
kubectl get pods -n security | grep keycloak

# OAuth2 Proxy is running
kubectl get pods -n oauth2-proxy | grep Running

# All secrets exist
kubectl get secret keycloak-admin -n security
kubectl get secret oauth2-proxy -n oauth2-proxy
```

All checks should return successful results before proceeding.

## Next Steps

Once security and identity components are configured, proceed to **[Plugin Engine](./plugin-engine)** installation to deploy NATS messaging infrastructure.
