---
id: architecture
title: AI/Run CodeMie Deployment Architecture
sidebar_label: Architecture
sidebar_position: 3
---

# AI/Run CodeMie Deployment Architecture

The diagrams below depict the AI/Run CodeMie infrastructure deployment in one region of the GCP public cloud environment. There are two deployment options available:

- **Public cluster option** with access to AI/Run CodeMie from predefined networks or IP addresses (VPN, etc) on public DNS from user workstation
- **Private cluster option** with access to AI/Run CodeMie via Bastion host on private DNS

![AI/Run CodeMie Architecture](./images/architecture-diagram.drawio.png)

import ContainerResources from '../common/03-architecture/\_container-resources.mdx';

<ContainerResources />
