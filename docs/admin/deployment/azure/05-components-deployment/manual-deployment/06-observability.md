---
id: observability
sidebar_position: 6
title: Observability
sidebar_label: Observability
pagination_prev: admin/deployment/azure/components-deployment/manual-deployment/manual-deployment-overview
pagination_next: admin/deployment/azure/accessing-applications
---

# Observability Installation

This guide covers the installation of logging and monitoring components that provide operational visibility into your AI/Run CodeMie deployment.

## Overview

The observability stack consists of three components:

- **Fluent Bit** - Lightweight log collection and forwarding agent that captures logs from all pods
- **Kibana** - Log visualization and analytics dashboard for Elasticsearch
- **Kibana Dashboards** - Pre-configured monitoring dashboards for CodeMie metrics and logs

## Fluent Bit Installation

Fluent Bit collects and forwards data to Elasticsearch for monitoring and analysis. The default configuration collects two types of data:

**1. User Metrics (Mandatory)**

Collects structured usage metrics from CodeMie application pods, including:

- User activity and engagement patterns
- AI model usage and token consumption
- API request metrics and performance data
- Cost tracking and resource utilization

These metrics are required for Kibana dashboards and usage analytics. They are stored in the `codemie_metrics_logs` index.

**2. Infrastructure Logs (Optional)**

Collects application logs from the following namespaces:

- `codemie` - Core application logs
- `oauth2-proxy` - Authentication proxy logs
- `security` - Keycloak and security components
- `elastic` - Elasticsearch and Kibana logs
- `ingress-nginx` - Ingress controller logs

These logs are stored in the `codemie_infra_logs` index for troubleshooting and operational insights.

:::info Using External Logging System?
If you have an existing logging solution (CloudWatch, Stackdriver, Splunk, etc.), you can disable infrastructure log collection by removing the first `[INPUT]` section (tagged `kube.codemie-infra.*`) and its corresponding `[OUTPUT]` section from `fluent-bit/values.yaml`. User metrics collection must remain enabled for Kibana dashboards to function.
:::

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

### Step 5: Configure Log Index Pattern (Optional)

If you enabled infrastructure logging, configure the index pattern to view logs:

1. Navigate to **Stack Management** → **Index Patterns**
2. Click **Create index pattern**
3. Enter index pattern: `codemie_infra_logs*`
4. Select timestamp field: `@timestamp`
5. Click **Create index pattern**

Now you can view historical infrastructure logs in **Discover** section.

:::note Metrics Index
The `codemie_metrics_logs` index for user metrics is automatically configured during Kibana Dashboards installation. You don't need to create it manually.
:::

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

Proceed to **[Accessing Applications](../../accessing-applications)** - Learn how to access the deployed AI/Run CodeMie applications and complete the required configuration steps.
