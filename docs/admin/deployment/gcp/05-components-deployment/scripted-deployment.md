---
id: components-scripted-deployment
title: Scripted Components Deployment
sidebar_label: CodeMie Scripted Deployment
sidebar_position: 1
pagination_prev: admin/deployment/gcp/components-deployment/components-deployment-overview
pagination_next: admin/deployment/gcp/accessing-applications
---

# Scripted CodeMie Components Deployment

This guide walks you through deploying AI/Run CodeMie application components using the automated `helm-charts.sh` deployment script. The script handles the installation of all components in the correct dependency order using Helm charts.

:::tip Recommended Approach
Scripted deployment is recommended for standard installations as it automates component ordering, validates prerequisites, and ensures consistent configuration across all components.
:::

## Overview

The `helm-charts.sh` script from the [codemie-helm-charts](https://gitbud.epam.com/epm-cdme/codemie-helm-charts) repository automates the installation of:

- **Infrastructure services** (Nginx Ingress, GCP Storage Class)
- **Data layer** (Elasticsearch, PostgreSQL Operator)
- **Security components** (Keycloak Operator, Keycloak, OAuth2 Proxy)
- **Messaging system** (NATS, NATS Auth Callout)
- **Core CodeMie services** (API, UI, MCP Connect, Mermaid Server)
- **Observability stack** (Fluent Bit, Kibana, Kibana Dashboards)

The script supports flexible deployment modes, allowing you to install all components at once or deploy specific component groups based on your needs.

## Prerequisites

Before starting deployment, ensure you have completed all requirements:

### Verification Checklist

- [ ] **Infrastructure Deployed**: Completed [Infrastructure Deployment](../infrastructure-deployment/) phase
- [ ] **Cluster Access**: Connected to Bastion Host (for private clusters) or have authorized network access and kubectl configured for GKE
- [ ] **Container Registry**: Completed [Container Registry Access Setup](./#repository-and-access) from overview page
- [ ] **Helm Installed**: Helm 3.16.0+ installed on deployment machine
- [ ] **Repository Cloned**: `codemie-helm-charts` repository available locally
- [ ] **Domain Configured**: Know your CodeMie domain name from infrastructure outputs

:::warning Container Registry Access Required
You must complete the Container Registry Access setup from the [Components Deployment Overview](./#repository-and-access) before proceeding. The script requires the `gcp-artifact-registry` pull secret to exist.
:::

### Required Tools

Ensure these tools are available on your deployment machine (Bastion Host or local workstation):

- `kubectl` - Kubernetes cluster management
- `helm` 3.16.0+ - Kubernetes package manager
- `gcloud` CLI - For GCR authentication
- `bash` - Script execution environment

## Quick Start

Follow these steps for a standard private cluster deployment:

### Step 1: Clone Repository

Clone the Helm charts repository on your deployment machine:

```bash
git clone git@gitbud.epam.com:epm-cdme/codemie-helm-charts.git
cd codemie-helm-charts
```

### Step 2: Configure Domain and GCP Parameters

Update the required placeholders in the values files. Replace these values with your GCP-specific configuration:

| Placeholder                 | Description             | Example Value    | Files to Edit                            |
| --------------------------- | ----------------------- | ---------------- | ---------------------------------------- |
| `%%DOMAIN%%`                | Your domain name        | `example.com`    | All `values-gcp.yaml` files listed below |
| `%%GOOGLE_PROJECT_ID%%`     | GCP project ID          | `my-project-123` | `codemie-api/values-gcp.yaml`            |
| `%%GOOGLE_REGION%%`         | GCP region              | `europe-west3`   | `codemie-api/values-gcp.yaml`            |
| `%%GOOGLE_KMS_PROJECT_ID%%` | GCP project ID with KMS | `my-project-123` | `codemie-api/values-gcp.yaml`            |
| `%%GOOGLE_KMS_REGION%%`     | GCP region with KMS     | `europe-west3`   | `codemie-api/values-gcp.yaml`            |

**Files requiring domain configuration:**

- `kibana/values-gcp.yaml`
- `keycloak-helm/values-gcp.yaml`
- `oauth2-proxy/values-gcp.yaml`
- `codemie-ui/values-gcp.yaml`
- `codemie-api/values-gcp.yaml`

:::tip Find Your Values
Your domain name and GCP configuration were set during infrastructure deployment. Check Terraform outputs for `dns_name`, `project_id`, and `region`.
:::

**Example sed commands to replace placeholders:**

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

### Step 3: Create Service Account Key

Create a service account key for Kubernetes to access GCP services:

1. Access "IAM & Admin" in Google Cloud Console
2. Locate the "codemie-gsa" service account (created by Terraform)
3. Create a new JSON key for this service account
4. Download and save the key file to `codemie-helm-charts/codemie-gsa-key.json`

```bash
# Verify the key file exists
ls -la codemie-gsa-key.json
```

:::warning Key Security
Keep this service account key secure. It grants access to GCP resources including Vertex AI and Cloud KMS.
:::

### Step 4: Configure LoadBalancer Type (Private vs Public)

Choose your access model before running the deployment script. The default configuration is for **private access** (recommended).

#### Option A: Private Access (Default - No Changes Needed)

For private cluster deployment with access via Bastion Host, **no changes are required**. The default Helm values are pre-configured for Internal LoadBalancer:

```yaml
# Default configuration (already set)
ingress-nginx:
  controller:
    service:
      annotations:
        networking.gke.io/load-balancer-type: Internal
```

Skip to [Step 5](#step-5-authenticate-to-container-registry).

#### Option B: Public Access (Requires Configuration)

:::warning Prerequisites for Public Access

- Infrastructure deployed with **public DNS zone**
- Valid **TLS certificate** for your domain
- **Authorized IP ranges** defined (never leave open to 0.0.0.0/0)
  :::

If you need public access from external networks, modify these files **before running the deployment script**:

**1. Modify Nginx Ingress Controller**

Edit `codemie-helm-charts/ingress-nginx/values-gcp.yaml`:

```yaml
ingress-nginx:
  controller:
    service:
      # Remove the Internal annotation for public LoadBalancer
      annotations: {}
      type: LoadBalancer
      # Define allowed IP ranges (REQUIRED for security)
      loadBalancerSourceRanges:
        - x.x.x.x/24          # Your office network
        - x.x.x.x/24          # Your VPN network
      enableHttp: false       # Force HTTPS only
```

:::danger Security Critical
Never deploy a public LoadBalancer without `loadBalancerSourceRanges` configured. This would expose your application to the entire internet.
:::

**2. Modify NATS Service**

Edit `codemie-helm-charts/codemie-nats/values-gcp.yaml`:

```yaml
service:
  merge:
    metadata:
      # Remove the Internal annotation
      annotations: {}
    spec:
      type: LoadBalancer
      # Define allowed IP ranges for NATS access
      loadBalancerSourceRanges:
        - x.x.x.x/24          # Your office network
```

**3. Configure TLS Certificates**

For public access, create and configure TLS certificates:

```bash
# Create namespace
kubectl create ns codemie

# Create TLS secret from your certificate files
kubectl -n codemie create secret tls custom-tls \
  --key ${KEY_FILE} \
  --cert ${CERT_FILE}

# Copy secret to other namespaces
kubectl get secret custom-tls -n codemie -o yaml | sed '/namespace:/d' | kubectl apply -n security -f -
kubectl get secret custom-tls -n codemie -o yaml | sed '/namespace:/d' | kubectl apply -n elastic -f -
kubectl get secret custom-tls -n codemie -o yaml | sed '/namespace:/d' | kubectl apply -n oauth2-proxy -f -
```

**4. Enable TLS in Ingress Configuration**

Uncomment and configure the `ingress.tls` section in these files:

- `codemie-api/values-gcp.yaml`
- `codemie-ui/values-gcp.yaml`
- `kibana/values-gcp.yaml`
- `keycloak-helm/values-gcp.yaml`
- `codemie-nats/values-gcp.yaml`

Example configuration:

```yaml
tls:
  - secretName: custom-tls
    hosts:
      - example.com          # Replace with your domain
```

:::info Certificate Management
You can use [cert-manager](https://cert-manager.io/) for automatic certificate management, but this is not covered in this guide.
:::

### Step 5: Authenticate to Container Registry

Authenticate Helm to the Google Container Registry:

```bash
# Set credentials path
export GOOGLE_APPLICATION_CREDENTIALS=key.json

# Login to GCR
gcloud auth application-default print-access-token | \
  helm registry login -u oauth2accesstoken --password-stdin europe-west3-docker.pkg.dev
```

### Step 6: Get Latest CodeMie Version

Retrieve the latest AI/Run CodeMie release version:

```bash
# Check latest version
bash get-codemie-latest-release-version.sh -c key.json

# Note the version output (e.g., 1.2.3) for the next step
```

### Step 7: Run Deployment Script

Execute the deployment script with your chosen mode:

```bash
# For first-time installation (installs all components including Nginx Ingress)
bash helm-charts.sh --cloud gcp --version <version> --mode all
```

Replace `<version>` with the version from Step 5 (e.g., `1.2.3`).

:::tip Idempotent Script
The deployment script is idempotent, meaning you can safely re-run it multiple times. If the script fails or is interrupted, simply run it again with the same parameters to continue or retry the deployment.
:::

## Configuration Reference

### Script Parameters

The deployment script accepts three required parameters:

| Parameter   | Description               | Allowed Values                   |
| ----------- | ------------------------- | -------------------------------- |
| `--cloud`   | Target cloud provider     | `gcp`, `aws`, `azure`            |
| `--version` | CodeMie component version | Semantic version (e.g., `1.2.3`) |
| `--mode`    | Installation mode         | `all`, `recommended`, `update`   |

### Deployment Modes

| Mode            | Components Installed                                         | Use Case                                        |
| --------------- | ------------------------------------------------------------ | ----------------------------------------------- |
| **all**         | All components including Nginx Ingress Controller            | Fresh GKE cluster without existing ingress      |
| **recommended** | All components except Nginx Ingress Controller               | Cluster with existing ingress controller        |
| **update**      | Only CodeMie core components (API, UI, MCP Connect, Mermaid) | Updating existing installation to a new version |

:::tip Choosing Deployment Mode

- **First-time installation**: Use `all` or `recommended` depending on whether you need Nginx Ingress
- **Version updates**: Use `update` to upgrade only CodeMie components
- **Fresh GKE cluster**: Use `all` mode
  :::

## Advanced Configuration

### Setting up DNS Records

After deployment completes and LoadBalancers are provisioned, configure DNS records to make applications accessible.

:::info When DNS is Required

- **Private clusters with private DNS**: DNS is automatically configured by Terraform
- **Public clusters**: You must manually add DNS A records to your DNS provider
  :::

#### Required DNS Records

**1. Wildcard Record for Nginx Ingress Controller**

This allows access to all subdomains managed by Nginx (CodeMie UI, API, Keycloak, Kibana):

| Field     | Value                                       |
| --------- | ------------------------------------------- |
| **Type**  | A                                           |
| **Name**  | `*` (wildcard)                              |
| **Value** | LoadBalancer IP of Nginx Ingress Controller |

Get the Nginx Ingress IP:

```bash
kubectl get service ingress-nginx-controller -n ingress-nginx \
  -o jsonpath='{.status.loadBalancer.ingress[0].ip}'
```

**2. NATS Record for Plugin Engine**

This allows direct access to NATS for the CodeMie Plugin Engine:

| Field     | Value                   |
| --------- | ----------------------- |
| **Type**  | A                       |
| **Name**  | `nats-codemie`          |
| **Value** | LoadBalancer IP of NATS |

Get the NATS service IP:

```bash
kubectl get service codemie-nats -n codemie \
  -o jsonpath='{.status.loadBalancer.ingress[0].ip}'
```

**Example DNS Configuration:**

```
*.example.com           A   x.x.x.x
nats-codemie.example.com A   x.x.x.x
```

## Next Steps

After successful deployment and validation, proceed to:

**[Accessing Applications](../accessing-applications)** - Learn how to access the deployed AI/Run CodeMie applications and complete the required configuration steps.
