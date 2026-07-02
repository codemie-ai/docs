---
id: manual-deployment
title: Manual Deployment
sidebar_label: Manual Deployment
sidebar_position: 6
pagination_prev: admin/deployment/gcp/on-vm/deployment/scripted-deployment
pagination_next: admin/deployment/gcp/on-vm/deployment/byo
---

# Manual Deployment

This guide provides step-by-step instructions for manually deploying CodeMie On VM infrastructure using Terraform on GCP, followed by application provisioning via BYO mode (`./deploy.sh --byo`).

:::info When to Use Manual Deployment
Manual deployment is suitable when you need fine-grained control over each Terraform phase, want to customize infrastructure configurations, or are integrating with existing infrastructure management workflows.
:::

## Prerequisites

Ensure you have completed all requirements from the [Prerequisites](../../prerequisites) page:

- [ ] **GCP Access**: Active project with required IAM roles
- [ ] **Tools Installed**: Terraform 1.15.x, gcloud CLI, jq, openssl, envsubst
- [ ] **GCP Authentication**: `gcloud auth application-default login` completed
- [ ] **Repository Access**: Cloned [codemie-on-vm](https://gitbud.epam.com/epm-cdme/codemie-on-vm)
- [ ] **GCP Registry**: `key.json` file available

## Deployment Phases

| Phase                                | Description                                             | Directory                       |
| ------------------------------------ | ------------------------------------------------------- | ------------------------------- |
| **Phase 1: State Backend**           | Creates GCS bucket for Terraform state                  | `terraform/gcp/remote-backend/` |
| **Phase 2: Platform Infrastructure** | Provisions VM, GCS bucket, Cloud KMS key, DNS, firewall | `terraform/gcp/platform/`       |
| **Phase 3: Application**             | Deploys Docker Compose stack via BYO mode               | `./` (repo root)                |

---

## Phase 1: Terraform State Backend

:::info One-Time Setup
This phase only needs to run once per GCP project. It creates the GCS bucket used to store Terraform state for subsequent phases.
:::

1. Navigate to the remote backend directory:

```bash
cd terraform/gcp/remote-backend/
```

2. Initialize Terraform:

```bash
terraform init
```

3. Create `terraform.tfvars`:

```hcl
project_id         = "my-codemie-project"
region             = "europe-west3"
states_bucket_name = "codemie-tfstate"
```

4. Plan and apply:

```bash
terraform plan -out=tfplan
terraform apply tfplan
```

5. Note the GCS bucket name from the outputs — you will use it as `TF_VAR_states_bucket_name` in the next phase.

---

## Phase 2: Platform Infrastructure

1. Navigate to the platform directory:

```bash
cd terraform/gcp/platform/
```

2. Create `backend.tfvars`:

```hcl
bucket = "codemie-tfstate"
prefix = "codemie/platform"
```

3. Initialize Terraform with backend configuration:

```bash
terraform init -backend-config=backend.tfvars
```

4. Create `terraform.tfvars`:

```hcl
project_id           = "my-codemie-project"
region               = "europe-west3"
zone_suffix          = "a"
platform_name        = "codemie"
machine_type         = "n2-highmem-4"
disk_size            = 100
platform_domain_name = ""   # Leave empty for private IP access
```

5. Plan and apply:

```bash
terraform plan -out=tfplan
terraform apply tfplan
```

6. Note the outputs:

```bash
terraform output vm_private_ip
terraform output gcs_bucket_name
terraform output kms_key_id
terraform output instance_name
terraform output zone
```

---

## Phase 3: Application Provisioning (BYO Mode)

Now that infrastructure is provisioned, use BYO mode to deploy the application stack.

1. Navigate to the project root.

2. Place the GCP registry key:

```bash
cp /path/to/key.json ./key.json
```

3. Configure `deployment.conf` with BYO settings from Phase 2 outputs:

```bash
CLOUD_PROVIDER="gcp"
CODEMIE_VERSION="2.26.0"
COMPOSE_PROFILE="enterprise"            # oss | enterprise

# BYO GCE VM settings
BYO_VM_HOST="<vm_private_ip>"           # From terraform output
BYO_VM_USER="ubuntu"
BYO_VM_SSH_KEY="/path/to/codemie-key"
BYO_VM_SSH_MODE="iap"                   # iap | direct
BYO_GCP_PROJECT_ID="<project_id>"       # Your GCP project
BYO_GCP_ZONE="<zone>"                   # e.g. europe-west3-a
BYO_GCP_INSTANCE_NAME="<instance_name>" # From terraform output
BYO_GCS_BUCKET_NAME="<gcs_bucket>"     # From terraform output
BYO_GCP_KMS_KEY_ID="<kms_key_id>"      # From terraform output (empty = plain encryption)
BYO_PLATFORM_DOMAIN_NAME=""            # Optional: overrides CODEMIE_HOST
```

4. Run BYO deployment:

```bash
./deploy.sh --byo
```

5. Verify:

```bash
curl -k https://<CODEMIE_HOST>/v1/healthcheck
```

## Re-deploying

To update CodeMie:

1. Edit `deployment.conf` (change `CODEMIE_VERSION`)
2. Run `./deploy.sh --byo` again — secrets are preserved automatically

## Next Steps

- [BYO VM](../byo) — Deploy on a completely external GCE VM not managed by this Terraform
