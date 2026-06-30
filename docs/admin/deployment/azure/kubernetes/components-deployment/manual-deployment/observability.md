---
id: observability
sidebar_position: 6
title: Observability
sidebar_label: Observability
pagination_prev: admin/deployment/azure/kubernetes/components-deployment/manual-deployment/manual-deployment-overview
pagination_next: admin/deployment/azure/kubernetes/accessing-applications
---

import ObservabilityOverview from '../../../../common/deployment/components-deployment/manual-deployment/observability/\_observability-overview.mdx';
import ObservabilityFluentBit from '../../../../common/deployment/components-deployment/manual-deployment/observability/\_observability-fluent-bit.mdx';
import ObservabilityKibana from '../../../../common/deployment/components-deployment/manual-deployment/observability/\_observability-kibana.mdx';
import ObservabilityDashboards from '../../../../common/deployment/components-deployment/manual-deployment/observability/\_observability-dashboards.mdx';
import ObservabilityValidation from '../../../../common/deployment/components-deployment/manual-deployment/observability/\_observability-validation.mdx';

<ObservabilityOverview />

<ObservabilityFluentBit />

<ObservabilityKibana
  valuesFileName="values-azure.yaml"
  kibanaUrl="https://codemie.example.com/kibana"
/>

<ObservabilityDashboards
  kibanaUrl="https://codemie.example.com/kibana"
/>

<ObservabilityValidation
  kibanaUrl="https://codemie.example.com/kibana"
/>
