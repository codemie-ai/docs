---
id: infrastructure-manual-deployment
title: Manual Infrastructure Deployment
sidebar_label: Manual Deployment
sidebar_position: 2
pagination_prev: admin/deployment/gcp/infrastructure-deployment/infrastructure-deployment-overview
pagination_next: admin/deployment/gcp/components-deployment/components-deployment-overview
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

Before starting the deployment, ensure you have completed all requirements from the [Prerequisites](../prerequisites) page:

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
private_cluster         = false
create_private_dns_zone = false
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
- Cloud SQL connection details

:::tip Infrastructure Ready
The GCP infrastructure deployment is now complete. You can proceed to configure cluster access or continue with components deployment.
:::

## Bastion Host Access Configuration (Optional)

:::warning Private Cluster Only
This section is only required if you deployed a **completely private GKE cluster** with private DNS. For public clusters or clusters with authorized networks configured, you can access the GKE API and CodeMie application directly from your workstation.
:::

The Bastion Host is a secure jump server that provides access to your private GKE cluster and applications running inside the VPC. This VM enables both command-line management (SSH) and browser-based access (RDP) to internal resources.

### Connection Methods Overview

| Connection Type | Use Case                                                      | Access Method         |
| --------------- | ------------------------------------------------------------- | --------------------- |
| **SSH**         | Deploy and manage Kubernetes workloads using kubectl and Helm | Terminal/SSH client   |
| **RDP**         | Access web UIs exposed via private DNS (Kibana, Keycloak)     | Remote Desktop client |

### Option 1: SSH Connection for Cluster Management

Use SSH to connect to the Bastion Host for deploying and managing Kubernetes resources.

1. Retrieve the SSH command from Terraform outputs and connect:

```bash
# Get the SSH connection command
terraform output bastion_ssh_command

# Example output:
# gcloud compute ssh bastion-vm --project=your-project --zone=europe-west3-a

# Use this command to connect
gcloud compute ssh bastion-vm --project=your-project --zone=europe-west3-a
```

:::tip IAM Permissions
Ensure your user account is listed in `bastion_members` variable from Phase 2 configuration. Only authorized users can SSH into the Bastion Host.
:::

#### Step 2: Set user password (Required for RDP)

After connecting via SSH, set a password for the `ubuntu` user for later RDP access:

```bash
# Set password for the ubuntu user (you'll be prompted to enter it twice)
sudo passwd ubuntu
```

:::info Save Your Password
The `ubuntu` user password you set here will be used to login via RDP. Make sure to remember it or store it securely.
:::

3. Fetch GKE cluster credentials to enable kubectl commands:

```bash
# Get the kubectl configuration command
terraform output get_kubectl_credentials_for_private_cluster

# Example output:
# gcloud container clusters get-credentials your-cluster-name --region=europe-west3 --project=your-project

# Run the command to configure kubectl
gcloud container clusters get-credentials your-cluster-name --region=europe-west3 --project=your-project
```

4. Clone the Helm charts repository needed for component deployment:

```bash
git clone https://gitbud.epam.com/epm-cdme/codemie-helm-charts.git
cd codemie-helm-charts
```

You're now ready to proceed with [Components Deployment](../components-deployment).

### Option 2: RDP Connection for Web UI Access

Use RDP to access application web interfaces that are only available via private DNS (such as Kibana, Keycloak Admin Console).

:::tip When to Use RDP
RDP is useful when you need to access web-based administrative interfaces that aren't exposed publicly. For kubectl/Helm operations, SSH access is sufficient.
:::

1. Retrieve the RDP forwarding command from Terraform outputs and start the IAP tunnel:

```bash
# Get the RDP forwarding command
terraform output bastion_rdp_command

# Example output:
# gcloud compute start-iap-tunnel bastion-vm 3389 --local-host-port=localhost:3389 --zone=europe-west3-a --project=your-project
```

Run the command to create an IAP tunnel that forwards RDP traffic (keep this terminal open):

```bash
gcloud compute start-iap-tunnel bastion-vm 3389 \
  --local-host-port=localhost:3389 \
  --zone=europe-west3-a \
  --project=your-project
```

2. Open your Remote Desktop client and connect:

| Setting      | Value                      |
| ------------ | -------------------------- |
| **Computer** | `localhost:3389`           |
| **Username** | `ubuntu`                   |
| **Password** | Password set in SSH Step 2 |

### Tips for Using the Bastion Host

#### Pasting Commands into Terminal

Use the correct keyboard shortcut for pasting in Linux terminal:

```
Shift + Ctrl + V
```

(Regular `Ctrl + V` won't work in most Linux terminal applications)

#### File Transfer to/from Bastion

Transfer files between your local machine and Bastion using `gcloud scp`:

```bash
# Upload file to Bastion
gcloud compute scp local-file.txt bastion-vm:~/remote-file.txt \
  --project=your-project --zone=europe-west3-a

# Download file from Bastion
gcloud compute scp bastion-vm:~/remote-file.txt ./local-file.txt \
  --project=your-project --zone=europe-west3-a
```

## Next Steps

After successful infrastructure deployment, proceed to [Components Deployment](../components-deployment/) to install AI/Run CodeMie application components.
