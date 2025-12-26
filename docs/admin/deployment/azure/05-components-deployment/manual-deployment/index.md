---
id: manual-deployment-overview
sidebar_position: 2
title: Manual Deployment Overview
description: Overview of manual component installation process
pagination_next: admin/deployment/azure/components-deployment/manual-deployment/storage-and-ingress
---

# Manual CodeMie Components Deployment

This guide provides step-by-step instructions for manually deploying AI/Run CodeMie application components using Helm charts. Manual deployment gives you granular control over each component installation, allowing for customization and troubleshooting at each stage.

:::info When to Use Manual Deployment
Use manual deployment when you need:

- Fine-grained control over individual component configuration
- Custom installation order or selective component deployment
- Troubleshooting capabilities at each deployment stage
- Integration with existing infrastructure components

If you prefer automated deployment, see [Scripted Deployment](../components-scripted-deployment) instead.
:::

## Overview

Manual deployment involves installing components individually in a specific dependency order. Each component is deployed using Helm charts with cloud-specific values files (`values-azure.yaml`).

### Deployment Scope

This guide covers all components required for a fully functional AI/Run CodeMie installation:

- **Infrastructure services** - Storage provisioning and ingress routing
- **Data layer** - Document storage and relational databases
- **Security components** - Identity management and authentication proxies
- **Messaging system** - Inter-service communication infrastructure
- **Core CodeMie services** - Main application components
- **Observability stack** - Logging and monitoring dashboards

## Prerequisites

Before starting manual deployment, ensure you have completed all requirements:

### Verification Checklist

