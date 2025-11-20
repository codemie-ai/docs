---
id: infrastructure-scripted-deployment
title: Scripted Deployment
sidebar_label: Scripted Deployment
sidebar_position: 1
---

# Scripted Deployment

The `azure-terraform.sh` script automates the deployment of infrastructure.

## Deployment Order

| #   | Resource name                                                            | Source                                                                              |
| --- | ------------------------------------------------------------------------ | ----------------------------------------------------------------------------------- |
| 1   | Terraform Backend                                                        | [codemie-terraform-azure](https://gitbud.epam.com/epm-cdme/codemie-terraform-azure) |
| 2   | Main Azure resources (see [AI/Run CodeMie Architecture](../architecture)) | [codemie-terraform-azure](https://gitbud.epam.com/epm-cdme/codemie-terraform-azure) |

## Core Infrastructure Configuration

1. Clone git repo with project [codemie-terraform-azure](https://gitbud.epam.com/epm-cdme/codemie-terraform-azure):

```bash
git clone git@gitbud.epam.com:epm-cdme/codemie-terraform-azure.git
cd codemie-terraform-azure
```

2. Fill configuration details that specific for your Azure account in `deployment.conf`. For example:

```plaintext
# AI/Run CodeMie deployment variables configuration
# Fill required values and save this file as deployment.conf

AZURE_TENANT_ID=""
AZURE_SUBSCRIPTION_ID=""
TF_VAR_customer="airun" # The name of the customer for deployment (must be in lowercase letters)
TF_VAR_resource_group_name=""
TF_VAR_location="West Europe" # The Azure region where resources will be created
TF_VAR_tags='{"createdWith":"Terraform","environment":"demo"}' # Tags to apply to all resources
TF_VAR_admin_group_object_ids='["3a459347-0000-1111-2222-e73413cfa80a"]' # A list of Object IDs of AAD Groups which should have Admin Role on the Cluster.
....
```

:::info
Full list of available variables can be found in the `variables.tf` file for appropriate module. For example, for [platform](https://gitbud.epam.com/epm-cdme/codemie-terraform-azure/-/blob/main/platform/variables.tf) module.
:::

## AI Models Configuration

The AI models deployment can be controlled by the `DEPLOY_AI_MODELS` parameter:

- **When set to "true" (default)**: The script will deploy Azure AI resources including OpenAI services and private endpoints
- **When set to "false"**: The script will skip the AI models deployment entirely, allowing for core infrastructure deployment only

This is useful when:

- You want to deploy only the core platform infrastructure
- You already have AI models deployed in Azure
- You want to deploy AI models separately at a later time
- You are using AI models from other providers (such as Anthropic, Vertex, or AWS Bedrock models) and need to integrate them with your infrastructure without deploying Azure AI resources

### AI Models Networking Configuration

**Choosing the Right Network Configuration**

| If you want to:                          | Set these values:                                                                                                                                      | Result                                                                                                                                |
| ---------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------- |
| **Most Secure Setup** (Recommended)      | `TF_VAR_ai_models_public_network_access_enabled="false"`                                                                                               | - Access only through **Azure Private Links**<br/>- **Public access blocked**<br/>- Secure access from within your Azure environment  |
| **Limited Public Access** (Option 1)     | `TF_VAR_ai_models_public_network_access_enabled="true"`<br/>`TF_VAR_ai_models_network_acls='{"default_action":"Deny","ip_rules":["123.123.123.123"]}'` | - Access through **Azure Private Links**<br/>- **Specific IPs** can access from internet<br/>- All other **public access blocked**    |
| **Limited Public Access** (Option 2)     | `TF_VAR_ai_models_public_network_access_enabled="true"`<br/>`TF_VAR_ai_models_network_acls='{"default_action":"Deny","ip_rules":[]}'`                  | - Access through **Azure Private Links**<br/>- **No specific IPs** can access from internet<br/>- All other **public access blocked** |
| **Full Public Access** (Not recommended) | `TF_VAR_ai_models_public_network_access_enabled="true"`<br/>`TF_VAR_ai_models_network_acls='{"default_action":"Allow","ip_rules":[]}'`                 | - Anyone can access from internet<br/>- Access through **Azure Private Links**<br/>- Least secure option                              |

The following settings in `deployment.conf` control network access to your Azure OpenAI services:

```plaintext
# AI Models Network Configuration
#
TF_VAR_ai_models_public_network_access_enabled="true|false"

# Network ACLs for AI Models (JSON format)
# default_action: Allow or Deny
# ip_rules: Array of allowed IP addresses/ranges
# Not applicable if ai_models_public_network_access_enabled is set to 'false'
#
TF_VAR_ai_models_network_acls='{
  "default_action": "Deny|Allow",
  "ip_rules": ["IP1","IP2"]
}'
```

**Private Link Configuration**

Our solution automatically creates Azure Private Links for your AI models, enabling secure access from within your Azure environment.

By default, these Private Links use:

- **Network name**: "AksVNet"
- **Subnet name**: "UserSubnet"

You can customize these values in `deployment.conf` file if needed:

```plaintext
TF_VAR_ai_network_name="CustomNetworkName"
TF_VAR_ai_endpoint_subnet_name="CustomSubnetName"
```

Private Links will be deployed in this network/subnet configuration regardless of your public access settings, ensuring your AI models are always accessible from your Azure infrastructure.

### Cognitive Regions Configuration Guide

When `DEPLOY_AI_MODELS="true"`, you can configure the AI models and regions using the `TF_VAR_cognitive_regions` parameter in your `deployment.conf` file.

The `TF_VAR_cognitive_regions` variable accepts a JSON object with the following structure:

```json
{
  "region_name": {
    "count": number,
    "custom_domain_name": boolean,
    "available_models": [
      {
        "format": "OpenAI",
        "name": "deployment_name",
        "model_name": "actual_model_name",
        "version": "model_version",
        "capacity": total_capacity_number,
        "type": "Standard|GlobalStandard"
      }
    ]
  }
}
```

**Parameters Explanation**

**Region Level**

- **region_name**: Azure region name (e.g., "japaneast", "eastus", "westeurope")
- **count**: Number of cognitive service instances to create in this region
- **custom_domain_name**: Whether to enable custom domain names for the cognitive services

**Model Level**

- **format**: Always "OpenAI" for OpenAI models
- **name**: Deployment name for the model (used in API calls)
- **model_name**: The actual OpenAI model name
- **version**: Model version to deploy
- **capacity**: Total capacity for the model (will be divided by count automatically)
- **type**:
  - "Standard": Regional deployment
  - "GlobalStandard": Global deployment with higher availability

**Capacity Distribution**

The **capacity** value you specify is the **total capacity** for that model across all instances in the region. The system automatically divides this by the count to distribute capacity evenly.

Examples:

- If you set capacity: `348` and count: `3`, each instance will get `348 / 3 = 116` capacity units.
- If you set capacity: `200` and count: `2`, each instance will get `200 / 2 = 100` capacity units.

**Deployment Scenarios**

Configure your AI models deployment across Azure regions using the `TF_VAR_cognitive_regions` parameter in `deployment.conf`. This JSON-formatted parameter defines which models to deploy, where to deploy them, and their capacity allocations.

```plaintext
TF_VAR_cognitive_regions=""
```

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

## Usage

Run installation script:

```bash
bash ./azure-terraform.sh
```

After execution, the script will:

1. Validate your deployment environment:
   1. Check for required tools (`tfenv`, `Azure CLI`)
   2. Verify Azure authentication status
   3. Validate configuration parameters
2. Deploy Infrastructure:
   1. Create Terraform backend storage (Azure Storage Account)
   2. Deploy core AI/Run CodeMie Platform infrastructure
   3. Set up AI Models (if selected)

## Connect to Bastion VM

1. Go to `CodeMieRG` resource group on Azure portal
2. Choose Connect via Bastion option for `CodeMieVM` virtual machine
3. Connect to the jumpbox VM via SSH.
   - Authentication type: `SSH Private Key from Azure Key Vault`
   - Username: `azadmin`
   - Subscription: `<project subscription name>`
   - Azure Key Vault: CodeMieAskVault
   - Azure Key Vault Secret: codemie-vm-private-key
4. After successful connection set password for the `azadmin` user:

```bash
sudo passwd azadmin
```

:::info
Use `ctrl+shift+c` and `ctrl+shift+v` to copy/insert values into browser window
:::

## Prepare Bastion VM

1. Connect to the jumpbox VM via RDP with username: `azadmin` and with the password set on previous step.
2. Open terminal and login to Azure:

```bash
az login
```

3. Set subscription:

```bash
az account set --subscription <subscription-id>
```

4. Get kubeconfig with command:

```bash
# Default resource group name: CodeMieRG (unless overridden in deployment.conf)

az aks get-credentials --resource-group <main-resource-group-name> --name CodeMieAks --overwrite-existing
kubelogin convert-kubeconfig -l azurecli
```

5. Set primary resource group as default:

```bash
az configure --defaults group=<resource-group-name> # From TF_VAR_resource_group_name or if not specified – CodeMieRG
```
