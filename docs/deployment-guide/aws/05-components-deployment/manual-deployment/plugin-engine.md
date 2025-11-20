---
id: plugin-engine
sidebar_position: 5
title: Plugin Engine
description: Install NATS and NATS Auth Callout
---

# Plugin Engine Installation

## NATS

To deploy NATS, follow the steps below:

### 1. Create NATS Secrets

Create `codemie-nats-secrets` Kubernetes secret. To set it up, follow these steps to generate and encode the necessary values:

#### NATS_URL

- Since NATS is deployed in the same namespace as the AI/Run CodeMie and NATS Callout services, use the internal URL `nats://codemie-nats:4222`
- Base64 encode this URL before using it in the secret

#### CALLOUT_USERNAME

- Use the username `callout`
- Base64 encode this username before using it in the secret

#### CALLOUT_PASSWORD

- Generate a secure password using the command: `pwgen -s -1 25`
- Base64 encode this password before using it in the secret

#### CALLOUT_BCRYPTED_PASSWORD

- Use the NATS server to generate a bcrypt-hashed password based on the `CALLOUT_PASSWORD`
- Command: `nats server passwd -p <CALLOUT_PASSWORD>`
- Base64 encode the bcrypt-hashed password before using it in the secret

#### CODEMIE_USERNAME

- Use the username `codemie`
- Base64 encode this username before using it in the secret

#### CODEMIE_PASSWORD

- Generate a secure password using the command: `pwgen -s -1 25`
- Base64 encode this password before using it in the secret

#### CODEMIE_BCRYPTED_PASSWORD

- Use the NATS server to generate a bcrypt-hashed password based on the `CODEMIE_PASSWORD`
- Command: `nats server passwd -p <CODEMIE_PASSWORD>`
- Base64 encode the bcrypt-hashed password before using it in the secret

#### ISSUER_NKEY and ISSUER_NSEED

- Use the `nsc` tool to generate NATS account keys
- Reference: https://natsbyexample.com/examples/auth/callout/cli
- Command: `nsc generate nkey --account`
- Base64 encode the NKEY and NSEED before using them in the secret

#### ISSUER_XKEY and ISSUER_XSEED

- Use the `nsc` tool to generate NATS curve keys
- Reference: https://natsbyexample.com/examples/auth/callout/cli
- Command: `nsc generate nkey --curve`
- Base64 encode the XKEY and XSEED before using them in the secret

### Secret Example

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: codemie-nats-secrets
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

:::info Encoding Secrets
Use the following command to encode secret values:

```bash
echo -n 'your-value-here' | base64
```

Or use `kubectl` to create secret directly:

```bash
kubectl -n codemie create secret generic codemie-nats-secrets \
  --from-literal NATS_URL=nats://codemie-nats:4222 \
  --from-literal CALLOUT_USERNAME=callout \
  --from-literal CALLOUT_PASSWORD=<generated-password> \
  # ... add remaining literals
```

:::

### 2. Install NATS Helm Chart

Install `codemie-nats` helm chart in the created namespace, applying custom values file with the command:

```bash
helm repo add nats https://nats-io.github.io/k8s/helm/charts/
helm repo update nats
helm upgrade --install codemie-nats nats/nats --version 1.2.6 \
  --namespace codemie --values ./codemie-nats/values-aws.yaml \
  --wait --timeout 900s
```

:::info TLS Configuration for Plugin Engine
In AWS, if TLS termination for Plugin Engine load balancer is handled by NLB (TLS certificate is on LB itself), then Plugin Engine NATS URL should start with `tls` protocol, for example: `tls://codemie-nats.example.com:30422`, otherwise use `nats://codemie-nats.example.com:30422`
:::

## NATS Auth Callout

:::info Registry Login Required
Before applying `codemie-ui`, `codemie-api`, `codemie-nats-auth-callout`, `codemie-mcp-connect-service`, and `mermaid-server` helm-charts, it's necessary to login into AI/Run CodeMie GCR:

```bash
export GOOGLE_APPLICATION_CREDENTIALS=key.json
gcloud auth application-default print-access-token | helm registry login -u oauth2accesstoken --password-stdin https://europe-west3-docker.pkg.dev
```

:::

To deploy the NATS Auth Callout service, follow the steps below:

Install `codemie-nats-auth-callout` helm chart, applying custom values file with the command:

```bash
helm upgrade --install codemie-nats-auth-callout \
  "oci://europe-west3-docker.pkg.dev/or2-msq-epmd-edp-anthos-t1iylu/helm-charts/codemie-nats-auth-callout" \
  --version "x.y.z" \
  --namespace "codemie" \
  -f "./codemie-nats-auth-callout/values-aws.yaml" \
  --wait --timeout 600s
```

## Next Steps

Proceed to [Core Components](./core-components) installation.
