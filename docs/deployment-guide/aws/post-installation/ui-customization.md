---
id: ui-customization
sidebar_position: 3
title: UI Customization (Optional)
description: Customize AI/Run CodeMie user interface
---

# UI Customization (Optional)

To meet customer requirements, some of the UI elements on the AI/Run CodeMie can be hidden or changed via customer config. The `customer-config.yaml` file follows a YAML format with a specific structure:

```yaml
components:
  - id: "componentId"
    settings:
      name: "Component Display Name"
      enabled: true|false
      url: "https://example.com/resource"
```

Below are the standard components that can be configured or hidden/enabled in AI/Run CodeMie:

## Video Portal

Provides links to tutorial videos for users.

```yaml
- id: "videoPortal"
  settings:
    name: "Video Portal"
    enabled: true
    url: "https://example-video-portal.com"
```

| Setting | Type | Required | Description |
| ------- | ---- | -------- | ----------- |
| name | string | Yes | Display name for the video portal link |
| enabled | boolean | Yes | Set to `true` to show the video portal link, `false` to hide it |
| url | string | Yes | URL to your video tutorial content |

## User Guide

Provides a link to user documentation.

```yaml
- id: "userGuide"
  settings:
    name: "User Guide"
    enabled: true
    url: "https://example-tutorial-portal.com"
```

| Setting | Type | Required | Description |
| ------- | ---- | -------- | ----------- |
| name | string | Yes | Display name for the user guide link |
| enabled | boolean | Yes | Set to `true` to show the user guide link, `false` to hide it |
| url | string | Yes | URL to your user documentation |

## Admin Actions

Controls whether administrative actions are available.

```yaml
- id: "adminActions"
  settings:
    enabled: true
```

| Setting | Type | Required | Description |
| ------- | ---- | -------- | ----------- |
| enabled | boolean | Yes | Set to `true` to enable admin actions, `false` to disable them |

## Feedback Assistant

Controls whether the feedback feature is available.

```yaml
- id: "feedbackAssistant"
  settings:
    enabled: true
```

| Setting | Type | Required | Description |
| ------- | ---- | -------- | ----------- |
| enabled | boolean | Yes | Set to `true` to enable the feedback assistant, `false` to disable it |

## Workflow Documentation

Provides a link to workflow-specific documentation.

```yaml
- id: "workflowDocumentation"
  settings:
    name: "Workflow Documentation"
    enabled: true
    url: "https://example-documentation.com"
```

| Setting | Type | Required | Description |
| ------- | ---- | -------- | ----------- |
| name | string | Yes | Display name for the workflow documentation link |
| enabled | boolean | Yes | Set to `true` to show the workflow documentation link, `false` to hide it |
| url | string | Yes | URL to your workflow documentation |

## Configuration

To configure it add the following blocks with specific for you configuration to the `codemie-helm-charts/codemie-api/values.yaml`:

```yaml
extraObjects:
  - apiVersion: v1
    kind: ConfigMap
    metadata:
      name: customer-config
    data:
      customer-config.yaml: |
        ---
        components:
          - id: "videoPortal"
            settings:
              name: "Video Portal"
              enabled: false
              url: "https://example-video-portal.com"
          - id: "userGuide"
            settings:
              name: "User Guide"
              enabled: false
              url: "https://example-tutorial-portal.com"
          - id: "adminActions"
            settings:
              enabled: true
          - id: "feedbackAssistant"
            settings:
              enabled: false
          - id: "workflowDocumentation"
            settings:
              name: "Workflow Documentation"
              enabled: false
              url: "https://example-documentation.com"
```

```yaml
extraVolumes: |
  ...
  - name: customer-config
    configMap:
      name: customer-config
  ...
```

```yaml
extraVolumeMounts: |
  ...
  - name: customer-config
    mountPath: /app/config/customer/customer-config.yaml
    subPath: customer-config.yaml
  ...
```

And apply helm chart with the command:

```bash
helm upgrade --install codemie-api oci://europe-west3-docker.pkg.dev/or2-msq-epmd-edp-anthos-t1iylu/helm-charts/codemie \
--version x.y.z \
--namespace "codemie" \
-f "./codemie-api/values-aws.yaml" \
--wait --timeout 600s
```
