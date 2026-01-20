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
  cloudName="aws"
  domainConfigStep=""
  installStepNumber="2"
  verifyStepNumber="3"
  accessStepNumber="4"
  indexPatternStepNumber="5"
  kibanaUrl="https://kibana.<your-domain>"
  kibanaExample="`https://kibana.codemie.example.com` (custom domain)"
/>

<ObservabilityDashboards
  dashboardUrlExample="https://kibana.<your-domain>"
  dashboardUrlFullExample="https://kibana.codemie.example.com"
/>

<ObservabilityValidation
  kibanaValidationUrl="https://kibana.<your-domain>"
/>
