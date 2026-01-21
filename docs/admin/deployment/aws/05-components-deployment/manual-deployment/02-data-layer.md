---
id: data-layer
sidebar_position: 2
title: Data Layer
sidebar_label: Data Layer
pagination_prev: admin/deployment/aws/components-deployment/manual-deployment/k8s-components
pagination_next: admin/deployment/aws/components-deployment/manual-deployment/security-and-identity
---

import DataLayerOverview from '../../../common/deployment/05-components-deployment/manual-deployment/data-layer/\_data-layer-overview.mdx';
import DataLayerElasticsearch from '../../../common/deployment/05-components-deployment/manual-deployment/data-layer/\_data-layer-elasticsearch.mdx';
import DataLayerPostgresOperator from '../../../common/deployment/05-components-deployment/manual-deployment/data-layer/\_data-layer-postgresql-operator.mdx';
import DataLayerPostgresConfig from '../../../common/deployment/05-components-deployment/manual-deployment/data-layer/\_data-layer-postgresql-config.mdx';
import DataLayerValidation from '../../../common/deployment/05-components-deployment/manual-deployment/data-layer/\_data-layer-validation.mdx';

<DataLayerOverview />

<DataLayerElasticsearch cloudProvider="AWS" valuesFileName="values-aws.yaml" />

<DataLayerPostgresOperator
  postgresServiceName="AWS RDS PostgreSQL"
/>

<DataLayerPostgresConfig
  postgresServiceName="AWS RDS PostgreSQL"
  postgresExampleHost="codemie-postgres.abc123.us-west-2.rds.amazonaws.com"
/>

<DataLayerValidation />
