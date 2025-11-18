---
sidebar_position: 2
title: Manual Deployment
description: Manual step-by-step component installation
---

# Manual Components Installation

Use this guide to manually install AI/Run CodeMie components one by one.

:::info
Manual steps are not mandatory if you chose the automated `helm-charts.sh` script.
:::

## Component Installation Order

This guide covers installation of the following components in order:

1. **Storage and Ingress** (if needed)
   - AWS gp3 Storage Class
   - Nginx Ingress Controller

2. **Data Layer**
   - Elasticsearch
   - Kibana
   - Postgres-operator
   - PostgreSQL

3. **Security and Identity**
   - Keycloak-operator
   - Keycloak
   - OAuth2 Proxy

4. **Messaging**
   - NATS
   - NATS Auth Callout

5. **AI/Run CodeMie Core**
   - CodeMie API
   - CodeMie UI
   - MCP Connect
   - Mermaid Server

6. **Observability** (optional)
   - Fluentbit
   - Kibana Dashboards

## Prerequisites Setup

### Container Registry Access

Before deploying AI/Run CodeMie components, set up pull secrets:

1. Obtain `key.json` file from AI/Run CodeMie team

2. Create the `codemie` namespace:

   ```bash
   kubectl create namespace codemie
   ```

3. Configure the secret:

   ```bash
   kubectl create secret docker-registry gcp-artifact-registry \
     --docker-server=https://europe-west3-docker.pkg.dev \
     --docker-email=gsa-%%PROJECT_NAME%%-to-gcr@or2-msq-epmd-edp-anthos-t1iylu.iam.gserviceaccount.com \
     --docker-username=_json_key \
     --docker-password="$(cat key.json)" \
     -n codemie
   ```

4. Reference the secret in deployments:
   ```yaml
   imagePullSecrets:
     - name: gcp-artifact-registry
   ```

### Container Registry Login

Login to AI/Run CodeMie container registry:

```bash
export GOOGLE_APPLICATION_CREDENTIALS=key.json
gcloud auth application-default print-access-token | helm registry login -u oauth2accesstoken --password-stdin https://europe-west3-docker.pkg.dev
```

## Storage and Ingress Setup

### AWS gp3 Storage Class

Install only if your EKS cluster does not have AWS gp3 storage class:

```bash
kubectl apply -f storage-class/storageclass-aws-gp3.yaml
```

### Nginx Ingress Controller

Install only if your EKS cluster does not have Nginx Ingress Controller:

1. Create namespace:

   ```bash
   kubectl create namespace ingress-nginx
   ```

2. Install Nginx Ingress:
   ```bash
   helm upgrade --install ingress-nginx ingress-nginx/. \
     -n ingress-nginx \
     --values ingress-nginx/values-aws.yaml \
     --wait --timeout 900s \
     --dependency-update
   ```

## Data Layer Installation

### Elasticsearch

1. Create namespace:

   ```bash
   kubectl create namespace elastic
   ```

2. Create credentials secret:

   ```bash
   kubectl -n elastic create secret generic elasticsearch-master-credentials \
     --from-literal=username=elastic \
     --from-literal=password="$(openssl rand -base64 12)" \
     --type=Opaque \
     --dry-run=client -o yaml | kubectl apply -f -
   ```

3. Install Elasticsearch:
   ```bash
   helm upgrade --install elastic elasticsearch/. \
     -n elastic \
     --values elasticsearch/values-aws.yaml \
     --wait --timeout 900s \
     --dependency-update
   ```

### Kibana

1. Configure domain in `kibana/values-aws.yaml` (replace `%%DOMAIN%%`)

2. Create encryption keys secret:

   ```bash
   kubectl create secret generic "kibana-encryption-keys" \
     --namespace="elastic" \
     --from-literal=encryptedSavedObjects.encryptionKey="$(openssl rand -hex 16)" \
     --from-literal=reporting.encryptionKey="$(openssl rand -hex 16)" \
     --from-literal=security.encryptionKey="$(openssl rand -hex 16)" \
     --type=Opaque
   ```

