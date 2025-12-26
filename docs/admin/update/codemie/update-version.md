---
id: update-version
sidebar_position: 1
title: Update AI/Run CodeMie
sidebar_label: CodeMie Platform
description: Step-by-step guide for updating AI/Run CodeMie components across AWS, Azure, and GCP deployments
---

# Update AI/Run CodeMie Core Components

This guide provides comprehensive instructions for updating your AI/Run CodeMie deployment to the latest version. The update process is streamlined and supports all major cloud providers.

:::tip Best Practice
Regular updates ensure optimal performance, security patches, and access to the latest features.
:::

## Components to Update

This update process will upgrade the following AI/Run CodeMie components:

- **CodeMie MCP Connect** - Model Context Protocol integration service
- **Mermaid Server** - Diagram rendering service
- **CodeMie NATS Auth Callout** - Message bus authentication service
- **CodeMie UI** - Frontend application
- **CodeMie API** - Backend services and APIs

## Prerequisites

Before beginning the update process, ensure you have the following:

### Required Access and Tools

- Access to the [codemie-helm-charts](https://gitbud.epam.com/epm-cdme/codemie-helm-charts) repository
- `kubectl` configured with access to your Kubernetes cluster (EKS/AKS/GKE)
- Helm 3.16.0 or higher installed
- Local copy of `codemie-helm-charts` repository with values from initial deployment

### Pre-Update Checklist

- [ ] Review the latest release notes
- [ ] Create backups of critical data and configurations
- [ ] Verify cluster resources are sufficient
- [ ] Confirm maintenance window with stakeholders

### Helm Registry Authentication

Before updating, authenticate with the AI/Run CodeMie Helm registry:

```bash
export GOOGLE_APPLICATION_CREDENTIALS=key.json
gcloud auth application-default print-access-token | helm registry login -u oauth2accesstoken --password-stdin europe-west3-docker.pkg.dev
```

:::warning Authentication Required
All update operations require valid Helm registry authentication. Ensure your credentials are current before proceeding.
:::

## Update Methods

Choose the update method that best suits your operational requirements:

- **Automated Update**: Recommended for most deployments. Uses a script to update all components in the correct sequence.
- **Manual Update**: Provides granular control over the update process. Useful for troubleshooting or staged rollouts.

### Automated Update (Recommended)

The automated update script ensures all components are updated in the correct order with minimal manual intervention.

#### Update Command

Replace `x.y.z` with your target version (e.g., `2.2.5`):

import Tabs from '@theme/Tabs';
import TabItem from '@theme/TabItem';

<Tabs groupId="cloud-provider">
  <TabItem value="aws" label="AWS" default>
    ```bash
    bash helm-charts.sh --cloud aws --version x.y.z --mode update
    ```

    **Example:**
    ```bash
    bash helm-charts.sh --cloud aws --version 2.2.5 --mode update
    ```

  </TabItem>
  <TabItem value="azure" label="Azure">
    ```bash
    bash helm-charts.sh --cloud azure --version x.y.z --mode update
    ```

    **Example:**
    ```bash
    bash helm-charts.sh --cloud azure --version 2.2.5 --mode update
    ```

  </TabItem>
  <TabItem value="gcp" label="GCP">
    ```bash
    bash helm-charts.sh --cloud gcp --version x.y.z --mode update
    ```

    **Example:**
    ```bash
    bash helm-charts.sh --cloud gcp --version 2.2.5 --mode update
    ```

  </TabItem>
</Tabs>

#### Update Sequence

The automated script updates components in the following order to ensure compatibility:

1. **CodeMie MCP Connect** - Model Context Protocol integration service
2. **Mermaid Server** - Diagram rendering service
3. **CodeMie NATS Auth Callout** - Message bus authentication service
4. **CodeMie UI** - Frontend application
5. **CodeMie API** - Backend services and APIs

### Manual Update

For advanced users requiring granular control over the update process or performing staged rollouts, manual component updates can be performed individually.

#### Step 1: Update CodeMie MCP Connect Service

Update the Model Context Protocol integration service.

Replace `x.y.z` with your target version (e.g., `2.2.5`):

```bash
helm upgrade --install codemie-mcp-connect-service \
  oci://europe-west3-docker.pkg.dev/or2-msq-epmd-edp-anthos-t1iylu/helm-charts/codemie-mcp-connect-service \
  --version x.y.z \
  --namespace "codemie" \
  -f "./codemie-mcp-connect-service/values.yaml" \
  --wait --timeout 600s
```

#### Step 2: Update Mermaid Server

Update the diagram rendering service.

Replace `x.y.z` with your target version (e.g., `2.2.5`):

```bash
helm upgrade --install mermaid-server \
  oci://europe-west3-docker.pkg.dev/or2-msq-epmd-edp-anthos-t1iylu/helm-charts/mermaid-server \
  --version x.y.z \
  --namespace "codemie" \
  -f "./mermaid-server/values.yaml" \
  --wait --timeout 600s
```

#### Step 3: Update CodeMie NATS Auth Callout

Update the message bus authentication service with cloud-specific configuration.

Replace `x.y.z` with your target version (e.g., `2.2.5`):

<Tabs groupId="cloud-provider">
  <TabItem value="aws" label="AWS" default>
    ```bash
    helm upgrade --install codemie-nats-auth-callout \
      oci://europe-west3-docker.pkg.dev/or2-msq-epmd-edp-anthos-t1iylu/helm-charts/codemie-nats-auth-callout \
      --version x.y.z \
      --namespace "codemie" \
      -f "./codemie-nats-auth-callout/values-aws.yaml" \
      --wait --timeout 600s
    ```
  </TabItem>
  <TabItem value="azure" label="Azure">
    ```bash
    helm upgrade --install codemie-nats-auth-callout \
      oci://europe-west3-docker.pkg.dev/or2-msq-epmd-edp-anthos-t1iylu/helm-charts/codemie-nats-auth-callout \
      --version x.y.z \
      --namespace "codemie" \
      -f "./codemie-nats-auth-callout/values-azure.yaml" \
      --wait --timeout 600s
    ```
  </TabItem>
  <TabItem value="gcp" label="GCP">
    ```bash
    helm upgrade --install codemie-nats-auth-callout \
      oci://europe-west3-docker.pkg.dev/or2-msq-epmd-edp-anthos-t1iylu/helm-charts/codemie-nats-auth-callout \
      --version x.y.z \
      --namespace "codemie" \
      -f "./codemie-nats-auth-callout/values-gcp.yaml" \
      --wait --timeout 600s
    ```
  </TabItem>
</Tabs>

#### Step 4: Update CodeMie UI

Update the frontend application with cloud-specific configuration.

Replace `x.y.z` with your target version (e.g., `2.2.5`):

<Tabs groupId="cloud-provider">
  <TabItem value="aws" label="AWS" default>
    ```bash
    helm upgrade --install codemie-ui \
      oci://europe-west3-docker.pkg.dev/or2-msq-epmd-edp-anthos-t1iylu/helm-charts/codemie-ui \
      --version x.y.z \
      --namespace "codemie" \
      -f "./codemie-ui/values-aws.yaml" \
      --wait --timeout 180s
    ```
  </TabItem>
  <TabItem value="azure" label="Azure">
    ```bash
    helm upgrade --install codemie-ui \
      oci://europe-west3-docker.pkg.dev/or2-msq-epmd-edp-anthos-t1iylu/helm-charts/codemie-ui \
      --version x.y.z \
      --namespace "codemie" \
      -f "./codemie-ui/values-azure.yaml" \
      --wait --timeout 180s
    ```
  </TabItem>
  <TabItem value="gcp" label="GCP">
    ```bash
    helm upgrade --install codemie-ui \
      oci://europe-west3-docker.pkg.dev/or2-msq-epmd-edp-anthos-t1iylu/helm-charts/codemie-ui \
      --version x.y.z \
      --namespace "codemie" \
      -f "./codemie-ui/values-gcp.yaml" \
      --wait --timeout 180s
    ```
  </TabItem>
</Tabs>

#### Step 5: Update CodeMie API

Update the backend services and APIs with cloud-specific configuration.

Replace `x.y.z` with your target version (e.g., `2.2.5`):

<Tabs groupId="cloud-provider">
  <TabItem value="aws" label="AWS" default>
    ```bash
    helm upgrade --install codemie-api \
      oci://europe-west3-docker.pkg.dev/or2-msq-epmd-edp-anthos-t1iylu/helm-charts/codemie \
      --version x.y.z \
      --namespace "codemie" \
      -f "./codemie-api/values-aws.yaml" \
      --wait --timeout 600s
    ```
  </TabItem>
  <TabItem value="azure" label="Azure">
    ```bash
    helm upgrade --install codemie-api \
      oci://europe-west3-docker.pkg.dev/or2-msq-epmd-edp-anthos-t1iylu/helm-charts/codemie \
      --version x.y.z \
      --namespace "codemie" \
      -f "./codemie-api/values-azure.yaml" \
      --wait --timeout 600s
    ```
  </TabItem>
  <TabItem value="gcp" label="GCP">
    ```bash
    helm upgrade --install codemie-api \
      oci://europe-west3-docker.pkg.dev/or2-msq-epmd-edp-anthos-t1iylu/helm-charts/codemie \
      --version x.y.z \
      --namespace "codemie" \
      -f "./codemie-api/values-gcp.yaml" \
      --wait --timeout 600s
    ```
  </TabItem>
</Tabs>

#### Step 6: Verify Update Success

After updating all components, verify the deployment status:

```bash
kubectl get pods -n codemie
```

**Success Criteria:**

- All pods are in `Running` state
- No pods are in `CrashLoopBackOff` or `Error` state

### Functional Testing

1. **Access the UI** - Verify the web interface loads correctly
2. **Test Authentication** - Confirm user login functionality
3. **Create Assistant** - Validate core functionality
4. **Review Logs** - Check for any error messages or warnings

## Troubleshooting

If you encounter issues during or after the update, use these troubleshooting steps:

### Image Pull Errors

**Symptoms:**

- Pods show `ImagePullBackOff` or `ErrImagePull` status
- Error messages indicate authentication failures
- Container images cannot be downloaded from the registry

**Resolution:**

Request a new service account key

:::warning Service Account Key Expiration
Service account keys have a **90-day retention period** and expire automatically after this time. If authentication continues to fail after re-authentication attempts, your `key.json` service account key has likely expired.

**To resolve expired keys:**

1. Request a new service account key from your administrator or support team
2. Replace the expired `key.json` file with the newly provided key
3. Re-authenticate using the new credentials
4. Update the image pull secret in your Kubernetes cluster

Contact your support team to obtain a new service account key for registry access.
:::

## Support

If you need assistance with the update process:

1. Review this documentation thoroughly
2. Check the troubleshooting section for common issues
3. Consult the [FAQ](../../deployment/faq) for known issues
4. Contact your support team with detailed error messages and logs
