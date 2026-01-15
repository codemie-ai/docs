---
id: core-components
sidebar_position: 5
title: AI/Run CodeMie Core Components
sidebar_label: Core Components
---

# Core Components Installation

This guide covers the installation of the main AI/Run CodeMie application services that provide the core functionality.

## Overview

This step installs the following core components in sequence:

1. **PostgreSQL Secret** - Database connection credentials
2. **MCP Connect Service** - Model Context Protocol connector
3. **CodeMie UI** - Frontend web application
4. **Mermaid Server** - Diagram rendering service
5. **CodeMie API** - Backend REST API service

## Registry Authentication

Before installing any core components, ensure you're authenticated to the container registry:

```bash
export GOOGLE_APPLICATION_CREDENTIALS=key.json
gcloud auth application-default print-access-token | \
  helm registry login -u oauth2accesstoken --password-stdin europe-west3-docker.pkg.dev
```

:::tip Already Authenticated?
If you authenticated during the Plugin Engine installation, you can skip this step.
:::

## PostgreSQL Secret Installation

Create the PostgreSQL connection secret required by CodeMie API.

### Create PostgreSQL Secret

```bash
kubectl create secret generic codemie-postgresql \
  --from-literal=PG_PASS=<CODEMIE_POSTGRES_DATABASE_PASSWORD> \
  --from-literal=PG_USER=<CODEMIE_POSTGRES_DATABASE_USER> \
  --from-literal=PG_HOST=<CODEMIE_POSTGRES_DATABASE_HOST> \
  --from-literal=PG_NAME=<CODEMIE_POSTGRES_DATABASE_NAME> \
  --namespace codemie
```

:::note Replace Placeholders
Replace `<CODEMIE_POSTGRES_DATABASE_*>` placeholders with actual values from your PostgreSQL instance:

- `PG_HOST` - PostgreSQL hostname (e.g., Cloud SQL connection string or cluster service)
- `PG_NAME` - Database name (e.g., `codemie`)
- `PG_USER` - Database username (e.g., `codemie`)
- `PG_PASS` - Database password
  :::

**Secret Example**:

```yaml
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

### Verify Secret

```bash
kubectl get secret codemie-postgresql -n codemie
```

## MCP Connect Service Installation

The MCP Connect service enables CodeMie to communicate with Model Context Protocol servers.

### Step 1: Install MCP Connect Helm Chart

Deploy the MCP Connect service:

```bash
helm upgrade --install codemie-mcp-connect-service \
  oci://europe-west3-docker.pkg.dev/or2-msq-epmd-edp-anthos-t1iylu/helm-charts/codemie-mcp-connect-service \
  --version x.y.z \
  --namespace "codemie" \
  -f "./codemie-mcp-connect-service/values.yaml" \
  --wait \
  --timeout 600s
```

Replace `x.y.z` with the version identified in the Getting Started steps.

### Step 2: Verify MCP Connect Deployment

```bash
# Check pod status
kubectl get pods -n codemie | grep mcp-connect

# Check service logs
kubectl logs -n codemie -l app=codemie-mcp-connect-service
```

## CodeMie UI Installation

The CodeMie UI provides the frontend web application for users.

### Step 1: Configure Domain Name

Fill in missing values in `codemie-ui/values-gcp.yaml` file by replacing `%%DOMAIN%%` with your domain name, e.g., `example.com`

:::tip Domain Configuration
If you followed the Getting Started steps in the [overview](./), this should already be configured.
:::

### Step 2: Install CodeMie UI Helm Chart

Deploy the CodeMie UI:

```bash
helm upgrade --install codemie-ui \
  oci://europe-west3-docker.pkg.dev/or2-msq-epmd-edp-anthos-t1iylu/helm-charts/codemie-ui \
  --version x.y.z \
  --namespace "codemie" \
  -f "./codemie-ui/values-gcp.yaml" \
  --wait \
  --timeout 180s
```

Replace `x.y.z` with the version identified in the Getting Started steps.

### Step 3: Verify CodeMie UI Deployment

```bash
# Check pod status
kubectl get pods -n codemie | grep codemie-ui

