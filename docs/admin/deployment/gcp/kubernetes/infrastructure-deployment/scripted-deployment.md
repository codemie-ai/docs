---
id: infrastructure-scripted-deployment
title: Infrastructure Scripted Deployment
sidebar_label: Scripted Deployment
sidebar_position: 1
pagination_prev: admin/deployment/gcp/kubernetes/infrastructure-deployment/infrastructure-deployment-overview
pagination_next: admin/deployment/gcp/kubernetes/components-deployment/components-deployment-overview
---

# Scripted Infrastructure Deployment

This guide walks you through deploying GCP infrastructure for AI/Run CodeMie using the automated `gcp-terraform.sh` deployment script. The script handles all deployment phases automatically: Terraform state backend and core platform infrastructure.

:::tip Recommended Approach
Scripted deployment is the recommended method as it handles prerequisite checks, configuration validation, and proper sequencing of Terraform operations automatically.
:::

## Prerequisites

Before starting the deployment, ensure you have completed all requirements from the [Prerequisites](../prerequisites.md) page:

### Verification Checklist

- [ ] **GCP Access**: Project Owner or Editor role with IAM permissions
- [ ] **Required APIs Enabled**: Cloud IAP, Service Networking, Secret Manager, Vertex AI APIs
- [ ] **Tools Installed**: tfenv, Terraform 1.13.5, gcloud CLI, kubectl, Helm, Docker
- [ ] **GCP Authentication**: Logged in with gcloud CLI and application default credentials configured
- [ ] **Repository Access**: Have access to Terraform and Helm repositories
- [ ] **Network Planning**: Prepared list of authorized networks (if accessing GKE API from workstation)

:::warning Authentication Required
You must be authenticated to GCP CLI before running Terraform. Run `gcloud auth login` and `gcloud auth application-default login`. Verify the active project with `gcloud config get-value project`.
:::

## Deployment Phases

The script automatically deploys infrastructure in sequential phases:

| Phase                                | Description                                                                        | Required |
| ------------------------------------ | ---------------------------------------------------------------------------------- | -------- |
| **Phase 1: State Backend**           | Creates GCS bucket for Terraform state files                                       | Yes      |
| **Phase 2: Platform Infrastructure** | Deploys GKE, networking, storage, databases, security components, and Bastion Host | Yes      |

## Step 1: Clone Platform Repository

Clone the platform Terraform repository:

```bash
git clone https://gitbud.epam.com/epm-cdme/codemie-terraform-gcp-platform.git
cd codemie-terraform-gcp-platform
```

## Step 2: Configure Platform Deployment

Edit `deployment.conf` file to provide your GCP-specific configuration:

```bash
# GCP project ID where the platform will be deployed
TF_VAR_project_id="my-gcp-project-id"

# GCP region where the platform will be deployed
TF_VAR_region="europe-west3"

# GCS bucket name prefix for Terraform remote state storage
TF_VAR_storage_bucket_name="codemie-terraform-states"

TF_VAR_labels='{"sys_name":"ai_run","environment":"development","project":"ai_run"}'

# Unique platform identifier used in resource naming
TF_VAR_platform_name="codemie"

# Whether to create a private GKE cluster
# Setting to true will also deploy a bastion host for cluster access
TF_VAR_private_cluster=false

# Users/groups who can access the bastion host via IAP (only used when private_cluster = true)
# Format: ["user:email@domain.com", "group:group@domain.com"]
TF_VAR_bastion_members='["user:user@example.com"]'

# Machine type for worker nodes
TF_VAR_node_pool_machine_type="e2-standard-8"
TF_VAR_node_pool_min_count=2
TF_VAR_node_pool_max_count=3

# Additional networks authorized to access the GKE cluster API server
TF_VAR_extra_authorized_networks='[]'

# Optional: Dedicated Cloud SQL Instances Configuration
# Set enabled=true to provision a dedicated Cloud SQL instance for the service.
# Omitted fields fall back to defaults (tier, db_name, username, etc.).
TF_VAR_keycloak_db_config='{"enabled":true}'
TF_VAR_langfuse_db_config='{"enabled":false}'
TF_VAR_litellm_db_config='{"enabled":false}'
```

:::info Complete Variable List
For all available configuration options, refer to the `platform/terraform.tfvars.example` file in the repository.
:::

## Step 3: Run Deployment Script

Execute the automated deployment script:

```bash
bash ./gcp-terraform.sh
```

The script will automatically execute the following operations:

