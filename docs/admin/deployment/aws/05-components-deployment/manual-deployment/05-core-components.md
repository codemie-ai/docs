---
id: core-components
sidebar_position: 6
title: Core Components
sidebar_label: Core Components
pagination_prev: admin/deployment/aws/components-deployment/manual-deployment/manual-deployment-overview
pagination_next: admin/deployment/aws/components-deployment/manual-deployment/observability
---

import CoreComponentsOverview from '../../../common/deployment/05-components-deployment/manual-deployment/core/\_core-components-overview.mdx';
import CoreComponentsMcpConnect from '../../../common/deployment/05-components-deployment/manual-deployment/core/\_core-components-mcp-connect.mdx';
import CoreComponentsMermaid from '../../../common/deployment/05-components-deployment/manual-deployment/core/\_core-components-mermaid.mdx';
import CoreComponentsUi from '../../../common/deployment/05-components-deployment/manual-deployment/core/\_core-components-ui.mdx';
import CoreComponentsApi from '../../../common/deployment/05-components-deployment/manual-deployment/core/\_core-components-api.mdx';
import CoreComponentsAccess from '../../../common/deployment/05-components-deployment/manual-deployment/core/\_core-components-access.mdx';
import CoreComponentsValidation from '../../../common/deployment/05-components-deployment/manual-deployment/core/\_core-components-validation.mdx';

<CoreComponentsOverview />

<CoreComponentsMcpConnect />

<CoreComponentsMermaid />

<CoreComponentsUi cloudProvider="AWS" valuesFileName="values-aws.yaml" />

<CoreComponentsApi
cloudProvider="AWS"
valuesFileName="values-aws.yaml"
additionalConfigParams={`- \`%%AWS_DEFAULT_REGION%%\` should be replaced with your AWS region (e.g., \`us-east-1\`)

- \`%%EKS_AWS_ROLE_ARN%%\` should be replaced with your EKS service account IAM role ARN
- \`%%AWS_KMS_KEY_ID%%\` should be replaced with your KMS key ID for encryption
- \`%%AWS_S3_BUCKET_NAME%%\` should be replaced with your S3 bucket name
- \`%%AWS_S3_REGION%%\` should be replaced with your S3 bucket region`}
  />

<CoreComponentsAccess />

<CoreComponentsValidation />
