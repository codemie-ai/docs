---
id: litellm-proxy
sidebar_position: 2
title: LiteLLM Proxy
description: Load balancing and high availability for LLM requests
---

# LiteLLM Proxy Installation and Configuration Guide

This guide provides instructions for installing and configuring the LiteLLM Proxy, which serves as a unified gateway for our platform. It enables seamless connection to a diverse range of Large Language Models (LLMs) from providers like AWS Bedrock, Azure OpenAI, and Google Vertex AI. LiteLLM is the recommended solution for implementations that require support for multiple LLM providers or advanced features such as spend tracking and user-based budgeting.

:::info Prerequisites

Before you begin, please ensure you have the following:

- **Access to your Kubernetes cluster via `kubectl`.**
- **Access to the [codemie-helm-charts](https://gitbud.epam.com/epm-cdme/codemie-helm-charts) repository.**

**Conditional Prerequisites:**

- **If you are using AWS Bedrock LLM models:**
  - Option 1 (Recommended for EKS): IAM Role with access to Bedrock services for use with IRSA (IAM Roles for Service Accounts)
  - Option 2: AWS User with access to Bedrock services

- **If you are using Azure OpenAI LLM models:**
  - Option 1 (Recommended): Azure Entra ID Application with access to Azure OpenAI services
  - Option 2: Direct API key authentication

- **If you are using GCP Vertex AI LLM models:**
  - GCP Service Account with access to Vertex AI

:::

:::warning

Minimal supported version of AI/Run CodeMie for use with LiteLLM Proxy is 2.0.0. Make sure you've updated your CodeMie installation before proceeding.

:::

Review LiteLLM Proxy system requirements before proceeding.

## LiteLLM Proxy System Requirements

The diagram below depicts the LiteLLM Proxy deployed on Kubernetes infrastructure within a cloud environment.

:::note

The architecture diagram from Confluence (drawio) should be recreated as a static image and placed in `./images/litellm-architecture.png`

:::

### Components and Requirements

| Component | CPU (Limits/Requests) | Memory (Limits/Requests) | Storage |
|-----------|----------------------|--------------------------|---------|
| LiteLLM Proxy x 2 Replicas | 2 / 2 (1 / 1) | 4Gi / 4Gi (2Gi / 2Gi) | — |
| Redis | 0.15 / 0.1 | 192Mi / 128Mi | 2Gi |
| PostgreSQL[^1] | — | — | — |
| **Total** | ~2.15 / ~2.1 vCPU | ~4 / ~4 GiB RAM | ~2 Gi PVC |

[^1]: Reusing main AI/Run CodeMie PostgreSQL instance

## Deployment Workflow {#deployment-workflow}

This guide provides a complete workflow for installing and integrating the LiteLLM Proxy. The process is divided into the following parts:

1. **[Step 1: PostgreSQL Database Setup](#step1-postgres-setup)** — Create a dedicated database and user for LiteLLM.
2. **[Step 2: Configure API and Proxy Values](#step2-configure-values)** — Configure the required `values.yaml` files for CodeMie and LiteLLM.
3. **[Step 3: Cloud Provider Authentication](#step3-auth-secrets)** — Configure credentials for AWS, Azure, and GCP.
4. **[Step 4: LiteLLM Model Configuration](#step4-model-config)** — Configure model lists and regions.
5. **[Step 5: Deployment](#step5-deployment)** — Install the LiteLLM Proxy using one of two methods:
   - **[Option A: Automated Deployment (Recommended)](#step5-option-a)**
   - **[Option B: Manual Deployment](#step5-option-b)**

For users migrating from the deprecated DIAL Proxy, see:

- **[Appendix: Migration Guide from DIAL to LiteLLM](#appendix-migration)**

## Step 1: PostgreSQL Database Setup {#step1-postgres-setup}

<details>
<summary>Click to expand</summary>

LiteLLM requires a dedicated database and user in your PostgreSQL instance. Follow these steps to configure it.

1. Connect to your main PostgreSQL instance.

:::info Finding Your Database Credentials

Your main database connection details (host, port, user, and password) are generated during the Terraform deployment and can be found in the **`deployment_outputs.env`** file. Use these values to connect with a database management tool.

```bash title="Example from deployment_outputs.env"
# RDS Database Outputs
CODEMIE_POSTGRES_DATABASE_HOST=...
CODEMIE_POSTGRES_DATABASE_PORT=...
CODEMIE_POSTGRES_DATABASE_NAME=...
CODEMIE_POSTGRES_DATABASE_USER=...
CODEMIE_POSTGRES_DATABASE_PASSWORD="..."
```

:::

You can connect using one of the following methods:

- Use your cloud provider's built-in query tools.
- Deploy pgAdmin inside the cluster to access your private PostgreSQL instance.

<details>
<summary>Click here for instructions on deploying pgAdmin</summary>

```bash
# Create a dedicated namespace
kubectl create ns pgadmin

# Create credentials for pgadmin
kubectl create secret generic pgadmin4-credentials \
--namespace pgadmin \
--from-literal=password="$(openssl rand -hex 16)" \
--type=Opaque

# Inside cloned codemie-helm-charts
# Deploy pgadmin using Helm
helm upgrade --install pgadmin pgadmin/. -n pgadmin --values pgadmin/values.yaml --wait --timeout 900s --dependency-update

# Forward a local port to the service to access the UI
kubectl -n pgadmin port-forward svc/pgadmin-pgadmin4 8080:80

# You can now access the pgadmin UI at http://localhost:8080
# Default user: "pgadmin4@example.com"
# Retrieve the pgAdmin password from the Kubernetes secret.
kubectl -n pgadmin get secret pgadmin4-credentials -o jsonpath='{.data.password}' | base64 -d; echo
```

</details>

2. Execute the following SQL commands to create the dedicated database and user for LiteLLM. **Important:** Replace `'your_strong_password_here'` with a new, secure password for the `litellm` user.

```sql
CREATE DATABASE postgres_litellm;
```

```sql
CREATE USER litellm WITH PASSWORD 'your_strong_password_here';
GRANT ALL PRIVILEGES ON DATABASE postgres_litellm TO litellm;
```

3. Switch your connection to the newly created `postgres_litellm` database.

4. Grant all privileges on the `public` schema to the new user:

```sql
GRANT ALL ON SCHEMA public TO litellm;
```

</details>

## Step 2: Configure CodeMie API and LiteLLM Values {#step2-configure-values}

<details>
<summary>Click to expand</summary>

This step is required for both Automated and Manual setups.

Add the following environment variables to your CodeMie API `values.yaml`: `codemie-api/values-<cloud>.yaml`

:::note

MODELS_ENV must equal the cloud you use for deployment: `aws`, `azure`, or `gcp`.

:::

```yaml
extraEnv:
  - name: MODELS_ENV
    value: "aws"
  - name: LLM_PROXY_MODE
    value: "lite_llm"
  - name: LLM_PROXY_ENABLED
    value: "true"
  - name: LITE_LLM_URL
    value: "http://litellm.litellm:4000"
  - name: LITE_LLM_TAGS_HEADER_VALUE
    value: "global"
  - name: LITE_LLM_APP_KEY
    valueFrom:
      secretKeyRef:
        name: litellm-integration
        key: litellm-app-key
  - name: LITE_LLM_MASTER_KEY
    valueFrom:
      secretKeyRef:
        name: litellm-integration
        key: litellm-master-key
```

Configure `litellm/values-<cloud_name>.yaml`

```yaml
litellm-helm:
  ingress:
    enabled: true
    annotations: {}
    className: "nginx"
    hosts:
      - host: litellm.%%DOMAIN%%   # Replace with your domain
        paths:
          - path: /
            pathType: ImplementationSpecific
    tls: []

  redis:
    global:
      # Storage Class Configuration
      defaultStorageClass: "your-storage-class"  # e.g., "gp3", "standard", etc.
```

</details>

## Step 3: Cloud Provider Authentication Secrets {#step3-auth-secrets}

<details>
<summary>Click to expand</summary>

LiteLLM Proxy requires credentials to authenticate with cloud provider services. The recommended authentication method depends on where your Kubernetes cluster is hosted and which AI services you intend to use.

### Cloud Authentication Methods

| Cluster Environment | AWS Bedrock | GCP Vertex AI | Azure OpenAI |
|---------------------|-------------|---------------|--------------|
| **AWS (EKS Cluster)** | <ul><li>IRSA (IAM Roles for Service Accounts)</li><li>AWS User Credentials</li></ul> | <ul><li>GCP Service Account Credentials</li></ul> | <ul><li>Azure Entra ID Application Credentials</li></ul> |
| **GCP (GKE Cluster)** | <ul><li>AWS User Credentials</li></ul> | <ul><li>GCP Service Account Credentials</li></ul> | <ul><li>Azure Entra ID Application Credentials</li></ul> |
| **Azure (AKS Cluster)** | <ul><li>AWS User Credentials</li></ul> | <ul><li>GCP Service Account Credentials</li></ul> | <ul><li>Azure Entra ID Application Credentials</li></ul> |

### AWS Bedrock Authentication

*Required only if you plan to use models from AWS Bedrock.*

- **Option 1: IRSA (IAM Roles for Service Accounts) - Recommended for EKS**
  This method securely associates an IAM role with the LiteLLM Proxy's Kubernetes service account, avoiding the need to store static AWS credentials as secrets.

:::info

The required IAM Role ARN is automatically generated during the Terraform deployment. You can find it as `EKS_AWS_ROLE_ARN` in the `deployment_outputs.env` file.

:::

To enable IRSA, replace `%%EKS_AWS_ROLE_ARN%%` with `EKS_AWS_ROLE_ARN` value in your `litellm/values-aws.yaml` file:

```yaml
litellm-helm:
  serviceAccount:
    create: true
    annotations:
      eks.amazonaws.com/role-arn: "%%EKS_AWS_ROLE_ARN%%"
```

- **Option 2: AWS User Credentials**
  This method is used if you are not running on EKS or prefer to use static credentials.

:::info

You must create the `litellm-aws-auth` secret manually before deploying the Helm chart.

:::

Create the secret using the following command, replacing the placeholders with your actual credentials:

```bash
kubectl create secret generic litellm-aws-auth \
--namespace litellm \
--from-literal=AWS_ACCESS_KEY_ID="YOUR_AWS_ACCESS_KEY_ID" \
--from-literal=AWS_SECRET_ACCESS_KEY="YOUR_AWS_SECRET_ACCESS_KEY" \
--type=Opaque
```

Then, ensure your `litellm/values-aws.yaml` file is configured to mount this secret:

```yaml
litellm-helm:
  # ... other components
  environmentSecrets:
    - litellm-aws-auth
```

### Azure OpenAI Authentication

*Required only if you plan to use models from Azure OpenAI.*

- **Option 1: Azure Entra ID Application (Client Credentials)**

Authentication is configured via an Azure Entra ID Application. The deployment process requires the following credentials:

- `AZURE_TENANT_ID`
- `AZURE_CLIENT_ID`
- `AZURE_CLIENT_SECRET`

:::info

The variables `AZURE_TENANT_ID`, `AZURE_CLIENT_ID`, and `AZURE_CLIENT_SECRET` are available in the `deployment_outputs.env` file. This file is automatically generated during the Terraform deployment.

:::

When running the installation script and selecting Azure as your cloud provider, you will be prompted to enter them.

- **Option 2: Direct API key authentication**

:::info Content coming soon

Documentation for configuring direct API key authentication will be added soon.

:::

### Google Vertex AI Authentication

*Required only if you plan to use models from Google Vertex AI.*

If you select **GCP** as your cloud provider during the automated installation, you must provide credentials for Vertex AI.

:::info

**Prerequisite:** Before running the script, ensure a valid `gcp-service-account.json` file is present in the root of the repository. This file is necessary for authentication.

:::

During the script's execution, you will be prompted to enter the following value:

- `VERTEX_PROJECT`: Your Google Cloud project ID where Vertex AI is enabled.

</details>

## Step 4: LiteLLM Proxy Model Configuration {#step4-model-config}

<details>
<summary>Click to expand</summary>

The core of the LiteLLM Proxy configuration is the model list, which defines the LLM models the proxy will manage. Sample configuration files are provided in the Helm chart for each major cloud provider.

### Configuration File Locations

- **AWS Bedrock**: `litellm/config/litellm-aws-config.yaml`
- **Azure OpenAI**: `litellm/config/litellm-azure-config.yaml`
- **Google Vertex AI**: `litellm/config/litellm-gcp-config.yaml`

### Regional Configuration Overview

The sample configurations specify default regions for accessing the models. The table below provides a summary.

| Provider | Model | Default Region |
|----------|-------|----------------|
| AWS Bedrock | claude-3-5-sonnet | us-west-2 |
| AWS Bedrock | claude-3-5-sonnet-v2 | us-west-2 |
| AWS Bedrock | claude-3-7 | us-west-2 |
| AWS Bedrock | claude-4-sonnet-1m | us-west-2 |
| AWS Bedrock | claude-4-sonnet | us-west-2 |
| AWS Bedrock | claude-4-sonnet | eu-central-1 |
| AWS Bedrock | claude-4-opus | us-west-2 |
| AWS Bedrock | claude-4-1-opus | us-west-2 |
| AWS Bedrock | titan | us-west-2 |
| Google Vertex AI | gemini-2.0-flash | us-central1 |
| Google Vertex AI | gemini-2.5-pro | us-central1 |
| Google Vertex AI | claude-sonnet-v2-vertex | us-east5 |
| Google Vertex AI | claude-sonnet-3-7-vertex | us-east5 |
| Google Vertex AI | text-embedding-005 | us-central1 |
| Azure OpenAI | gpt-4o-2024-08-06 | eastus2 |
| Azure OpenAI | gpt-4o-2024-11-20 | eastus2 |
| Azure OpenAI | gpt-4o-mini | eastus2 |
| Azure OpenAI | gpt-4.1 | eastus2 |
| Azure OpenAI | gpt-4.1-mini | eastus2 |
| Azure OpenAI | gpt-5-2025-08-07 | eastus2 |
| Azure OpenAI | gpt-5-mini-2025-08-07 | eastus2 |
| Azure OpenAI | gpt-5-nano-2025-08-07 | eastus2 |
| Azure OpenAI | gpt-4-vision | eastus2 |
| Azure OpenAI | o3-mini | eastus2 |
| Azure OpenAI | o1 | eastus2 |
| Azure OpenAI | o3-2025-04-16 | eastus2 |
| Azure OpenAI | o4-mini-2025-04-16 | eastus2 |
| Azure OpenAI | codemie-text-embedding-ada-002 | eastus2 |

### Customizing Regions

You can customize the regions where your models are accessed by modifying the corresponding configuration files.

- **AWS Bedrock**
  To use a different AWS region, modify the `aws_region_name` parameter in the model's configuration.

```yaml
model_list:
  - model_name: claude-4-sonnet
    litellm_params:
      aws_region_name: us-west-2 # Change this to your preferred region, e.g., "eu-central-1"
```

- **Azure OpenAI**
  For Azure, the region is determined by the endpoint URL in the `api_base` parameter.

```yaml
model_list:
  - model_name: gpt-4o-2024-08-06
    litellm_params:
      model: azure/gpt-4o-2024-08-06
      api_base: https://your-resource.openai.azure.com/  # Your Azure OpenAI endpoint defines the region
      litellm_credential_name: default_azure_openai_credential
```

- **Google Vertex AI**
  For Google Vertex AI, the method for region configuration depends on the model family:

  - **Gemini Models**: Region is set globally in the `litellm_settings` section.

```yaml
litellm_settings:
  vertex_project: os.environ/VERTEX_PROJECT
  vertex_location: "us-central1"  # Change this to your preferred region for Gemini models
```

  - **Claude Models on Vertex AI**: Region and project are specified directly in each model's configuration.

```yaml
model_list:
  - model_name: claude-sonnet-3-7-vertex
    litellm_params:
      model: vertex_ai/claude-3-7-sonnet
      vertex_ai_project: os.environ/VERTEX_PROJECT
      vertex_ai_location: "us-east5"  # Change this to your preferred region for this specific model
```

</details>

## Step 5: Deployment {#step5-deployment}

Choose one of the following methods to deploy the LiteLLM Proxy. **Option A** is recommended for most users as it automates secret creation, Helm deployment, and integration configuration.

### Option A: Automated Deployment (Recommended) {#step5-option-a}

<details>
<summary>Click to expand</summary>

The deployment script automates:

- Kubernetes secret creation
- Helm repository configuration
- LiteLLM Proxy deployment
- Integration secret creation for CodeMie

#### Pre-Deployment Checklist

Before running the script, ensure you have completed the following configuration steps:

1. **Clone the Repository:** Clone the [codemie-helm-charts](https://gitbud.epam.com/epm-cdme/codemie-helm-charts) repository and navigate to its root directory.

2. **Configure API and Proxy Values:** Update both the `codemie-api/values-<cloud>.yaml` and `litellm/values-<cloud_name>.yaml` files with your environment-specific settings as described in [Step 2](#step2-configure-values).

3. **Configure LLM Models:** Review and customize your desired models and regions in the `litellm/config/litellm-<cloud>-config.yaml` file, as detailed in [Step 4](#step4-model-config).

:::warning

Completing all configuration steps mentioned in the checklist is **mandatory** for a successful installation.

:::

#### Run the Deployment Script

Once all configurations are in place, execute the following command from the root of the repository. Replace `<cloud_name>` with your target cloud (`aws`, `azure`, or `gcp`) and specify the desired version.

```bash
bash helm-charts.sh --cloud <cloud_name> --version=x.y.z --mode all --optional litellm
```

During execution, the script may prompt you to enter authentication details if you are deploying for Azure or GCP.

</details>

### Option B: Manual Deployment {#step5-option-b}

<details>
<summary>Click to expand</summary>

This method is recommended if you need granular control over the deployment process or need to integrate it into custom automation pipelines. It involves manually creating all resources and configuring the integration.

#### Pre-Deployment Checklist

Before you begin the deployment, ensure you have completed the following configuration steps:

1. **Clone the Repository:** Clone the [codemie-helm-charts](https://gitbud.epam.com/epm-cdme/codemie-helm-charts) repository and navigate to its root directory.

2. **Configure API and Proxy Values:** Update both the `codemie-api/values-<cloud>.yaml` and `litellm/values-<cloud_name>.yaml` files as described in [Step 2](#step2-configure-values).

3. **Configure LLM Models:** Customize your models and regions in the `litellm/config/litellm-<cloud>-config.yaml` file, as detailed in [Step 4](#step4-model-config).

#### Step 5.1: Create Namespace {#manual-step-5-1-namespace}

Create a dedicated namespace for all LiteLLM Proxy resources.

```bash
kubectl create namespace litellm
```

#### Step 5.2: Create Secrets and ConfigMaps {#manual-step-5-2-secrets}

Create the following secrets in the `litellm` namespace. Some are universal, while others are specific to the cloud provider you are using.

##### Universal Secrets (Required for all deployments)

**1. LiteLLM Proxy Master Key Secret**

```bash
# This key is used to secure the LiteLLM Proxy UI and API
kubectl create secret generic litellm-masterkey \
--namespace litellm \
--from-literal=masterkey="sk-$(openssl rand -hex 16)" \
--type=Opaque
```

**2. Redis Secret**

```bash
# This password secures the Redis instance used for caching
kubectl create secret generic litellm-redis \
--namespace litellm \
--from-literal=redis-password="$(openssl rand -hex 16)" \
--type=Opaque
```

**3. PostgreSQL Secret**

Replace `your_database_host_here` and `your_strong_password_here` with the values from your PostgreSQL setup in [Step 1](#step1-postgres-setup).

```bash
kubectl create secret generic litellm-postgresql \
--namespace litellm \
--from-literal=username="litellm" \
--from-literal=host="your_database_host_here" \
--from-literal=password="your_strong_password_here" \
--type=Opaque
```

##### Cloud-Specific Secrets (Create only what you need)

Refer to [Step 3: Cloud Provider Authentication Secrets](#step3-auth-secrets) for details on obtaining these credentials.

#### Step 5.3: Deploy the LiteLLM Helm Chart {#manual-step-5-3-helm}

Deploy the LiteLLM Proxy using your customized values file.

```bash
# Ensure you are in the root of the codemie-helm-charts repository
helm upgrade --install litellm ./litellm \
--namespace litellm \
--values ./litellm/values-<cloud_name>.yaml
```

#### Step 5.4: Configure CodeMie Integration {#manual-step-5-4-integration}

After the LiteLLM Proxy is running, you must configure the CodeMie API to communicate with it. This involves creating an integration secret and redeploying the CodeMie API.

##### 5.4.1. Create the Integration Secret {#manual-step-5-4-1-integration-secret}

The following command retrieves the LiteLLM domain and master key, creates a dedicated team and service account key for CodeMie, and then creates a Kubernetes secret named `litellm-integration` in the `codemie` namespace.

```bash
# Get the LiteLLM domain from ingress
LITELLM_DOMAIN=$(kubectl get ingress -n litellm litellm -o jsonpath='{.spec.rules[0].host}')
echo "LiteLLM domain is: $LITELLM_DOMAIN"

# Get the LiteLLM master key
LITELLM_MASTER_KEY=$(kubectl get secret litellm-masterkey -n litellm -o jsonpath='{.data.masterkey}' | base64 --decode)

# Create a new team in LiteLLM
curl --location "https://$LITELLM_DOMAIN/team/new" \
--header 'Content-Type: application/json' \
--header "Authorization: Bearer $LITELLM_MASTER_KEY" \
--data '{ "team_alias": "codemie", "team_id": "codemie" }'

# Generate Application Key
LITELLM_APPLICATION_KEY="sk-$(openssl rand -hex 16)"
curl --location "https://$LITELLM_DOMAIN/key/service-account/generate" \
--header "Content-Type: application/json" \
--header "Authorization: Bearer $LITELLM_MASTER_KEY" \
--data "{ \"key_alias\": \"codemie-back\", \"key\": \"$LITELLM_APPLICATION_KEY\", \"team_id\": \"codemie\" }"

# Create integration secret
kubectl create secret generic litellm-integration \
--namespace codemie \
--from-literal=litellm-app-key="$LITELLM_APPLICATION_KEY" \
--from-literal=litellm-master-key="$LITELLM_MASTER_KEY" \
--type=Opaque
```

##### 5.4.2. Redeploy the CodeMie API {#manual-step-5-4-2-redeploy-api}

Now that the `litellm-integration` secret is created, you must redeploy the CodeMie API to apply the configuration changes. The required environment variables should already be present in your `codemie-api/values-<cloud>.yaml` file, as specified in the pre-deployment checklist.

Run the deployment command for the CodeMie API to finalize the integration.

```bash title="Example Redeployment Command"
# Adjust this command to your deployment workflow
helm upgrade --install codemie-api oci://<your-registry>/codemie \
--version x.y.z \
--namespace "codemie" \
-f "./codemie-api/values-<cloud_name>.yaml" \
--wait --timeout 600s
```

#### Step 5.5: Verify Deployment and Access UI {#manual-step-5-5-verify}

##### Verification Commands

Use the following commands to check the status of your LiteLLM Proxy deployment:

```bash
# Check if LiteLLM Proxy pods are running
kubectl get pods -n litellm

# Check if the services are created
kubectl get svc -n litellm

# Check if the ingress is configured correctly
kubectl get ingress -n litellm
```

##### Accessing the LiteLLM UI

You can access the administrative UI using the domain configured in your ingress. The username is `admin`, and the password is the master key you created.

```bash
# Get the LiteLLM UI URL
LITELLM_DOMAIN=$(kubectl get ingress -n litellm litellm -o jsonpath='{.spec.rules[0].host}')
echo "LiteLLM UI is available at: https://$LITELLM_DOMAIN"

# Get the master key to use as the password
LITELLM_MASTER_KEY=$(kubectl get secret litellm-masterkey -n litellm -o jsonpath='{.data.masterkey}' | base64 --decode)
echo "Use 'admin' as the username and the following key as the password: $LITELLM_MASTER_KEY"
```

</details>

## Appendix: Migration Guide from DIAL to LiteLLM {#appendix-migration}

<details>
<summary>Click here for instructions on migrating from DIAL Proxy to LiteLLM</summary>

This guide provides a safe, step-by-step process for migrating from the deprecated DIAL component to LiteLLM without service interruption.

:::info

**Migration Strategy:** We will first deploy and verify a standalone LiteLLM instance. Only after confirming it is operational will we reconfigure the CodeMie API to use the new proxy.

:::

### Migration Steps

1. **Prepare the PostgreSQL Database**
   Follow the instructions in [Step 1: PostgreSQL Database Setup](#step1-postgres-setup).

2. **Deploy LiteLLM Proxy Standalone**
   Follow the first three parts of the manual deployment guide to install LiteLLM without connecting it to the CodeMie API yet:
   - [Step 5.1: Create Namespace](#manual-step-5-1-namespace)
   - [Step 5.2: Create Secrets and ConfigMaps](#manual-step-5-2-secrets)
   - [Step 5.3: Deploy the LiteLLM Helm Chart](#manual-step-5-3-helm)

3. **Verify the Standalone LiteLLM Instance**
   Before proceeding, use the verification commands from [Step 5.5](#manual-step-5-5-verify) to ensure LiteLLM is running correctly and you can access its UI. The dashboard will show no traffic, which is expected.

4. **Reconfigure and Redeploy the CodeMie API**
   Now, switch the CodeMie API from DIAL to LiteLLM.

   1. Create the integration secret by following the instructions in [Step 5.4.1: Create the Integration Secret](#manual-step-5-4-1-integration-secret).

   2. In your `codemie-api/values-<cloud>.yaml`, remove the old DIAL environment variables and ensure the LiteLLM variables (as specified in [Step 2](#step2-configure-values)) are correctly configured.

```yaml title="Update extraEnv in codemie-api/values-<cloud_name>.yaml"
# In codemie-api/values-<cloud_name>.yaml
extraEnv:
  # ... other existing variables ...

  # 1. REMOVE or COMMENT OUT the old DIAL variables
  # - name: AZURE_OPENAI_URL
  #   value: "http://dial-core.codemie-dial"
  # - name: AZURE_OPENAI_API_KEY
  #   value: "b9bcf6fce0243f2599ef1e7ee4fb9951"

  # 2. ENSURE the new LiteLLM variables are present and configured
  - name: LLM_PROXY_MODE
    value: "lite_llm"
  - name: LLM_PROXY_ENABLED
    value: "true"
  - name: LITE_LLM_URL
    value: "http://litellm.litellm:4000"
  - name: LITE_LLM_TAGS_HEADER_VALUE
    value: "global"
  - name: LITE_LLM_APP_KEY
    valueFrom:
      secretKeyRef:
        name: litellm-integration
        key: litellm-app-key
  - name: LITE_LLM_MASTER_KEY
    valueFrom:
      secretKeyRef:
        name: litellm-integration
        key: litellm-master-key
```

   3. Redeploy the CodeMie API to apply the changes by following the instructions in [Step 5.4.2: Redeploy the CodeMie API](#manual-step-5-4-2-redeploy-api).

5. **Verify the Full Integration**
   After the `codemie-api` pod restarts, test the integration by using a feature in the CodeMie UI that makes an LLM call. Check the **Dashboard** in the LiteLLM UI to confirm that new requests are appearing and being processed successfully.

6. **Deprecate and Remove DIAL**

:::warning

This is a destructive operation. Ensure your platform is fully functional with LiteLLM before proceeding.

:::

Once you have confirmed the integration is stable, you can safely remove the old DIAL components.

```bash
# Uninstall the DIAL Helm release
helm uninstall dial --namespace codemie-dial

# Delete the DIAL namespace and all its resources
kubectl delete namespace codemie-dial

# Delete the old integration secret from the 'codemie' namespace
kubectl delete secret secret-azure-openai-api -n codemie
```

The migration is now complete.

</details>

## Next Steps

- Return to [Extensions Overview](./)
- Configure other extensions
