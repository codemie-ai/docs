---
id: enterprise-features
title: Enterprise Features
sidebar_label: Enterprise Features
sidebar_position: 4
pagination_prev: null
pagination_next: null
description: Overview of all Enterprise Edition features in AI/Run CodeMie, with links to documentation.
---

# ✨ Enterprise Features

## CLI & Developer Experience

| Feature                 | Description                                                                                                                                                                                                                                                                                                                  | Documentation                                                      |
| ----------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------ |
| **CodeMie CLI**         | Unified CLI wrapping Claude Code, Gemini, OpenCode, and a built-in LangGraph agent. Includes SSO authentication, analytics, audit logging, secrets scanning, budget controls, and governance policies. Bring-your-own-infrastructure model with no per-developer fees.                                                       | [Overview](../../codemie-cli/)                                     |
| **Assistants from CLI** | Connect any CodeMie platform assistant to Claude Code via `codemie setup assistants`. Call assistants directly from a coding session using `@assistant-name`, or start a terminal-only chat session.                                                                                                                         | [Assistants Integration](../../codemie-cli/assistants-integration) |
| **Skills from CLI**     | Install any CodeMie skill into Claude Code as a slash command via `codemie setup skills`. Skills can also be invoked directly from the terminal with `codemie skill run`.                                                                                                                                                    | [Skills Integration](../../codemie-cli/skills-integration)         |
| **Claude Code Skills**  | Six pre-built skills automatically available in `codemie-claude`: platform SDK management (`codemie-sdk`), analytics reports (`codemie-analytics`), branded HTML dashboards (`codemie-html-report`), config health audit (`claude-setup-audit`), GitHub issue filing (`report-issue`), and Microsoft 365 access (`msgraph`). | [Claude Code Skills](../../codemie-cli/codemie-claude-skills)      |

## Platform Extensions

| Feature                       | Description                                                                                                                                                                                                                                                        | Documentation                                                                                |
| ----------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | -------------------------------------------------------------------------------------------- |
| **LiteLLM Proxy**             | Unified gateway for multi-LLM deployments. Enables connection to AWS Bedrock, Azure OpenAI, and Google Vertex AI with spend tracking, user-based budgeting, load balancing, and model failover. Required for multi-provider deployments. Requires CodeMie v2.0.0+. | [LiteLLM Proxy](../../../admin/deployment/extensions/litellm-proxy/)                         |
| **Assistants Evaluation**     | Langfuse-based open-source LLM observability platform. Provides tracing of LLM calls, evaluation scoring of AI responses, usage analytics, and debugging tools for LLM applications.                                                                               | [Assistants Evaluation](../../../admin/deployment/extensions/assistants-evaluation/)         |
| **AI Code Explorer (AICE)**   | Graph-based (Neo4j) code analysis and exploration platform. Provides advanced code understanding through AI-powered insights and knowledge graph representation for large codebases.                                                                               | [AI Code Explorer](../../../admin/deployment/extensions/ai-code-explorer/)                   |
| **Angular Upgrade Assistant** | AI-powered Vue.js/Vite UI for streamlining Angular project upgrades to newer versions. Assists with dependency resolution and automated build error fixing.                                                                                                        | [Angular Upgrade Assistant](../../../admin/deployment/extensions/angular-upgrade-assistant/) |
| **Salesforce DevForce AI**    | AI-powered development accelerator for Salesforce workflows. Provides intelligent assistance for Salesforce-related development tasks and automation.                                                                                                              | [Salesforce DevForce AI](../../../admin/deployment/extensions/salesforce-devforce-ai/)       |
| **MF Lens**                   | Mainframe code analysis and exploration solution. Uses graph-based (Neo4j) knowledge representation for COBOL and mainframe code, with LiteLLM for AI-powered insights.                                                                                            | [MF Lens](../../../admin/deployment/extensions/mf-lens/)                                     |

## AWS AgentCore

| Feature           | Description                                                                                                                                                                        | Documentation                                                                    |
| ----------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------- |
| **AWS AgentCore** | Discover AWS-hosted agent runtimes, browse their endpoints, and install them as assistants in the platform — without writing integration code. Requires an active AWS integration. | [AWS AgentCore](../../../admin/configuration/extensions/aws-agentcore/agentcore) |

## Analytics & Governance

| Feature                   | Description                                                                                                                                                                                                                                                                               | Documentation                                                                                                                                                                                  |
| ------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Budget Management**     | Per-user and per-project spend limits enforced via LiteLLM. Supports three budget categories (Platform, CLI, Premium models) with configurable soft/hard limits, automatic resets, and real-time spend tracking. Requires LiteLLM Proxy.                                                  | [Project Budgets](../../../admin/configuration/codemie/project-budget-management) · [LiteLLM Budget Configuration](../../../admin/configuration/extensions/litellm-proxy/budget-configuration) |
| **AI Adoption Analytics** | Analytics dashboard tracking LLM usage, costs, and AI adoption across the organization. Includes the AI Champions Leaderboard — ranking users by engagement score across six dimensions. Requires [LiteLLM Proxy](../../../admin/deployment/extensions/litellm-proxy/) for spending data. | [Analytics](../../analytics/)                                                                                                                                                                  |

:::info Access Requirements
All features listed on this page require an Enterprise Edition license. Contact your CodeMie platform administrator to enable these features in your deployment.
:::