# Check UI service
kubectl get svc -n codemie | grep codemie-ui

# Check ingress
kubectl get ingress -n codemie
```

## Mermaid Server Installation

The Mermaid Server provides diagram generation and rendering capabilities for chats.

### Step 1: Install Mermaid Server Helm Chart

Deploy the Mermaid Server:

```bash
helm upgrade --install mermaid-server \
  oci://europe-west3-docker.pkg.dev/or2-msq-epmd-edp-anthos-t1iylu/helm-charts/mermaid-server \
  --version x.y.z \
  --namespace "codemie" \
  -f "./mermaid-server/values.yaml" \
  --wait \
  --timeout 600s
```

Replace `x.y.z` with the version identified in the Getting Started steps.

### Step 2: Verify Mermaid Server Deployment

```bash
# Check pod status
kubectl get pods -n codemie | grep mermaid-server

# Check service logs
kubectl logs -n codemie -l app=mermaid-server
```

## CodeMie API Installation

The CodeMie API is the backend service that handles business logic, data processing, and API operations.

### Step 1: Configure CodeMie API Values

Fill in missing values in `codemie-api/values-gcp.yaml` file:

- Replace `%%DOMAIN%%` with your domain name, e.g., `example.com`
- Replace `%%GOOGLE_PROJECT_ID%%` with your GCP project ID where Vertex AI is available
- Replace `%%GOOGLE_KMS_PROJECT_ID%%` with your GCP project ID where KMS key is available
- Replace `%%GOOGLE_REGION%%` with your GCP region, e.g., `europe-west3`
- Replace `%%GOOGLE_KMS_REGION%%` with your GCP KMS region, e.g., `europe-west3`

:::tip Configuration Values
If you followed the Getting Started steps in the [overview](./), domain and GCP parameters should already be configured using sed commands.
:::

### Step 2: Copy Elasticsearch Credentials

Copy Elasticsearch credentials to the codemie namespace:

```bash
kubectl get secret elasticsearch-master-credentials -n elastic -o yaml | \
  sed '/namespace:/d' | \
  kubectl apply -n codemie -f -
```

### Step 3: Create Google Service Account Secret

Create the secret with the GCP service account key for Vertex AI and KMS access:

```bash
kubectl create secret generic google-service-account \
  --namespace codemie \
  --from-file=gcp-service-account.json=codemie-gsa-key.json
```

:::warning Service Account Key
Ensure the `codemie-gsa-key.json` file exists in your current directory. This key was created during the Getting Started steps and grants access to Vertex AI and Cloud KMS.
:::

### Step 4: Install CodeMie API Helm Chart

Deploy the CodeMie API:

```bash
helm upgrade --install codemie-api \
  oci://europe-west3-docker.pkg.dev/or2-msq-epmd-edp-anthos-t1iylu/helm-charts/codemie \
  --version x.y.z \
  --namespace "codemie" \
  -f "./codemie-api/values-gcp.yaml" \
  --wait \
  --timeout 600s
```

Replace `x.y.z` with the version identified in the Getting Started steps.

### Step 5: Verify CodeMie API Deployment

```bash
# Check pod status
kubectl get pods -n codemie | grep codemie-api

# Check API logs
kubectl logs -n codemie -l app=codemie-api --tail=100

# Check API service
kubectl get svc -n codemie | grep codemie-api
```

### Step 6: Access CodeMie UI

AI/Run CodeMie UI can be accessed by the following URL: `https://codemie.%%DOMAIN%%`, e.g., `https://codemie.example.com`

The application should now be fully functional, though you'll need to complete post-deployment configuration for users and AI models.

## Post-Installation Validation

After completing all core component installations, verify the complete deployment:

```bash
# Check all pods in codemie namespace
kubectl get pods -n codemie

# Check all services
kubectl get svc -n codemie

# Check ingress resources
kubectl get ingress -n codemie
```

## Next Steps

Once all core components are deployed and validated, proceed to **[Observability](./observability)** installation to deploy logging and monitoring components.

After completing all installations, proceed to **[Configuration](../../../../configuration/)** to configure users, AI models, and data sources.
