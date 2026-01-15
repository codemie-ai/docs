---
id: infrastructure-manual-deployment
title: Manual Infrastructure Deployment
sidebar_label: Manual Deployment
sidebar_position: 1
pagination_prev: admin/deployment/gcp/infrastructure-deployment/infrastructure-deployment-overview
pagination_next: admin/deployment/gcp/components-deployment/components-deployment-overview
---

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
- [ ] **Tools Installed**: Terraform 1.5.7, gcloud CLI, kubectl, Helm, Docker
- [ ] **GCP Authentication**: Logged in with gcloud CLI and project set
- [ ] **Repository Access**: Have access to Terraform and Helm repositories
- [ ] **Network Planning**: Prepared list of authorized networks (if accessing GKE API from workstation)
- [ ] **Domain & Certificate**: DNS zone and TLS certificate ready (for public access) or will use private DNS

:::warning Authentication Required
You must be authenticated to GCP CLI before running Terraform. Run `gcloud auth login` and verify with `gcloud config get-value project`.
:::

## Deployment Phases

Manual deployment involves two sequential phases:

| Phase                                | Description                                                                        | Repository                                                                                                    |
| ------------------------------------ | ---------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------- |
| **Phase 1: State Backend**           | Creates GCS bucket for Terraform state files                                       | [codemie-terraform-gcp-remote-backend](https://gitbud.epam.com/epm-cdme/codemie-terraform-gcp-remote-backend) |
| **Phase 2: Platform Infrastructure** | Deploys GKE, networking, storage, databases, security components, and Bastion Host | [codemie-terraform-gcp-platform](https://gitbud.epam.com/epm-cdme/codemie-terraform-gcp-platform)             |

:::info Bastion Host
Bastion Host is optional and only required for completely private GKE clusters with private DNS. For public clusters or clusters with authorized networks, you can access GKE API directly.
:::

## Phase 1: Deploy Terraform State Backend

The first step is to create a Google Cloud Storage bucket for storing Terraform state files. This bucket will be used by all subsequent infrastructure deployments to maintain state consistency and enable team collaboration.

:::tip Why This Matters
The state backend ensures that your infrastructure state is stored securely and can be shared across your team. Without this, Terraform state would only exist locally on your machine.
:::

### Step 1: Clone the Repository

Clone the Terraform state backend repository to your local machine:

```bash
git clone git@gitbud.epam.com:epm-cdme/codemie-terraform-gcp-remote-backend.git
cd codemie-terraform-gcp-remote-backend
```

### Step 2: Review Configuration Variables

Open and review the `variables.tf` file to understand available configuration options:

```bash
# View all available variables
cat variables.tf
```

Key variables to consider:

- **project_id**: Your GCP project ID
- **storage_bucket_name**: Prefix for storage bucket name
- **region**: GCP region for the bucket (e.g., `europe-west3`)

If you need to customize any values, create a `terraform.tfvars` file with your overrides.

### Step 3: Deploy the State Backend

Initialize Terraform and deploy the storage bucket:

```bash
# Initialize Terraform providers
terraform init

# Preview the resources that will be created
terraform plan

# Create the GCS bucket
terraform apply
```

When prompted, type `yes` to confirm the deployment.

### Step 4: Verify Deployment

After successful deployment, verify the bucket was created:

```bash
# Check Terraform outputs
terraform output

# Or verify via gcloud CLI
gcloud storage buckets list | grep terraform
```

**Save the bucket name** - you'll need it for Phase 2 configuration.

:::tip Next Phase
The storage bucket is now ready. Proceed to Phase 2 to deploy the main platform infrastructure.
:::

## Phase 2: Deploy Platform Infrastructure

This phase deploys all core GCP resources required to run AI/Run CodeMie. This includes the GKE cluster, networking components, databases, and security infrastructure.

### Step 1: Clone the Repository

Clone the platform infrastructure Terraform repository:

```bash
git clone https://gitbud.epam.com/epm-cdme/codemie-terraform-gcp-platform.git
cd codemie-terraform-gcp-platform
```

### Step 2: Configure Remote State Backend

Configure Terraform to use the GCS bucket created in Phase 1 for storing infrastructure state.

Edit the `versions.tf` file and update the backend configuration:

```hcl
backend "gcs" {
    bucket = "your-bucket-name-from-phase1"  # Replace with actual bucket name
    prefix = "terraform/platform/state"       # Path prefix for state files
}
```

### Step 3: Review and Configure Variables

The `variables.tf` file contains all configurable parameters for your infrastructure deployment. Review these variables and create a `terraform.tfvars` file to customize values for your environment.

#### Create Configuration File

Create a `terraform.tfvars` file in the repository root:

```bash
# Create and edit configuration file
nano terraform.tfvars
```

#### Essential Variables

Configure these required variables in `terraform.tfvars`:

```hcl
# GCP Project Configuration
project_id = "your-gcp-project-id"           # Your GCP project ID
platform_name = "codemie"                     # Platform identifier

# Network Access Control
bastion_members = [
  "group:devops@example.com",                 # Grant Bastion access to specific users/groups
  "user:admin@example.com"
]

# DNS Configuration
dns_name = "codemie-example-com"              # DNS zone name (hyphens, no dots)
dns_domain = "codemie.example.com."           # Full domain with trailing dot

# GKE API Access (optional)
extra_authorized_networks = [
  {
    cidr_block   = "x.x.x.x/24"               # Your office/VPN CIDR
    display_name = "Office Network"
  },
  {
    cidr_block   = "x.x.x.x/24"               # Additional network if needed
    display_name = "VPN Network"
  }
]

# Cluster Configuration
private_cluster = false                       # Set to true for completely private GKE cluster
create_private_dns_zone = false               # Set to true if using private DNS
```

:::info Configuration References
For all available variables and their descriptions, see:

- **Example configuration**: [terraform.tfvars.example](https://gitbud.epam.com/epm-cdme/codemie-terraform-gcp-platform/-/blob/main/terraform.tfvars.example?ref_type=heads)
- **Variable definitions**: [variables.tf](https://gitbud.epam.com/epm-cdme/codemie-terraform-gcp-platform/-/blob/main/variables.tf?ref_type=heads)
  :::

### Step 4: Deploy Platform Infrastructure

Initialize Terraform and deploy the complete platform infrastructure:

```bash
# Initialize Terraform and download providers/modules
terraform init

# Review the execution plan
terraform plan

# Deploy all infrastructure resources
terraform apply
```

### Step 5: Verify Deployment

After successful deployment, verify all resources were created correctly:

```bash
# View Terraform outputs (includes important connection information)
terraform output

# Verify GKE cluster exists
gcloud container clusters list --project=your-project-id

# Check Cloud SQL instance
gcloud sql instances list --project=your-project-id

# List created VPC networks
gcloud compute networks list --project=your-project-id
```

**Save the Terraform outputs** - they contain critical information needed for subsequent steps, including:

- GKE cluster connection commands
- Bastion Host SSH/RDP commands
- Cloud SQL connection details
- Service account information

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

#### Step 1: Connect to Bastion Host

Retrieve the SSH command from Terraform outputs and connect:

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

#### Step 2: Set Root Password (Required for RDP)

After connecting via SSH, set a root password for later RDP access:

```bash
# Switch to root user
sudo -s

# Set root password (you'll be prompted to enter it twice)
passwd
```

:::info Save Your Password
The root password you set here will be used to login via RDP. Make sure to remember it or store it securely.
:::

#### Step 3: Configure Kubectl Access

Fetch GKE cluster credentials to enable kubectl commands:

```bash
# Get the kubectl configuration command
terraform output get_kubectl_credentials_for_private_cluster

# Example output:
# gcloud container clusters get-credentials your-cluster-name --region=europe-west3 --project=your-project

# Run the command to configure kubectl
gcloud container clusters get-credentials your-cluster-name --region=europe-west3 --project=your-project
```

#### Step 4: Clone Deployment Repository

Clone the Helm charts repository needed for component deployment:

```bash
# Clone the repository
git clone https://gitbud.epam.com/epm-cdme/codemie-helm-charts.git
cd codemie-helm-charts
```

You're now ready to proceed with [Components Deployment](../components-deployment).

### Option 2: RDP Connection for Web UI Access

Use RDP to access application web interfaces that are only available via private DNS (such as Kibana, Keycloak Admin Console).

:::tip When to Use RDP
RDP is useful when you need to access web-based administrative interfaces that aren't exposed publicly. For kubectl/Helm operations, SSH access is sufficient.
:::

#### Step 1: Set Up RDP Port Forwarding

Retrieve the RDP forwarding command from Terraform outputs:

```bash
# Get the RDP forwarding command
terraform output bastion_rdp_command

# Example output:
# gcloud compute start-iap-tunnel bastion-vm 3389 --local-host-port=localhost:3389 --zone=europe-west3-a --project=your-project
```

Run the command to create an IAP tunnel that forwards RDP traffic:

```bash
# Start the IAP tunnel (keep this terminal open)
gcloud compute start-iap-tunnel bastion-vm 3389 \
  --local-host-port=localhost:3389 \
  --zone=europe-west3-a \
  --project=your-project
```

#### Step 2: Connect with Remote Desktop Client

Open your Remote Desktop client and connect:

| Setting      | Value                      |
| ------------ | -------------------------- |
| **Computer** | `localhost:3389`           |
| **Username** | `root`                     |
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
