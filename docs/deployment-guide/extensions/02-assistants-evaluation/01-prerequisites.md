---
id: prerequisites
title: Prerequisites
sidebar_label: Prerequisites
sidebar_position: 1
description: Prerequisites for installing Langfuse
---

# Prerequisites

Before starting any deployment method, ensure you have:

## Required Tools

- `kubectl` configured and connected to your cluster
- `helm` installed (version 3.x)
- `openssl` for generating secure secrets

## Infrastructure Requirements

- Installed and deployed AI/Run CodeMie instance
- PostgreSQL database instance
- Sufficient cluster resources for Langfuse components
- Kubernetes cluster with appropriate permissions

:::warning Minimum CodeMie Version

Minimal supported version of AI/Run CodeMie for evaluation is 1.3.0. Make sure you've updated your CodeMie installation before proceeding.

:::

## Access to the following repositories:

- [codemie-helm-charts](https://gitbud.epam.com/epm-cdme/codemie-helm-charts)

Review Langfuse system requirements before proceeding.
