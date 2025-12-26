---
id: observability
sidebar_position: 6
title: Observability
sidebar_label: Observability
pagination_next: deployment-guide/azure/ai-models-integration/ai-models-integration-overview
---

# Observability Installation

This guide covers the installation of logging and monitoring components that provide operational visibility into your AI/Run CodeMie deployment.

## Overview

The observability stack consists of three components:

- **Fluent Bit** - Lightweight log collection and forwarding agent that captures logs from all pods
- **Kibana** - Log visualization and analytics dashboard for Elasticsearch
- **Kibana Dashboards** - Pre-configured monitoring dashboards for CodeMie metrics and logs

## Fluent Bit Installation

Fluent Bit collects logs from all Kubernetes pods and CodeMie application metrics and forwards them to Elasticsearch for storage and analysis.

### Step 1: Create Fluent Bit Namespace

Create a dedicated namespace for Fluent Bit:

```bash
kubectl create namespace fluentbit
```

### Step 2: Copy Elasticsearch Credentials

Fluent Bit needs Elasticsearch credentials to forward logs. Copy the credentials:

```bash
kubectl get secret elasticsearch-master-credentials -n elastic -o yaml | \
  sed '/namespace:/d' | \
  kubectl apply -n fluentbit -f -
```

**Command Breakdown**:

- `kubectl get secret ... -o yaml` - Exports secret as YAML from elastic namespace
- `sed '/namespace:/d'` - Removes namespace field to allow cross-namespace copy
- `kubectl apply -n fluentbit -f -` - Applies to fluentbit namespace

### Step 3: Install Fluent Bit Helm Chart

Deploy Fluent Bit:

```bash
helm upgrade --install fluent-bit fluent-bit/. \
  -n fluentbit \
  --values fluent-bit/values.yaml \
  --wait \
  --timeout 900s \
  --dependency-update
```

**Command Breakdown**:

- `fluent-bit` - Release name
- `-n fluentbit` - Deploys to fluentbit namespace
- `--values fluent-bit/values.yaml` - Uses Fluent Bit configuration

### Step 4: Verify Fluent Bit Deployment

Check that Fluent Bit is running:

```bash
# Check DaemonSet
kubectl get daemonset -n fluentbit

# Check pods (should be one per node)
kubectl get pods -n fluentbit

# Check logs
kubectl logs -n fluentbit daemonset/fluent-bit --tail=50
```

Expected output:

- DaemonSet should show desired pods match ready pods
- One Fluent Bit pod should be running on each cluster node
- Logs should indicate successful connection to Elasticsearch

## Kibana Installation

Kibana provides a web interface for searching, analyzing, and visualizing logs stored in Elasticsearch.

### Step 1: Create Kibana Encryption Keys Secret

Generate encryption keys for Kibana's saved objects, reports, and security features:

```bash
kubectl create secret generic kibana-encryption-keys \
  --namespace=elastic \
  --from-literal=encryptedSavedObjects.encryptionKey="$(openssl rand -hex 16)" \
  --from-literal=reporting.encryptionKey="$(openssl rand -hex 16)" \
  --from-literal=security.encryptionKey="$(openssl rand -hex 16)" \
  --type=Opaque
```

**Command Breakdown**:

- `encryptedSavedObjects.encryptionKey` - Encrypts saved searches, dashboards, and visualizations
- `reporting.encryptionKey` - Encrypts report generation data
- `security.encryptionKey` - Encrypts session cookies and security tokens
- `openssl rand -hex 16` - Generates 32-character (16-byte) random hex string

**Secret Structure**:

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: kibana-encryption-keys
  namespace: elastic
type: Opaque
data:
  encryptedSavedObjects.encryptionKey: <base64-encoded-32-char-key>
  reporting.encryptionKey: <base64-encoded-32-char-key>
  security.encryptionKey: <base64-encoded-32-char-key>
```

### Step 2: Install Kibana Helm Chart

Deploy Kibana:

```bash
helm upgrade --install kibana kibana/. \
  -n elastic \
  --values kibana/values-azure.yaml \
  --wait \
  --timeout 900s \
  --dependency-update
