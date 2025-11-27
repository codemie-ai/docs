---
id: infrastructure-deployment-overview
title: Azure Infrastructure Deployment
sidebar_label: Infrastructure Deployment
sidebar_position: 4
---

# Azure Infrastructure Deployment

## Overview

:::info
Skip if you have ready AKS cluster with all required services (see [AI/Run CodeMie deployment architecture](../architecture)).
:::

This section describes the process of deploying the AI/Run CodeMie infrastructure within an Azure environment and will cover the following topics:

- Create Azure storage account and container to store terraform states
- Create the AKS Cluster
- Create the Virtual Networks (vNet)
  - HubVNet
  - AksVNet
- Create the Azure NAT Gateway
- Create the Node Pool
- Create the Storage Accounts
  - VM Storage Account
  - AI/Run Storage Account
- Create the Bastion Host
- Create the Virtual Machine
- Create PostgreSQL Flexible server and database
- Create the Azure Key Vault key to encrypt and decrypt sensitive data in the AI/Run application
- Create the Entra ID Applications
  - to access the Azure Key Vault key from the AI/Run CodeMie application backend
  - to access the Azure AI services from AI/Run CodeMie application backend
- Create the Azure AI models

## Next Steps

Choose your deployment method:

- [Scripted Deployment →](./infrastructure-scripted-deployment)