3. Install Kibana:
   ```bash
   helm upgrade --install kibana kibana/. \
     -n elastic \
     --values kibana/values-aws.yaml \
     --wait --timeout 900s \
     --dependency-update
   ```

Access Kibana at: `https://kibana.<your-domain>`

### Postgres-operator

```bash
helm upgrade --install postgres-operator postgres-operator-helm/. \
  -n postgres-operator \
  --create-namespace \
  --wait --timeout 900s \
  --dependency-update
```

### PostgreSQL

:::warning Cloud-managed PostgreSQL Recommended
In-cluster PostgreSQL installation is deprecated. Using cloud-managed PostgreSQL (AWS RDS) is now required for new deployments.
:::

1. Create PostgreSQL secret:

For cloud-managed Postgres:

```bash
kubectl create secret generic codemie-postgresql \
  --from-literal=password=%%YOUR_PASSWORD%% \
  --namespace codemie
```

For in-cluster Postgres (deprecated):

```bash
kubectl create secret generic codemie-postgresql \
  --from-literal=password=$(openssl rand -base64 12) \
  --from-literal=postgres-password=$(openssl rand -base64 12) \
  --namespace codemie
```

## Security and Identity Installation

### Keycloak-operator

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

### Keycloak

1. Configure domain in `keycloak-helm/values-aws.yaml` (replace %%DOMAIN%%)

2. Install Keycloak:
   ```bash
   helm upgrade --install keycloak keycloak-helm/. \
     -n security \
     --values keycloak-helm/values-aws.yaml \
     --wait --timeout 900s \
     --dependency-update
   ```

Access Keycloak at: `https://keycloak.<your-domain>/auth/admin`

### OAuth2 Proxy

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

4. Configure domain in `oauth2-proxy/values-aws.yaml` (replace %%DOMAIN%%)

5. Install OAuth2 Proxy:
   ```bash
   helm upgrade --install oauth2-proxy oauth2-proxy/. \
     -n oauth2-proxy \
     --values oauth2-proxy/values-aws.yaml \
     --wait --timeout 900s \
     --dependency-update
   ```

## Messaging Installation

### NATS

To deploy NATS, follow the steps below:

#### 1. Create NATS Secrets

Create `codemie-nats-secrets` Kubernetes secret. To set it up, follow these steps to generate and encode the necessary values:

##### NATS_URL

- Since NATS is deployed in the same namespace as the AI/Run CodeMie and NATS Callout services, use the internal URL `nats://codemie-nats:4222`
- Base64 encode this URL before using it in the secret

##### CALLOUT_USERNAME

- Use the username `callout`
- Base64 encode this username before using it in the secret

##### CALLOUT_PASSWORD

- Generate a secure password using the command: `pwgen -s -1 25`
- Base64 encode this password before using it in the secret

##### CALLOUT_BCRYPTED_PASSWORD

- Use the NATS server to generate a bcrypt-hashed password based on the `CALLOUT_PASSWORD`
- Command: `nats server passwd -p <CALLOUT_PASSWORD>`
- Base64 encode the bcrypt-hashed password before using it in the secret

##### CODEMIE_USERNAME

- Use the username `codemie`
- Base64 encode this username before using it in the secret

##### CODEMIE_PASSWORD

- Generate a secure password using the command: `pwgen -s -1 25`
- Base64 encode this password before using it in the secret

##### CODEMIE_BCRYPTED_PASSWORD

- Use the NATS server to generate a bcrypt-hashed password based on the `CODEMIE_PASSWORD`
- Command: `nats server passwd -p <CODEMIE_PASSWORD>`
- Base64 encode the bcrypt-hashed password before using it in the secret

##### ISSUER_NKEY and ISSUER_NSEED

- Use the `nsc` tool to generate NATS account keys
- Reference: https://natsbyexample.com/examples/auth/callout/cli
- Command: `nsc generate nkey --account`
- Base64 encode the NKEY and NSEED before using them in the secret

