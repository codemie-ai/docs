---
id: security-and-identity
sidebar_position: 3
title: Security and Identity Components
sidebar_label: Security and Identity
---

import SecurityOverview from '../../../common/deployment/05-components-deployment/manual-deployment/\_security-overview.mdx';
import SecurityKeycloakOperator from '../../../common/deployment/05-components-deployment/manual-deployment/\_security-keycloak-operator.mdx';
import SecurityKeycloakInstall from '../../../common/deployment/05-components-deployment/manual-deployment/\_security-keycloak-install.mdx';
import SecurityOauth2Proxy from '../../../common/deployment/05-components-deployment/manual-deployment/\_security-oauth2-proxy.mdx';
import SecurityValidation from '../../../common/deployment/05-components-deployment/manual-deployment/\_security-validation.mdx';

<SecurityOverview />

<SecurityKeycloakOperator />

<SecurityKeycloakInstall
cloudName="gcp"
cloudProvider="GCP"
domainConfigStep={<>

### Step 1: Configure Domain Name

Fill in values in `keycloak-helm/values-gcp.yaml` file by replacing `%%DOMAIN%%` with your domain name, e.g., `example.com`

:::tip Domain Configuration
If you followed the Getting Started steps in the [overview](./), this should already be configured.
:::
</>}
installStepNumber="2"
verifyStepNumber="3"
accessStepNumber="4"
databaseInfo=""
keycloakUrl="https://keycloak.%%DOMAIN%%/auth/admin"
keycloakExample="`https://keycloak.example.com/auth/admin`"
/>

<SecurityOauth2Proxy
cloudName="gcp"
cloudProvider="GCP"
domainConfigStep={<>

### Step 4: Configure Domain Name

Fill in missing values in `oauth2-proxy/values-gcp.yaml` file by replacing `%%DOMAIN%%` with your domain name, e.g., `example.com`

:::tip Domain Configuration
If you followed the Getting Started steps in the [overview](./), this should already be configured.
:::
</>}
installStepNumber="5"
verifyStepNumber="6"
/>

<SecurityValidation />
