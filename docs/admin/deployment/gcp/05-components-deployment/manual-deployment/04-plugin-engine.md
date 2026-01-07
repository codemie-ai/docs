---
id: plugin-engine
sidebar_position: 4
title: Plugin Engine (NATS)
sidebar_label: Plugin Engine
---

# Plugin Engine Installation

This guide covers the installation of the messaging infrastructure that enables inter-service communication and plugin system functionality.

## Overview

This step installs two critical messaging components:

- **NATS** - Lightweight, high-performance message broker
- **NATS Auth Callout** - Authentication and authorization service for NATS

## NATS Installation

NATS provides the messaging backbone for AI/Run CodeMie's plugin system and inter-service communication.

### Step 1: Create CodeMie Namespace

Create the namespace where NATS and core CodeMie components will be deployed:

```bash
kubectl create namespace codemie
```

### Step 2: Create NATS Secrets

Create the `codemie-nats-secrets` Kubernetes secret with all required authentication and encryption keys.

#### Generate Required Values

Follow these steps to generate all necessary values for the secret:

**NATS_URL**

- Since NATS is deployed in the same namespace as AI/Run CodeMie services, use the internal URL: `nats://codemie-nats:4222`
- Base64 encode this URL before using it in the secret

**CALLOUT_USERNAME**

- Use the username `callout`
- Base64 encode this username before using it in the secret

**CALLOUT_PASSWORD**

- Generate a secure password: `pwgen -s -1 25`
- Base64 encode this password before using it in the secret

**CALLOUT_BCRYPTED_PASSWORD**

- Use the NATS server to generate a bcrypt-hashed password based on the `CALLOUT_PASSWORD`
- Command: `nats server passwd -p <CALLOUT_PASSWORD>`
- Base64 encode the bcrypt-hashed password before using it in the secret

**CODEMIE_USERNAME**

- Use the username `codemie`
- Base64 encode this username before using it in the secret

**CODEMIE_PASSWORD**

- Generate a secure password: `pwgen -s -1 25`
- Base64 encode this password before using it in the secret

**CODEMIE_BCRYPTED_PASSWORD**

- Use the NATS server to generate a bcrypt-hashed password based on the `CODEMIE_PASSWORD`
- Command: `nats server passwd -p <CODEMIE_PASSWORD>`
- Base64 encode the bcrypt-hashed password before using it in the secret

**ISSUER_NKEY and ISSUER_NSEED**

- Use the `nsc` tool to generate NATS account keys
- Reference: https://natsbyexample.com/examples/auth/callout/cli
- Command: `nsc generate nkey --account`
- Base64 encode the NKEY and NSEED before using them in the secret

**ISSUER_XKEY and ISSUER_XSEED**

- Use the `nsc` tool to generate NATS curve keys
- Reference: https://natsbyexample.com/examples/auth/callout/cli
- Command: `nsc generate nkey --curve`
- Base64 encode the XKEY and XSEED before using them in the secret

#### Create the Secret

**Secret Example**:

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

:::info Encoding Values
Use the following command to encode values:

```bash
echo -n 'your-value-here' | base64
```

Or create the secret directly using kubectl:

```bash
kubectl -n codemie create secret generic codemie-nats-secrets \
  --from-literal=NATS_URL=nats://codemie-nats:4222 \
  --from-literal=CALLOUT_USERNAME=callout \
  --from-literal=CALLOUT_PASSWORD=<your-password> \
  # ... add all other fields
```

:::

### Step 3: Install NATS Helm Chart

Add the NATS Helm repository and install NATS:

```bash
# Add NATS Helm repository
helm repo add nats https://nats-io.github.io/k8s/helm/charts/
helm repo update nats

# Install NATS
helm upgrade --install codemie-nats nats/nats \
  --version 1.2.6 \
  --namespace codemie \
  --values ./codemie-nats/values-gcp.yaml \
  --wait \
  --timeout 900s
```

**Command Breakdown**:

- `--version 1.2.6` - Specifies the NATS Helm chart version
- `--namespace codemie` - Deploys to the codemie namespace
- `--values ./codemie-nats/values-gcp.yaml` - Uses GCP-specific configuration

