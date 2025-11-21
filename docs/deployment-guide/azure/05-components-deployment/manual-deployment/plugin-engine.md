---
id: plugin-engine
sidebar_position: 4
title: Plugin Engine
sidebar_label: Plugin Engine
---

# Plugin Engine Installation

## Install AI/Run CodeMie NATS Component

To deploy a NATS, follow the steps below:

1. Create `codemie-nats-secrets` Kubernetes secret. To set up it, follow these steps to generate and encode the necessary values:

   1. **NATS_URL**
      - Since NATS is deployed in the same namespace as the AI/Run CodeMie and NATS Callout services, use the internal URL `nats://codemie-nats:443`
      - Base64 encode this URL before using it in the secret.

   2. **CALLOUT_USERNAME**
      - Use the username `callout`.
      - Base64 encode this username before using it in the secret.

   3. **CALLOUT_PASSWORD**
      - Generate a secure password using the command: `pwgen -s -1 25`.
      - Base64 encode this password before using it in the secret.

   4. **CALLOUT_BCRYPTED_PASSWORD**
      - Use the NATS server to generate a bcrypt-hashed password based on the `CALLOUT_PASSWORD`.
      - Command: `nats server passwd -p <CALLOUT_PASSWORD>`
      - Base64 encode the bcrypt-hashed password before using it in the secret.

   5. **CODEMIE_USERNAME**
      - Use the username `codemie`.
      - Base64 encode this username before using it in the secret.

   6. **CODEMIE_PASSWORD**
      - Generate a secure password using the command: `pwgen -s -1 25`.
      - Base64 encode this password before using it in the secret.

   7. **CODEMIE_BCRYPTED_PASSWORD**
      - Use the NATS server to generate a bcrypt-hashed password based on the `CODEMIE_PASSWORD`.
      - Command: `nats server passwd -p <CODEMIE_PASSWORD>`
      - Base64 encode the bcrypt-hashed password before using it in the secret.

   8. **ISSUER_NKEY and ISSUER_NSEED**
      - Use the `nsc` tool to generate NATS account keys. For example: https://natsbyexample.com/examples/auth/callout/cli
      - Command: `nsc generate nkey --account`
      - Base64 encode the NKEY and NSEED before using them in the secret.

   9. **ISSUER_XKEY and ISSUER_XSEED**
      - Use the `nsc` tool to generate NATS curve keys. For example: https://natsbyexample.com/examples/auth/callout/cli
      - Command: `nsc generate nkey --curve`
      - Base64 encode the XKEY and XSEED before using them in the secret.

   Secret example:

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

   :::info
   Use the following command `echo -n 'your-value-here' | base64` to encode secret or use `kubectl` to create secret from (i.e. `kubectl -n codemie create secret generic --from-literal NATS_URL=nats://codemie-nats:443 --from-literal CALLOUT_USERNAME=callout ...`)
   :::

2. Install `codemie-nats` helm chart in created namespace, applying custom values file with the command:

   ```bash
   helm repo add nats https://nats-io.github.io/k8s/helm/charts/
   helm repo update nats
   helm upgrade --install codemie-nats nats/nats --version 1.2.6 \
   --namespace codemie --values ./codemie-nats/values-azure.yaml \
   --wait --timeout 900s
   ```

## Install AI/Run CodeMie NATS Auth Callout Component

:::info
Before applying `codemie-ui`, `codemie-api`, `codemie-nats-auth-callout`, `codemie-mcp-connect-service` and `mermaid-server` helm-charts, it's necessary to login into AI/Run CodeMie GCR:

```bash
export GOOGLE_APPLICATION_CREDENTIALS=key.json
gcloud auth application-default print-access-token | helm registry login -u oauth2accesstoken --password-stdin https://europe-west3-docker.pkg.dev
```
:::

To deploy a NATS Auth Callout service, follow the steps below:

1. Install `codemie-nats-auth-callout` helm chart, applying custom values file with the command:

   ```bash
   helm upgrade --install codemie-nats-auth-callout \
   "oci://europe-west3-docker.pkg.dev/or2-msq-epmd-edp-anthos-t1iylu/helm-charts/codemie-nats-auth-callout" \
   --version "x.y.z" \
   --namespace "codemie" \
   -f "./codemie-nats-auth-callout/values-azure.yaml" \
   --wait --timeout 600s
   ```

## Next Steps

Proceed to [Core Components](./core-components) installation.
