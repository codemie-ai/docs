---
id: plugin-engine
sidebar_position: 4
title: Plugin Engine
sidebar_label: Plugin Engine
pagination_next: deployment-guide/azure/components-deployment/manual-deployment/core-components
---

# Plugin Engine Installation

This guide covers the installation of the messaging infrastructure that enables connecting MCP servers and plugins running somewhere else to CodeMie agents.

## Overview

The plugin engine consists of two components:

- **NATS** - High-performance message broker enabling pub/sub and request/reply messaging patterns
- **NATS Auth Callout** - Authentication service that validates NATS connections and enforces authorization policies

## NATS Installation

NATS provides the messaging backbone for CodeMie's plugin system, enabling real-time communication between the core application and distributed plugins.

### Step 1: Create NATS Secrets

Create the `codemie-nats-secrets` secret containing authentication credentials and encryption keys. Follow these steps to generate and encode the necessary values:

#### 1. NATS_URL

Internal service URL for NATS communication:

```bash
NATS_URL="nats://codemie-nats:443"
```

#### 2. Callout User Credentials

Credentials for the NATS Auth Callout service:

```bash
# Username
CALLOUT_USERNAME="callout"

# Generate secure password
CALLOUT_PASSWORD=$(pwgen -s -1 25)

# Generate bcrypt hash (requires nats CLI installed)
CALLOUT_BCRYPTED_PASSWORD=$(nats server passwd -p "$CALLOUT_PASSWORD")
```

#### 3. CodeMie User Credentials

Credentials for CodeMie application to connect to NATS:

```bash
# Username
CODEMIE_USERNAME="codemie"

# Generate secure password
CODEMIE_PASSWORD=$(pwgen -s -1 25)

# Generate bcrypt hash (requires nats CLI installed)
CODEMIE_BCRYPTED_PASSWORD=$(nats server passwd -p "$CODEMIE_PASSWORD")
```

#### 4. NATS Account Keys

Generate NATS account keys for JWT authentication:

```bash
# Generate account NKey (save both outputs)
nsc generate nkey --account
# Output:
# ISSUER_NSEED: SAXXXXX... (private seed, keep secure)
# ISSUER_NKEY: AXXXXX... (public key)
```

