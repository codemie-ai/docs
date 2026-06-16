---
id: workflows-index
title: Workflows
sidebar_position: 2
pagination_prev: user-guide/index
pagination_next: null
---

# How to Work With Workflows

## Overview

This section covers how to work with Workflows in AI/Run CodeMie.

---

## Getting Started

Learn the basics of creating and managing workflows:

- [Workflows Overview](./workflows-overview.md) - Introduction to workflows and their capabilities
- [Create Workflow](./create-workflow.md) - Build a workflow from scratch
- [Create a Workflow from a Template](./create-workflow-from-template.md) - Start with pre-built templates
- [Workflow Templates](./workflow-templates.md) - Explore available workflow templates

## Working with Workflows

Manage and share your workflow executions:

- [Share Workflow Execution](./share-workflow-execution.md) - Share results with team members
- [Exporting Workflow Execution](./exporting-workflow-execution.md) - Export execution data
- [LLM Model Name in Workflow](./llm-model-name-in-workflow.md) - Configure AI models for workflows

## Workflow Marketplace

Discover, execute, and share workflows across the platform:

- [Marketplace Overview](./marketplace-overview.md) - Browse and execute community-published workflows
- [Publish to Marketplace](./marketplace-publishing.md) - Share a workflow globally with publishing requirements and credential policies
- [Clone Workflow from Marketplace](./clone-workflow-from-marketplace.md) - Create a personal copy of a marketplace workflow

## Moving Workflows Between Projects

You can move a workflow from one project to another by changing its project assignment:

1. Open the workflow for editing (click **Edit** from the workflow card actions menu).
2. Open **Workflow Config** → **Basic** tab.
3. Change the **Project name** dropdown to the desired target project.
4. Click **Save**.

The workflow moves to the new project immediately. All configuration (states, transitions, and settings) is preserved.

:::warning Integrations
Integrations are not transferred between projects regardless of their level (project or user). If the workflow used integrations (e.g., Jira, Confluence, Git), you will need to recreate them in the target project.
:::

:::info
You can only move a workflow to a project you have access to.
:::

---

## Workflow Configuration

:::info YAML Configuration Guide
For building complex workflows, explore and use the comprehensive YAML configuration documentation.
:::

### Core Documentation

- [Overview](./configuration/index.md) - Configuration guide introduction
- [Introduction & Getting Started](./configuration/introduction.md) - Core concepts and first workflow
- [Configuration Reference](./configuration/configuration-reference.md) - Complete YAML reference
- [Workflow States](./configuration/workflow-states.md) - State types and configuration
- [State Transitions](./configuration/state-transitions.md) - Control flow and branching
- [Context Management](./configuration/context-management.md) - Share data between states

### Advanced Topics

- [Advanced Features](./configuration/advanced-features.md) - Map-reduce, memory, retry policies
- [Specialized Node Types](./configuration/specialized-nodes.md) - Custom node implementations
- [Integration Capabilities](./configuration/integration-capabilities.md) - Connect external systems

### Resources

- [Best Practices](./configuration/best-practices.md) - Design principles and optimization
- [Complete Examples](./configuration/examples.md) - Real-world workflow examples
- [Troubleshooting](./configuration/troubleshooting.md) - Debug and resolve issues
