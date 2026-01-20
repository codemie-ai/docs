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
cloudName="gcp"
domainConfigStep={<>

### Step 2: Configure Domain Name

Fill in values in `kibana/values-gcp.yaml` file by replacing `%%DOMAIN%%` with your domain name, e.g., `example.com`

:::tip Domain Configuration
If you followed the Getting Started steps, this should already be configured.
:::
</>}
installStepNumber="3"
verifyStepNumber="4"
accessStepNumber="5"
indexPatternStepNumber="6"
kibanaUrl="https://kibana.%%DOMAIN%%/"
kibanaExample="`https://kibana.example.com`"
/>

<ObservabilityDashboards
  dashboardUrlExample="https://kibana.<your-domain>"
  dashboardUrlFullExample="https://kibana.example.com"
/>

<ObservabilityValidation
  kibanaValidationUrl="https://kibana.example.com"
/>
