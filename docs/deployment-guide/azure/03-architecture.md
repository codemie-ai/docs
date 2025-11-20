---
id: architecture
title: AI/Run CodeMie Deployment Architecture
sidebar_label: Architecture
sidebar_position: 3
---

# AI/Run CodeMie Deployment Architecture

The diagram below depicts the AI/Run CodeMie infrastructure deployment in the Azure public cloud environment.

![Azure Architecture Diagram](./images/architecture-diagram.drawio.png)

## EntraID Integration Options

import Tabs from '@theme/Tabs';
import TabItem from '@theme/TabItem';

<Tabs>
  <TabItem value="option1" label="Option 1" default>
    ![EntraID Integration Option 1](./images/azure-client-tenant.drawio.png)
  </TabItem>
  <TabItem value="option2" label="Option 2">
    ![EntraID Integration Option 2](./images/azure-cross-tenants.drawio.png)
  </TabItem>
  <TabItem value="option3" label="Option 3">
    ![EntraID Integration Option 3](./images/azure-epam-tenant.drawio.png)
  </TabItem>
</Tabs>

## Container Resources Requirements

| Component           | Pods                     | RAM   | vCPU | Storage            |
| ------------------- | ------------------------ | ----- | ---- | ------------------ |
| CodeMie API         | 2                        | 8Gi   | 4.0  | –                  |
| CodeMie UI          | 1                        | 128Mi | 0.1  | –                  |
| Elasticsearch       | 2                        | 16Gi  | 4.0  | 100-200 Gb per pod |
| Kibana              | 1                        | 1Gi   | 1.0  | –                  |
| Mermaid-server      | 1                        | 512Mi | 1.0  | –                  |
| PostgreSQL          | Managed service in cloud |       |      | 30-50 Gb           |
| Keycloak + DB       | 1 + 1                    | 4Gi   | 2.0  | 1 Gb               |
| Oauth2-proxy        | 1                        | 128Mi | 0.1  | –                  |
| NATS + Auth Callout | 1 + 1                    | 512Mi | 1.0  | –                  |
| MCP Connect         | 1                        | 1Gi   | 0.5  | –                  |
| Fluentbit           | daemonset                | 128Mi | 0.1  | –                  |
| LLM Proxy\*         | 1                        | 1Gi   | 1.0  | –                  |

\*Depends on the exact LLM proxy type
