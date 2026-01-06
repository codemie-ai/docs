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
- [ ] **GCP Authentication**: Logged in via `gcloud auth login` and project set
- [ ] **Repository Access**: Have access to `codemie-terraform-gcp-remote-backend` and `codemie-terraform-gcp-platform` repositories
- [ ] **Network Planning**: Prepared list of authorized networks (if accessing GKE API from workstation)
- [ ] **Domain & Certificate**: DNS zone and TLS certificate ready (for public access) or will use private DNS

:::warning Authentication Required
You must be authenticated to GCP CLI before running Terraform. Run `gcloud auth login` and verify with `gcloud config get-value project`.
:::

## Deployment Phases

The manual deployment consists of two sequential phases. Each phase uses a dedicated Terraform repository with specific GCP resources.

### Phase 1: Terraform State Backend

**Terraform Repository:** [codemie-terraform-gcp-remote-backend](https://gitbud.epam.com/epm-cdme/codemie-terraform-gcp-remote-backend)

**Resources Deployed:**

- Google Cloud Storage bucket for Terraform state files

**Estimated Duration:** ~2-3 minutes

### Phase 2: Platform Infrastructure

**Terraform Repository:** [codemie-terraform-gcp-platform](https://gitbud.epam.com/epm-cdme/codemie-terraform-gcp-platform)

**Resources Deployed:**

- VPC Network and Subnets
- Cloud NAT and Cloud Router
- GKE Cluster with Node Pools
- Cloud SQL (PostgreSQL)
- Google Service Accounts
- Cloud KMS Key
- Cloud DNS Zones
- Bastion Host (optional, for private clusters)

**Estimated Duration:** ~25-35 minutes

**Terraform Modules Used:**

- [terraform-google-modules/service-accounts](https://registry.terraform.io/modules/terraform-google-modules/service-accounts/google/latest)
- [terraform-google-modules/kms](https://registry.terraform.io/modules/terraform-google-modules/kms/google/latest)
- [terraform-google-modules/network](https://registry.terraform.io/modules/terraform-google-modules/network/google/latest)
- [terraform-google-modules/cloud-nat](https://registry.terraform.io/modules/terraform-google-modules/cloud-nat/google/latest)
- [terraform-google-modules/kubernetes-engine](https://registry.terraform.io/modules/terraform-google-modules/kubernetes-engine/google/latest)
- [terraform-google-modules/bastion-host](https://registry.terraform.io/modules/terraform-google-modules/bastion-host/google/latest)
- [terraform-google-modules/cloud-dns](https://registry.terraform.io/modules/terraform-google-modules/cloud-dns/google/latest)
- [TerraformFoundation/sql-db/google/private_service_access](https://registry.terraform.io/modules/TerraformFoundation/sql-db/google/latest/submodules/private_service_access)
- [TerraformFoundation/sql-db/google/postgresql](https://registry.terraform.io/modules/TerraformFoundation/sql-db/google/latest/submodules/postgresql)

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

:::tip What Gets Deployed
This phase will create:

- **GKE Cluster** - Kubernetes cluster for running AI/Run CodeMie
- **VPC Network** - Private network with subnets and firewall rules
- **Cloud NAT** - Outbound internet connectivity with static IP
- **Cloud SQL** - PostgreSQL database for application data
- **Service Accounts** - Identity for accessing Vertex AI and other GCP services
- **Cloud KMS Key** - Encryption key for sensitive data
- **Cloud DNS** - Name resolution for CodeMie components
- **Bastion Host** - Management VM for private cluster access (optional)
  :::

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

:::warning State Backend Required
You must configure the remote backend before running `terraform init`. Without this, Terraform will store state locally, preventing team collaboration and risking state loss.
:::

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
    cidr_block   = "203.0.113.0/24"           # Your office/VPN CIDR
    display_name = "Office Network"
  },
  {
    cidr_block   = "198.51.100.0/24"          # Additional network if needed
    display_name = "VPN Network"
  }
]

# Cluster Configuration
private_cluster = false                       # Set to true for completely private GKE cluster
create_private_dns_zone = false               # Set to true if using private DNS
```

#### Variable Descriptions

| Variable                    | Description                                                           | Required |
| --------------------------- | --------------------------------------------------------------------- | -------- |
| `project_id`                | GCP project ID where resources will be created                        | Yes      |
| `platform_name`             | Identifier used in resource names (lowercase letters only)            | Yes      |
| `bastion_members`           | IAM principals granted SSH access to Bastion Host                     | Yes      |
| `dns_name`                  | DNS zone name (use hyphens instead of dots)                           | Yes      |
| `dns_domain`                | Fully qualified domain name with trailing dot                         | Yes      |
| `extra_authorized_networks` | CIDR blocks allowed to access GKE API (empty for Bastion-only access) | No       |
| `private_cluster`           | Creates fully private GKE cluster (API not accessible from internet)  | No       |
| `create_private_dns_zone`   | Creates private DNS zone instead of public (requires private cluster) | No       |

:::info Configuration References
For all available variables and their descriptions, see:

- **Example configuration**: [terraform.tfvars.example](https://gitbud.epam.com/epm-cdme/codemie-terraform-gcp-platform/-/blob/main/terraform.tfvars.example?ref_type=heads)
- **Variable definitions**: [variables.tf](https://gitbud.epam.com/epm-cdme/codemie-terraform-gcp-platform/-/blob/main/variables.tf?ref_type=heads)

For Terraform module documentation, refer to:

- [terraform-google-modules/service-accounts](https://registry.terraform.io/modules/terraform-google-modules/service-accounts/google/latest)
- [terraform-google-modules/kubernetes-engine](https://registry.terraform.io/modules/terraform-google-modules/kubernetes-engine/google/latest)
- [terraform-google-modules/network](https://registry.terraform.io/modules/terraform-google-modules/network/google/latest)
- [terraform-google-modules/cloud-nat](https://registry.terraform.io/modules/terraform-google-modules/cloud-nat/google/latest)
- [terraform-google-modules/kms](https://registry.terraform.io/modules/terraform-google-modules/kms/google/latest)
- [terraform-google-modules/bastion-host](https://registry.terraform.io/modules/terraform-google-modules/bastion-host/google/latest)
- [terraform-google-modules/cloud-dns](https://registry.terraform.io/modules/terraform-google-modules/cloud-dns/google/latest)
- [TerraformFoundation/sql-db/google/postgresql](https://registry.terraform.io/modules/TerraformFoundation/sql-db/google/latest/submodules/postgresql)
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

When prompted, review the planned changes and type `yes` to confirm deployment.

:::warning Deployment Duration
Platform deployment takes approximately **25-35 minutes**. The GKE cluster and Cloud SQL database are the longest operations. Do not interrupt the process once started.
:::

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

## Bastion Host Connection and Setup Guide (Optional)

:::warning
Required only if you are deploying a completely private cluster with a private DNS domain. Otherwise, you can access GKE API and CodeMie application without bastion.
:::

The Bastion Host enables secure access to your Kubernetes cluster inside a private network.

You can connect in two ways:

- **SSH Connection**: For deploying and managing workloads in Kubernetes with command-line tools
- **RDP Connection**: For interacting with application UIs that are only accessible within the VPC using private DNS

### SSH Connection

Use SSH to deploy and manage cluster resources.

**How to connect:**

1. **SSH into the Bastion Host**

Use the SSH command provided as a Terraform output (bastion_ssh_command):

```bash
# Use the command from Terraform outputs
# Parameter: bastion_ssh_command
```

2. **Change the Root Password**

:::info
The "root" user and a new password will be used later to connect via RDP connection.
:::

```bash
sudo -s
passwd
```

3. **Clone the Deployment Repository**

```bash
git clone https://gitbud.epam.com/epm-cdme/codemie-helm-charts.git
```

4. **Get Kubernetes Credentials**

Fetch GKE credentials using the Terraform output (get_credentials_command):

```bash
# Use the command from Terraform outputs
# Parameter: get_kubectl_credentials_for_private_cluster
```

### RDP Connection: Access Private Application UIs

Some applications are exposed internally via private DNS and are not accessible from outside the VPC. Use RDP through the Bastion Host to access these UIs.

**How to connect:**

1. **Set Up RDP Port Forwarding**

Use the command from Terraform output (bastion_rdp_command). This will forward port 3389 to your local machine:

```bash
# Use the command from Terraform outputs
# Parameter: bastion_rdp_command
```

2. **Connect via Remote Desktop Client**

Open your preferred RDP client and connect to `localhost:3389`.

3. **Useful Tips**
   - Run Google Chrome as root:

   ```bash
   /usr/bin/google-chrome --no-sandbox
   ```

   - Paste commands into terminal: Use `Shift-Ctrl-V`

## Next Steps

After successful deployment, proceed to [Components Deployment](../components-deployment/) to install AI/Run CodeMie application components.