1. **Validate Configuration**: Check `deployment.conf` for required variables
2. **Verify Prerequisites**: Check for required tools (tfenv, terraform, gcloud CLI)
3. **Check Terraform Version**: Ensure correct Terraform version via tfenv
4. **Verify GCP Authentication**: Validate active gcloud session and application default credentials
5. **Deploy State Backend**: Create GCS bucket for Terraform state storage (`remote-backend/`)
6. **Deploy Platform Infrastructure**: Provision core GCP infrastructure (`platform/`)
7. **Generate Outputs**: Create `deployment_outputs.env` with infrastructure details required for the next phases

## Deployment Outputs

Upon successful deployment, the script generates a `deployment_outputs.env` file containing essential infrastructure details needed for the next deployment phase:

```bash
# GKE Cluster
GKE_CLUSTER_NAME=codemie-gke
GKE_LOCATION=europe-west3
GKE_NETWORK=codemie-cluster-network
GKE_SUBNET=codemie-cluster-subnet
KUBECTL_COMMAND=gcloud container clusters get-credentials --project my-gcp-project --zone europe-west3 codemie-gke

# PostgreSQL
CODEMIE_POSTGRES_DATABASE_HOST=<postgres-private-ip>
CODEMIE_POSTGRES_DATABASE_PORT=5432
CODEMIE_POSTGRES_DATABASE_NAME=codemie
CODEMIE_POSTGRES_DATABASE_USER=admin
CODEMIE_POSTGRES_DATABASE_INSTANCE=codemie-postgresql
CODEMIE_POSTGRES_DATABASE_SECRET=codeemiePGDB
CODEMIE_POSTGRES_DATABASE_PASSWORD=generated-password

# GCP
VERTEX_PROJECT=my-gcp-project

# Keycloak PostgreSQL (present when keycloak_db_config.enabled=true)
KEYCLOAK_POSTGRES_DATABASE_HOST=<keycloak-postgres-private-ip>
KEYCLOAK_POSTGRES_DATABASE_PORT=5432
KEYCLOAK_POSTGRES_DATABASE_NAME=keycloak
KEYCLOAK_POSTGRES_DATABASE_USER=keycloak_admin
KEYCLOAK_POSTGRES_DATABASE_INSTANCE=codemie-keycloak-postgresql
KEYCLOAK_POSTGRES_DATABASE_SECRET=codemieKeycloakPGDB
KEYCLOAK_POSTGRES_DATABASE_PASSWORD=generated-password

# LiteLLM PostgreSQL (present when litellm_db_config.enabled=true)
LITELLM_POSTGRES_DATABASE_HOST=<litellm-postgres-private-ip>
LITELLM_POSTGRES_DATABASE_PORT=5432
LITELLM_POSTGRES_DATABASE_NAME=litellm
LITELLM_POSTGRES_DATABASE_USER=litellm_admin
LITELLM_POSTGRES_DATABASE_INSTANCE=codemie-litellm-postgresql
LITELLM_POSTGRES_DATABASE_SECRET=codemieLitellmPGDB
LITELLM_POSTGRES_DATABASE_PASSWORD=generated-password

# Langfuse PostgreSQL (present when langfuse_db_config.enabled=true)
LANGFUSE_POSTGRES_DATABASE_HOST=<langfuse-postgres-private-ip>
LANGFUSE_POSTGRES_DATABASE_PORT=5432
LANGFUSE_POSTGRES_DATABASE_NAME=langfuse
LANGFUSE_POSTGRES_DATABASE_USER=langfuse_admin
LANGFUSE_POSTGRES_DATABASE_INSTANCE=codemie-langfuse-postgresql
LANGFUSE_POSTGRES_DATABASE_SECRET=codemieLangfusePGDB
LANGFUSE_POSTGRES_DATABASE_PASSWORD=generated-password
```

:::tip Save These Outputs
The `deployment_outputs.env` file contains sensitive information. Store it securely, do not commit to version control and reference it during the Components Deployment phase.
:::

## Post-Deployment Validation

After deployment completes, verify that all infrastructure was created successfully:

### Step 1: Verify GCP Resources

```bash
# Verify GKE cluster status
gcloud container clusters list --project=<your-project-id>

# Check Cloud SQL instance
gcloud sql instances list --project=<your-project-id>

# Verify GCS state bucket
gcloud storage buckets list | grep terraform
```

### Step 2: Check Deployment Logs

Review the deployment logs in the `logs/` directory for any warnings or errors:

```bash
less logs/codemie_gcp_deployment_YYYY-MM-DD-HHMMSS.log
```

## Next Steps

After successful infrastructure deployment and validation, proceed to:

**[Components Deployment](../components-deployment/index.md)** - Deploy AI/Run CodeMie application components to your GKE cluster
