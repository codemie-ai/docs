---
id: google-vertex-ai
sidebar_position: 6
title: Google Vertex AI
description: Enable Vertex AI API and configure partner models
pagination_prev: admin/configuration/ai-models-integration/ai-models-integration-overview
pagination_next: null
---

# Google Vertex AI Configuration

## Overview

This guide explains how to enable Google Vertex AI models for use with AI/Run CodeMie. Google Vertex AI provides access to both native Google models (Gemini series) and partner models from providers like Anthropic (Claude).

:::info Model Availability
**Native Google Models**: Available immediately after enabling Vertex AI API

**Partner Models**: Require explicit enablement in Model Garden
:::

## Prerequisites

Before starting, ensure you have:

- **GCP Project**: Active Google Cloud project with billing enabled
- **IAM Permissions**: `Vertex AI User` or `Vertex AI Administrator` role
- **APIs Enabled**: Vertex AI API must be enabled
- **Service Account**: Service account with appropriate permissions (for programmatic access)

## Step 1: Enable Vertex AI API

### 1.1 Navigate to Vertex AI

1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Select your project from the project dropdown
3. In the navigation menu or search bar, find **Vertex AI**
4. Click on **Vertex AI** to open the service

### 1.2 Enable the API

If this is your first time using Vertex AI:

1. You'll see a prompt to enable the Vertex AI API
2. Click **Enable** or **Enable API**
3. Wait for the API to be enabled (typically takes 1-2 minutes)

## Step 2: Access Model Garden

### 2.1 Navigate to Model Garden

1. In Vertex AI console, locate the left navigation menu
2. Click **Model Garden**
3. You'll see a catalog of available models organized by provider

### 2.2 Understanding Model Types

Models in Vertex AI are categorized as:

**Native Google Models** (Available by Default):

- Gemini 3 Pro
- Gemini 2.5 Pro
- Text Embeddings (text-embedding-005)

**Partner Models** (Require Enablement):

- Anthropic Claude (Claude 4 series)

## Step 3: Enable Partner Models

### 3.1 Enable Claude Models (Example)

To enable Anthropic Claude models on Vertex AI:

1. In Model Garden, navigate to **Partner models** section or search for "Claude"
2. Select the Claude model you want to enable (e.g., "Claude Opus 4.5")
3. Review the model details page showing:
   - Model capabilities
   - Token limits
   - Supported data types
   - Pricing information
4. Click **Enable** button at the top of the page
5. Review and accept the terms of service
6. Wait for enablement to complete
