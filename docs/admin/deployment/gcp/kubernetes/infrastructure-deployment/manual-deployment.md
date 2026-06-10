---
id: infrastructure-manual-deployment
title: Manual Infrastructure Deployment
sidebar_label: Manual Deployment
sidebar_position: 2
pagination_prev: admin/deployment/gcp/kubernetes/infrastructure-deployment/infrastructure-deployment-overview
pagination_next: admin/deployment/gcp/kubernetes/infrastructure-deployment/infrastructure-bastion-host-access
---

import Tabs from '@theme/Tabs';
import TabItem from '@theme/TabItem';

# Manual Infrastructure Deployment

This guide walks you through deploying GCP infrastructure for AI/Run CodeMie using Terraform with manual step-by-step instructions. This approach provides full control over each deployment phase and allows for customization at every step.

:::tip When to Use Manual Deployment
Use manual deployment when you need:

- Full control over each Terraform operation
- Understanding of each infrastructure component
- Custom configurations or modifications during deployment
- Troubleshooting capabilities at each step
  :::

## Prerequisites

Before starting the deployment, ensure you have completed all requirements from the [Prerequisites](../prerequisites.md) page:

### Verification Checklist

- [ ] **GCP Access**: Project Owner or Editor role with IAM permissions
- [ ] **Required APIs Enabled**: Cloud IAP, Service Networking, Secret Manager, Vertex AI APIs
- [ ] **Tools Installed**: Terraform 1.13.5, gcloud CLI, kubectl, Helm, Docker
- [ ] **GCP Authentication**: Logged in with gcloud CLI and application default credentials configured
- [ ] **Repository Access**: Have access to Terraform and Helm repositories
- [ ] **Network Planning**: Prepared list of authorized networks (if accessing GKE API from workstation)
- [ ] **Domain & Certificate**: DNS zone and TLS certificate ready (for public access) or will use private DNS

:::warning Authentication Required
You must be authenticated to GCP CLI before running Terraform. Run `gcloud auth login` and `gcloud auth application-default login`. Verify the active project with `gcloud config get-value project`.
:::

## Deployment Phases

Manual deployment involves two sequential phases, both within the same repository:

| Phase                                | Description                                                                        | Directory         |
| ------------------------------------ | ---------------------------------------------------------------------------------- | ----------------- |
| **Phase 1: State Backend**           | Creates GCS bucket for Terraform state files                                       | `remote-backend/` |
| **Phase 2: Platform Infrastructure** | Deploys GKE, networking, storage, databases, security components, and Bastion Host | `platform/`       |

:::info Bastion Host
Bastion Host is optional and only required for completely private GKE clusters with private DNS. For public clusters or clusters with authorized networks, you can access GKE API directly.
:::

## Phase 1: Deploy Terraform State Backend

The first step is to create a Google Cloud Storage bucket for storing Terraform state files. This bucket will be used by all subsequent infrastructure deployments to maintain state consistency and enable team collaboration.

:::tip Why This Matters
The state backend ensures that your infrastructure state is stored securely and can be shared across your team. Without this, Terraform state would only exist locally on your machine.
:::

1. Clone the platform repository to your local machine:

```bash
git clone https://gitbud.epam.com/epm-cdme/codemie-terraform-gcp-platform.git
cd codemie-terraform-gcp-platform
```

2. Navigate to the `remote-backend/` directory and configure variables. There are two ways to provide Terraform variables:

```bash
cd remote-backend
```

<Tabs groupId="config-method">
  <TabItem value="deployment-conf" label="Using deployment.conf" default>

Load variables from `deployment.conf` (`set -a` enables auto-export of all variables):

```bash
set -a && source ../deployment.conf && set +a
```

Initialize Terraform and deploy the storage bucket:

```bash
terraform init
terraform plan -out=tfplan
terraform apply tfplan
```

  </TabItem>
  <TabItem value="tfvars" label="Using terraform.tfvars">

Create a `terraform.tfvars` file in the `remote-backend/` directory:

```hcl
project_id           = "your-gcp-project-id"
region               = "europe-west3"
storage_bucket_name  = "codemie-terraform-states"

# Optional: Custom labels
labels = {
  "sys_name"    = "ai_run"
  "environment" = "development"
  "project"     = "ai_run"
}
```

Initialize Terraform and deploy the storage bucket:

```bash
terraform init
terraform plan -out=tfplan
terraform apply tfplan
```

  </TabItem>
</Tabs>

3. After successful deployment, note the bucket name from Terraform outputs:

```bash
export BACKEND_BUCKET=$(terraform output -raw terraform_states_storage_bucket_name)
echo "Backend bucket: $BACKEND_BUCKET"
```

