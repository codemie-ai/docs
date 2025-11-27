---
id: infrastructure-manual-deployment
title: Manual Infrastructure Deployment
sidebar_label: Manual Deployment
sidebar_position: 1
---

# Manual Infrastructure Deployment

## Deployment Order

| #   | Resource name                                                                                      | Source                                                                                                        | Modules used                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
| --- | -------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| 1   | Terraform Backend                                                                                  | [codemie-terraform-gcp-remote-backend](https://gitbud.epam.com/epm-cdme/codemie-terraform-gcp-remote-backend) | –                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  |
| 2   | VPC<br/>NAT<br/>BastionHost<br/>GKE cluster<br/>Google Service Accounts<br/>KMS key<br/>Postgresql | [codemie-terraform-gcp-platform](https://gitbud.epam.com/epm-cdme/codemie-terraform-gcp-platform)             | • [terraform-google-modules/service-accounts](https://registry.terraform.io/modules/terraform-google-modules/service-accounts/google/latest)<br/>• [terraform-google-modules/kms](https://registry.terraform.io/modules/terraform-google-modules/kms/google/latest)<br/>• [terraform-google-modules/network](https://registry.terraform.io/modules/terraform-google-modules/network/google/latest)<br/>• [terraform-google-modules/cloud-nat](https://registry.terraform.io/modules/terraform-google-modules/cloud-nat/google/latest)<br/>• [terraform-google-modules/kubernetes-engine](https://registry.terraform.io/modules/terraform-google-modules/kubernetes-engine/google/latest)<br/>• [terraform-google-modules/bastion-host](https://registry.terraform.io/modules/terraform-google-modules/bastion-host/google/latest)<br/>• [terraform-google-modules/cloud-dns](https://registry.terraform.io/modules/terraform-google-modules/cloud-dns/google/latest)<br/>• [TerraformFoundation/sql-db/google/private_service_access](https://registry.terraform.io/modules/TerraformFoundation/sql-db/google/latest/submodules/private_service_access)<br/>• [TerraformFoundation/sql-db/google/postgresql](https://registry.terraform.io/modules/TerraformFoundation/sql-db/google/latest/submodules/postgresql) |

## Terraform Backend Resources Deployment

This step covers the creation of Google Storage Bucket to store Terraform states.

To create a bucket, follow the steps below:

1. Clone the git repository with the project [codemie-terraform-gcp-remote-backend](https://gitbud.epam.com/epm-cdme/codemie-terraform-gcp-remote-backend):

```bash
git clone git@gitbud.epam.com:epm-cdme/codemie-terraform-gcp-remote-backend.git
cd codemie-terraform-gcp-remote-backend
```

2. Review and change, if needed, the input variables for Terraform run in the `codemie-terraform-gcp-remote-backend/variables.tf` file.

3. Initialize the backend and apply the changes:

```bash
terraform init
terraform plan
terraform apply
```

The created bucket will be used for all subsequent infrastructure deployments.

## Main GCP Resources Deployment

This step will cover the following topics:

- Create the GKE Cluster
- Create the Google Service Account to access the Vertex AI services
- Create the NAT
- Create the GCP KMS key to encrypt and decrypt sensitive data in the AI/Run application
- Create the BastionHost to connect to private cluster

To accomplish the tasks outlined above, follow these steps:

1. Clone the git repository with the project [codemie-terraform-gcp-platform](https://gitbud.epam.com/epm-cdme/codemie-terraform-gcp-platform):

```bash
git clone https://gitbud.epam.com/epm-cdme/codemie-terraform-gcp-platform.git
cd codemie-terraform-gcp-platform
```

2. Set remote backend in `versions.tf`:

```hcl
backend "gcs" {
    bucket = "bucket-name-you-created"
    prefix = "prefix-for-state"
}
```

3. Review the input variables for Terraform run in the `codemie-terraform-gcp-platform/variables.tf` file and create a `terraform.tfvars` in the repo to change default variable values in a key-value format. For example:

```hcl
project_id = "gcp-project-id"
platform_name = "codemie"
bastion_members = ["group:email","user:another-email"]
dns_name = "domain-com"
dns_domain = "domain.com."
extra_authorized_networks = [
  {
    cidr_block   = "x.x.x.x/x"
    display_name = "GlobalProtectRegion1"
  },
  {
    cidr_block   = "x.x.x.x/x"
    display_name = "GlobalProtectRegion2"
  }
] # Add if you want to access GKE cluster from your workstation, otherwise GKE API will be accessible only from bastion VM
private_cluster = false
create_private_dns_zone = false
...
```

:::info
Ensure you have carefully reviewed all variables and replaced mock values with yours. To see all possible values, please consult the file [terraform.tfvars.example](https://gitbud.epam.com/epm-cdme/codemie-terraform-gcp-platform/-/blob/main/terraform.tfvars.example?ref_type=heads) or [variables.tf](https://gitbud.epam.com/epm-cdme/codemie-terraform-gcp-platform/-/blob/main/variables.tf?ref_type=heads).

Additional information about Terraform modules can be found in appropriate official documentation. For example:

- [terraform-google-modules/service-accounts](https://registry.terraform.io/modules/terraform-google-modules/service-accounts/google/latest)
- [terraform-google-modules/kms](https://registry.terraform.io/modules/terraform-google-modules/kms/google/latest)
- [terraform-google-modules/network](https://registry.terraform.io/modules/terraform-google-modules/network/google/latest)
- [terraform-google-modules/cloud-nat](https://registry.terraform.io/modules/terraform-google-modules/cloud-nat/google/latest)
- [terraform-google-modules/kubernetes-engine](https://registry.terraform.io/modules/terraform-google-modules/kubernetes-engine/google/latest)
- [terraform-google-modules/bastion-host](https://registry.terraform.io/modules/terraform-google-modules/bastion-host/google/latest)
- [terraform-google-modules/cloud-dns](https://registry.terraform.io/modules/terraform-google-modules/cloud-dns/google/latest)
- [TerraformFoundation/sql-db/google/private_service_access](https://registry.terraform.io/modules/TerraformFoundation/sql-db/google/latest/submodules/private_service_access)
- [TerraformFoundation/sql-db/google/postgresql](https://registry.terraform.io/modules/TerraformFoundation/sql-db/google/latest/submodules/postgresql)
  :::

4. Initialize the backend and apply the changes:

```bash
terraform init
terraform plan
terraform apply
```

This concludes GCP infrastructure deployment.

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
