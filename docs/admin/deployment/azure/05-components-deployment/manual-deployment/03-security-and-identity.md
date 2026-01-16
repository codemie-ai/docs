---
id: security-and-identity
sidebar_position: 3
title: Security and Identity
sidebar_label: Security and Identity
pagination_prev: admin/deployment/azure/components-deployment/manual-deployment/manual-deployment-overview
pagination_next: admin/deployment/azure/components-deployment/manual-deployment/plugin-engine
---

import SecurityOverview from '../../../common/deployment/05-components-deployment/manual-deployment/\_security-overview.mdx';
import SecurityKeycloakOperator from '../../../common/deployment/05-components-deployment/manual-deployment/\_security-keycloak-operator.mdx';
import SecurityKeycloakInstall from '../../../common/deployment/05-components-deployment/manual-deployment/\_security-keycloak-install.mdx';
import SecurityOauth2Proxy from '../../../common/deployment/05-components-deployment/manual-deployment/\_security-oauth2-proxy.mdx';
import SecurityValidation from '../../../common/deployment/05-components-deployment/manual-deployment/\_security-validation.mdx';

<SecurityOverview />

<SecurityKeycloakOperator />

<SecurityKeycloakInstall
  cloudName="azure"
  cloudProvider="Azure"
  domainConfigStep=""
  installStepNumber="1"
  verifyStepNumber="2"
  accessStepNumber="3"
  databaseInfo=" including PostgreSQL connection"
  keycloakUrl="https://<your-domain>/keycloak/admin"
  keycloakExample="`https://codemie.example.com/keycloak/admin`"
/>

<SecurityOauth2Proxy
  cloudName="azure"
  cloudProvider="Azure"
  domainConfigStep=""
  installStepNumber="4"
  verifyStepNumber="5"
/>

<SecurityValidation />