### Step 4: Verify NATS Deployment

Check that NATS is running:

```bash
# Check pod status
kubectl get pods -n codemie | grep nats

# Check NATS service
kubectl get svc -n codemie | grep nats

# Check NATS logs
kubectl logs -n codemie <nats-pod-name>
```

:::info Plugin Engine NATS URL
Use plugin engine NATS URL with `nats` protocol, for example: `nats://codemie-nats.example.com:30422`

This URL should be used when configuring external plugin engines or debugging NATS connectivity.
:::

## NATS Auth Callout Installation

The NATS Auth Callout service provides authentication and authorization for NATS connections.

### Step 1: Authenticate to Container Registry

Before deploying NATS Auth Callout, authenticate to the AI/Run CodeMie container registry:

```bash
export GOOGLE_APPLICATION_CREDENTIALS=key.json
gcloud auth application-default print-access-token | \
  helm registry login -u oauth2accesstoken --password-stdin europe-west3-docker.pkg.dev
```

:::tip Registry Authentication
This step is required for all AI/Run CodeMie proprietary components: `codemie-ui`, `codemie-api`, `codemie-nats-auth-callout`, `codemie-mcp-connect-service`, and `mermaid-server`.

If you already authenticated during the Getting Started steps, you can skip this.
:::

### Step 2: Install NATS Auth Callout Helm Chart

Deploy the NATS Auth Callout service:

```bash
helm upgrade --install codemie-nats-auth-callout \
  "oci://europe-west3-docker.pkg.dev/or2-msq-epmd-edp-anthos-t1iylu/helm-charts/codemie-nats-auth-callout" \
  --version "x.y.z" \
  --namespace "codemie" \
  -f "./codemie-nats-auth-callout/values-gcp.yaml" \
  --wait \
  --timeout 600s
```

Replace `x.y.z` with the version identified in the Getting Started steps.

### Step 3: Verify NATS Auth Callout Deployment

Check that the NATS Auth Callout service is running:

```bash
# Check pod status
kubectl get pods -n codemie | grep nats-auth-callout

# Check service logs
kubectl logs -n codemie -l app=codemie-nats-auth-callout

# Test NATS connectivity (from a test pod)
kubectl run -it --rm nats-test --image=natsio/nats-box --restart=Never -- nats pub test "hello"
```

## Post-Installation Validation

After completing this step, verify the messaging infrastructure:

```bash
# Check all NATS-related pods
kubectl get pods -n codemie | grep nats

# Check NATS service endpoints
kubectl get svc -n codemie | grep nats

# Verify secrets exist
kubectl get secret codemie-nats-secrets -n codemie
```

All NATS pods should be in `Running` state before proceeding.

## Troubleshooting

### NATS Pod Not Starting

**Symptom**: NATS pod remains in `CrashLoopBackOff` or `Error` state

**Solution**:

- Check NATS logs: `kubectl logs -n codemie <nats-pod-name>`
- Verify secret exists and is valid: `kubectl get secret codemie-nats-secrets -n codemie`
- Check configuration: `kubectl get configmap -n codemie`
- Review NATS values file: `cat codemie-nats/values-gcp.yaml`

### NATS Auth Callout Connection Errors

**Symptom**: NATS Auth Callout fails to connect to NATS

**Solution**:

- Verify NATS is running: `kubectl get pods -n codemie | grep nats`
- Check NATS service: `kubectl get svc -n codemie codemie-nats`
- Review auth callout logs: `kubectl logs -n codemie -l app=codemie-nats-auth-callout`
- Verify credentials in secret match NATS configuration

### Image Pull Errors

**Symptom**: NATS Auth Callout pod stuck in `ImagePullBackOff`

**Solution**:

- Verify registry authentication: Re-run authentication command from Step 1
- Check pull secret exists: `kubectl get secret gcp-artifact-registry -n codemie`
- Verify network connectivity to `europe-west3-docker.pkg.dev`

## Next Steps

Once the plugin engine is deployed and validated, proceed to **[Core Components](./core-components)** installation to deploy the main AI/Run CodeMie services.
