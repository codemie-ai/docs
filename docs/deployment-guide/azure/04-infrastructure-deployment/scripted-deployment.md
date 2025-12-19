---
id: infrastructure-scripted-deployment
title: Infrastructure Scripted Deployment
sidebar_label: Infrastructure Scripted Deployment
sidebar_position: 1
---

import Tabs from '@theme/Tabs';
import TabItem from '@theme/TabItem';

# Scripted Infrastructure Deployment

This guide walks you through deploying Azure infrastructure for AI/Run CodeMie using the automated `azure-terraform.sh` deployment script. The script handles all three deployment phases automatically: Terraform state backend, core platform infrastructure, and optional AI model deployments.

:::tip Recommended Approach
Scripted deployment is the recommended method as it handles prerequisite checks, configuration validation, and proper sequencing of Terraform operations automatically.
:::

## Prerequisites

Before starting the deployment, ensure you have completed all requirements from the [Prerequisites](../prerequisites) page:

### Verification Checklist

- [ ] **Azure Access**: Contributor role with Entra ID App Registration access
- [ ] **Tools Installed**: Terraform 1.5.7, Azure CLI, kubectl, Helm, gcloud CLI, Docker
- [ ] **Azure Authentication**: Logged in via `az login` and subscription set
- [ ] **Repository Access**: Have access to `codemie-terraform-azure` repository
- [ ] **Network Planning**: Prepared list of allowed networks
- [ ] **Domain & Certificate**: DNS zone and TLS certificate ready (for public access) or will use private DNS

:::warning Authentication Required
You must be authenticated to Azure CLI before running the deployment script. Run `az login` and verify with `az account show`.
:::

## Deployment Phases

The script automatically deploys infrastructure in three sequential phases:

| Phase                                | Description                                                      | Required | Duration   |
| ------------------------------------ | ---------------------------------------------------------------- | -------- | ---------- |
| **Phase 1: State Backend**           | Creates Azure Storage Account for Terraform state files          | Yes      | ~2-3 min   |
| **Phase 2: Platform Infrastructure** | Deploys AKS, networking, storage, databases, security components | Yes      | ~25-35 min |
| **Phase 3: AI Models**               | Provisions Azure OpenAI services (if enabled)                    | Optional | ~5-10 min  |

:::info Skipping AI Models
Set `DEPLOY_AI_MODELS="false"` in configuration to skip Phase 3 if using external AI providers.
:::

## Quick Start

### Step 1: Clone Repository

Clone the Terraform deployment repository:

```bash
git clone git@gitbud.epam.com:epm-cdme/codemie-terraform-azure.git
cd codemie-terraform-azure
```

### Step 2: Configure Deployment

Edit the `deployment.conf` file to provide your Azure-specific configuration:

```bash
# Required: Azure Account Information
AZURE_TENANT_ID="00000000-0000-0000-0000-000000000000"
AZURE_SUBSCRIPTION_ID="11111111-1111-1111-1111-111111111111"

# Required: Basic Configuration
TF_VAR_customer="airun"                    # Customer identifier (lowercase letters only)
TF_VAR_location="West Europe"              # Azure region for deployment
TF_VAR_resource_group_name=""              # Leave empty to auto-generate

# Required: AKS Admin Access
TF_VAR_admin_group_object_ids='["3a459347-0000-1111-2222-e73413cfa80a"]'

# Optional: Resource Tagging
TF_VAR_tags='{"createdWith":"Terraform","environment":"production"}'

# Optional: AI Models Deployment
DEPLOY_AI_MODELS="true"                    # Set to "false" to skip Azure OpenAI deployment
```

