---
id: 3rd-party-components
title: Third-Party Component Updates
sidebar_label: 3rd-Party Components
sidebar_position: 1
pagination_prev: admin/update/update-overview
pagination_next: null
---

import FeatureCard from '@site/src/components/FeatureCard';
import FeatureGrid from '@site/src/components/FeatureGrid';

# Third-Party Component Updates

Upgrade guides for infrastructure and observability components used by the AI/Run CodeMie platform.

<FeatureGrid>
  <FeatureCard
    icon="/img/tools/keycloak.svg"
    iconType="image"
    invertInDarkTheme={false}
    title="Keycloak"
    description="Upgrade guides, operator updates, database migration, and theme setup for the Keycloak identity provider."
    link="/admin/update/3rd-party-components/keycloak/"
  />
  <FeatureCard
    icon="/img/tools/terraform.svg"
    iconType="image"
    invertInDarkTheme={false}
    title="Terraform"
    description="Upgrade Terraform from 1.5.7 to 1.13.5 for AWS and Azure deployments, including S3 native state locking migration."
    link="/admin/update/3rd-party-components/terraform/"
  />
  <FeatureCard
    icon="/img/tools/elasticsearch.svg"
    iconType="image"
    invertInDarkTheme={false}
    title="Elasticsearch"
    description="Upgrade Elasticsearch and Kibana, and migrate to quarterly metrics index rotation."
    link="/admin/update/3rd-party-components/elasticsearch/"
  />
  <FeatureCard
    icon="/img/tools/fluent-bit.svg"
    iconType="image"
    invertInDarkTheme={false}
    title="Fluent Bit"
    description="Upgrade Fluent Bit used for log shipping and observability."
    link="/admin/update/3rd-party-components/fluent-bit/fluent-bit-upgrade"
  />
  <FeatureCard
    icon="/img/tools/nats.svg"
    iconType="image"
    invertInDarkTheme={false}
    title="NATS"
    description="Upgrade NATS messaging system used for platform communication."
    link="/admin/update/3rd-party-components/nats/nats-upgrade"
  />
  <FeatureCard
    icon="/img/tools/oauth2-proxy.svg"
    iconType="image"
    invertInDarkTheme={false}
    title="OAuth2 Proxy"
    description="Upgrade OAuth2 Proxy for authentication and authorization functionality."
    link="/admin/update/3rd-party-components/oauth2-proxy/oauth2-proxy-upgrade"
  />
</FeatureGrid>
