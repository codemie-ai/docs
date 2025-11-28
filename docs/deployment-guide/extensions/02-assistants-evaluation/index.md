---
id: assistants-evaluation
title: Assistants Evaluation (Langfuse)
sidebar_label: Assistants Evaluation
sidebar_position: 2
description: Install and configure Langfuse for LLM observability and evaluation
---

# Assistants Evaluation (Langfuse)

This comprehensive guide explains how to install and configure Langfuse using Helm, with both automated and manual deployment methods.

## Overview

Langfuse is an open-source LLM observability platform that provides:

- **Tracing**: Track and analyze LLM calls and their performance
- **Evaluation**: Assess and score AI assistant responses
- **Analytics**: Gain insights into usage patterns and costs
- **Debugging**: Identify and troubleshoot issues in LLM applications

## Deployment Options

This guide provides two deployment methods:

### Automated Deployment (Recommended)

Uses the `deploy-langfuse.sh` script to automatically handle:
- Kubernetes secret creation
- Helm repository configuration
- Langfuse deployment
- Integration secret creation for CodeMie

See [Deployment](./deployment) for both automated and manual deployment options.

## Documentation Structure

Follow these sections in order for a successful deployment:

1. [Prerequisites](./prerequisites) - Required tools and infrastructure
2. [System Requirements](./system-requirements) - Resource specifications and architecture
3. [Deployment Prerequisites](./deployment-prerequisites) - Configuration steps before deployment
4. [Deployment](./deployment) - Automated or manual deployment options
5. [Post-Deployment Configuration](./post-deployment) - Configure CodeMie integration
6. [Troubleshooting](./troubleshooting) - Common issues and solutions

## Next Steps

Start with [Prerequisites](./prerequisites) to ensure your environment is ready for Langfuse deployment.
