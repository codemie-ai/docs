---
id: data-layer
sidebar_position: 2
title: Data Layer
sidebar_label: Data Layer
pagination_prev: admin/deployment/aws/components-deployment/manual-deployment/storage-and-ingress
pagination_next: admin/deployment/aws/components-deployment/manual-deployment/security-and-identity
---

import DataLayerOverview from '../../../common/deployment/05-components-deployment/manual-deployment/\_data-layer-overview.mdx';
import DataLayerElasticsearch from '../../../common/deployment/05-components-deployment/manual-deployment/\_data-layer-elasticsearch.mdx';
import DataLayerPostgresOperator from '../../../common/deployment/05-components-deployment/manual-deployment/\_data-layer-postgresql-operator.mdx';
import DataLayerPostgresConfig from '../../../common/deployment/05-components-deployment/manual-deployment/\_data-layer-postgresql-config.mdx';
import DataLayerValidation from '../../../common/deployment/05-components-deployment/manual-deployment/\_data-layer-validation.mdx';

<DataLayerOverview />

<DataLayerElasticsearch cloudProvider="AWS" cloudName="aws" />

<DataLayerPostgresOperator
  postgresServiceName="AWS RDS PostgreSQL instance"
/>

<DataLayerPostgresConfig
  postgresServiceName="AWS RDS PostgreSQL"
  postgresExampleHost="codemie-postgres.abc123.us-west-2.rds.amazonaws.com"
/>

<DataLayerValidation />
