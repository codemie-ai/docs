---
id: ui-customization
sidebar_position: 3
title: UI Customization (Optional)
description: Customize AI/Run CodeMie user interface
---

# UI Customization (Optional)

## Overview

AI/Run CodeMie allows you to customize the user interface to match your organization's branding and requirements.

## Branding Configuration

### Custom Logo

To add your organization's logo:

1. Prepare logo image file (recommended size: 200x50px, PNG or SVG format)
2. Create a ConfigMap with the logo file
3. Mount the ConfigMap to the UI deployment
4. Update UI configuration to reference the logo path

### Color Scheme

Customize the color scheme to match your brand:

1. Navigate to `codemie-ui/values-aws.yaml`
2. Add custom CSS variables for colors:

```yaml
extraEnv:
  - name: CUSTOM_PRIMARY_COLOR
    value: "#your-color-hex"
  - name: CUSTOM_SECONDARY_COLOR
    value: "#your-color-hex"
```

## Platform Configuration

### Custom Welcome Message

Add a custom welcome message for users:

```yaml
extraObjects:
  - apiVersion: v1
    kind: ConfigMap
    metadata:
      name: codemie-ui-custom-config
    data:
      welcome-message.txt: |
        Welcome to AI/Run CodeMie
        Your custom message here
```

### Feature Toggles

Enable or disable specific UI features:

```yaml
extraEnv:
  - name: ENABLE_MARKETPLACE
    value: "true"
  - name: ENABLE_WORKFLOWS
    value: "true"
```

## Applying Customizations

After modifying UI configuration:

1. Update the Helm release:

   ```bash
   helm upgrade codemie-ui \
     oci://europe-west3-docker.pkg.dev/or2-msq-epmd-edp-anthos-t1iylu/helm-charts/codemie-ui \
     --version x.y.z \
     --namespace codemie \
     -f ./codemie-ui/values-aws.yaml
   ```

2. Verify changes in the browser (may require cache clear)

## Next Steps

Proceed to [AI Models Integration](../ai-models-integration/) to configure LLM and embedding models.
