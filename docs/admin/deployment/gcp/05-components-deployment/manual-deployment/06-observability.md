---
id: observability
sidebar_position: 6
title: Observability Components
sidebar_label: Observability
pagination_prev: admin/deployment/gcp/components-deployment/manual-deployment/manual-deployment-overview
pagination_next: admin/deployment/gcp/accessing-applications
---

import ObservabilityOverview from '../../../common/deployment/05-components-deployment/manual-deployment/observability/\_observability-overview.mdx';
import ObservabilityFluentBit from '../../../common/deployment/05-components-deployment/manual-deployment/observability/\_observability-fluent-bit.mdx';
import ObservabilityKibana from '../../../common/deployment/05-components-deployment/manual-deployment/observability/\_observability-kibana.mdx';
import ObservabilityDashboards from '../../../common/deployment/05-components-deployment/manual-deployment/observability/\_observability-dashboards.mdx';
import ObservabilityValidation from '../../../common/deployment/05-components-deployment/manual-deployment/observability/\_observability-validation.mdx';

<ObservabilityOverview />

<ObservabilityFluentBit />

<ObservabilityKibana
  valuesFileName="values-gcp.yaml"
  kibanaUrl="https://kibana.example.com"
/>

<ObservabilityDashboards
  kibanaUrl="https://kibana.example.com"
/>

<ObservabilityValidation
  kibanaUrl="https://kibana.example.com"
/>
