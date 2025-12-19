---
id: components-scripted-deployment
sidebar_position: 1
title: Scripted Deployment
description: Automated components deployment using Helm charts
---

# Scripted Components Deployment

The `helm-charts.sh` script (from the [codemie-helm-charts](https://gitbud.epam.com/epm-cdme/codemie-helm-charts) repository) automates the deployment of AI/Run CodeMie components using Helm charts.

## Prerequisites

- EKS cluster with:
  - Nginx Ingress Controller (or will be installed if using `--mode all`)
  - AWS gp3 storage class
- [Helm](https://helm.sh/docs/intro/install/) installed and configured
- Required cloud provider CLI tools and credentials set up (AWS CLI, Google Cloud SDK)
- `deployment_outputs.env` file from Infrastructure Deployment copied to root directory

## Script Parameters

The script requires exactly three input parameters:

### 1. Cloud Provider

Target cloud provider where deployment should be executed.

**Allowed Values:** `aws`, `azure`, `gcp`

### 2. AI/Run Version

Version of AI/Run components to deploy (semantic versioning format).

**Example:** `x.y.z`

### 3. Mode Name

Specifies which components to install.

**Allowed Values:**

- `all` - installs both AI/Run CodeMie and 3rd-party components (for fresh installation)
- `recommended` - installs both AI/Run and 3rd-party components except Nginx Ingress Controller
- `update` - updates only AI/Run CodeMie core components (see [Update AI/Run CodeMie](../update-version) for more details)

## Component Configuration

Before running the script, configure component-specific placeholders:

| Component    | Placeholder              | Description           | Example                                          | File to Edit                    |
| ------------ | ------------------------ | --------------------- | ------------------------------------------------ | ------------------------------- |
| Kibana       | `%%DOMAIN%%`             | Your public domain    | `example.com`                                    | `kibana/values-aws.yaml`        |
| Keycloak     | `%%DOMAIN%%`             | Your public domain    | `example.com`                                    | `keycloak-helm/values-aws.yaml` |
| OAuth2 Proxy | `%%DOMAIN%%`             | Your public domain    | `example.com`                                    | `oauth2-proxy/values-aws.yaml`  |
| CodeMie UI   | `%%DOMAIN%%`             | Your public domain    | `example.com`                                    | `codemie-ui/values-aws.yaml`    |
| CodeMie API  | `%%DOMAIN%%`             | Your public domain    | `example.com`                                    | `codemie-api/values-aws.yaml`   |
| CodeMie API  | `%%AWS_DEFAULT_REGION%%` | AWS region            | `us-west-2`                                      | `codemie-api/values-aws.yaml`   |
| CodeMie API  | `%%EKS_AWS_ROLE_ARN%%`   | IAM role for EKS IRSA | `arn:aws:iam::0123456789012:role/AWSIRSA_AI_RUN` | `codemie-api/values-aws.yaml`   |
| CodeMie API  | `%%AWS_KMS_KEY_ID%%`     | AWS KMS key ID        | `50f3f093-dc86-48de-8f2d-7a76e480348c`           | `codemie-api/values-aws.yaml`   |
| CodeMie API  | `%%AWS_S3_BUCKET_NAME%%` | S3 bucket name        | `codemie-user-data-0123456789012`                | `codemie-api/values-aws.yaml`   |
| CodeMie API  | `%%AWS_S3_REGION%%`      | S3 bucket region      | `us-west-2`                                      | `codemie-api/values-aws.yaml`   |

## Usage Example

To deploy AI/Run CodeMie with all third-party components:

**For Helm 3.x:**

```bash
export GOOGLE_APPLICATION_CREDENTIALS=key.json
gcloud auth application-default print-access-token | helm registry login -u oauth2accesstoken --password-stdin https://europe-west3-docker.pkg.dev

bash helm-charts.sh --cloud aws --version x.y.z --mode all
```

**For Helm 4.x and higher:**

```bash
export GOOGLE_APPLICATION_CREDENTIALS=key.json
gcloud auth application-default print-access-token | helm registry login -u oauth2accesstoken --password-stdin europe-west3-docker.pkg.dev

bash helm-charts.sh --cloud aws --version x.y.z --mode all
```

## Next Steps

After successful deployment, proceed to [Post-Installation Configuration](../post-installation/) to complete required setup steps.