:::tip Required vs Optional Variables
The configuration file contains many variables. Most have sensible defaults. Focus on the **Required** variables first. See the [Configuration Reference](#configuration-reference) below for advanced options.
:::

:::info Complete Variable List
For all available configuration options, refer to the `variables.tf` files:

- **Platform variables**: [platform/variables.tf](https://gitbud.epam.com/epm-cdme/codemie-terraform-azure/-/blob/main/platform/variables.tf)
- **AI models variables**: [ai-models/variables.tf](https://gitbud.epam.com/epm-cdme/codemie-terraform-azure/-/blob/main/ai-models/variables.tf)
  :::

### Step 3: Run Deployment

Execute the automated deployment script:

```bash
bash ./azure-terraform.sh
```

The script will:

1. **Validate Environment**: Check for required tools and Azure authentication
2. **Verify Configuration**: Validate `deployment.conf` parameters
3. **Deploy Phase 1**: Create Terraform state backend storage
4. **Deploy Phase 2**: Provision core platform infrastructure (AKS, networking, storage, databases)
5. **Deploy Phase 3**: Provision AI models (if `DEPLOY_AI_MODELS="true"`)
6. **Generate Outputs**: Create `deployment_outputs.env` with infrastructure details than will be required during next phases

:::warning Deployment in Progress
Do not interrupt the script during execution. The deployment process can take 30-45 minutes. Monitor the output for any errors.
:::

## Configuration Reference

### AI Models Deployment Control

Control whether Azure OpenAI services are deployed using the `DEPLOY_AI_MODELS` parameter:

| Setting            | Behavior                                                             | Use Case                                                                        |
| ------------------ | -------------------------------------------------------------------- | ------------------------------------------------------------------------------- |
| `"true"` (default) | Deploys Azure OpenAI services, private endpoints, and AI application | Using Azure-hosted AI models                                                    |
| `"false"`          | Skips AI models deployment entirely                                  | Using external AI providers (OpenAI API, Anthropic, AWS Bedrock, GCP Vertex AI) |

:::tip When to Skip AI Models
Skip Azure OpenAI deployment (`DEPLOY_AI_MODELS="false"`) if you:

- Already have Azure OpenAI services deployed
- Plan to use other non GPT family models (Claude, Gemini, etc)
- Want to deploy AI models separately later
- Are deploying infrastructure in stages
  :::

### AI Models Network Access

Configure network access controls for Azure OpenAI services. All deployments include private endpoint connectivity; public access is optional and can be restricted.

<Tabs>
  <TabItem value="private-only" label="Private Only (Recommended)" default>
    **Most Secure Configuration** - Access only through Azure Private Endpoints

    ```bash
    TF_VAR_ai_models_public_network_access_enabled="false"
    ```

    **Result**:
    - ✅ Access via Azure Private Links from your VNet
    - ❌ Public internet access completely disabled
    - ✅ Recommended for production environments

  </TabItem>

  <TabItem value="restricted-public" label="Restricted Public Access">
    **Hybrid Configuration** - Private access + specific public IPs allowed

    ```bash
    TF_VAR_ai_models_public_network_access_enabled="true"
    TF_VAR_ai_models_network_acls='{
      "default_action": "Deny",
      "ip_rules": ["203.0.113.0/24", "198.51.100.50"]
    }'
    ```

    **Result**:
    - ✅ Access via Azure Private Links from your VNet
    - ✅ Access from specified IP addresses/ranges only
    - ❌ All other public access denied
    - 💡 Useful for accessing from corporate networks or specific locations

  </TabItem>

  <TabItem value="public-open" label="Public Access (Not Recommended)">
    **Least Secure Configuration** - Open public access

    ```bash
    TF_VAR_ai_models_public_network_access_enabled="true"
    TF_VAR_ai_models_network_acls='{
      "default_action": "Allow",
      "ip_rules": []
    }'
    ```

    **Result**:
    - ✅ Access via Azure Private Links from your VNet
    - ⚠️ Access from any public IP address
    - ❌ Not recommended for production

  </TabItem>
</Tabs>

#### Private Endpoint Configuration

Private endpoints are automatically deployed for secure VNet connectivity. Customize the network location if needed:

```bash
# Default values (can be customized)
TF_VAR_ai_network_name="AksVNet"              # VNet for private endpoint
TF_VAR_ai_endpoint_subnet_name="UserSubnet"   # Subnet for private endpoint
```

:::info Private Endpoints
Private endpoints are created regardless of public access settings, ensuring secure connectivity from your Azure infrastructure.
:::

### Azure OpenAI Model Configuration

When `DEPLOY_AI_MODELS="true"`, configure which AI models to deploy and their regional distribution using `TF_VAR_cognitive_regions`.

#### Configuration Parameters

**Region-Level Settings**:

- `region_name`: Azure region (e.g., "eastus", "westeurope", "japaneast")
- `count`: Number of Azure OpenAI instances to create in this region
- `custom_domain_name`: Enable custom domain names (true/false)

**Model-Level Settings**:

- `format`: Always `"OpenAI"`
- `name`: Deployment name used in API calls
- `model_name`: Azure OpenAI model identifier (e.g., "gpt-4o", "gpt-4", "text-embedding-ada-002")
- `version`: Model version (e.g., "2024-11-20")
- `capacity`: Total capacity units (automatically distributed across instances)
- `type`: `"Standard"` (regional) or `"GlobalStandard"` (global with higher availability)

:::tip Capacity Distribution
The `capacity` value is the **total** capacity for that model. It's automatically divided by `count`:

- `capacity: 348` with `count: 3` → Each instance gets 116 capacity units
- `capacity: 200` with `count: 2` → Each instance gets 100 capacity units
  :::

#### Configuration Examples

<details>
<summary>Single Region Configuration Example</summary>

```bash
TF_VAR_cognitive_regions='{
  "eastus": {
    "count": 2,
    "custom_domain_name": true,
    "available_models": [
      {
        "format": "OpenAI",
        "name": "gpt-4o-2024-11-20",
        "model_name": "gpt-4o",
        "version": "2024-11-20",
        "capacity": 200,
        "type": "GlobalStandard"
      },
      {
        "format": "OpenAI",
        "name": "gpt-4.1-2025-04-14",
        "model_name": "gpt-4.1",
        "version": "2025-04-14",
        "capacity": 200,
        "type": "GlobalStandard"
      },
      {
        "format": "OpenAI",
        "name": "text-embedding-ada-002",
        "model_name": "text-embedding-ada-002",
        "version": "2",
        "capacity": 200,
        "type": "GlobalStandard"
      }
    ]
  }
}'
```

</details>

<details>
<summary>Multiple Regions Configuration Example</summary>

```bash
TF_VAR_cognitive_regions='{
  "eastus": {
    "count": 2,
    "custom_domain_name": true,
    "available_models": [
      {
        "format": "OpenAI",
        "name": "gpt-4o-2024-11-20",
        "model_name": "gpt-4o",
        "version": "2024-11-20",
        "capacity": 200,
        "type": "GlobalStandard"
      },
      {
        "format": "OpenAI",
        "name": "gpt-4.1-2025-04-14",
        "model_name": "gpt-4.1",
        "version": "2025-04-14",
        "capacity": 200,
        "type": "GlobalStandard"
      },
      {
        "format": "OpenAI",
        "name": "text-embedding-ada-002",
        "model_name": "text-embedding-ada-002",
        "version": "2",
        "capacity": 200,
        "type": "GlobalStandard"
      }
    ]
  },
   "eastus2": {
    "count": 2,
    "custom_domain_name": true,
    "available_models": [
      {
        "format": "OpenAI",
        "name": "gpt-4o-2024-11-20",
        "model_name": "gpt-4o",
        "version": "2024-11-20",
        "capacity": 200,
        "type": "GlobalStandard"
      },
      {
        "format": "OpenAI",
        "name": "gpt-4.1-2025-04-14",
        "model_name": "gpt-4.1",
        "version": "2025-04-14",
        "capacity": 200,
        "type": "GlobalStandard"
      },
      {
        "format": "OpenAI",
        "name": "text-embedding-ada-002",
        "model_name": "text-embedding-ada-002",
        "version": "2",
        "capacity": 200,
        "type": "GlobalStandard"
      }
    ]
  }
}'
```

</details>

## Deployment Outputs

Upon successful deployment, the script generates a `deployment_outputs.env` file containing essential infrastructure details needed for the next deployment phase:

```bash
# Platform Infrastructure Outputs
AZURE_CLIENT_ID="00000000-0000-0000-0000-000000000000"
AZURE_KEY_VAULT_URL="https://codemie-kv-abc123.vault.azure.net"
AZURE_KEY_NAME="codemie-key"
AZURE_STORAGE_ACCOUNT_NAME="codemiestorage123"
AZURE_RESOURCE_GROUP="airun-codemie"
BASTION_ADMIN_USERNAME="azadmin"
CODEMIE_DOMAIN_NAME="example.com"

# AI Model Outputs (if DEPLOY_AI_MODELS="true")
AZURE_AI_TENANT_ID="00000000-0000-0000-0000-000000000000"
AZURE_AI_CLIENT_ID="00000000-0000-0000-0000-000000000000"
AZURE_AI_CLIENT_SECRET="some-secret"

# Database Outputs
CODEMIE_POSTGRES_DATABASE_HOST="codemie-psql-abc123.postgres.database.azure.com"
CODEMIE_POSTGRES_DATABASE_PORT="5432"
CODEMIE_POSTGRES_DATABASE_NAME="codemie"
CODEMIE_POSTGRES_DATABASE_USER="pgadmin"
CODEMIE_POSTGRES_DATABASE_PASSWORD="password"
```

:::tip Save These Outputs
The `deployment_outputs.env` file contains sensitive information. Store it securely and reference it during the Components Deployment phase.
:::

## Post-Deployment Validation

After deployment completes, verify that all infrastructure was created successfully:

### 1. Verify Azure Resources

Check that all expected resources were created in the Azure Portal:

```bash
# List all resources in the resource group
az resource list --resource-group <resource-group-name> --output table

# Verify AKS cluster status
az aks show --resource-group <resource-group-name> --name CodeMieAks --query "provisioningState"

# Verify PostgreSQL server status
az postgres flexible-server show --resource-group <resource-group-name> --name <postgres-server-name>
```

### 2. Check Deployment Logs

Review the deployment logs in the `logs/` directory for any warnings or errors:

```bash
ls -la logs/
# Review logs
cat logs/codemie_azure_deployment_YYYY-MM-DD-HHMMSS.log
```

### 3. Verify Key Resources

Ensure critical resources are accessible:

| Resource            | Verification                                           |
| ------------------- | ------------------------------------------------------ |
| **AKS Cluster**     | Status should be "Succeeded", private endpoint created |
| **Key Vault**       | Accessible, contains SSH keys and secrets              |
| **Storage Account** | Created with private endpoint                          |
| **PostgreSQL**      | Running, accessible via private endpoint               |
| **Azure Bastion**   | Deployed and associated with Hub VNet                  |
| **NAT Gateway**     | Public IP assigned and associated with AKS subnets     |

## Access Jumpbox VM via Bastion

The Jumpbox VM provides secure management access to your AKS cluster. Access it through Azure Bastion:

### Step 1: Connect via SSH (Initial Setup)

1. Navigate to your resource group in the Azure Portal (default: `CodeMieRG`)
2. Select the Jumpbox VM (`CodeMieVM`)
3. Click **Connect** → **Connect via Bastion**
4. Configure connection settings:
   - **Authentication type**: `SSH Private Key from Azure Key Vault`
   - **Username**: `azadmin`
   - **Subscription**: Your Azure subscription
   - **Azure Key Vault**: `CodeMieAskVault` (or your Key Vault name)
   - **Azure Key Vault Secret**: `codemie-vm-private-key`
5. Click **Connect**

:::tip Browser Shortcuts
Use `Ctrl+Shift+C` and `Ctrl+Shift+V` to copy/paste in the browser-based Bastion session.
:::

### Step 2: Set User Password

After initial SSH connection, set a password for the `azadmin` user (required for RDP access):

```bash
sudo passwd azadmin
```

### Step 3: Connect via RDP (Management Access)

1. Disconnect from SSH session
2. Return to VM → **Connect** → **Connect via Bastion**
3. Configure connection settings:
   - **Protocol**: `RDP`
   - **Username**: `azadmin`
   - **Authentication type**: `Password`
   - **Password**: Password set in Step 2
4. Click **Connect**

## Configure Jumpbox for AKS Access

Once connected to the Jumpbox via RDP, configure access to the AKS cluster:

### 1. Authenticate to Azure

```bash
az login
```

### 2. Set Active Subscription

```bash
az account set --subscription <subscription-id>
```

### 3. Configure kubectl Access

Retrieve AKS credentials and configure kubectl:

```bash
# Replace <resource-group-name> with your resource group
# Default: CodeMieRG (unless overridden in deployment.conf)
az aks get-credentials \
  --resource-group <resource-group-name> \
  --name CodeMieAks \
  --overwrite-existing

# Convert kubeconfig for Azure CLI authentication
kubelogin convert-kubeconfig -l azurecli
```

### 4. Set Default Resource Group

```bash
# Set default resource group for Azure CLI commands
az configure --defaults group=<resource-group-name>
```

### 5. Verify Cluster Access

```bash
# Test cluster connectivity
kubectl get nodes

# View cluster information
kubectl cluster-info
```

## Troubleshooting

### Deployment Fails During Terraform Apply

**Symptom**: Script fails with Terraform errors

**Solutions**:

- Check Azure quotas and limits for your subscription
- Verify you have sufficient permissions (Contributor role)
- Review Terraform logs in `logs/` directory for specific error messages
- Ensure all required variables in `deployment.conf` are set correctly
- Check Azure service health for the selected region

### Cannot Connect to Bastion

**Symptom**: Bastion connection fails or times out

**Solutions**:

- Verify Azure Bastion is deployed and in "Succeeded" state
- Check NSG rules allow Bastion subnet access
- Ensure your browser allows pop-ups from Azure Portal
- Try a different browser

### AKS Cluster Not Accessible from Jumpbox

**Symptom**: `kubectl` commands fail or timeout

**Solutions**:

- Verify you ran `kubelogin convert-kubeconfig`
- Ensure you're authenticated to Azure CLI: `az account show`
- Check private DNS zones are properly configured
- Verify VNet peering between Hub and AKS VNets

### AI Models Deployment Fails

**Symptom**: Phase 3 fails with OpenAI service errors

**Solutions**:

- Verify Azure OpenAI quota in selected regions
- Check model availability in target regions
- Ensure capacity values are within limits
- Confirm `TF_VAR_cognitive_regions` JSON is properly formatted

### Deployment Hangs or Takes Too Long

**Symptom**: Deployment runs longer than expected

**Solutions**:

- Check Azure Portal for resource provisioning status
- AKS deployment typically takes 20-30 minutes
- Review logs for stuck Terraform operations
- Ensure Azure services in selected region are available

## Next Steps

After successful infrastructure deployment and validation, proceed to:

**[Components Deployment](../components-deployment/)** - Deploy AI/Run CodeMie application components to your AKS cluster