- [ ] **Infrastructure Deployed**: Completed [Infrastructure Deployment](../../infrastructure-deployment/) phase
- [ ] **Cluster Access**: Connected to Jumpbox VM and kubectl configured for AKS
- [ ] **Container Registry**: Completed [Container Registry Access Setup](../#repository-and-access) from overview page
- [ ] **Helm Installed**: Helm 3.16.0+ installed on deployment machine
- [ ] **Repository Cloned**: `codemie-helm-charts` repository available locally
- [ ] **Domain Configured**: Know your CodeMie domain name from infrastructure outputs
- [ ] **Version Identified**: Know which CodeMie version you're deploying

:::warning Container Registry Access Required
You must complete the Container Registry Access setup from the [Components Deployment Overview](../#repository-and-access) before proceeding. Each component requires the `gcp-artifact-registry` pull secret to exist.
:::

### Required Tools

Ensure these tools are available on your deployment machine (Jumpbox):

- `kubectl` - Kubernetes cluster management
- `helm` 3.16.0+ - Kubernetes package manager
- `gcloud` CLI - For GCR authentication
- `az` CLI - For Azure operations

## Component Installation Order

Components must be installed in the following order to satisfy dependencies:

### 1. [Storage and Ingress](./storage-and-ingress)

**Purpose**: Foundation infrastructure for storage provisioning and external access

**Components**:

- Azure Storage Class (for dynamic volume provisioning)
- Nginx Ingress Controller (for HTTP/HTTPS routing)

**When to Skip**: If your cluster already has these components configured

### 2. [Data Layer](./data-layer)

**Purpose**: Persistent storage for application data and user content

**Components**:

- Elasticsearch (document storage and search engine)
- PostgreSQL Operator (database lifecycle management)
- PostgreSQL (relational database instances)

**Dependencies**: Requires storage class from Step 1

### 3. [Security and Identity](./security-and-identity)

**Purpose**: User authentication, authorization, and access control

**Components**:

- Keycloak Operator (Keycloak lifecycle management)
- Keycloak (identity and access management)
- OAuth2 Proxy (authentication proxy)

**Dependencies**: Requires PostgreSQL from Step 2

### 4. [Plugin Engine](./plugin-engine)

**Purpose**: Inter-service messaging and plugin communication infrastructure

**Components**:

- NATS (message broker)
- NATS Auth Callout (authentication service for NATS)

**Dependencies**: None (standalone messaging layer)

### 5. [AI/Run CodeMie Core](./core-components)

**Purpose**: Main application services providing CodeMie functionality

**Components**:

- CodeMie API (backend REST API)
- CodeMie UI (frontend web application)
- MCP Connect (Model Context Protocol connector)
- Mermaid Server (diagram rendering service)

**Dependencies**: Requires all previous components (data layer, security, messaging)

### 6. [Observability](./observability)

**Purpose**: System monitoring, logging aggregation, and operational insights

**Components**:

- Fluent Bit (log collection and forwarding)
- Kibana (log visualization and analysis)
- Kibana Dashboards (pre-configured monitoring views)

**Dependencies**: Requires Elasticsearch from Step 2

## Getting Started

### Step 1: Clone Repository

Clone the Helm charts repository on your Jumpbox VM:

```bash
git clone git@gitbud.epam.com:epm-cdme/codemie-helm-charts.git
cd codemie-helm-charts
```

### Step 2: Configure Domain Name

Update the domain name in values files. Replace `codemie.example.com` with your actual domain, or leave it if using the default one:

```bash
# Use your domain from deployment_outputs.env
YOUR_DOMAIN="codemie.example.com"

# Update all values-azure.yaml files
find . -name "values-azure.yaml" -exec sed -i "s/codemie.example.com/$YOUR_DOMAIN/g" {} \;

# Update domain placeholder in CodeMie API values
sed -i "s/%%DOMAIN%%/example.com/g" codemie-api/values-azure.yaml
```

:::tip Domain Configuration
Your domain name was configured during infrastructure deployment. Find it in `deployment_outputs.env` as `CODEMIE_DOMAIN_NAME`.
:::

### Step 3: Authenticate to Container Registry

Authenticate Helm to the Google Container Registry:

```bash
# Set credentials
export GOOGLE_APPLICATION_CREDENTIALS=key.json

# Login to registry
gcloud auth application-default print-access-token | \
  helm registry login -u oauth2accesstoken --password-stdin europe-west3-docker.pkg.dev
```

### Step 4: Get Latest CodeMie Version

Retrieve the latest AI/Run CodeMie release version:

```bash
# Check latest version
bash get-codemie-latest-release-version.sh -c key.json

# Note the version (e.g., 1.2.3) for component installations
```

You'll use this version when installing each component's Helm chart.

## Installation Process

Follow the component installation guides in the order listed above. Each guide provides:

- Detailed installation commands
- Configuration options
- Validation steps
- Troubleshooting guidance

:::tip Installation Duration
Manual deployment typically takes 60-90 minutes to complete all components. You can pause between components if needed, as each step is independent once prerequisites are met.
:::

:::warning Respect Installation Order
Installing components out of order will cause deployment failures. Always follow the numbered sequence to ensure dependencies are satisfied.
:::

## Best Practices

### Before You Begin

1. **Review all guides first** - Familiarize yourself with the complete installation flow
2. **Prepare configuration values** - Have your domain name, version number, and any custom settings ready
3. **Set up monitoring** - Keep a terminal window open with `kubectl get pods -n codemie -w` to watch deployments
4. **Document customizations** - Note any deviations from default configurations for future reference

### During Installation

1. **Verify each component** - Don't proceed to the next component until the current one is healthy
2. **Check pod status** - Wait for all pods to reach `Running` or `Completed` state before continuing
3. **Review logs for errors** - If a component fails, check logs before attempting fixes
4. **Save configurations** - Keep copies of any modified values files

### Validation Commands

Use these commands after each component installation:

```bash
# Check pod status
kubectl get pods -n codemie

# View specific component
kubectl get pods -n codemie | grep <component-name>

# Check logs
kubectl logs -n codemie <pod-name> --tail=50

# Describe pod for events
kubectl describe pod -n codemie <pod-name>
```

## Common Issues

### Image Pull Failures

**Symptom**: Pods stuck in `ImagePullBackOff` or `ErrImagePull`

**Solution**:

- Verify `gcp-artifact-registry` secret exists: `kubectl get secret -n codemie`
- Re-authenticate to registry (repeat Step 3)
- Check network connectivity to `europe-west3-docker.pkg.dev`

### Dependency Errors

**Symptom**: Component fails to start with connection or dependency errors

**Solution**:

- Verify prerequisite components are running
- Check component installation order was followed
- Review service endpoints: `kubectl get svc -n codemie`

### Resource Constraints

**Symptom**: Pods remain in `Pending` state

**Solution**:

- Check node resources: `kubectl top nodes`
- Review PVC status: `kubectl get pvc -n codemie`
- Verify storage class exists: `kubectl get storageclass`

## Next Steps

Begin the installation process by following the guides in order, starting with **[Storage and Ingress](./storage-and-ingress)**.

After completing all component installations, proceed to **[Configuration](../../../../configuration/)** to configure users, AI models, and data sources.
