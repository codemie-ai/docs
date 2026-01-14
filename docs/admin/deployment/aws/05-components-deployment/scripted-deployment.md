---
id: components-scripted-deployment
sidebar_position: 1
title: CodeMie Scripted Deployment
sidebar_label: CodeMie Scripted Deployment
pagination_prev: admin/deployment/aws/components-deployment/components-deployment-overview
pagination_next: admin/configuration/index
---

# Scripted CodeMie Components Deployment

This guide walks you through deploying AI/Run CodeMie application components using the automated `helm-charts.sh` deployment script. The script handles the installation of all components in the correct dependency order using Helm charts.

:::tip Recommended Approach
Scripted deployment is recommended for standard installations as it automates component ordering, validates prerequisites, and ensures consistent configuration across all components.
:::

## Overview

The deployment script automates the installation of:

- **Infrastructure services** (Nginx Ingress, Storage Class)
- **Data layer** (Elasticsearch, PostgreSQL Operator)
- **Security components** (Keycloak, OAuth2 Proxy)
- **Messaging system** (NATS)
- **Core CodeMie services** (API, UI, MCP Connect)
- **Observability stack** (Fluent Bit, Kibana)

## Prerequisites

Before starting deployment, ensure you have completed all requirements:

### Verification Checklist

- [ ] **Infrastructure Deployed**: Completed [Infrastructure Deployment](../infrastructure-deployment/) phase
- [ ] **Cluster Access**: kubectl configured for EKS cluster
- [ ] **Container Registry**: Completed [Container Registry Access Setup](./#repository-and-access) from overview page
- [ ] **Helm Installed**: Helm 3.16.0+ installed on deployment machine
- [ ] **Repository Cloned**: `codemie-helm-charts` repository available locally
- [ ] **Domain Configured**: Know your CodeMie domain name from infrastructure outputs
- [ ] **Deployment Outputs**: Have `deployment_outputs.env` file from infrastructure deployment

:::warning Container Registry Access Required
You must complete the Container Registry Access setup from the [Components Deployment Overview](./#repository-and-access) before proceeding. The script requires the `gcp-artifact-registry` pull secret to exist.
:::

### Required Tools

Ensure these tools are available on your deployment machine:

- `kubectl` - Kubernetes cluster management
- `helm` 3.16.0+ - Kubernetes package manager
- `gcloud` CLI - For GCR authentication
- `aws` CLI - For AWS operations

## Quick Start

### Step 1: Clone Repository

Clone the Helm charts repository on your deployment machine:

```bash
git clone git@gitbud.epam.com:epm-cdme/codemie-helm-charts.git
cd codemie-helm-charts
```

### Step 2: Configure AWS-Specific Values

Update AWS-specific values in the CodeMie API configuration. Use values from your `deployment_outputs.env` file:

```bash
# Source the deployment outputs
source deployment_outputs.env

# Update CodeMie API values with AWS-specific configuration
sed -i "s/%%DOMAIN%%/${CODEMIE_DOMAIN_NAME}/g" codemie-api/values-aws.yaml
sed -i "s/%%AWS_DEFAULT_REGION%%/${AWS_DEFAULT_REGION}/g" codemie-api/values-aws.yaml
sed -i "s|%%EKS_AWS_ROLE_ARN%%|${EKS_AWS_ROLE_ARN}|g" codemie-api/values-aws.yaml
sed -i "s/%%AWS_KMS_KEY_ID%%/${AWS_KMS_KEY_ID}/g" codemie-api/values-aws.yaml
sed -i "s/%%AWS_S3_BUCKET_NAME%%/${AWS_S3_BUCKET_NAME}/g" codemie-api/values-aws.yaml
sed -i "s/%%AWS_S3_REGION%%/${AWS_S3_REGION}/g" codemie-api/values-aws.yaml
```

### Step 3: Configure Domain Name

Update the domain name in remaining values files:

```bash
# Use your domain from deployment_outputs.env
YOUR_DOMAIN="${CODEMIE_DOMAIN_NAME}"

# Update all values-aws.yaml files
find . -name "values-aws.yaml" -exec sed -i "s/codemie.example.com/$YOUR_DOMAIN/g" {} \;
```

:::tip Domain Configuration
Your domain name was configured during infrastructure deployment. Find it in `deployment_outputs.env` as `CODEMIE_DOMAIN_NAME`.
:::

### Step 4: Authenticate to Container Registry

Authenticate Helm to the Google Container Registry:

```bash
# Set credentials
export GOOGLE_APPLICATION_CREDENTIALS=key.json

# Login to registry
gcloud auth application-default print-access-token | \
  helm registry login -u oauth2accesstoken --password-stdin europe-west3-docker.pkg.dev
```

### Step 5: Get Latest CodeMie Version

Retrieve the latest AI/Run CodeMie release version:

```bash
# Check latest version
bash get-codemie-latest-release-version.sh -c key.json

# Note the version (e.g., 1.2.3) for next step
```

### Step 6: Run Deployment Script

Execute the deployment script with your chosen mode:

```bash
# For first-time installation (installs all components)
bash helm-charts.sh --cloud aws --version <version> --mode all

# OR for clusters with existing Nginx Ingress
bash helm-charts.sh --cloud aws --version <version> --mode recommended
```

:::tip Idempotent Script
The deployment script is idempotent, meaning you can safely re-run it multiple times. If the script fails or is interrupted, simply run it again with the same parameters to continue or retry the deployment.
:::

## Configuration Reference

### Script Parameters

The deployment script accepts three required parameters:

| Parameter   | Description               | Values                           |
| ----------- | ------------------------- | -------------------------------- |
| `--cloud`   | Target cloud provider     | `aws`, `azure`, `gcp`            |
| `--version` | CodeMie component version | Semantic version (e.g., `1.2.3`) |
| `--mode`    | Installation mode         | `all`, `recommended`, `update`   |

### Deployment Modes

| Mode            | Components Installed                                         | Use Case                                      |
| --------------- | ------------------------------------------------------------ | --------------------------------------------- |
| **all**         | All components including Nginx Ingress Controller            | Fresh EKS cluster without existing ingress    |
| **recommended** | All components except Nginx Ingress Controller               | Cluster with existing ingress controller      |
| **update**      | Only CodeMie core components (API, UI, MCP Connect, Mermaid) | Updating existing installation to new version |

:::tip Choosing Deployment Mode

- **First-time installation**: Use `all` or `recommended` depending on whether you need Nginx Ingress
- **Version updates**: Use `update` to upgrade only CodeMie components
- **Fresh EKS cluster**: Use `all` mode
  :::

### AWS-Specific Configuration Values

The following AWS-specific values must be configured in `codemie-api/values-aws.yaml` (automated by Step 2 in Quick Start):

| Placeholder              | Description                   | Example Value                                    | Source File              |
| ------------------------ | ----------------------------- | ------------------------------------------------ | ------------------------ |
| `%%DOMAIN%%`             | Your domain name              | `example.com`                                    | `deployment_outputs.env` |
| `%%AWS_DEFAULT_REGION%%` | AWS region                    | `us-west-2`                                      | `deployment_outputs.env` |
| `%%EKS_AWS_ROLE_ARN%%`   | IAM role for EKS IRSA         | `arn:aws:iam::0123456789012:role/AWSIRSA_AI_RUN` | `deployment_outputs.env` |
| `%%AWS_KMS_KEY_ID%%`     | AWS KMS key ID for encryption | `50f3f093-dc86-48de-8f2d-7a76e480348c`           | `deployment_outputs.env` |
| `%%AWS_S3_BUCKET_NAME%%` | S3 bucket for user data       | `codemie-user-data-0123456789012`                | `deployment_outputs.env` |
| `%%AWS_S3_REGION%%`      | S3 bucket region              | `us-west-2`                                      | `deployment_outputs.env` |

### Domain Name Configuration

The following files require domain name configuration (automated by Step 3 in Quick Start):

| Component        | File                            | Placeholder           | Example Value         |
| ---------------- | ------------------------------- | --------------------- | --------------------- |
| **Kibana**       | `kibana/values-aws.yaml`        | `codemie.example.com` | `codemie.example.com` |
| **Keycloak**     | `keycloak-helm/values-aws.yaml` | `codemie.example.com` | `codemie.example.com` |
| **OAuth2 Proxy** | `oauth2-proxy/values-aws.yaml`  | `codemie.example.com` | `codemie.example.com` |
| **CodeMie UI**   | `codemie-ui/values-aws.yaml`    | `codemie.example.com` | `codemie.example.com` |
| **CodeMie API**  | `codemie-api/values-aws.yaml`   | `codemie.example.com` | `codemie.example.com` |

## Next Steps

After successful deployment and validation, proceed to:

**[Configuration](../../../configuration/)** - Complete required setup including:

- Initial user configuration in Keycloak
- AI model integration setup
- Data source connections
- Security and access control configuration
- System health monitoring setup