:::tip Next Phase
The storage bucket is now ready. Proceed to Phase 2 to deploy the main platform infrastructure.
:::

## Phase 2: Deploy Platform Infrastructure

This phase deploys all core GCP resources required to run AI/Run CodeMie. This includes the GKE cluster, networking components, databases, and security infrastructure.

1. Navigate to the `platform/` directory:

```bash
cd ../platform
```

2. Configure and deploy. There are two ways to provide Terraform variables:

<Tabs groupId="config-method">
  <TabItem value="deployment-conf" label="Using deployment.conf" default>

Load variables from `deployment.conf`:

```bash
set -a && source ../deployment.conf && set +a
```

Initialize Terraform with backend configuration and deploy:

```bash
terraform init \
  -backend-config="bucket=${BACKEND_BUCKET}" \
  -backend-config="prefix=${TF_VAR_region}/codemie/platform_terraform.tfstate"

terraform plan -out=tfplan
terraform apply tfplan
```

  </TabItem>
  <TabItem value="tfvars" label="Using terraform.tfvars">

Create a `terraform.tfvars` file with your configuration:

```hcl
# GCP Project Configuration
project_id    = "your-gcp-project-id"
platform_name = "codemie"

# Network Access Control (only used when private_cluster = true)
bastion_members = [
  "group:devops@airun.example.com",
  "user:admin@airun.example.com"
]

# DNS Configuration (only used when create_private_dns_zone = true)
dns_name   = "codemie-example-com"
dns_domain = "codemie.airun.example.com."

# GKE API Access (optional)
extra_authorized_networks = [
  {
    cidr_block   = "x.x.x.x/24"
    display_name = "Office Network"
  }
]

# Cluster Configuration
private_cluster = false                       # Set to true for completely private GKE cluster
create_private_dns_zone = false               # Set to true if using private DNS

# Optional: Dedicated Cloud SQL Instances Configuration
# Set enabled = true to provision a dedicated Cloud SQL instance for the service.
# All other fields are optional and fall back to defaults.
keycloak_db_config = { enabled = true }
langfuse_db_config = { enabled = false }
litellm_db_config  = { enabled = false }

# Optional: Dedicated Cloud Memorystore Redis Instance
# Set enabled = true to provision a Memorystore Redis instance for caching.
# Supported fields: enabled, tier (BASIC|STANDARD_HA), memory_size_gb, redis_version.
codemie_cache_config = { enabled = false }
```

:::info Configuration References
For all available variables and their descriptions, see `variables.tf` in the `platform/` directory.
:::

Set the backend bucket and region:

```bash
export BACKEND_BUCKET="your-bucket-name-from-phase1"
export REGION="europe-west3"
```

Initialize Terraform with backend configuration and deploy:

```bash
terraform init \
  -backend-config="bucket=${BACKEND_BUCKET}" \
  -backend-config="prefix=${REGION}/codemie/platform_terraform.tfstate"

terraform plan -out=tfplan
terraform apply tfplan
```

  </TabItem>
</Tabs>

3. After successful deployment, verify all resources were created correctly:

```bash
# View Terraform outputs
terraform output

# Verify GKE cluster exists
gcloud container clusters list --project=<your-project-id>

# Check Cloud SQL instance
gcloud sql instances list --project=<your-project-id>
```

**Save the Terraform outputs** — they contain critical information needed for subsequent steps, including:

- GKE cluster connection commands
- Bastion Host SSH/RDP commands
- Cloud SQL connection details (`pg_host`, `pg_port`, `pg_database`, `pg_user`, `pg_secret_name`)
- Keycloak Cloud SQL details (`keycloak_pg_host`, `keycloak_pg_database`, `keycloak_pg_user`, `keycloak_pg_secret_name`) — present when `keycloak_db_config.enabled = true`
- LiteLLM Cloud SQL details (`litellm_pg_host`, `litellm_pg_database`, `litellm_pg_user`, `litellm_pg_secret_name`) — present when `litellm_db_config.enabled = true`
- Langfuse Cloud SQL details (`langfuse_pg_host`, `langfuse_pg_database`, `langfuse_pg_user`, `langfuse_pg_secret_name`) — present when `langfuse_db_config.enabled = true`
- Cache details (`codemie_cache_address`, `codemie_cache_secret`) — present when `codemie_cache_config.enabled = true`
- Service account information

:::tip Infrastructure Ready
The GCP infrastructure deployment is now complete. You can proceed to configure cluster access or continue with components deployment.
:::

## Next Steps

After successful infrastructure deployment:

- **Private GKE cluster with private DNS** — proceed to [Bastion Host Access Configuration](./bastion-host-access.md) to set up secure access before deploying components.
- **Public cluster or authorized networks** — proceed directly to [Components Deployment](../components-deployment/index.md).
