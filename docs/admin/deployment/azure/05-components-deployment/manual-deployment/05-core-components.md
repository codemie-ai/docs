---
id: core-components
sidebar_position: 5
title: Core Components
sidebar_label: Core Components
pagination_prev: admin/deployment/azure/components-deployment/manual-deployment/manual-deployment-overview
pagination_next: admin/deployment/azure/components-deployment/manual-deployment/observability
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

<CoreComponentsUi cloudProvider="Azure" valuesFileName="values-azure.yaml" />

<CoreComponentsApi
  cloudProvider="Azure"
  valuesFileName="values-azure.yaml"
  additionalConfigParams=""
/>

<CoreComponentsAccess />

<CoreComponentsValidation />
