---
id: observability
sidebar_position: 6
title: Observability Components
sidebar_label: Observability
---

# Observability Installation

This guide covers the installation of logging and monitoring components that provide operational insights into your AI/Run CodeMie deployment.

## Overview

This step installs the observability stack:

- **Fluent Bit** - Lightweight log processor and forwarder
- **Kibana Dashboards** - Pre-configured monitoring views for metrics and usage

:::info Optional Components
Observability components are optional but highly recommended for production deployments. They enable centralized logging, usage monitoring, and troubleshooting capabilities.
:::

## Fluent Bit Installation

Fluent Bit collects logs from all Kubernetes pods and forwards them to Elasticsearch for centralized storage and analysis.

:::tip When to Install
Install Fluent Bit if you don't have an existing logging system and want to store historical log data in Elasticsearch.
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

**Command Breakdown**:

- `-n fluentbit` - Deploys to the fluentbit namespace
- `--values fluent-bit/values.yaml` - Uses custom configuration
- `--wait` - Waits for all resources to be ready

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

Expected results:

- Fluent Bit pods should be running on all nodes (1 pod per node)
- Logs should show successful connection to Elasticsearch
- No error messages in pod logs

### Step 5: Configure Kibana Index

Set up the Kibana index pattern to view logs:

1. Access Kibana at `https://kibana.example.com`
2. Navigate to **Stack Management** → **Index Patterns**
3. Create a new index pattern: `codemie_infra_logs*`
4. Select `@timestamp` as the time field
5. Click **Create index pattern**

You can now view historical logs in Kibana under **Discover** section.

:::tip Log Patterns
The `codemie_infra_logs*` index contains logs from all Kubernetes infrastructure and application pods. You can filter by namespace, pod name, or log level.
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

Expected results:

- Fluent Bit DaemonSet shows desired number equals ready number
- All Fluent Bit pods in `Running` state
- Logs show successful Elasticsearch connection
- Kibana dashboards are accessible

## Troubleshooting

### Fluent Bit Not Forwarding Logs

**Symptom**: No logs appearing in Elasticsearch/Kibana

**Solution**:

- Check Fluent Bit logs: `kubectl logs -n fluentbit <pod-name>`
- Verify Elasticsearch connection:
  ```bash
  kubectl exec -n fluentbit <fluent-bit-pod> -- curl -u elastic:<password> http://elasticsearch-master.elastic.svc.cluster.local:9200/_cluster/health
  ```
- Verify Elasticsearch credentials secret exists in fluentbit namespace
- Check Fluent Bit configuration: `kubectl get configmap -n fluentbit`

### Fluent Bit Pods CrashLooping

**Symptom**: Fluent Bit pods in `CrashLoopBackOff` state

**Solution**:

- Check pod logs: `kubectl logs -n fluentbit <pod-name> --previous`
- Verify Elasticsearch is running: `kubectl get pods -n elastic`
- Check resource limits: `kubectl describe pod -n fluentbit <pod-name>`
- Verify configuration is valid: `kubectl describe configmap -n fluentbit`

### Kibana Dashboard Installation Fails

**Symptom**: Dashboard installation script returns errors

**Solution**:

- Verify Kibana URL is accessible: `curl -k https://kibana.example.com`
- Check Elasticsearch credentials are correct
- Ensure Kibana is fully started and healthy
- Review script output for specific error messages
- Try manual authentication method first to isolate issues

### Index Pattern Not Created

**Symptom**: Cannot find `codemie_infra_logs*` index in Kibana

**Solution**:

- Verify Fluent Bit is forwarding logs: Check Fluent Bit logs
- Check if index exists in Elasticsearch:
  ```bash
  kubectl exec -n elastic elastic-master-0 -- curl -u elastic:<password> http://localhost:9200/_cat/indices?v
  ```
- Wait a few minutes for logs to accumulate
- Manually create index pattern in Kibana

## Next Steps

Congratulations! You have completed the manual deployment of all AI/Run CodeMie components.

### Complete Configuration

Proceed to **[Configuration](../../../../configuration/)** to complete the setup:

- Configure initial users in Keycloak
- Set up AI model integration (Vertex AI)
- Configure data source connections
- Set up security and access control
- Configure system health monitoring

### Verify Complete Deployment

Ensure all components are running:

```bash
# Check all namespaces
kubectl get pods --all-namespaces | grep -E 'codemie|elastic|security|oauth2-proxy|ingress-nginx|fluentbit'

# Access CodeMie UI
# Open https://codemie.example.com in your browser
```

### Documentation and Support

- Review configuration documentation for post-deployment setup
- Keep track of all passwords and secrets in a secure location
- Document any customizations made during installation
- Set up regular backups for persistent data (Elasticsearch, PostgreSQL)
