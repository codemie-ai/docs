---
id: white-label-overview
title: White-Label Theming Kit
sidebar_label: White-Label Theming
sidebar_position: 1
description: Apply your own product name, logos, colors, fonts, and help links to AI/Run CodeMie with a theme package, without rebuilding any image
kitVersion: '1'
pagination_prev: admin/configuration/index
pagination_next: null
---

# White-Label Theming Kit

The white-label theming kit lets you present AI/Run CodeMie under your own brand. You describe the brand in a single `theme-package.yaml` file — product name, colors, typography, logos, favicons, and help links — and the `apply-theme` script validates it, renders it into Helm values, and rolls it out to the running platform. No source change and no image rebuild are needed.

The kit is published in the documentation repository at [`admin/configuration/white-label/kit`](https://github.com/codemie-ai/docs/tree/main/admin/configuration/white-label/kit) and contains:

| File                                | Purpose                                                                |
| ----------------------------------- | ---------------------------------------------------------------------- |
| `apply-theme`                       | Script that validates, renders, and applies a theme package            |
| `theme-package.schema.json`         | JSON Schema (draft-07) that defines the theme package contract         |
| `theme-package.yaml`                | Annotated template to copy and fill in                                 |
| `examples/acme/`                    | Complete example for the fictional brand "Acme Corp", including assets |
| `.github/workflows/apply-theme.yml` | Example GitHub Actions workflow for pipeline use                       |
| `tests/`                            | Automated tests for the script (bats-core)                             |

:::info Kit version and platform releases
This page describes **kit version 1** (`kitVersion: "1"` in the page metadata), which works with theme packages that declare `version: '1'`. Each AI/Run CodeMie release is published with the kit version it is paired with; check the [Release Notes](../../update/release-notes/release-notes.md) for your target release before you upgrade, and use the kit version that is listed there.
:::

:::warning Re-apply the theme after platform upgrades
A subsequent `helm upgrade` without `--reuse-values` will drop the brand theme; always pass `--reuse-values` or re-apply the theme package after upgrades.
:::

## Prerequisites

Install the following tools on the machine, or in the pipeline runner, that executes `apply-theme`:

| Tool                                                | Minimum version | Used for                                              |
| --------------------------------------------------- | --------------- | ----------------------------------------------------- |
| [yq](https://github.com/mikefarah/yq)               | 4               | Reading and converting the theme package YAML         |
| [ajv-cli](https://github.com/ajv-validator/ajv-cli) | 6               | Validating the package against the JSON Schema        |
| [helm](https://helm.sh/docs/intro/install/)         | 3               | Upgrading the UI and API releases (apply phase)       |
| [kubectl](https://kubernetes.io/docs/tasks/tools/)  | 1.25            | Restarting and checking deployments (apply phase)     |
| [bats-core](https://github.com/bats-core/bats-core) | 1.10            | Running the kit test suite (optional, kit developers) |

The apply phase also requires `kubectl` and `helm` to be authenticated against the cluster that hosts AI/Run CodeMie, with permission to upgrade the two Helm releases and restart their deployments in the target namespace. The validate and render phases need no cluster access.

## Quick Start

1. **Fill in the template.** Copy `kit/theme-package.yaml` next to your brand assets and fill in every field marked `REQUIRED`.

   ```bash
   cp kit/theme-package.yaml my-brand/theme-package.yaml
   ```

2. **Validate.** Run the script in `--render-only` mode. It checks the package, renders the Helm values into a temporary directory, and does not contact the cluster.

   ```bash
   kit/apply-theme --render-only my-brand/theme-package.yaml my-brand/assets
   ```

3. **Apply.** Run the script without `--render-only` to upgrade both releases and restart the deployments.

   ```bash
   kit/apply-theme --namespace codemie my-brand/theme-package.yaml my-brand/assets
   ```

## Step-by-Step Walkthrough

### 1. Prepare the assets directory

Create a directory that holds exactly the five brand files referenced by the `assets` section of the package:

| Package field       | Typical file       | Notes                         |
| ------------------- | ------------------ | ----------------------------- |
| `assets.logoLight`  | `logo-light.svg`   | Logo shown on the light theme |
| `assets.logoDark`   | `logo-dark.svg`    | Logo shown on the dark theme  |
| `assets.favicon`    | `favicon.ico`      | Legacy browser icon           |
| `assets.faviconSvg` | `favicon.svg`      | Vector browser icon           |
| `assets.manifest`   | `site.webmanifest` | Web app manifest              |

File names in the package are resolved relative to the assets directory you pass to the script.

### 2. Fill in the theme package

Edit your copy of `theme-package.yaml`. Every field is described in the [Theme Package Reference](./package-reference.md). The main sections are:

- `product` — the product name and short name shown in the browser tab and UI headers.
- `colors` — semantic tokens such as `surface.default`, each with a `dark` and a `light` value in `#rrggbb` format. Tokens you do not list keep the default values.
- `typography` — CSS font families for UI text, prose, and code. Optionally add `fontFaceCSS` with inline `@font-face` rules.
- `assets` — the file names from the previous step.
- `links` — the name and URL of each help link shown in the UI. Include every link that is enabled in your `customer-config.yaml`; see [Customer Feature Configuration](../codemie/customer-feature-configuration.md).

A complete, valid package for the fictional brand "Acme Corp" is available in `kit/examples/acme/`.

```yaml
version: '1'

product:
  name: 'Acme Corp AI Platform'
  shortName: 'Acme'

colors:
  surface.default:
    dark: '#121826'
    light: '#ffffff'

typography:
  bodyFamily: 'Inter, sans-serif'
  bodyProseFamily: 'Georgia, serif'
  codeFamily: 'Fira Code, monospace'
  fontFaceCSS: null

assets:
  logoLight: 'logo-light.svg'
  logoDark: 'logo-dark.svg'
  favicon: 'favicon.ico'
  faviconSvg: 'favicon.svg'
  manifest: 'site.webmanifest'

links:
  userGuide:
    name: 'Acme Docs'
    url: 'https://docs.acme.example/'
```

### 3. Validate and render

```bash
kit/apply-theme --render-only --output-dir ./rendered my-brand/theme-package.yaml my-brand/assets
```

The script runs the validation phase and then the render phase:

1. The package is validated against `theme-package.schema.json`.
2. Every file named in `assets` must exist in the assets directory.
3. If a `customer-config.yaml` is found, every link that is enabled there must be present in the package. The script looks for the file at the path in the `CUSTOMER_CONFIG_PATH` environment variable, and falls back to `/etc/codemie/customer-config.yaml`. The check is skipped when no file is found.

If any check fails, the script prints all problems and exits with a non-zero code without writing output. Otherwise it writes three files to the output directory (a temporary directory when `--output-dir` is not set):

| File                           | Content                                                                                       |
| ------------------------------ | --------------------------------------------------------------------------------------------- |
| `brand.css`                    | A `:root` block of CSS custom properties for typography and colors, preceded by `fontFaceCSS` |
| `values-codemie-ui.brand.yaml` | Helm values overlay for the UI release: product names, base64-encoded assets, `brand.css`     |
| `values-codemie.brand.yaml`    | Helm values overlay for the API release: the help links shown in the UI                       |

Both overlays carry a `checksum/brand` pod annotation computed from the package. A changed package therefore always triggers a new rollout.

Review `brand.css` and the two values files before applying, especially when you run the kit for the first time.

### 4. Apply to the cluster

```bash
kit/apply-theme \
  --namespace codemie \
  --release-ui codemie-ui \
  --release-codemie codemie \
  my-brand/theme-package.yaml my-brand/assets
```

After validation and rendering, the script:

1. Runs `helm upgrade --reuse-values` for the UI release with `values-codemie-ui.brand.yaml`.
2. Runs `helm upgrade --reuse-values` for the API release with `values-codemie.brand.yaml`.
3. Restarts both deployments and waits for the rollouts to finish.

The script always reuses the values of the running releases. It never sets the chart version or the image tag, so applying a theme never changes which version of the platform is running.

| Option                     | Default        | Description                                       |
| -------------------------- | -------------- | ------------------------------------------------- |
| `--render-only`            | off            | Validate and render only; make no cluster changes |
| `--namespace <ns>`         | `default`      | Namespace of both Helm releases                   |
| `--release-ui <name>`      | `codemie-ui`   | Helm release name of the UI chart                 |
| `--release-codemie <name>` | `codemie`      | Helm release name of the API chart                |
| `--output-dir <dir>`       | temp directory | Directory for the rendered files                  |

### 5. Verify in the browser

Reload the platform in a private browser window and confirm the product name in the tab, the logos on the light and dark themes, the favicon, and the help links in the UI.

## Use in a Pipeline

The `--render-only` mode is designed for pipelines: it needs no cluster access, exits non-zero on any validation error, and leaves the rendered files in `--output-dir` so a later job can archive or review them. A typical pipeline runs a validation job on every change to the theme package and a separate, manually triggered job that applies it.

The kit ships an example GitHub Actions workflow in `kit/.github/workflows/apply-theme.yml`. It is triggered manually (`workflow_dispatch`) and has two jobs:

- `validate` runs `apply-theme --render-only` against the package and assets paths that you provide as inputs.
- `apply` runs only when `validate` succeeds. It writes a kubeconfig from the `KUBECONFIG_DATA` repository secret and runs `apply-theme` with the namespace and release names that you provide as inputs.

Copy the workflow into your own repository, adjust the input defaults and the tool installation steps to your runners, and store the base64-encoded kubeconfig of a service account with limited rights as the `KUBECONFIG_DATA` secret. For other CI systems, run the same two commands: `apply-theme --render-only` first, then `apply-theme` without the flag.

## Limits and Out-of-Scope Items

- **Asset size.** The five asset files are delivered as base64-encoded ConfigMap data. Keep the combined size of the assets below 1 MiB.
- **No font binaries.** Font files are not delivered through the kit. Reference fonts by URL in `typography.fontFaceCSS`, for example `@font-face { font-family: 'Inter'; src: url('https://fonts.acme.example/inter.woff2'); }`, and make sure the URL is reachable from users' browsers.
- **Root-scoped CSS only.** `brand.css` contains a single `:root` block. The kit does not change component styles or class names.
- **Per-user appearance.** The user-level custom appearance settings are not touched by the kit and continue to work as before.
- **Not covered.** The gradient background images on authentication pages and the default AI avatar image (`ai-avatar.png`) are not part of the theme package and keep their default look.
- **Default versions.** The kit never changes the chart version or the image tag of the platform.

## Troubleshooting

| Symptom                                                          | Cause and fix                                                                                                             |
| ---------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------- |
| `validation failed` with a list of schema errors                 | A required field is missing or malformed. Compare the package with the [Theme Package Reference](./package-reference.md). |
| `assets.<name>: file not found`                                  | The file name in `assets` does not match a file in the assets directory.                                                  |
| `links.<id>: enabled in customer-config but absent from package` | Add the link to the package, or disable the component in `customer-config.yaml`.                                          |
| Brand disappears after a platform upgrade                        | The upgrade ran without `--reuse-values`. Re-run `apply-theme`.                                                           |
| Browser still shows the old logo                                 | Hard-reload the page or clear the browser cache; the deployments were restarted but the browser may cache static files.   |

## Related Topics

- [Theme Package Reference](./package-reference.md)
- [Customer Feature Configuration](../codemie/customer-feature-configuration.md)
- [Release Notes](../../update/release-notes/release-notes.md)
