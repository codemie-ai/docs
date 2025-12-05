---
id: restore-system-instructions
sidebar_position: 9
title: Restore System Instructions
description: Revert assistant system instructions to previous versions using history tracking
---

# Restore System Instructions

When experimenting with assistant configurations, the latest system instructions don't always produce the best results. AI/Run CodeMie automatically tracks all instruction changes, allowing you to restore any previous version.

## Access Instruction History

1. Navigate to **Assistants** → **Project Assistants**.

2. Click the **Actions** button (⋮) next to your assistant and select **Edit**:

   ![Edit assistant](../images/image217.png)

3. Select the **History** tab:

   ![History tab](../images/image117.png)

## Restore Previous Version

1. Browse through saved versions and click the version title to preview.

2. Select the version you want to restore.

3. Click the **Restore** button:

   ![Restore version](../images/image97.png)

:::info Version History
AI/Run CodeMie preserves all system instruction modifications, creating a complete audit trail. This allows you to safely experiment with different approaches while maintaining the ability to revert to proven configurations.
:::

:::tip Testing Iterations
Use version history to A/B test different instruction sets. Compare results from multiple versions to identify the most effective configuration for your use case.
:::