```

**Command Breakdown**:

- `kibana` - Release name
- `-n elastic` - Deploys to elastic namespace
- `--values kibana/values-azure.yaml` - Uses Azure-specific configuration

### Step 3: Verify Kibana Deployment

Check that Kibana is running:

```bash
# Check pod status
kubectl get pods -n elastic | grep kibana

# Check deployment
kubectl get deployment -n elastic kibana

# Check service
kubectl get service -n elastic kibana

# Check logs
kubectl logs -n elastic deployment/kibana --tail=50
```

Expected output:

- Kibana pod should be in `Running` state
- Deployment should show ready replicas
- Logs should indicate successful connection to Elasticsearch

### Step 4: Access Kibana

Kibana can be accessed at:

```
https://<your-domain>/kibana
```

**Example URLs**:

- `https://codemie.example.com/kibana` (custom domain)

**Login Credentials**:

- Username: `elastic`
- Password: Retrieved from Elasticsearch secret (see [Data Layer](./data-layer#step-2-create-elasticsearch-credentials-secret))

### Step 5: Configure Log Index Pattern

After accessing Kibana, configure the index pattern to view CodeMie logs:

1. Navigate to **Stack Management** → **Index Patterns**
2. Click **Create index pattern**
3. Enter index pattern: `codemie_infra_logs*`
4. Select timestamp field: `@timestamp`
5. Click **Create index pattern**

Now you can view logs in **Discover** section.

## Kibana Dashboards Installation

Install pre-configured dashboards that provide operational insights into CodeMie performance, usage, and health using the `manage-kibana-dashboards.sh` script.

### Option 1: Kubernetes Secret Authentication (Recommended)

This method automatically retrieves Elasticsearch credentials from the Kubernetes secret:

```bash
bash ./kibana-dashboards/manage-kibana-dashboards.sh \
  --url "https://<your-domain>/kibana" \
  --k8s-auth \
  --non-interactive
```

**Parameters**:

- `--url` - Your Kibana URL (replace `<your-domain>` with your actual domain)
- `--k8s-auth` - Use Kubernetes secret for authentication
- `--non-interactive` - Run without prompts (uses `elasticsearch-master-credentials` from `elastic` namespace)

**Example**:

```bash
bash ./kibana-dashboards/manage-kibana-dashboards.sh \
  --url "https://codemie.example.com/kibana" \
  --k8s-auth \
  --non-interactive
```

### Option 2: Manual Authentication

This method prompts for Elasticsearch credentials interactively:

```bash
bash ./kibana-dashboards/manage-kibana-dashboards.sh \
  --url "https://<your-domain>/kibana"
```

You'll be prompted to enter the Elasticsearch username and password.

### Verify Dashboard Installation

After running the script:

1. Log in to Kibana
2. Navigate to **Dashboard** section
3. You should see pre-configured CodeMie dashboards including:
   - **AI/Run Adoption** - Platform adoption metrics and user engagement
   - **CodeMie Assistants Dashboard** - Assistant usage and performance metrics
   - **CodeMie Datasource Observability** - Data source indexing and query performance
   - **CodeMie Workflow Usage** - Workflow execution metrics and analytics

### Additional Options

For more configuration options and help:

```bash
bash ./kibana-dashboards/manage-kibana-dashboards.sh --help
```

## Post-Installation Validation

After completing observability stack installation, verify the following:

```bash
# Fluent Bit is running on all nodes
kubectl get daemonset -n fluentbit
kubectl get pods -n fluentbit

# Kibana is running
kubectl get pods -n elastic | grep kibana
kubectl get deployment -n elastic kibana

# Check Kibana is accessible
curl -k https://<your-domain>/kibana
```

All checks should return successful results.

## Next Steps

Congratulations! You have successfully completed the manual deployment of all AI/Run CodeMie components.

Proceed to **[Configuration](../../../../configuration-guide/)** to:

- Create initial users and configure authentication
- Set up AI model integrations
- Configure data sources
- Customize the UI and branding
- Set up monitoring and alerts
