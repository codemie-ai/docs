---
id: data-layer
sidebar_position: 2
title: Data Layer
sidebar_label: Data Layer
pagination_prev: admin/deployment/azure/components-deployment/manual-deployment/k8s-components
pagination_next: admin/deployment/azure/components-deployment/manual-deployment/security-and-identity
---

import DataLayerOverview from '../../../common/deployment/05-components-deployment/manual-deployment/data-layer/\_data-layer-overview.mdx';
import DataLayerElasticsearch from '../../../common/deployment/05-components-deployment/manual-deployment/data-layer/\_data-layer-elasticsearch.mdx';
import DataLayerPostgresOperator from '../../../common/deployment/05-components-deployment/manual-deployment/data-layer/\_data-layer-postgresql-operator.mdx';
import DataLayerPostgresConfig from '../../../common/deployment/05-components-deployment/manual-deployment/data-layer/\_data-layer-postgresql-config.mdx';
import DataLayerValidation from '../../../common/deployment/05-components-deployment/manual-deployment/data-layer/\_data-layer-validation.mdx';

<DataLayerOverview />

<DataLayerElasticsearch cloudProvider="Azure" valuesFileName="values-azure.yaml" />

<DataLayerPostgresOperator
  postgresServiceName="Azure Database for PostgreSQL"
/>

<DataLayerPostgresConfig
  postgresServiceName="Azure Database for PostgreSQL"
  postgresExampleHost="codemie-postgres.postgres.database.azure.com"
/>

<DataLayerValidation />
