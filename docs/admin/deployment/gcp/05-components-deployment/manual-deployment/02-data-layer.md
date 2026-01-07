---
id: data-layer
sidebar_position: 2
title: Data Layer Components
sidebar_label: Data Layer
---

# Data Layer Installation

This guide covers the installation of data storage components that provide persistent storage for application data, search capabilities, and relational database management.

## Overview

This step installs three critical data layer components:

- **Elasticsearch** - Document storage and full-text search engine
- **Kibana** - Visualization and exploration tool for Elasticsearch data
- **PostgreSQL Operator** - Kubernetes operator for managing PostgreSQL database lifecycle

## Elasticsearch Installation

Elasticsearch provides document storage and search capabilities for AI/Run CodeMie.

### Step 1: Create Elastic Namespace

Create a dedicated namespace for Elasticsearch and related components:

```bash
kubectl create namespace elastic
```

### Step 2: Create Elasticsearch Credentials Secret

Generate and create the Elasticsearch master credentials:

```bash
kubectl -n elastic create secret generic elasticsearch-master-credentials \
  --from-literal=username=elastic \
  --from-literal=password="$(openssl rand -base64 12)" \
  --type=Opaque \
  --dry-run=client -o yaml | kubectl apply -f -
```

**Secret Example**:

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: elasticsearch-master-credentials
  namespace: elastic
type: Opaque
data:
  username: <base64-encoded-username>
  password: <base64-encoded-password>
```

:::tip Retrieve Password
To retrieve the generated password later:

```bash
kubectl get secret elasticsearch-master-credentials -n elastic -o jsonpath='{.data.password}' | base64 -d
```

:::

### Step 3: Install Elasticsearch Helm Chart

Deploy Elasticsearch using Helm:

```bash
helm upgrade --install elastic elasticsearch/. \
  -n elastic \
  --values elasticsearch/values-gcp.yaml \
  --wait \
  --timeout 900s \
  --dependency-update
```

### Step 4: Verify Elasticsearch Deployment

Check that Elasticsearch is running:

```bash
# Check pod status
kubectl get pods -n elastic

# Check Elasticsearch service
kubectl get svc -n elastic
```

Wait for all Elasticsearch pods to reach `Running` state before proceeding.

## Kibana Installation

Kibana provides visualization and management interface for Elasticsearch data.

### Step 1: Configure Domain Name

Fill in missing values in `kibana/values-gcp.yaml` file by replacing `%%DOMAIN%%` with your domain name, e.g., `example.com`

:::tip Domain Configuration
If you followed the Getting Started steps in the [overview](./), this should already be configured.
:::

### Step 2: Create Kibana Encryption Keys

Generate encryption keys for Kibana security features:

```bash
kubectl create secret generic "kibana-encryption-keys" \
  --namespace="elastic" \
  --from-literal=encryptedSavedObjects.encryptionKey="$(openssl rand -hex 16)" \
  --from-literal=reporting.encryptionKey="$(openssl rand -hex 16)" \
  --from-literal=security.encryptionKey="$(openssl rand -hex 16)" \
  --type=Opaque
```

**Secret Example**:

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: kibana-encryption-keys
  namespace: elastic
data:
  encryptedSavedObjects.encryptionKey: <base64-encoded-32-byte-encryption-key>
  reporting.encryptionKey: <base64-encoded-32-byte-encryption-key>
  security.encryptionKey: <base64-encoded-32-byte-encryption-key>
type: Opaque
```

### Step 3: Install Kibana Helm Chart

Deploy Kibana using Helm:

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

# Check Kibana service
kubectl get svc -n elastic | grep kibana
```

### Step 5: Access Kibana

Kibana can be accessed by the following URL: `https://kibana.%%DOMAIN%%/`, e.g., `https://kibana.example.com`

Use the Elasticsearch credentials from Step 2 of Elasticsearch installation to log in.

## PostgreSQL Operator Installation

The PostgreSQL Operator manages the lifecycle of PostgreSQL database instances in Kubernetes.

### Step 1: Install PostgreSQL Operator

Deploy the PostgreSQL Operator using Helm:

```bash
helm upgrade --install postgres-operator postgres-operator-helm/. \
  -n postgres-operator \
  --create-namespace \
  --wait \
  --timeout 900s \
  --dependency-update
```

**Command Breakdown**:

- `--create-namespace` - Automatically creates the namespace if it doesn't exist
- `-n postgres-operator` - Deploys to the postgres-operator namespace

### Step 2: Verify PostgreSQL Operator Deployment

Check that the operator is running:

```bash
# Check pod status
kubectl get pods -n postgres-operator

# Check operator logs
kubectl logs -n postgres-operator deployment/postgres-operator
```

The operator should be in `Running` state and ready to manage PostgreSQL instances.

:::info PostgreSQL Instances
PostgreSQL database instances will be created later as part of the core components installation or can be managed externally using GCP Cloud SQL.
:::

## Post-Installation Validation

After completing this step, verify all data layer components:

```bash
# Check all pods in elastic namespace
kubectl get pods -n elastic

# Check Elasticsearch cluster health
kubectl exec -n elastic -it elastic-master-0 -- curl -u elastic:$(kubectl get secret elasticsearch-master-credentials -n elastic -o jsonpath='{.data.password}' | base64 -d) http://localhost:9200/_cluster/health?pretty

# Check PostgreSQL Operator
kubectl get pods -n postgres-operator
```

All pods should be in `Running` state before proceeding.

## Troubleshooting

### Elasticsearch Pods Not Starting

**Symptom**: Elasticsearch pods remain in `Pending` or `CrashLoopBackOff` state

**Solution**:

- Check storage class availability: `kubectl get storageclass`
- Verify PVC binding: `kubectl get pvc -n elastic`
- Check pod logs: `kubectl logs -n elastic <pod-name>`
- Ensure sufficient node resources: `kubectl top nodes`

### Kibana Connection Errors

**Symptom**: Kibana fails to connect to Elasticsearch

**Solution**:

- Verify Elasticsearch is healthy: `kubectl get pods -n elastic`
- Check Elasticsearch service: `kubectl get svc -n elastic elasticsearch-master`
- Review Kibana logs: `kubectl logs -n elastic <kibana-pod-name>`

## Next Steps

Once the data layer is deployed and validated, proceed to **[Security and Identity](./security-and-identity)** installation to deploy Keycloak and OAuth2 Proxy components.
