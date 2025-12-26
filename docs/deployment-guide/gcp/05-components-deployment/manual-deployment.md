---
id: components-manual-deployment
title: Manual Components Deployment
sidebar_label: Manual Deployment
sidebar_position: 2
---

# Manual Components Deployment

Use this instruction to manually install AI/Run CodeMie by each component.

## Nginx Ingress Controller

Install only if your GKE cluster does not have Nginx Ingress Controller.

1. Create Kubernetes namespace, e.g. `ingress-nginx` with the command:

```bash
kubectl create namespace ingress-nginx
```

2. Install `ingress-nginx` helm chart in created namespace:

```bash
helm upgrade --install ingress-nginx ingress-nginx/. -n ingress-nginx --values ingress-nginx/values-gcp.yaml --wait --timeout 900s --dependency-update
```

## Storage Class

Install only if your GKE cluster does not have storage class:

```bash
kubectl apply -f storage-class/storageclass-gcp-pd-balanced.yaml
```

## Install Elasticsearch Component

1. Create Kubernetes namespace, e.g. `elastic` with the command:

```bash
kubectl create namespace elastic
```

2. Create Kubernetes secret:

```bash
kubectl -n elastic create secret generic elasticsearch-master-credentials \
  --from-literal=username=elastic \
  --from-literal=password="$(openssl rand -base64 12)" \
  --type=Opaque \
  --dry-run=client -o yaml | kubectl apply -f -
```

Secret example:

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: elasticsearch-master-credentials
type: Opaque
data:
  username: <base64-encoded-username>
  password: <base64-encoded-password>
```

3. Install `elasticsearch` helm chart in created namespace with the command:

```bash
helm upgrade --install elastic elasticsearch/. -n elastic --values elasticsearch/values-gcp.yaml --wait --timeout 900s --dependency-update
```

## Install Kibana Component

1. Fill in missing values in `kibana/values-gcp.yaml` file by replacing `%%DOMAIN%%` with your domain name, e.g. `example.com`

2. Create `kibana-encryption-keys` Kubernetes secret:

```bash
kubectl create secret generic "kibana-encryption-keys" \
  --namespace="elastic" \
  --from-literal=encryptedSavedObjects.encryptionKey="$(openssl rand -hex 16)" \
  --from-literal=reporting.encryptionKey="$(openssl rand -hex 16)" \
  --from-literal=security.encryptionKey="$(openssl rand -hex 16)" \
  --type=Opaque
```

Secret example:

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: kibana-encryption-keys
  namespace: elastic
data:
  encryptedSavedObjects.encryptionKey: <base64-encoded-32-byte-long-strong-encryption-key>
  reporting.encryptionKey: <base64-encoded-32-byte-long-strong-encryption-key>
  security.encryptionKey: <base64-encoded-32-byte-long-strong-encryption-key>
type: Opaque
```

3. Install `kibana` helm chart with the command:

```bash
helm upgrade --install kibana kibana/. -n elastic --values kibana/values-gcp.yaml --wait --timeout 900s --dependency-update
```

4. Kibana can be accessed by the following URL: `https://kibana.%%DOMAIN%%/`, e.g. `https://kibana.example.com`

## Install Postgres-Operator Component

1. Apply `postgres-operator` chart:

```bash
helm upgrade --install postgres-operator postgres-operator-helm/. -n postgres-operator --create-namespace --wait --timeout 900s --dependency-update
```

## Install Keycloak-Operator Component

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
helm upgrade --install keycloak keycloak-helm/. -n security --values keycloak-helm/values-gcp.yaml  --wait --timeout 900s --dependency-update
```

Keycloak Admin UI can be accessed by the following URL: `https://keycloak.%%DOMAIN%%/auth/admin`, e.g. `https://keycloak.example.com/auth/admin`

## Install AI/Run CodeMie NATS Component

To deploy NATS, follow the steps below:

1. Create Kubernetes namespace, e.g. `codemie` with the command:

```bash
kubectl create namespace codemie
```

