---
id: manual-deployment-overview
sidebar_position: 2
title: Manual Deployment Overview
description: Overview of manual component installation process
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

Manual deployment involves installing components individually in a specific dependency order. Each component is deployed using Helm charts with cloud-specific values files (`values-gcp.yaml`).

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
- [ ] **Cluster Access**: Connected to Bastion Host (for private clusters) or have authorized network access and kubectl configured for GKE
- [ ] **Container Registry**: Completed [Container Registry Access Setup](../#repository-and-access) from overview page
- [ ] **Helm Installed**: Helm 3.16.0+ installed on deployment machine
- [ ] **Repository Cloned**: `codemie-helm-charts` repository available locally
- [ ] **Domain Configured**: Know your CodeMie domain name from infrastructure outputs

:::warning Container Registry Access Required
You must complete the Container Registry Access setup from the [Components Deployment Overview](../#repository-and-access) before proceeding. Each component requires the `gcp-artifact-registry` pull secret to exist.
:::

### Required Tools

Ensure these tools are available on your deployment machine (Bastion Host or local workstation):

- `kubectl` - Kubernetes cluster management
- `helm` 3.16.0+ - Kubernetes package manager
- `gcloud` CLI - For GCR authentication
- `bash` - Script execution environment

## Component Installation Order

Components must be installed in the following order to satisfy dependencies:

### 1. [Kubernetes Components](./k8s-components)

**Purpose**: Foundation infrastructure for storage provisioning and external access

**Components**:

- GCP Storage Class (for dynamic volume provisioning)
- Nginx Ingress Controller (for HTTP/HTTPS routing)

**When to Skip**: If your cluster already has these components configured

### 2. [Data Layer](./data-layer)

**Purpose**: Persistent storage for application data and user content

**Components**:

- Elasticsearch (document storage and search engine)
- Kibana (visualization and exploration tool)
- PostgreSQL Operator (database lifecycle management)

**Dependencies**: Requires storage class from Step 1

### 3. [Security and Identity](./security-and-identity)

**Purpose**: User authentication, authorization, and access control

**Components**:

- Keycloak Operator (Keycloak lifecycle management)
- Keycloak (identity and access management)
- OAuth2 Proxy (authentication proxy)

**Dependencies**: None (standalone identity layer)

### 4. [Plugin Engine](./plugin-engine)

**Purpose**: Inter-service messaging and plugin communication infrastructure

**Components**:

- NATS (message broker)
- NATS Auth Callout (authentication service for NATS)

**Dependencies**: None (standalone messaging layer)

### 5. [AI/Run CodeMie Core](./core-components)

**Purpose**: Main application services providing CodeMie functionality

**Components**:

- PostgreSQL Secret (database credentials)
- MCP Connect (Model Context Protocol connector)
- CodeMie UI (frontend web application)
- Mermaid Server (diagram rendering service)
- CodeMie API (backend REST API)

**Dependencies**: Requires all previous components (data layer, security, messaging)

### 6. [Observability](./observability)

**Purpose**: System monitoring, logging aggregation, and operational insights

**Components**:

- Fluent Bit (log collection and forwarding)
- Kibana Dashboards (pre-configured monitoring views)

**Dependencies**: Requires Elasticsearch from Step 2

## Getting Started

### Step 1: Clone Repository

Clone the Helm charts repository on your deployment machine:

```bash
git clone git@gitbud.epam.com:epm-cdme/codemie-helm-charts.git
cd codemie-helm-charts
```

### Step 2: Configure Domain and GCP Parameters

Update the required placeholders in the values files. Replace these values with your GCP-specific configuration:

```bash
# Set your values
DOMAIN="example.com"
PROJECT_ID="my-gcp-project"
REGION="europe-west3"

# Replace domain in all files
find . -name "values-gcp.yaml" -exec sed -i "s/%%DOMAIN%%/$DOMAIN/g" {} \;

# Replace GCP parameters in CodeMie API
sed -i "s/%%GOOGLE_PROJECT_ID%%/$PROJECT_ID/g" codemie-api/values-gcp.yaml
sed -i "s/%%GOOGLE_REGION%%/$REGION/g" codemie-api/values-gcp.yaml
sed -i "s/%%GOOGLE_KMS_PROJECT_ID%%/$PROJECT_ID/g" codemie-api/values-gcp.yaml
sed -i "s/%%GOOGLE_KMS_REGION%%/$REGION/g" codemie-api/values-gcp.yaml
```

:::tip Find Your Values
Your domain name and GCP configuration were set during infrastructure deployment. Check Terraform outputs for `dns_name`, `project_id`, and `region`.
:::

### Step 3: Authenticate to Container Registry

Authenticate Helm to the Google Container Registry:

```bash
# Set credentials path
export GOOGLE_APPLICATION_CREDENTIALS=key.json

# Login to GCR
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

:::warning Respect Installation Order
Installing components out of order will cause deployment failures. Always follow the numbered sequence to ensure dependencies are satisfied.
:::

## Common Issues

### Image Pull Failures

**Symptom**: Pods stuck in `ImagePullBackOff` or `ErrImagePull`

**Solution**:

- Verify `gcp-artifact-registry` secret exists: `kubectl get secret -n codemie`
- Re-authenticate to registry (repeat Step 3)
- Check network connectivity to `europe-west3-docker.pkg.dev`

## Next Steps

Begin the installation process by following the guides in order, starting with **[Kubernetes Components](./k8s-components)**.

After completing all component installations, proceed to **[Configuration](../../../../configuration/)** to configure users, AI models, and data sources.
