---
id: ai-models-integration-overview
sidebar_position: 3
title: AI Models Integration
description: Configure LLM and embedding models for AI/Run CodeMie
pagination_prev: admin/configuration/index
---

# AI Models Integration

## Overview

AI/Run CodeMie provides flexible integration options for connecting to Large Language Models (LLMs) and embedding models from various cloud providers. This section guides you through configuring model access, managing model settings, and choosing the right integration approach for your deployment.

## Prerequisites

Before configuring AI models, complete the following:

1. **Enable Models in Cloud Provider**
   - [Azure OpenAI](./azure-openai): Create Azure OpenAI service and deploy models
   - [AWS Bedrock](./aws-bedrock): Request access to foundation models in AWS
   - [Google Vertex AI](./google-vertex-ai): Enable Vertex AI API and configure partner models

2. **Obtain Cloud Credentials**
   - API keys, endpoints, or authentication credentials for your chosen provider
   - Required IAM permissions for model access

3. **Access Helm Chart Configuration**
   - Clone [codemie-helm-charts](https://gitbud.epam.com/epm-cdme/codemie-helm-charts) repository
   - Locate `codemie-api/values.yaml` file

## Integration Options

AI/Run CodeMie supports three model integration approaches. **We recommend LiteLLM Proxy for production deployments** due to its advanced features, flexibility, and usage tracking capabilities.

### Option 1: LiteLLM Proxy (Recommended)

:::tip Recommended Approach
LiteLLM is the **preferred integration method** for production environments. It provides comprehensive usage statistics, detailed analytics, flexible routing, and enterprise-grade features that are essential for managing LLM and embedding models at scale.
:::

**Best for**: Production deployments, multiple LLM providers usage, budget control, usage tracking

Deploy LiteLLM as a centralized proxy gateway with enterprise features including:

- **Usage Statistics & Analytics**: Detailed tracking of model usage, costs, token consumption, and performance metrics
- **Budget Management**: Set spending limits per user, team, or project with real-time enforcement
- **Multi-provider Support**: Route requests across AWS, Azure, GCP seamlessly with unified API
- **Load Balancing**: Distribute requests across multiple model deployments for high availability
- **Fallback Routing**: Automatic failover if primary model unavailable
- **Rate Limiting**: Control request rates per user or team
- **Caching**: Built-in response caching to reduce costs and latency
- **Observability**: OpenTelemetry integration for monitoring and tracing

**Configuration**: Requires [LiteLLM Proxy deployment](../../deployment/extensions/litellm-proxy/)

**Required Environment Variables**:

- `LLM_PROXY_MODE=lite_llm` - Enable LiteLLM Proxy mode
- `LLM_PROXY_ENDPOINT=https://your-litellm-proxy-url` - LiteLLM Proxy URL
- `LLM_PROXY_API_KEY=your-api-key` - LiteLLM Proxy authentication key

[Learn more about LiteLLM Proxy →](../../deployment/extensions/litellm-proxy/)

### Option 2: Native Provider Integration (Easiest & Fastest Setup)

**Best for**: Quick setup, testing, single-cloud deployments, minimal configuration

Connect directly to cloud provider APIs without additional proxy layers. This is the **easiest and fastest option to get started**, requiring minimal configuration and no additional infrastructure.

**Supported Providers**:

- Azure OpenAI
- AWS Bedrock
- Google Vertex AI

**Configuration**: Uses `llm-<MODELS_ENV>-config.yaml` files mounted to CodeMie API pods.

**Proxy Mode**: `LLM_PROXY_MODE=internal`

[Learn more about CodeMie Native LLM Config →](./codemie-native-llm-config)

### Option 3: Third-Party LLM Proxy

**Best for**: Existing proxy infrastructure, OpenAI-compatible proxies, custom routing requirements

Integrate with your existing LLM proxy service that implements OpenAI-compatible APIs. Configure CodeMie to route requests through your proxy endpoint.

**Requirements**:

- OpenAI API-compatible endpoints
- Authentication mechanism (API keys, tokens)

**Configuration**: Use native integration with custom endpoint URLs

---

## Choosing the Right Integration Option

- **Choose LiteLLM** if you need production-grade features, usage analytics, multi-cloud support, or plan to scale
- **Choose Native** if you need to get started quickly, testing features, or have simple single-provider requirements
- **Choose Third-Party** if you already have an existing LLM proxy infrastructure