2. Create `codemie-nats-secrets` Kubernetes secret. To set it up, follow these steps to generate and encode the necessary values:

   **NATS_URL**
   - Since NATS is deployed in the same namespace as the AI/Run CodeMie and NATS Callout services, use the internal URL `nats://codemie-nats:4222`
   - Base64 encode this URL before using it in the secret

   **CALLOUT_USERNAME**
   - Use the username `callout`
   - Base64 encode this username before using it in the secret

   **CALLOUT_PASSWORD**
   - Generate a secure password using the command: `pwgen -s -1 25`
   - Base64 encode this password before using it in the secret

   **CALLOUT_BCRYPTED_PASSWORD**
   - Use the NATS server to generate a bcrypt-hashed password based on the `CALLOUT_PASSWORD`
   - Command: `nats server passwd -p <CALLOUT_PASSWORD>`
   - Base64 encode the bcrypt-hashed password before using it in the secret

   **CODEMIE_USERNAME**
   - Use the username `codemie`
   - Base64 encode this username before using it in the secret

   **CODEMIE_PASSWORD**
   - Generate a secure password using the command: `pwgen -s -1 25`
   - Base64 encode this password before using it in the secret

   **CODEMIE_BCRYPTED_PASSWORD**
   - Use the NATS server to generate a bcrypt-hashed password based on the `CODEMIE_PASSWORD`
   - Command: `nats server passwd -p <CODEMIE_PASSWORD>`
   - Base64 encode the bcrypt-hashed password before using it in the secret

   **ISSUER_NKEY and ISSUER_NSEED**
   - Use the `nsc` tool to generate NATS account keys. For example: https://natsbyexample.com/examples/auth/callout/cli
   - Command: `nsc generate nkey --account`
   - Base64 encode the NKEY and NSEED before using them in the secret

   **ISSUER_XKEY and ISSUER_XSEED**
   - Use the `nsc` tool to generate NATS curve keys. For example: https://natsbyexample.com/examples/auth/callout/cli
   - Command: `nsc generate nkey --curve`
   - Base64 encode the XKEY and XSEED before using them in the secret

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
Use the following command `echo -n 'your-value-here' | base64` to encode secret or use `kubectl` to create secret (i.e. `kubectl -n codemie create secret generic --from-literal NATS_URL=nats://codemie-nats:4222 --from-literal CALLOUT_USERNAME=callout ...`)
:::

3. Install `codemie-nats` helm chart in created namespace, applying custom values file with the command:

```bash
helm repo add nats https://nats-io.github.io/k8s/helm/charts/
helm repo update nats
helm upgrade --install codemie-nats nats/nats --version 1.2.6 \
--namespace codemie --values ./codemie-nats/values-gcp.yaml \
--wait --timeout 900s
```

:::info
Use plugin engine NATS URL with `nats` protocol, for example: `nats://codemie-nats.example.com:30422`
:::

## Install AI/Run CodeMie NATS Auth Callout Component

:::info
Before applying `codemie-ui`, `codemie-api`, `codemie-nats-auth-callout`, `codemie-mcp-connect-service` and `mermaid-server` helm-charts it's necessary to login into AI/Run CodeMie GCR:

```bash
export GOOGLE_APPLICATION_CREDENTIALS=key.json
gcloud auth application-default print-access-token | helm registry login -u oauth2accesstoken --password-stdin europe-west3-docker.pkg.dev
```

:::

To deploy NATS Auth Callout service, follow the steps below:

1. Install `codemie-nats-auth-callout` helm chart, applying custom values file with the command:

```bash
helm upgrade --install codemie-nats-auth-callout \
"oci://europe-west3-docker.pkg.dev/or2-msq-epmd-edp-anthos-t1iylu/helm-charts/codemie-nats-auth-callout" \
--version "x.y.z" \
--namespace "codemie" \
-f "./codemie-nats-auth-callout/values-gcp.yaml" \
--wait --timeout 600s
```

## Install AI/Run CodeMie MCP Connect Component

1. Install `mcp-connect` helm chart with the command:

```bash
helm upgrade --install codemie-mcp-connect-service oci://europe-west3-docker.pkg.dev/or2-msq-epmd-edp-anthos-t1iylu/helm-charts/codemie-mcp-connect-service \
--version x.y.z \
--namespace "codemie" \
-f "./codemie-mcp-connect-service/values.yaml" \
--wait --timeout 600s
```

## Install PostgreSQL secret

Create `codemie-postgresql` secret:

```bash
kubectl create secret generic codemie-postgresql \
        --from-literal=PG_PASS=<CODEMIE_POSTGRES_DATABASE_PASSWORD> \
        --from-literal=PG_USER=<CODEMIE_POSTGRES_DATABASE_USER> \
        --from-literal=PG_HOST=<CODEMIE_POSTGRES_DATABASE_HOST> \
        --from-literal=PG_NAME=<CODEMIE_POSTGRES_DATABASE_NAME> \
        --namespace codemie
```

:::note
Replace `<CODEMIE_POSTGRES_DATABASE_*>` placeholders with actual values.
:::

Secret example:

```bash
apiVersion: v1
kind: Secret
metadata:
  name: codemie-postgresql
  namespace: codemie
data:
  PG_HOST: <base64-encoded-host>
  PG_NAME: <base64-encoded-db-name>
  PG_PASS: <base64-encoded-password>
  PG_USER: <base64-encoded-user>
type: Opaque
```

## Install OAuth2 Proxy Component