##### ISSUER_XKEY and ISSUER_XSEED

- Use the `nsc` tool to generate NATS curve keys
- Reference: https://natsbyexample.com/examples/auth/callout/cli
- Command: `nsc generate nkey --curve`
- Base64 encode the XKEY and XSEED before using them in the secret

#### Secret Example

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

#### 2. Install NATS Helm Chart

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

### NATS Auth Callout

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

## AI/Run CodeMie Core Installation

### MCP Connect

```bash
helm upgrade --install codemie-mcp-connect-service \
  oci://europe-west3-docker.pkg.dev/or2-msq-epmd-edp-anthos-t1iylu/helm-charts/codemie-mcp-connect-service \
  --version x.y.z \
  --namespace "codemie" \
  -f "./codemie-mcp-connect-service/values.yaml" \
  --wait --timeout 600s
```

### Mermaid Server

```bash
helm upgrade --install mermaid-server \
  oci://europe-west3-docker.pkg.dev/or2-msq-epmd-edp-anthos-t1iylu/helm-charts/mermaid-server \
  --version x.y.z \
  --namespace "codemie" \
  -f "./mermaid-server/values.yaml" \
  --wait --timeout 600s
```

### CodeMie UI

1. Configure domain in `codemie-ui/values-aws.yaml` (replace %%DOMAIN%%)

2. Install:
   ```bash
   helm upgrade --install codemie-ui \
     oci://europe-west3-docker.pkg.dev/or2-msq-epmd-edp-anthos-t1iylu/helm-charts/codemie-ui \
     --version x.y.z \
     --namespace "codemie" \
     -f "./codemie-ui/values-aws.yaml" \
     --wait --timeout 180s
   ```

### CodeMie API

1. Configure all placeholders in `codemie-api/values-aws.yaml`:
   - `%%DOMAIN%%`
   - `%%AWS_DEFAULT_REGION%%`
   - `%%EKS_AWS_ROLE_ARN%%`
   - `%%AWS_KMS_KEY_ID%%`
   - `%%AWS_S3_BUCKET_NAME%%`
   - `%%AWS_S3_REGION%%`

2. Copy Elasticsearch credentials:

   ```bash
   kubectl get secret elasticsearch-master-credentials -n elastic -o yaml | sed '/namespace:/d' | kubectl apply -n codemie -f -
   ```

3. Install:
   ```bash
   helm upgrade --install codemie-api \
     oci://europe-west3-docker.pkg.dev/or2-msq-epmd-edp-anthos-t1iylu/helm-charts/codemie \
     --version x.y.z \
     --namespace "codemie" \
     -f "./codemie-api/values-aws.yaml" \
     --wait --timeout 600s
   ```

Access AI/Run CodeMie at: `https://codemie.<your-domain>`

## Observability (Optional)

### Fluentbit

If you don't have your own logging system:

1. Create namespace:

   ```bash
   kubectl create ns fluentbit
   ```

2. Copy Elasticsearch credentials:

   ```bash
   kubectl get secret elasticsearch-master-credentials -n elastic -o yaml | sed '/namespace:/d' | kubectl apply -n fluentbit -f -
   ```

3. Install Fluentbit:

   ```bash
   helm upgrade --install fluent-bit fluent-bit/. \
     -n fluentbit \
     --values fluent-bit/values.yaml \
     --wait --timeout 900s \
     --dependency-update
   ```

4. Configure `codemie_infra_logs*` index in Kibana

### Kibana Dashboards

Install custom dashboards for metrics and monitoring:

```bash
bash ./kibana-dashboards/manage-kibana-dashboards.sh --url "https://kibana.url"
```

Use `--force` to recreate existing resources.

:::warning
Kibana URL must NOT include trailing slash to avoid 404 errors.
:::

## Next Steps

After all components are installed, proceed to [Post-Installation Configuration](../06-post-installation.md) to complete required setup steps.
