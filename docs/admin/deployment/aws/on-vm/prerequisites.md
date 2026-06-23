---
id: prerequisites
title: Prerequisites
sidebar_label: Prerequisites
sidebar_position: 2
pagination_prev: admin/deployment/aws/on-vm/overview
pagination_next: admin/deployment/aws/on-vm/architecture
---

# Prerequisites

This page outlines the requirements for deploying AI/Run CodeMie On VM. Ensure all prerequisites are met before proceeding.

## AWS Account Requirements

### Required Access and Permissions

- **Active AWS Account** with a region that supports [Amazon Bedrock](https://docs.aws.amazon.com/bedrock/latest/userguide/bedrock-regions.html)
- **IAM permissions** to create an IAM deployer role (one-time setup)
- **Sufficient quota** for: 1 EC2 instance, 1 VPC, 1 S3 bucket, 1 KMS key, 1 EIP

:::tip IAM Deployer Role
The deployment uses a dedicated IAM role with scoped permissions. You only need broad IAM access to create this role once — subsequent deployments use the role.
:::

### Network Requirements

- Outbound internet access from EC2 (to pull Docker images, access Bedrock API)
- Optional: Route 53 hosted zone (if using a custom domain with ALB + ACM)

## Deployment Machine Tools

The following tools must be installed on the machine where you run `./deploy.sh`:

| Tool                                                                                                                                    | Version | Purpose                     |
| --------------------------------------------------------------------------------------------------------------------------------------- | ------- | --------------------------- |
| [Terraform](https://developer.hashicorp.com/terraform/install)                                                                          | 1.15.x  | Infrastructure provisioning |
| [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)                                                | latest  | AWS resource management     |
| [Session Manager Plugin](https://docs.aws.amazon.com/systems-manager/latest/userguide/session-manager-working-with-install-plugin.html) | latest  | SSH access via AWS SSM      |
| [jq](https://jqlang.github.io/jq/download/)                                                                                             | latest  | JSON parsing                |
| openssl                                                                                                                                 | latest  | Secret generation           |
| envsubst                                                                                                                                | latest  | Template rendering          |

**Enterprise profile only:**

| Tool                                  | Version | Purpose             |
| ------------------------------------- | ------- | ------------------- |
| [nsc](https://github.com/nats-io/nsc) | latest  | NATS key generation |

### Verify Installation

```bash
terraform version    # Should show 1.15.x
aws --version        # AWS CLI v2
session-manager-plugin  # Should print version info
jq --version
openssl version
envsubst --version
```

## GCP Container Registry Access

CodeMie container images are hosted on `europe-west3-docker.pkg.dev`. You need a **GCP service account key file** (`key.json`) with read access to the registry.

:::info Obtaining key.json
Contact your CodeMie administrator or EPAM delivery team to obtain the `key.json` file for registry access.
:::

## Repository Access

Clone the deployment repository:

```bash
git clone https://gitbud.epam.com/epm-cdme/codemie-on-vm.git
cd codemie-on-vm
```

The repository structure:

| Directory                              | Purpose                                        |
| -------------------------------------- | ---------------------------------------------- |
| `compose/`                             | Docker Compose files and service configuration |
| `deploy.sh`                            | Deployment script                              |
| `terraform/aws/codemie-on-vm-aws-iam/` | IAM deployer role Terraform module             |
| `terraform/aws/remote-backend/`        | S3 Terraform state bucket                      |
| `terraform/aws/platform/`              | EC2, VPC, ALB, S3, KMS infrastructure          |

## Next Steps

After verifying all prerequisites, review the [Architecture](/admin/deployment/aws/on-vm/architecture) to understand what will be deployed.
