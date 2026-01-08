---
id: storage-and-ingress
sidebar_position: 1
title: Storage and Ingress
sidebar_label: Storage and Ingress
---

# Storage and Ingress Installation

This guide covers the installation of foundational infrastructure components that provide storage provisioning and external access to your AI/Run CodeMie deployment.

## Overview

This step installs two critical infrastructure components:

- **Nginx Ingress Controller** - Routes external HTTP/HTTPS traffic to services within the cluster
- **GCP Storage Class** - Enables dynamic provisioning of persistent volumes for stateful workloads

:::info When to Skip
If your GKE cluster already has an ingress controller and storage class configured, you can skip the relevant sections and proceed to [Data Layer](./data-layer).
:::

## Nginx Ingress Controller Installation

The Nginx Ingress Controller manages external access to services in your cluster, providing load balancing, SSL termination, and name-based virtual hosting.

### Step 1: Create Ingress Namespace

Create a dedicated namespace for the ingress controller:

```bash
kubectl create namespace ingress-nginx
```

:::tip Namespace Verification
Check if the namespace already exists before creating: `kubectl get namespace ingress-nginx`
:::

### Step 2: Install Nginx Ingress Helm Chart

Deploy the Nginx Ingress Controller using Helm:

```bash
helm upgrade --install ingress-nginx ingress-nginx/. \
  -n ingress-nginx \
  --values ingress-nginx/values-gcp.yaml \
  --wait \
  --timeout 900s \
  --dependency-update
```

**Command Breakdown**:

- `upgrade --install` - Installs or upgrades if already exists (idempotent)
- `-n ingress-nginx` - Deploys to the ingress-nginx namespace
- `--values ingress-nginx/values-gcp.yaml` - Uses GCP-specific configuration
- `--wait` - Waits for all resources to be ready
- `--timeout 900s` - Maximum wait time (15 minutes)
- `--dependency-update` - Updates chart dependencies before installation

:::warning
Do not interrupt the process.
:::

### Step 3: Verify Ingress Controller Deployment

Check that the ingress controller is running:

```bash
# Check pod status
kubectl get pods -n ingress-nginx

# Verify service and load balancer IP
kubectl get service ingress-nginx-controller -n ingress-nginx
```

Expected output:

- Pods should be in `Running` state
- Service should have an `EXTERNAL-IP` assigned (GCP Load Balancer IP)

## GCP Storage Class Installation

The GCP Storage Class enables Kubernetes to dynamically provision GCP Persistent Disks for stateful workloads like databases.

### Check Existing Storage Classes

Before installing, verify if a suitable storage class already exists:

```bash
kubectl get storageclass
```

:::info Skip if Already Exists
If your cluster already has appropriate storage classes (typically `standard-rwo` or similar), you can skip this installation.
:::

### Install Custom Storage Class

If no suitable storage class exists, install the GCP storage class:

```bash
kubectl apply -f storage-class/storageclass-gcp-pd-balanced.yaml
```

### Verify Storage Class

Check that the storage class was created:

```bash
kubectl get storageclass

# View storage class details
kubectl describe storageclass <storage-class-name>
```

## Post-Installation Validation

After completing this step, verify the following:

```bash
# Ingress controller is running
kubectl get pods -n ingress-nginx | grep Running

# Load balancer has IP assigned
kubectl get svc -n ingress-nginx ingress-nginx-controller | grep -v pending

# Storage class is available
kubectl get storageclass
```

All checks should return successful results before proceeding.

## Next Steps

Once storage and ingress are configured, proceed to **[Data Layer](./data-layer)** installation to deploy Elasticsearch, Kibana, and PostgreSQL components.
