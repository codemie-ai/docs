---
id: security-and-identity
sidebar_position: 3
title: Security and Identity Components
sidebar_label: Security and Identity
---

import SecurityOverview from '../../../common/deployment/05-components-deployment/manual-deployment/security/\_security-overview.mdx';
import SecurityKeycloakOperator from '../../../common/deployment/05-components-deployment/manual-deployment/security/\_security-keycloak-operator.mdx';
import SecurityKeycloakInstall from '../../../common/deployment/05-components-deployment/manual-deployment/security/\_security-keycloak-install.mdx';
import SecurityOauth2Proxy from '../../../common/deployment/05-components-deployment/manual-deployment/security/\_security-oauth2-proxy.mdx';
import SecurityValidation from '../../../common/deployment/05-components-deployment/manual-deployment/security/\_security-validation.mdx';

<SecurityOverview />

<SecurityKeycloakOperator />

<SecurityKeycloakInstall
cloudProvider="GCP"
valuesFileName="values-gcp.yaml"
keycloakUrl="https://keycloak.example.com/auth/admin"
/>

<SecurityOauth2Proxy
cloudProvider="GCP"
valuesFileName="values-gcp.yaml"
/>

<SecurityValidation />
