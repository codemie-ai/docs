---
id: scripted-deployment
title: Scripted Deployment
sidebar_label: Scripted Deployment
sidebar_position: 5
pagination_prev: admin/deployment/gcp/on-vm/deployment/deployment
pagination_next: admin/deployment/gcp/on-vm/deployment/manual-deployment
---

# Scripted Deployment

This guide walks through deploying CodeMie On VM on GCP using the automated `deploy.sh` script. The script handles all phases: Terraform state backend, infrastructure provisioning, and application deployment.

:::tip Recommended Approach
Scripted deployment is the recommended method as it handles prerequisite checks, configuration validation, and proper sequencing of Terraform operations automatically.
:::

## Step 1: Clone the Repository

```bash
git clone https://gitbud.epam.com/epm-cdme/codemie-on-vm.git
cd codemie-on-vm
```

## Step 2: Place the GCP Registry Key

Copy your `key.json` file to the repository root:

```bash
cp /path/to/key.json ./key.json
```

## Step 3: Create Deployment Configuration

```bash
cp deployment.conf.gcp.example deployment.conf
```

Edit `deployment.conf`:

```bash
CLOUD_PROVIDER="gcp"

# ── GCP ──────────────────────────────────────────────────────────────
TF_VAR_project_id=""                  # GCP project ID e.g. my-codemie-project
TF_VAR_region="europe-west3"
TF_VAR_zone_suffix="a"                # Zone = ${region}-${zone_suffix}

# ── Terraform State ──────────────────────────────────────────────────
TF_VAR_states_bucket_name=""          # GCS bucket name (created by bootstrap phase)

# ── Platform ─────────────────────────────────────────────────────────
TF_VAR_platform_name="codemie"

# ── VM ───────────────────────────────────────────────────────────────
TF_VAR_machine_type="n2-highmem-4"    # 4 vCPU, 32 GB RAM
TF_VAR_disk_size=100                  # Boot disk size in GB

# ── Domain & Private DNS (optional) ──────────────────────────────────
TF_VAR_platform_domain_name=""        # e.g. codemie.internal

# ── CodeMie ──────────────────────────────────────────────────────────
CODEMIE_VERSION="2.26.0"
COMPOSE_PROFILE="enterprise"          # oss | enterprise
```

## Step 4: Authenticate with GCP

```bash
gcloud auth application-default login

# Verify active project:
gcloud config get-value project
```

## Step 5: Run the Deployment

```bash
./deploy.sh
```

The script executes the following phases:

| Phase                          | Description                                                      |
| ------------------------------ | ---------------------------------------------------------------- |
| Loading config                 | Validates `deployment.conf` variables                            |
| Checking prerequisites         | Verifies required tools are installed                            |
| Verifying GCP credentials      | Confirms valid `gcloud` session and project                      |
| Initializing Terraform backend | Creates GCS bucket for Terraform state                           |
| Running platform Terraform     | Plans and applies VM, GCS bucket, Cloud KMS key, DNS, firewall   |
| Reading Terraform outputs      | Fetches VM private IP, GCS bucket name, KMS key ID               |
| Generating .env                | Creates secrets and renders Docker Compose environment           |
| Provisioning VM                | Installs Docker, syncs files, starts services via IAP SSH tunnel |
| Writing outputs                | Saves credentials to `deployment_outputs.env`                    |
| Deployment summary             | Prints URL, SSH command, credentials                             |

:::warning Interactive Prompts
The script will pause for approval at each Terraform plan stage. Review the plans carefully before typing `y`.
:::

## Step 6: Verify Deployment

After the script completes:

```bash
curl -k https://<CODEMIE_HOST>/v1/healthcheck
```

Expected response: `{"status":"ok"}`

## Deployment Outputs

The script creates `deployment_outputs.env` with:

- **CODEMIE_URL** — Application URL
- **VM_PRIVATE_IP** — VM private IP address
- **SSH_COMMAND** — Full SSH command for access via IAP
- **Credentials** — Keycloak admin or superadmin password
- **Internal secrets** — Preserved across re-runs

:::danger Sensitive File
`deployment_outputs.env` contains passwords and secrets. Do not commit it to version control.
:::

## SSH Access

Connect to the VM via IAP:

```bash
gcloud compute ssh <INSTANCE_NAME> \
  --project <PROJECT_ID> \
  --zone <ZONE> \
  --tunnel-through-iap
```

The instance name, project, and zone are printed in the deployment summary and available in `deployment_outputs.env`.

## Re-deploying / Updating

To update CodeMie version or configuration:

1. Edit `deployment.conf` (e.g., change `CODEMIE_VERSION`)
2. Run `./deploy.sh` again

The script detects the existing `deployment_outputs.env` and preserves all secrets.

## Next Steps

- [Manual Deployment](../manual-deployment) — Alternative method with full Terraform control
