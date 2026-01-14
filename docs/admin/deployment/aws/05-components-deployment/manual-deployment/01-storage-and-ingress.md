---
id: storage-and-ingress
sidebar_position: 1
title: Storage and Ingress
sidebar_label: Storage and Ingress
pagination_prev: admin/deployment/aws/components-deployment/manual-deployment/manual-deployment-overview
pagination_next: admin/deployment/aws/components-deployment/manual-deployment/data-layer
---

# Storage and Ingress Installation

This guide covers the installation of foundational infrastructure components that provide storage provisioning and external access to your AI/Run CodeMie deployment.

## Overview

This step installs two critical infrastructure components:

- **Nginx Ingress Controller** - Routes external HTTP/HTTPS traffic to services within the cluster
- **AWS gp3 Storage Class** - Enables dynamic provisioning of persistent volumes for stateful workloads

:::info When to Skip
If your EKS cluster already has an ingress controller and storage class configured, you can skip the relevant sections and proceed to [Data Layer](./data-layer).
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
  --values ingress-nginx/values-aws.yaml \
  --wait \
  --timeout 900s \
  --dependency-update
```

**Command Breakdown**:

- `upgrade --install` - Installs or upgrades if already exists (idempotent)
- `-n ingress-nginx` - Deploys to the ingress-nginx namespace
- `--values ingress-nginx/values-aws.yaml` - Uses AWS-specific configuration
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

# Verify service and load balancer hostname
kubectl get service ingress-nginx-controller -n ingress-nginx
```

Expected output:

- Pods should be in `Running` state
- Service should have an `EXTERNAL-IP` assigned (AWS NLB/ALB hostname)

### Step 4: Configure DNS Record

Create a DNS record pointing to the ingress controller's load balancer:

```bash
# Retrieve ingress controller hostname/IP
INGRESS_HOST=$(kubectl get service ingress-nginx-controller -n ingress-nginx -o jsonpath='{.status.loadBalancer.ingress[0].hostname}')

echo "Ingress Host: ${INGRESS_HOST}"
```

**DNS Configuration Options**:

If using **Route 53**:

```bash
# Get your hosted zone ID
HOSTED_ZONE_ID=$(aws route53 list-hosted-zones-by-name \
  --dns-name example.com \
  --query 'HostedZones[0].Id' \
  --output text | cut -d'/' -f3)

# Create CNAME record
aws route53 change-resource-record-sets \
  --hosted-zone-id ${HOSTED_ZONE_ID} \
  --change-batch '{
    "Changes": [{
      "Action": "UPSERT",
      "ResourceRecordSet": {
        "Name": "codemie.example.com",
        "Type": "CNAME",
        "TTL": 300,
        "ResourceRecords": [{"Value": "'${INGRESS_HOST}'"}]
      }
    }]
  }'
```

**Parameters to Adjust**:

- `example.com` - Replace with your domain name
- `codemie.example.com` - Replace with your desired hostname

:::tip DNS Configuration
These values should match what you configured during infrastructure deployment. Check your `deployment_outputs.env` file for the correct domain name.
:::

### Verification

Confirm the DNS record was created:

```bash
# List DNS records in Route 53
aws route53 list-resource-record-sets \
  --hosted-zone-id ${HOSTED_ZONE_ID} \
  --query "ResourceRecordSets[?Name=='codemie.example.com.']"

# Test DNS resolution
nslookup codemie.example.com
```

## AWS gp3 Storage Class Installation

The AWS gp3 Storage Class enables Kubernetes to dynamically provision Amazon EBS gp3 volumes for stateful workloads like databases.

### Check Existing Storage Classes

Before installing, verify if a suitable storage class already exists:

```bash
kubectl get storageclass
```

:::info Skip if Already Exists
If your cluster already has appropriate storage classes (typically `gp2` or `gp3`), you can skip this installation.
:::

### Install Custom Storage Class

If no suitable storage class exists, install the AWS gp3 storage class:

```bash
kubectl apply -f storage-class/storageclass-aws-gp3.yaml
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

# Load balancer has hostname/IP assigned
kubectl get svc -n ingress-nginx ingress-nginx-controller

# Storage class is available
kubectl get storageclass

# DNS record resolves correctly
nslookup codemie.example.com
```

All checks should return successful results before proceeding.

## Next Steps

Once storage and ingress are configured, proceed to **[Data Layer](./data-layer)** installation to deploy Elasticsearch and PostgreSQL components.
