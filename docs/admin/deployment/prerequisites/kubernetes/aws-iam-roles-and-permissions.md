---
id: aws-iam-roles-and-permissions
title: AWS IAM Roles and Permissions
sidebar_label: AWS IAM Roles and Permissions
sidebar_position: 4
pagination_prev: admin/deployment/prerequisites/prerequisites-kubernetes
pagination_next: null
---

# AWS IAM Roles and Permissions

This page describes the IAM roles and permissions required to deploy and run AI/Run CodeMie on AWS. It is intended for administrators who install the platform into an existing AWS account or EKS cluster, where the IAM roles are created manually or by a separate security team instead of the CodeMie Terraform modules.

## Overview

Two groups of IAM roles are involved in an AWS installation:

| Role                            | Used by                                    | Created by default in                                                                             | Required when                                            |
| ------------------------------- | ------------------------------------------ | ------------------------------------------------------------------------------------------------- | -------------------------------------------------------- |
| **Deployer role**               | The engineer or CI job that runs Terraform | [codemie-terraform-aws-iam](https://gitbud.epam.com/epm-cdme/codemie-terraform-aws-iam)           | Infrastructure is provisioned with the Terraform modules |
| **IRSA roles** (workload roles) | CodeMie pods running in EKS                | [codemie-terraform-aws-platform](https://gitbud.epam.com/epm-cdme/codemie-terraform-aws-platform) | Always, including when an existing cluster is reused     |
| **Cluster add-on roles**        | EBS CSI driver and VPC CNI add-ons         | [codemie-terraform-aws-platform](https://gitbud.epam.com/epm-cdme/codemie-terraform-aws-platform) | The cluster does not already provide equivalent roles    |

:::info Which roles are needed

- **Terraform provisions the infrastructure:** the deployer role is required. Phase 1 of the [infrastructure deployment](../../infrastructure-deployment/kubernetes.mdx) creates it, and can be skipped only if a role with the permissions below already exists.
- **Existing EKS cluster, Terraform is not used for the cluster:** the deployer role is not needed. The IRSA roles, the cluster OIDC provider, and the supporting resources described in [Requirements for an Existing EKS Cluster](#requirements-for-an-existing-eks-cluster) must be present.
  :::

## Deployer Role

The deployer role is assumed by Terraform to create and manage the EKS cluster and the related AWS resources. By default, it is named `AIRunDeployerRole`.

### Trust Policy

The role can be assumed by principals of the same AWS account and by EC2 instances:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com",
        "AWS": "arn:aws:iam::<ACCOUNT_ID>:root"
      }
    }
  ]
}
```

Access to assume the role is then granted to individual users or roles through their own IAM policies. After the role is created, its ARN is passed to the platform deployment as `TF_VAR_role_arn` in `deployment.conf`.

### Permissions Summary

The role carries eight inline policies. All of them use `Resource: "*"`, except the EKS identity provider policy, which is limited to EKS clusters in the account.

| Policy                                      | AWS services and capabilities                                                                                                                          |
| ------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------ |
| `DeployerPolicy-<platform_name>`            | ACM, Auto Scaling, EC2 and VPC networking, Elastic Load Balancing, IAM roles, policies and OIDC providers, Route 53, S3, SSM parameters, ECR, DynamoDB |
| `DeployerPolicyEKS-<platform_name>`         | EKS clusters, node groups, Fargate profiles, add-ons, and access entries                                                                               |
| `DeployerPolicyEKS-IDP-<platform_name>`     | EKS identity provider configuration, limited to `arn:aws:eks:*:<ACCOUNT_ID>:cluster/*`                                                                 |
| `DeployerPolicyLogs-<platform_name>`        | CloudWatch Logs log groups and retention                                                                                                               |
| `DeployerPolicyKMS-<platform_name>`         | KMS keys, aliases, grants, key policies, and key rotation                                                                                              |
| `DeployerPolicyRDS-<platform_name>`         | RDS instances, subnet groups, and parameter groups                                                                                                     |
| `DeployerPolicyElasticache-<platform_name>` | ElastiCache replication groups, subnet groups, and parameter groups                                                                                    |
| `DeployerPolicyBedrock-<platform_name>`     | Amazon Bedrock Guardrails management                                                                                                                   |

`<platform_name>` is the value of the `platform_name` variable, `codemie` by default.

:::note Scope of the permissions
The listed permissions cover provisioning of every component created by the Terraform modules. If a component is not provisioned by Terraform in a given installation (for example, an existing RDS instance), the corresponding actions can be removed from the policy.
:::

### Permissions Boundary

If the organization enforces IAM permissions boundaries, the boundary policy ARN can be attached to the deployer role with the `iam_permissions_boundary_policy_arn` variable of the IAM module. The boundary must not block the actions listed below. The same applies to the IRSA roles created by the platform module, which accept a boundary through `TF_VAR_role_permissions_boundary_arn`.

### Complete Policy Definitions

Expand a policy to view the exact list of actions.

<details>
<summary>`DeployerPolicy-<platform_name>`: core infrastructure (139 actions)</summary>

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "acm:*",
        "autoscaling:AttachInstances",
        "autoscaling:AttachLoadBalancers",
        "autoscaling:AttachLoadBalancerTargetGroups",
        "autoscaling:CreateAutoScalingGroup",
        "autoscaling:CreateLaunchConfiguration",
        "autoscaling:CreateOrUpdateTags",
        "autoscaling:DeleteAutoScalingGroup",
        "autoscaling:DeleteLaunchConfiguration",
        "autoscaling:DeleteScheduledAction",
        "autoscaling:DeleteTags",
        "autoscaling:Describe*",
        "autoscaling:DetachInstances",
        "autoscaling:DetachLoadBalancers",
        "autoscaling:DetachLoadBalancerTargetGroups",
        "autoscaling:PutScheduledUpdateGroupAction",
        "autoscaling:ResumeProcesses",
        "autoscaling:SetDesiredCapacity",
        "autoscaling:SetInstanceProtection",
        "autoscaling:SuspendProcesses",
        "autoscaling:UpdateAutoScalingGroup",
        "autoscaling:StartInstanceRefresh",
        "ec2:AllocateAddress",
        "ec2:AssignPrivateIpAddresses",
        "ec2:Associate*",
        "ec2:AttachInternetGateway",
        "ec2:AttachNetworkInterface",
        "ec2:AuthorizeSecurityGroupEgress",
        "ec2:AuthorizeSecurityGroupIngress",
        "ec2:CreateDefaultSubnet",
        "ec2:CreateDhcpOptions",
        "ec2:CreateEgressOnlyInternetGateway",
        "ec2:CreateInternetGateway",
        "ec2:CreateLaunchTemplate",
        "ec2:CreateLaunchTemplateVersion",
        "ec2:CreateNatGateway",
        "ec2:CreateNetworkInterface",
        "ec2:CreateRoute",
        "ec2:CreateRouteTable",
        "ec2:CreateSecurityGroup",
        "ec2:CreateSubnet",
        "ec2:CreateTags",
        "ec2:CreateVolume",
        "ec2:CreateVpc",
        "ec2:CreateVpcEndpoint",
        "ec2:DeleteDhcpOptions",
        "ec2:DeleteEgressOnlyInternetGateway",
        "ec2:DeleteInternetGateway",
        "ec2:DeleteKeyPair",
        "ec2:DeleteLaunchTemplate",
        "ec2:DeleteLaunchTemplateVersions",
        "ec2:DeleteNatGateway",
        "ec2:DeleteNetworkInterface",
        "ec2:DeleteRoute",
        "ec2:DeleteRouteTable",
        "ec2:DeleteSecurityGroup",
        "ec2:DeleteSubnet",
        "ec2:DeleteTags",
        "ec2:DeleteVolume",
        "ec2:DeleteVpc",
        "ec2:DeleteVpnGateway",
        "ec2:Describe*",
        "ec2:DetachInternetGateway",
        "ec2:DetachNetworkInterface",
        "ec2:DetachVolume",
        "ec2:Disassociate*",
        "ec2:GetLaunchTemplateData",
        "ec2:ImportKeyPair",
        "ec2:ModifyLaunchTemplate",
        "ec2:ModifySubnetAttribute",
        "ec2:ModifyVpcAttribute",
        "ec2:ModifyVpcEndpoint",
        "ec2:ReleaseAddress",
        "ec2:ReplaceRoute",
        "ec2:RevokeSecurityGroupEgress",
        "ec2:RevokeSecurityGroupIngress",
        "ec2:RunInstances",
        "ec2:UpdateSecurityGroupRuleDescriptionsEgress",
        "ec2:UpdateSecurityGroupRuleDescriptionsIngress",
        "ec2:GetSecurityGroupsForVpc",
        "ec2:ReplaceRouteTableAssociation",
        "elasticloadbalancing:*",
        "iam:AddRoleToInstanceProfile",
        "iam:AttachRolePolicy",
        "iam:CreateInstanceProfile",
        "iam:CreateOpenIDConnectProvider",
        "iam:CreatePolicy",
        "iam:CreatePolicyVersion",
        "iam:CreateRole",
        "iam:CreateServiceLinkedRole",
        "iam:DeleteInstanceProfile",
        "iam:DeleteOpenIDConnectProvider",
        "iam:DeletePolicy",
        "iam:DeletePolicyVersion",
        "iam:DeleteRole",
        "iam:DeleteRolePolicy",
        "iam:DeleteServiceLinkedRole",
        "iam:DetachRolePolicy",
        "iam:GetInstanceProfile",
        "iam:GetOpenIDConnectProvider",
        "iam:GetPolicy",
        "iam:GetPolicyVersion",
        "iam:GetRole",
        "iam:GetRolePolicy",
        "iam:List*",
        "iam:PassRole",
        "iam:PutRolePolicy",
        "iam:RemoveRoleFromInstanceProfile",
        "iam:TagInstanceProfile",
        "iam:TagOpenIDConnectProvider",
        "iam:TagPolicy",
        "iam:TagRole",
        "iam:UnTagInstanceProfile",
        "iam:UntagOpenIDConnectProvider",
        "iam:UnTagPolicy",
        "iam:UnTagRole",
        "iam:UpdateAssumeRolePolicy",
        "iam:UpdateOpenIDConnectProviderThumbprint",
        "route53:*",
        "s3:*",
        "ssm:AddTagsToResource",
        "ssm:DeleteParameter",
        "ssm:DescribeParameters",
        "ssm:GetParameter",
        "ssm:GetParameters",
        "ssm:ListTagsForResource",
        "ssm:PutParameter",
        "ecr:*",
        "dynamodb:CreateTable",
        "dynamodb:DeleteTable",
        "dynamodb:DescribeTable",
        "dynamodb:GetItem",
        "dynamodb:PutItem",
        "dynamodb:DeleteItem",
        "dynamodb:TagResource",
        "dynamodb:UntagResource",
        "dynamodb:DescribeContinuousBackups",
        "dynamodb:DescribeTimeToLive",
        "dynamodb:ListTagsOfResource"
      ],
      "Resource": "*"
    }
  ]
}
```

</details>

<details>
<summary>`DeployerPolicyEKS-<platform_name>`: EKS (36 actions)</summary>

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "eks:AssociateEncryptionConfig",
        "eks:CreateAddon",
        "eks:CreateCluster",
        "eks:CreateFargateProfile",
        "eks:CreateNodegroup",
        "eks:DeleteAddon",
        "eks:DeleteCluster",
        "eks:DeleteFargateProfile",
        "eks:DeleteNodegroup",
        "eks:DescribeAddon",
        "eks:DescribeAddonVersions",
        "eks:DescribeCluster",
        "eks:DescribeFargateProfile",
        "eks:DescribeNodegroup",
        "eks:DescribeUpdate",
        "eks:ListAddons",
        "eks:ListClusters",
        "eks:ListFargateProfiles",
        "eks:ListNodegroups",
        "eks:ListTagsForResource",
        "eks:TagResource",
        "eks:UntagResource",
        "eks:UpdateAddon",
        "eks:UpdateClusterConfig",
        "eks:UpdateClusterVersion",
        "eks:UpdateNodegroupConfig",
        "eks:UpdateNodegroupVersion",
        "eks:CreateAccessEntry",
        "eks:ListAccessEntries",
        "eks:DescribeAccessEntry",
        "eks:DeleteAccessEntry",
        "eks:UpdateAccessEntry",
        "eks:ListAccessPolicies",
        "eks:AssociateAccessPolicy",
        "eks:DisassociateAccessPolicy",
        "eks:ListAssociatedAccessPolicies"
      ],
      "Resource": "*"
    }
  ]
}
```

</details>

<details>
<summary>`DeployerPolicyEKS-IDP-<platform_name>`: EKS identity providers (4 actions)</summary>

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "eks:DescribeIdentityProviderConfig",
        "eks:AssociateIdentityProviderConfig",
        "eks:ListIdentityProviderConfigs",
        "eks:DisassociateIdentityProviderConfig"
      ],
      "Resource": "arn:aws:eks:*:<ACCOUNT_ID>:cluster/*"
    }
  ]
}
```

</details>

<details>
<summary>`DeployerPolicyLogs-<platform_name>`: CloudWatch Logs (7 actions)</summary>

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogGroup",
        "logs:DeleteLogGroup",
        "logs:DescribeLogGroups",
        "logs:ListTagsForResource",
        "logs:ListTagsLogGroup",
        "logs:PutRetentionPolicy",
        "logs:TagResource"
      ],
      "Resource": "*"
    }
  ]
}
```

</details>

<details>
<summary>`DeployerPolicyKMS-<platform_name>`: KMS (13 actions)</summary>

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "kms:CreateAlias",
        "kms:CreateGrant",
        "kms:CreateKey",
        "kms:DeleteAlias",
        "kms:DescribeKey",
        "kms:EnableKeyRotation",
        "kms:GetKeyPolicy",
        "kms:GetKeyRotationStatus",
        "kms:ListAliases",
        "kms:ListResourceTags",
        "kms:PutKeyPolicy",
        "kms:ScheduleKeyDeletion",
        "kms:TagResource"
      ],
      "Resource": "*"
    }
  ]
}
```

</details>

<details>
<summary>`DeployerPolicyRDS-<platform_name>`: RDS (15 actions)</summary>

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "rds:CreateDBSubnetGroup",
        "rds:CreateDBParameterGroup",
        "rds:AddTagsToResource",
        "rds:DescribeDBSubnetGroups",
        "rds:DescribeDBParameterGroups",
        "rds:ListTagsForResource",
        "rds:DescribeDBParameters",
        "rds:DeleteDBSubnetGroup",
        "rds:CreateDBInstance",
        "rds:DescribeDBInstances",
        "rds:DeleteDBInstance",
        "rds:CreateDBSnapshot",
        "rds:ModifyDBInstance",
        "rds:DeleteDBParameterGroup",
        "rds:ModifyDBSubnetGroup"
      ],
      "Resource": "*"
    }
  ]
}
```

</details>

<details>
<summary>`DeployerPolicyElasticache-<platform_name>`: ElastiCache (15 actions)</summary>

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "elasticache:AddTagsToResource",
        "elasticache:CreateCacheParameterGroup",
        "elasticache:CreateCacheSubnetGroup",
        "elasticache:CreateReplicationGroup",
        "elasticache:DeleteCacheSubnetGroup",
        "elasticache:DeleteCacheParameterGroup",
        "elasticache:DeleteReplicationGroup",
        "elasticache:DescribeCacheClusters",
        "elasticache:DescribeCacheParameters",
        "elasticache:DescribeCacheParameterGroups",
        "elasticache:DescribeCacheSubnetGroups",
        "elasticache:DescribeReplicationGroups",
        "elasticache:ListTagsForResource",
        "elasticache:ModifyCacheParameterGroup",
        "elasticache:ModifyReplicationGroup"
      ],
      "Resource": "*"
    }
  ]
}
```

</details>

<details>
<summary>`DeployerPolicyBedrock-<platform_name>`: Bedrock Guardrails (5 actions)</summary>

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "bedrock:CreateGuardrail",
        "bedrock:DeleteGuardrail",
        "bedrock:GetGuardrail",
        "bedrock:ListGuardrails",
        "bedrock:ListTagsForResource"
      ],
      "Resource": "*"
    }
  ]
}
```

</details>

## Requirements for an Existing EKS Cluster

When AI/Run CodeMie is installed into a cluster that was not created by the CodeMie Terraform modules, the following must be present before the platform deployment.

### EKS OIDC Provider

IRSA requires an IAM OIDC identity provider associated with the cluster. Verify that it exists:

```bash
aws eks describe-cluster --name <CLUSTER_NAME> --region <REGION> \
  --query "cluster.identity.oidc.issuer" --output text

aws iam list-open-id-connect-providers
```

The issuer URL returned by the first command must match one of the providers listed by the second. If it does not, create the provider:

```bash
eksctl utils associate-iam-oidc-provider --cluster <CLUSTER_NAME> --region <REGION> --approve
```

### CodeMie IRSA Role

The CodeMie pods access AWS services (KMS, S3, Bedrock, RDS) by assuming a single IAM role through their Kubernetes service accounts. The role is created once for the cluster and shared by all CodeMie components.

By default, the role is named `AWSIRSA_<PLATFORM_NAME>_AI_RUN`, where `<PLATFORM_NAME>` is the `platform_name` value in upper case with hyphens removed (for example, `AWSIRSA_CODEMIE_AI_RUN`). Any name can be used, as long as the ARN is passed to the deployment as described in [Connecting the Roles to the Deployment](#connecting-the-roles-to-the-deployment).

**What to create**

The role consists of one trust policy and four permission policies attached to it:

| Policy                             | Required                                        | Allows                                              | Values to replace                                       |
| ---------------------------------- | ----------------------------------------------- | --------------------------------------------------- | ------------------------------------------------------- |
| Trust policy                       | Yes                                             | The cluster service accounts to assume the role     | `<ACCOUNT_ID>`, `<OIDC_PROVIDER>`                       |
| `AWSIRSA_<Cluster>_AI_RUN_KMS`     | Yes                                             | Encrypt and decrypt data with the CodeMie KMS key   | `<REGION>`, `<ACCOUNT_ID>`, `<KMS_KEY_ALIAS>`           |
| `AWSIRSA_<Cluster>_AI_RUN_S3`      | Yes                                             | Read and write objects in the CodeMie S3 bucket     | `<S3_BUCKET_NAME>`                                      |
| `AWSIRSA_<Cluster>_AI_RUN_Bedrock` | When Amazon Bedrock models are used             | Invoke Bedrock models and guardrails                | None                                                    |
| `AWSIRSA_<Cluster>_AI_RUN_RDS`     | When IAM database authentication to RDS is used | Connect to the RDS instance with IAM authentication | `<REGION>`, `<ACCOUNT_ID>`, `<DB_INSTANCE_RESOURCE_ID>` |

`<Cluster>` is the `platform_name` value with the first letter capitalized and hyphens removed. The policy names are only a convention and can be changed.

**Step 1: Create the role with the trust policy**

Save the following document as `trust-policy.json`:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Principal": {
        "Federated": "arn:aws:iam::<ACCOUNT_ID>:oidc-provider/<OIDC_PROVIDER>"
      },
      "Condition": {
        "StringLike": {
          "<OIDC_PROVIDER>:sub": "system:serviceaccount:*",
          "<OIDC_PROVIDER>:aud": "sts.amazonaws.com"
        }
      }
    }
  ]
}
```

`<OIDC_PROVIDER>` is the cluster issuer URL without the `https://` prefix, as returned by the command in [EKS OIDC Provider](#eks-oidc-provider). The `sub` condition allows any namespace and service account. It can be narrowed to the `codemie` namespace and the service accounts of the CodeMie components if the security policy requires it.

```bash
aws iam create-role \
  --role-name <ROLE_NAME> \
  --assume-role-policy-document file://trust-policy.json
```

If a permissions boundary is enforced, add `--permissions-boundary <BOUNDARY_POLICY_ARN>`.

**Step 2: Create the permission policies**

Create each policy from the corresponding document below. Every policy is saved to a JSON file and created with:

```bash
aws iam create-policy \
  --policy-name <POLICY_NAME> \
  --policy-document file://<FILE_NAME>.json
```

<details>
<summary>KMS policy (required)</summary>

Allows the pods to encrypt and decrypt data with the CodeMie KMS key. `<KMS_KEY_ALIAS>` is the alias of the key, `airun-<platform_name>` by default (hyphens removed, lower case).

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": ["kms:Encrypt", "kms:Decrypt", "kms:DescribeKey"],
      "Resource": "arn:aws:kms:<REGION>:<ACCOUNT_ID>:alias/<KMS_KEY_ALIAS>"
    }
  ]
}
```

The key policy of the KMS key must also list the IRSA role as a key user, and the deployer role and the cluster administrator role as key administrators.

</details>

<details>
<summary>S3 policy (required)</summary>

Allows the pods to read and write objects in the CodeMie storage bucket.

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "S3ObjectAccess",
      "Effect": "Allow",
      "Action": ["s3:PutObject", "s3:GetObject"],
      "Resource": "arn:aws:s3:::<S3_BUCKET_NAME>/*"
    }
  ]
}
```

</details>

<details>
<summary>Bedrock policy (required when Amazon Bedrock models are used)</summary>

Allows the pods to invoke foundation models and cross-region inference profiles of the Anthropic, Amazon, Qwen, Moonshot AI, and OpenAI providers, to apply guardrails, and to subscribe to AWS Marketplace models. No values need to be replaced.

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "BedrockInvokeModels",
      "Effect": "Allow",
      "Action": [
        "bedrock:InvokeModel",
        "bedrock:InvokeModelWithResponseStream",
        "bedrock:CountTokens"
      ],
      "Resource": [
        "arn:aws:bedrock:*::foundation-model/anthropic.*",
        "arn:aws:bedrock:*::foundation-model/amazon.*",
        "arn:aws:bedrock:*::foundation-model/qwen.*",
        "arn:aws:bedrock:*::foundation-model/moonshotai.*"
      ]
    },
    {
      "Sid": "BedrockCrossRegionInferenceProfiles",
      "Effect": "Allow",
      "Action": [
        "bedrock:InvokeModel",
        "bedrock:InvokeModelWithResponseStream",
        "bedrock:CountTokens"
      ],
      "Resource": [
        "arn:aws:bedrock:*:*:inference-profile/*.amazon.*",
        "arn:aws:bedrock:*:*:inference-profile/*.anthropic.*",
        "arn:aws:bedrock:*:*:inference-profile/openai.*",
        "arn:aws:bedrock:*:*:inference-profile/qwen.*",
        "arn:aws:bedrock:*:*:inference-profile/moonshotai.*"
      ]
    },
    {
      "Sid": "BedrockGuardrails",
      "Effect": "Allow",
      "Action": [
        "bedrock:ApplyGuardrail",
        "bedrock:GetGuardrail",
        "bedrock:ListGuardrails"
      ],
      "Resource": "arn:aws:bedrock:*:*:guardrail/*"
    },
    {
      "Sid": "MarketplaceModelSubscriptions",
      "Effect": "Allow",
      "Action": [
        "aws-marketplace:ViewSubscriptions",
        "aws-marketplace:Subscribe"
      ],
      "Resource": "*"
    }
  ]
}
```

</details>

<details>
<summary>RDS policy (required when IAM database authentication is used)</summary>

Allows the pods to connect to the RDS instance with IAM authentication. `<DB_INSTANCE_RESOURCE_ID>` is the `DbiResourceId` of the instance (for example, `db-ABCDEFGHIJKLMNOP`), not its name. The instance must have IAM database authentication enabled.

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "RDSIAMConnect",
      "Effect": "Allow",
      "Action": "rds-db:connect",
      "Resource": "arn:aws:rds-db:<REGION>:<ACCOUNT_ID>:dbuser:<DB_INSTANCE_RESOURCE_ID>/*"
    }
  ]
}
```

The resource identifier can be retrieved with:

```bash
aws rds describe-db-instances --db-instance-identifier <DB_INSTANCE_NAME> \
  --query "DBInstances[0].DbiResourceId" --output text
```

</details>

**Step 3: Attach the policies to the role**

Attach every policy created in Step 2:

```bash
aws iam attach-role-policy \
  --role-name <ROLE_NAME> \
  --policy-arn arn:aws:iam::<ACCOUNT_ID>:policy/<POLICY_NAME>
```

**Step 4: Verify the role**

```bash
aws iam list-attached-role-policies --role-name <ROLE_NAME>
aws iam get-role --role-name <ROLE_NAME> --query "Role.Arn" --output text
```

The returned role ARN is the value of `EKS_AWS_ROLE_ARN` used in [Connecting the Roles to the Deployment](#connecting-the-roles-to-the-deployment).

### Langfuse IRSA Role (Optional)

Required only when Langfuse stores data in S3 (`enable_langfuse_s3=true`). By default, it is named `AWSIRSA_<PLATFORM_NAME>_LANGFUSE`.

- **Trust policy:** same structure as the CodeMie role, with the `sub` condition set to `system:serviceaccount:langfuse:*`.
- **Permissions:** `s3:PutObject`, `s3:GetObject`, `s3:DeleteObject` on the objects of the Langfuse bucket, and `s3:ListBucket` on the bucket itself.

### Cluster Add-On Roles

Both roles use `StringEquals` trust conditions on a single `kube-system` service account and AWS managed policies. They are not required if the cluster already runs these add-ons with equivalent permissions.

| Role                               | Service account                     | Managed policy                                                  |
| ---------------------------------- | ----------------------------------- | --------------------------------------------------------------- |
| `AWSIRSA_<Cluster>_EBS_CSI_Driver` | `kube-system:ebs-csi-controller-sa` | `arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy` |
| `AWSIRSA_<Cluster>_VPC_CNI`        | `kube-system:aws-node`              | `arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy`                  |

### Supporting Resources

The IRSA role policies refer to the following resources. They must exist, or the policies must be adjusted to the equivalents in use:

- **KMS keys** for application and user data encryption, with automatic rotation enabled.
- **S3 bucket** for CodeMie storage.
- **RDS for PostgreSQL** instance with IAM database authentication enabled (`iam_database_authentication_enabled = true`).
- **Amazon Bedrock** model access enabled in the target region for the models to be used.

### Connecting the Roles to the Deployment

After the roles exist, their ARNs replace the values normally produced by Terraform in `deployment_outputs.env`:

| Variable                | Value                         | Used in                                                                        |
| ----------------------- | ----------------------------- | ------------------------------------------------------------------------------ |
| `EKS_AWS_ROLE_ARN`      | ARN of the CodeMie IRSA role  | `%%EKS_AWS_ROLE_ARN%%` placeholder in the CodeMie API and LiteLLM values files |
| `LANGFUSE_AWS_ROLE_ARN` | ARN of the Langfuse IRSA role | `langfuse.langfuse.serviceAccount.annotations` in the Langfuse values file     |

The role ARN is attached to the service account through the annotation:

```yaml
serviceAccount:
  annotations:
    eks.amazonaws.com/role-arn: 'arn:aws:iam::<ACCOUNT_ID>:role/<ROLE_NAME>'
```

See [Platform Deployment](../../platform-deployment/index.mdx) for the full procedure.

## Verification

Before the deployment, confirm that the identity used for the installation resolves to the expected role and that the roles exist:

```bash
aws sts get-caller-identity

aws iam get-role --role-name <DEPLOYER_ROLE_NAME> \
  --query "Role.AssumeRolePolicyDocument"

aws iam get-role --role-name <IRSA_ROLE_NAME> \
  --query "Role.AssumeRolePolicyDocument"
```

The trust policy of each IRSA role must reference the OIDC provider of the target cluster. A mismatch results in pods failing with `AccessDenied` or `WebIdentityErr` errors when they call AWS services.
