---
id: security-and-identity
sidebar_position: 4
title: Security and Identity
sidebar_label: Security and Identity
pagination_prev: admin/deployment/aws/components-deployment/manual-deployment/manual-deployment-overview
pagination_next: admin/deployment/aws/components-deployment/manual-deployment/plugin-engine
---

import SecurityOverview from '../../../common/deployment/05-components-deployment/manual-deployment/security/\_security-overview.mdx';
import SecurityKeycloakOperator from '../../../common/deployment/05-components-deployment/manual-deployment/security/\_security-keycloak-operator.mdx';
import SecurityKeycloakInstall from '../../../common/deployment/05-components-deployment/manual-deployment/security/\_security-keycloak-install.mdx';
import SecurityOauth2Proxy from '../../../common/deployment/05-components-deployment/manual-deployment/security/\_security-oauth2-proxy.mdx';
import SecurityValidation from '../../../common/deployment/05-components-deployment/manual-deployment/security/\_security-validation.mdx';

<SecurityOverview />

<SecurityKeycloakOperator />

<SecurityKeycloakInstall
  cloudProvider="AWS"
  valuesFileName="values-aws.yaml"
  keycloakUrl="https://keycloak.codemie.example.com/auth/admin"
/>

<SecurityOauth2Proxy
  cloudProvider="AWS"
  valuesFileName="values-aws.yaml"
/>

<SecurityValidation />
