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

import ContainerResources from '../common/docs/\_container-resources.mdx';

<ContainerResources />
