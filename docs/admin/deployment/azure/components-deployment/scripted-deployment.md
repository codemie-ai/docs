---
id: components-scripted-deployment
sidebar_position: 1
title: CodeMie Scripted Deployment
sidebar_label: CodeMie Scripted Deployment
pagination_prev: admin/deployment/azure/components-deployment/components-deployment-overview
pagination_next: admin/deployment/azure/accessing-applications
---

# Scripted CodeMie Components Deployment

This guide walks you through deploying AI/Run CodeMie application components using the automated `helm-charts.sh` deployment script. The script handles the installation of all components in the correct dependency order using Helm charts.

:::tip Recommended Approach
Scripted deployment is recommended for standard installations as it automates component ordering, validates prerequisites, and ensures consistent configuration across all components.
:::

## Overview

The deployment script automates the installation of:

- **Infrastructure services** (Nginx Ingress, Storage Class)
- **Data layer** (Elasticsearch)
- **Security components** (Keycloak, OAuth2 Proxy)
- **Messaging system** (NATS)
- **Core CodeMie services** (API, UI, MCP Connect)
- **Observability stack** (Fluent Bit, Kibana)

## Prerequisites

Before starting deployment, ensure you have completed all requirements:

### Verification Checklist

- [ ] **Infrastructure Deployed**: Completed [Infrastructure Deployment](../infrastructure-deployment/index.md) phase
- [ ] **Cluster Access**: Connected to Jumpbox VM and kubectl configured for AKS
- [ ] **Container Registry**: Completed [Container Registry Access Setup](./index.md#repository-and-access) from overview page
- [ ] **Helm Installed**: Helm 3.16.0+ installed on deployment machine
- [ ] **Repository Cloned**: `codemie-helm-charts` repository available locally
- [ ] **Domain Configured**: Know your CodeMie domain name from infrastructure outputs
- [ ] **Deployment Outputs File**: Have `deployment_outputs.env` from infrastructure deployment

:::warning Container Registry Access Required
You must complete the Container Registry Access setup from the [Components Deployment Overview](./index.md#repository-and-access) before proceeding. The script requires the `gcp-artifact-registry` pull secret to exist.
:::

### Required Tools

Ensure these tools are available on your deployment machine (Jumpbox):

- `kubectl` - Kubernetes cluster management
- `helm` 3.16.0+ - Kubernetes package manager
- `gcloud` CLI - For GCR authentication
- `az` CLI - For Azure operations

## Quick Start

### Step 1: Clone Repository

Clone the Helm charts repository on your Jumpbox VM:

```bash
git clone git@gitbud.epam.com:epm-cdme/codemie-helm-charts.git
cd codemie-helm-charts
```

### Step 2: Configure Domain Name

Update the DNS zone name in values files. Replace `private.lab.com` with your actual DNS zone name, or leave it if using the default one:

```bash
# Use your DNS zone name from deployment_outputs.env
CODEMIE_DOMAIN_NAME="airun.example.com"

# Update all values-azure.yaml files
find . -name "values-azure.yaml" -exec sed -i "s/private.lab.com/$CODEMIE_DOMAIN_NAME/g" {} \;

# Update domain placeholder in CodeMie API values
sed -i "s/private.lab.com/$CODEMIE_DOMAIN_NAME/g" codemie-api/values-azure.yaml
```

:::tip Domain Configuration
Your DNS zone name was configured during infrastructure deployment. Find it in `deployment_outputs.env` as `CODEMIE_DOMAIN_NAME`.
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

# Note the version (e.g., 1.2.3) for next step
```

### Step 5: Run Deployment Script

Execute the deployment script with your chosen mode:

```bash
# For first-time installation (installs all components)
bash helm-charts.sh --cloud azure --version <version> --mode all

# OR for clusters with existing Nginx Ingress
bash helm-charts.sh --cloud azure --version <version> --mode recommended
```

:::tip Idempotent Script
The deployment script is idempotent, meaning you can safely re-run it multiple times. If the script fails or is interrupted, simply run it again with the same parameters to continue or retry the deployment.
:::

## Configuration Reference

### Script Parameters

The deployment script accepts three required parameters:

| Parameter   | Description               | Values                           |
| ----------- | ------------------------- | -------------------------------- |
| `--cloud`   | Target cloud provider     | `azure`, `aws`, `gcp`            |
| `--version` | CodeMie component version | Semantic version (e.g., `1.2.3`) |
| `--mode`    | Installation mode         | `all`, `recommended`, `update`   |

### Deployment Modes

| Mode            | Components Installed                                         | Use Case                                      |
| --------------- | ------------------------------------------------------------ | --------------------------------------------- |
| **all**         | All components including Nginx Ingress Controller            | Fresh AKS cluster without existing ingress    |
| **recommended** | All components except Nginx Ingress Controller               | Cluster with existing ingress controller      |
| **update**      | Only CodeMie core components (API, UI, MCP Connect, Mermaid) | Updating existing installation to new version |

:::tip Choosing Deployment Mode

- **First-time installation**: Use `all` or `recommended` depending on whether you need Nginx Ingress
- **Version updates**: Use `update` to upgrade only CodeMie components
- **Fresh AKS cluster**: Use `all` mode
  :::

### Domain Name Configuration

The following files require domain name configuration (automated by Step 2 in Quick Start):

| Component        | File                              | Placeholder               | Example Value               |
| ---------------- | --------------------------------- | ------------------------- | --------------------------- |
| **Kibana**       | `kibana/values-azure.yaml`        | `*.private.lab.com`       | `*.airun.example.com`       |
| **Keycloak**     | `keycloak-helm/values-azure.yaml` | `*.private.lab.com`       | `*.airun.example.com`       |
| **OAuth2 Proxy** | `oauth2-proxy/values-azure.yaml`  | `*.private.lab.com`       | `*.airun.example.com`       |
| **CodeMie UI**   | `codemie-ui/values-azure.yaml`    | `codemie.private.lab.com` | `codemie.airun.example.com` |
| **CodeMie API**  | `codemie-api/values-azure.yaml`   | `*.private.lab.com`       | `*.airun.example.com`       |

## Next Steps

After successful deployment and validation, proceed to:

**[Accessing Applications](../accessing-applications.md)** - Learn how to access the deployed AI/Run CodeMie applications and complete the required configuration steps.
