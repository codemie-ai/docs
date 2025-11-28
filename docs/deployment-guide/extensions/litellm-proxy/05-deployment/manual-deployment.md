---
id: manual-deployment
sidebar_label: Manual Deployment
sidebar_position: 2
title: Manual Deployment
description: Deploy LiteLLM Proxy manually with granular control
---

# Manual Deployment

This method is recommended if you need granular control over the deployment process or need to integrate it into custom automation pipelines. It involves manually creating all resources and configuring the integration.

## Pre-Deployment Checklist

Before you begin the deployment, ensure you have completed the following configuration steps:

1. **Clone the Repository:** Clone the [codemie-helm-charts](https://gitbud.epam.com/epm-cdme/codemie-helm-charts) repository and navigate to its root directory.

2. **Configure API and Proxy Values:** Update both the `codemie-api/values-<cloud>.yaml` and `litellm/values-<cloud_name>.yaml` files as described in [Configure Values](../configure-values).

3. **Configure LLM Models:** Customize your models and regions in the `litellm/config/litellm-<cloud>-config.yaml` file, as detailed in [Model Configuration](../model-config).

## Step 5.1: Create Namespace

Create a dedicated namespace for all LiteLLM Proxy resources.

```bash
kubectl create namespace litellm
```

## Step 5.2: Create Secrets and ConfigMaps

Create the following secrets in the `litellm` namespace. Some are universal, while others are specific to the cloud provider you are using.

### Universal Secrets (Required for all deployments)

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

Replace `your_database_host_here` and `your_strong_password_here` with the values from your PostgreSQL setup in [PostgreSQL Setup](../postgres-setup).

```bash
kubectl create secret generic litellm-postgresql \
--namespace litellm \
--from-literal=username="litellm" \
--from-literal=host="your_database_host_here" \
--from-literal=password="your_strong_password_here" \
--type=Opaque
```

### Cloud-Specific Secrets (Create only what you need)

Refer to [Cloud Provider Authentication](../auth-secrets) for details on obtaining these credentials.

## Step 5.3: Deploy the LiteLLM Helm Chart

Deploy the LiteLLM Proxy using your customized values file.

```bash
# Ensure you are in the root of the codemie-helm-charts repository
helm upgrade --install litellm ./litellm \
--namespace litellm \
--values ./litellm/values-<cloud_name>.yaml
```

## Step 5.4: Configure CodeMie Integration

After the LiteLLM Proxy is running, you must configure the CodeMie API to communicate with it. This involves creating an integration secret and redeploying the CodeMie API.

### 5.4.1. Create the Integration Secret

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

### 5.4.2. Redeploy the CodeMie API

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

## Step 5.5: Verify Deployment and Access UI

### Verification Commands

Use the following commands to check the status of your LiteLLM Proxy deployment:

```bash
# Check if LiteLLM Proxy pods are running
kubectl get pods -n litellm

# Check if the services are created
kubectl get svc -n litellm

# Check if the ingress is configured correctly
kubectl get ingress -n litellm
```

### Accessing the LiteLLM UI

You can access the administrative UI using the domain configured in your ingress. The username is `admin`, and the password is the master key you created.

```bash
# Get the LiteLLM UI URL
LITELLM_DOMAIN=$(kubectl get ingress -n litellm litellm -o jsonpath='{.spec.rules[0].host}')
echo "LiteLLM UI is available at: https://$LITELLM_DOMAIN"

# Get the master key to use as the password
LITELLM_MASTER_KEY=$(kubectl get secret litellm-masterkey -n litellm -o jsonpath='{.data.masterkey}' | base64 --decode)
echo "Use 'admin' as the username and the following key as the password: $LITELLM_MASTER_KEY"
```

## Next Steps

- For migration from DIAL Proxy, see [Migration Guide](../migration-guide)
- Return to [Extensions Overview](../../)
- Configure other extensions