Authentication middleware that provides secure authentication for the AI/Run CodeMie application by integrating with Keycloak or any other IdP.

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

4. Fill in missing values in `oauth2-proxy/values-gcp.yaml` file by replacing `%%DOMAIN%%` with your domain name, e.g. `example.com`

5. Install `oauth2-proxy` helm chart in created namespace with the command:

```bash
helm upgrade --install oauth2-proxy oauth2-proxy/. -n oauth2-proxy --values oauth2-proxy/values-gcp.yaml --wait --timeout 900s --dependency-update
```

## Install AI/Run CodeMie UI Component

1. Fill in missing values in values.yaml file in `codemie-ui/values-gcp.yaml` by replacing `%%DOMAIN%%` with your domain name, e.g. `example.com`

2. Install `codemie-ui` helm chart in created namespace, applying custom values file with the command:

```bash
helm upgrade --install codemie-ui oci://europe-west3-docker.pkg.dev/or2-msq-epmd-edp-anthos-t1iylu/helm-charts/codemie-ui \
--version x.y.z \
--namespace "codemie" \
-f "./codemie-ui/values-gcp.yaml" \
--wait --timeout 180s
```

3. Deploy AI/Run CodeMie API component

## Install AI/Run Mermaid Server Component

1. Install mermaid-server helm chart with the command:

```bash
helm upgrade --install mermaid-server oci://europe-west3-docker.pkg.dev/or2-msq-epmd-edp-anthos-t1iylu/helm-charts/mermaid-server \
--version x.y.z \
--namespace "codemie" \
-f "./mermaid-server/values.yaml" \
--wait --timeout 600s
```

## Install AI/Run CodeMie API Component

1. Fill in missing values in `codemie-api/values-gcp.yaml` file in `codemie-helm-charts/codemie-api`:
   - Replace `%%DOMAIN%%` with your domain name, e.g. `example.com`
   - Replace `%%GOOGLE_PROJECT_ID%%` with your project ID where Vertex AI is available
   - Replace `%%GOOGLE_KMS_PROJECT_ID%%` with your project ID where KMS key is available
   - Replace `%%GOOGLE_REGION%%` and `%%GOOGLE_KMS_REGION%%` with your GCP region, e.g. `europe-west3`

2. Copy Elasticsearch credentials to the application namespace with the command:

```bash
kubectl get secret elasticsearch-master-credentials -n elastic -o yaml | sed '/namespace:/d' | kubectl apply -n codemie -f -
```

3. Create `google-service-account` with the GCP service account key:

```bash
kubectl create secret generic google-service-account --namespace codemie --from-file=gcp-service-account.json=codemie-gsa-key.json
```

4. Install `codemie-api` helm chart, applying custom values file with the command:

```bash
helm upgrade --install codemie-api oci://europe-west3-docker.pkg.dev/or2-msq-epmd-edp-anthos-t1iylu/helm-charts/codemie \
--version x.y.z \
--namespace "codemie" \
-f "./codemie-api/values-gcp.yaml" \
--wait --timeout 600s
```

5. AI/Run CodeMie UI can be accessed by the following URL: `https://codemie.%%DOMAIN%%`, e.g. `https://codemie.example.com`

## Install Fluent Bit Component

If you do not have your own logging system then consider installing Fluent Bit component to store historical log data.

1. Create `Fluent Bit` namespace:

```bash
kubectl create ns fluentbit
```

2. Copy Elasticsearch credentials to the `fluentbit` namespace with the command:

```bash
kubectl get secret elasticsearch-master-credentials -n elastic -o yaml | sed '/namespace:/d' | kubectl apply -n fluentbit -f -
```

3. Install `Fluent Bit` with the command:

```bash
helm upgrade --install fluent-bit fluent-bit/. -n fluentbit --values fluent-bit/values.yaml --wait --timeout 900s --dependency-update
```

4. Go to Kibana and setup `codemie_infra_logs*` index to view historical logs

## Install Kibana Dashboards

AI/Run CodeMie supports custom metrics about Assistants usage, including token consumption, costs, and engagement patterns. To view these metrics and gain valuable insights into your AI assistant interactions, the Kibana dashboard installation is required.

**With manual authentication:**

```bash
bash ./kibana-dashboards/manage-kibana-dashboards.sh --url "https://kibana.<your-domain>"
```

**With Kubernetes secret authentication (recommended):**

```bash
bash ./kibana-dashboards/manage-kibana-dashboards.sh --url "https://kibana.<your-domain>" --k8s-auth --non-interactive
```

This uses the `elasticsearch-master-credentials` secret from the `elastic` namespace by default.

For more information and additional options, use:

```bash
bash ./kibana-dashboards/manage-kibana-dashboards.sh --help
```

## Next Steps

Complete the deployment by going to [Configuration](../../../configuration-guide/).
