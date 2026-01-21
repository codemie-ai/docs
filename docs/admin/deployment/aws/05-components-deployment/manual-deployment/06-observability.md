---
id: observability
sidebar_position: 7
title: Observability
sidebar_label: Observability
pagination_prev: admin/deployment/aws/components-deployment/manual-deployment/manual-deployment-overview
pagination_next: admin/deployment/aws/accessing-applications
---

import ObservabilityOverview from '../../../common/deployment/05-components-deployment/manual-deployment/observability/\_observability-overview.mdx';
import ObservabilityFluentBit from '../../../common/deployment/05-components-deployment/manual-deployment/observability/\_observability-fluent-bit.mdx';
import ObservabilityKibana from '../../../common/deployment/05-components-deployment/manual-deployment/observability/\_observability-kibana.mdx';
import ObservabilityDashboards from '../../../common/deployment/05-components-deployment/manual-deployment/observability/\_observability-dashboards.mdx';
import ObservabilityValidation from '../../../common/deployment/05-components-deployment/manual-deployment/observability/\_observability-validation.mdx';

<ObservabilityOverview />

<ObservabilityFluentBit />

<ObservabilityKibana
  valuesFileName="values-aws.yaml"
  kibanaUrl="https://kibana.codemie.example.com"
/>

<ObservabilityDashboards
  kibanaUrl="https://kibana.codemie.example.com"
/>

<ObservabilityValidation
  kibanaUrl="https://kibana.codemie.example.com"
/>
