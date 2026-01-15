---
id: observability
sidebar_position: 6
title: Observability Components
sidebar_label: Observability
pagination_prev: admin/deployment/gcp/components-deployment/manual-deployment/manual-deployment-overview
pagination_next: admin/deployment/gcp/accessing-applications
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

Copy Elasticsearch credentials to the fluentbit namespace:

```bash
kubectl get secret elasticsearch-master-credentials -n elastic -o yaml | \
  sed '/namespace:/d' | \
  kubectl apply -n fluentbit -f -
```

This allows Fluent Bit to authenticate with Elasticsearch.

### Step 3: Install Fluent Bit Helm Chart

Deploy Fluent Bit using Helm:

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
# Check pod status (Fluent Bit runs as DaemonSet)
kubectl get pods -n fluentbit

# Check Fluent Bit logs
kubectl logs -n fluentbit -l app=fluent-bit --tail=50

# Verify DaemonSet
kubectl get daemonset -n fluentbit
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

### Step 2: Configure Domain Name

Fill in values in `kibana/values-gcp.yaml` file by replacing `%%DOMAIN%%` with your domain name, e.g., `example.com`

:::tip Domain Configuration
If you followed the Getting Started steps, this should already be configured.
:::

### Step 3: Install Kibana Helm Chart

Deploy Kibana:

```bash
helm upgrade --install kibana kibana/. \
  -n elastic \
  --values kibana/values-gcp.yaml \
  --wait \
  --timeout 900s \
  --dependency-update
```

### Step 4: Verify Kibana Deployment

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

### Step 5: Access Kibana

Kibana can be accessed at: `https://kibana.%%DOMAIN%%/`, e.g., `https://kibana.example.com`

**Login Credentials**:

- Username: `elastic`
- Password: Retrieved from Elasticsearch secret (see [Data Layer](./data-layer#step-2-create-elasticsearch-credentials-secret))

### Step 6: Configure Kibana Index (Optional)

If you enabled infrastructure logging, set up the Kibana index pattern to view logs:

1. Access Kibana at `https://kibana.example.com`
2. Navigate to **Stack Management** → **Index Patterns**
3. Create a new index pattern: `codemie_infra_logs*`
4. Select `@timestamp` as the time field
5. Click **Create index pattern**

You can now view historical infrastructure logs in Kibana under **Discover** section.

:::note Metrics Index
The `codemie_metrics_logs` index for user metrics is automatically configured during Kibana Dashboards installation. You don't need to create it manually.
:::

## Kibana Dashboards Installation

AI/Run CodeMie includes pre-configured Kibana dashboards for monitoring assistant usage, token consumption, costs, and engagement patterns.

### Prerequisites

Ensure Kibana is accessible and you have Elasticsearch credentials ready.

### Installation Methods

Choose one of the following installation methods:

#### Method 1: Manual Authentication (Interactive)

Use this method if you prefer to enter Elasticsearch credentials interactively:

```bash
bash ./kibana-dashboards/manage-kibana-dashboards.sh \
  --url "https://kibana.<your-domain>"
```

Replace `<your-domain>` with your actual domain (e.g., `kibana.example.com`).

The script will prompt you for:

- Elasticsearch username (default: `elastic`)
- Elasticsearch password

#### Method 2: Kubernetes Secret Authentication (Recommended)

Use this method for automated deployments using stored credentials:

```bash
bash ./kibana-dashboards/manage-kibana-dashboards.sh \
  --url "https://kibana.<your-domain>" \
  --k8s-auth \
  --non-interactive
```

**Parameters**:

- `--url` - Kibana URL
- `--k8s-auth` - Use Kubernetes secret for authentication
- `--non-interactive` - Skip interactive prompts

This method uses the `elasticsearch-master-credentials` secret from the `elastic` namespace by default.

### Verify Dashboard Installation

After installation completes:

1. Access Kibana at `https://kibana.example.com`
2. Navigate to **Dashboard** section
3. Verify the following dashboards are available:
   - AI Assistant Usage Overview
   - Token Consumption and Costs
   - User Engagement Patterns
   - Model Performance Metrics

### Additional Options

For more information and additional options:

```bash
bash ./kibana-dashboards/manage-kibana-dashboards.sh --help
```

Available options include:

- `--namespace` - Custom namespace for secret (default: `elastic`)
- `--secret-name` - Custom secret name (default: `elasticsearch-master-credentials`)
- `--username` - Elasticsearch username (for manual auth)
- `--password` - Elasticsearch password (for manual auth)

## Post-Installation Validation

After completing observability stack installation, verify all components:

```bash
# Check Fluent Bit DaemonSet
kubectl get daemonset -n fluentbit

# Check Fluent Bit pods (should be 1 per node)
kubectl get pods -n fluentbit

# Test log forwarding
kubectl logs -n fluentbit <fluent-bit-pod-name> --tail=20
```

## Next Steps

Congratulations! You have completed the manual deployment of all AI/Run CodeMie components.

Proceed to **[Accessing Applications](../../accessing-applications)** - Learn how to access the deployed AI/Run CodeMie applications and complete the required configuration steps.
