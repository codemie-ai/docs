---
id: storage-and-ingress
sidebar_position: 1
title: Storage and Ingress
sidebar_label: Storage and Ingress
pagination_next: deployment-guide/azure/components-deployment/manual-deployment/data-layer
---

# Storage and Ingress Installation

This guide covers the installation of foundational infrastructure components that provide storage provisioning and external access to your AI/Run CodeMie deployment.

## Overview

This step installs two critical infrastructure components:

- **Nginx Ingress Controller** - Routes external HTTP/HTTPS traffic to services within the cluster
- **Azure Storage Class** - Enables dynamic provisioning of persistent volumes for stateful workloads

:::info When to Skip
If your AKS cluster already has an ingress controller and storage class configured, you can skip the relevant sections and proceed to [Data Layer](./data-layer).
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
  --values ingress-nginx/values-azure.yaml \
  --wait \
  --timeout 900s \
  --dependency-update
```

**Command Breakdown**:

- `upgrade --install` - Installs or upgrades if already exists (idempotent)
- `-n ingress-nginx` - Deploys to the ingress-nginx namespace
- `--values ingress-nginx/values-azure.yaml` - Uses Azure-specific configuration
- `--wait` - Waits for all resources to be ready
- `--timeout 900s` - Maximum wait time (15 minutes)
- `--dependency-update` - Updates chart dependencies before installation

:::warning Installation Time
This step typically takes 5-10 minutes as it provisions an Azure Load Balancer. Do not interrupt the process.
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
- Service should have an `EXTERNAL-IP` assigned (Azure Load Balancer IP)

### Step 4: Configure DNS Record

Create an A record in your Azure Private DNS zone pointing to the ingress controller's load balancer IP:

```bash
# Retrieve ingress controller IP
ingressip=$(kubectl get service ingress-nginx-controller -n ingress-nginx -o jsonpath='{.status.loadBalancer.ingress[0].ip}')

echo "Ingress IP: ${ingressip}"

# Create A record (adjust parameters to match your environment)
az network private-dns record-set a add-record \
  -g CodeMieRG \
  -z private.lab.com \
  -n codemie \
  -a ${ingressip}
```

**Parameters to Adjust**:

- `-g CodeMieRG` - Replace with your resource group name
- `-z private.lab.com` - Replace with your Private DNS zone name
- `-n codemie` - Replace with your desired hostname (subdomain)

:::tip DNS Configuration
These values should match what you configured during infrastructure deployment. Check your `deployment_outputs.env` file for the correct DNS zone and resource group names.
:::

### Verification

Confirm the DNS record was created:

```bash
# List DNS records
az network private-dns record-set a list \
  -g CodeMieRG \
  -z private.lab.com \
  -o table

# Test DNS resolution (from within VNet or via VPN)
nslookup codemie.private.lab.com
```

## Azure Storage Class Installation

The Azure Storage Class enables Kubernetes to dynamically provision Azure Disk volumes for stateful workloads like databases.

### Check Existing Storage Classes

Before installing, verify if a suitable storage class already exists:

```bash
kubectl get storageclass
```

:::info Skip if Already Exists
If your cluster already has appropriate storage classes (typically `managed-premium` or similar), you can skip this installation.
:::

### Install Custom Storage Class

If no suitable storage class exists, install the Azure storage class:

```bash
kubectl apply -f storage-class/storageclass-azure.yaml
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

# DNS record exists
az network private-dns record-set a show \
  -g CodeMieRG \
  -z private.lab.com \
  -n codemie
```

All checks should return successful results before proceeding.

## Next Steps

Once storage and ingress are configured, proceed to **[Data Layer](./data-layer)** installation to deploy Elasticsearch and PostgreSQL components.