Reference: [NATS Auth Callout Example](https://natsbyexample.com/examples/auth/callout/cli)

#### 5. NATS Curve Keys

Generate curve keys for encrypted connections:

```bash
# Generate curve XKey (save both outputs)
nsc generate nkey --curve
# Output:
# ISSUER_XSEED: XSXXXXX... (private seed, keep secure)
# ISSUER_XKEY: XXXXXX... (public key)
```

Reference: [NATS Auth Callout Example](https://natsbyexample.com/examples/auth/callout/cli)

#### 6. Create the Secret

Create the secret using `kubectl` with all generated values:

```bash
kubectl -n codemie create secret generic codemie-nats-secrets \
  --from-literal=NATS_URL="$NATS_URL" \
  --from-literal=CALLOUT_USERNAME="$CALLOUT_USERNAME" \
  --from-literal=CALLOUT_PASSWORD="$CALLOUT_PASSWORD" \
  --from-literal=CALLOUT_BCRYPTED_PASSWORD="$CALLOUT_BCRYPTED_PASSWORD" \
  --from-literal=CODEMIE_USERNAME="$CODEMIE_USERNAME" \
  --from-literal=CODEMIE_PASSWORD="$CODEMIE_PASSWORD" \
  --from-literal=CODEMIE_BCRYPTED_PASSWORD="$CODEMIE_BCRYPTED_PASSWORD" \
  --from-literal=ISSUER_NKEY="<your-nkey>" \
  --from-literal=ISSUER_NSEED="<your-nseed>" \
  --from-literal=ISSUER_XKEY="<your-xkey>" \
  --from-literal=ISSUER_XSEED="<your-xseed>" \
  --type=Opaque
```

:::warning Save Credentials
Save all generated passwords and keys securely. You'll need them for troubleshooting and future operations.
:::

**Alternative: YAML Secret Template**

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: codemie-nats-secrets
  namespace: codemie
type: Opaque
data:
  NATS_URL: <base64-encoded-nats-url>
  CALLOUT_USERNAME: <base64-encoded-callout-username>
  CALLOUT_PASSWORD: <base64-encoded-callout-password>
  CALLOUT_BCRYPTED_PASSWORD: <base64-encoded-callout-bcrypted-password>
  CODEMIE_USERNAME: <base64-encoded-codemie-username>
  CODEMIE_PASSWORD: <base64-encoded-codemie-password>
  CODEMIE_BCRYPTED_PASSWORD: <base64-encoded-codemie-bcrypted-password>
  ISSUER_NKEY: <base64-encoded-issuer-nkey>
  ISSUER_NSEED: <base64-encoded-issuer-nseed>
  ISSUER_XKEY: <base64-encoded-issuer-xkey>
  ISSUER_XSEED: <base64-encoded-issuer-xseed>
```

To encode values: `echo -n 'your-value-here' | base64`

### Step 2: Add NATS Helm Repository

Add the official NATS Helm repository:

```bash
# Add repository
helm repo add nats https://nats-io.github.io/k8s/helm/charts/

# Update repository index
helm repo update nats
```

### Step 3: Install NATS Helm Chart

Deploy NATS using the official Helm chart:

```bash
helm upgrade --install codemie-nats nats/nats \
  --version 1.2.6 \
  --namespace codemie \
  --values ./codemie-nats/values-azure.yaml \
  --wait \
  --timeout 900s
```

**Command Breakdown**:

- `codemie-nats` - Release name
- `nats/nats --version 1.2.6` - Uses NATS official chart version 1.2.6
- `--namespace codemie` - Deploys to codemie namespace
- `--values ./codemie-nats/values-azure.yaml` - Uses Azure-specific configuration

### Step 4: Verify NATS Deployment

Check that NATS is running:

```bash
# Check pod status
kubectl get pods -n codemie | grep nats

# Check NATS service
kubectl get service -n codemie codemie-nats

# Check NATS logs
kubectl logs -n codemie statefulset/codemie-nats --tail=50
```

Expected output:

- NATS pods should be in `Running` state
- Service should show cluster IP assigned
- Logs should indicate successful server startup

## NATS Auth Callout Installation

NATS Auth Callout validates authentication and authorization for NATS connections to CodeMie.

### Step 1: Install NATS Auth Callout Helm Chart

Deploy the NATS Auth Callout service:

```bash
helm upgrade --install codemie-nats-auth-callout \
  oci://europe-west3-docker.pkg.dev/or2-msq-epmd-edp-anthos-t1iylu/helm-charts/codemie-nats-auth-callout \
  --version "x.y.z" \
  --namespace codemie \
  -f ./codemie-nats-auth-callout/values-azure.yaml \
  --wait \
  --timeout 600s
```

**Command Breakdown**:

- `codemie-nats-auth-callout` - Release name
- `oci://europe-west3-docker.pkg.dev/...` - OCI registry URL for CodeMie Helm charts
- `--version "x.y.z"` - Replace with the CodeMie version you're deploying
- `--namespace codemie` - Deploys to codemie namespace
- `-f ./codemie-nats-auth-callout/values-azure.yaml` - Uses Azure-specific configuration

:::tip Version Number
Use the same version number you retrieved in the [Getting Started](./#step-4-get-latest-codemie-version) section.
:::

### Step 2: Verify NATS Auth Callout Deployment

Check that the auth callout service is running:

```bash
# Check pod status
kubectl get pods -n codemie | grep nats-auth-callout

# Check deployment
kubectl get deployment -n codemie codemie-nats-auth-callout

# Check logs
kubectl logs -n codemie deployment/codemie-nats-auth-callout --tail=50
```

Expected output:

- Pod should be in `Running` state
- Deployment should show ready replicas
- Logs should indicate successful connection to NATS

## Post-Installation Validation

After completing plugin engine installation, verify the following:

```bash
# NATS is running
kubectl get pods -n codemie | grep codemie-nats

# NATS Auth Callout is running
kubectl get pods -n codemie | grep nats-auth-callout

# NATS service is available
kubectl get service -n codemie codemie-nats

# NATS secrets exist
kubectl get secret codemie-nats-secrets -n codemie

# Test NATS connectivity (optional)
kubectl run -it --rm nats-test --image=natsio/nats-box:latest --restart=Never -n codemie -- nats context create test --server=nats://codemie-nats:443
```

All checks should return successful results before proceeding.

## Next Steps

Once the plugin engine is configured, proceed to **[Core Components](./core-components)** installation to deploy the main CodeMie application services.
