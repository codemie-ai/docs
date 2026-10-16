---
id: white-label-overview
title: White-Label Theming Kit
sidebar_label: White-Label Theming
sidebar_position: 1
description: Apply a custom product name, logos, colors, fonts, and help links to AI/Run CodeMie with a theme package, without rebuilding any image
kitVersion: '1'
pagination_prev: admin/configuration/index
pagination_next: null
---

# White-Label Theming Kit

The white-label theming kit presents AI/Run CodeMie under a customer brand. The brand is described in a single `theme-package.yaml` file — product name, colors, typography, logos, favicons, and help links — and the `apply-theme` script validates it, renders it into Helm values, and rolls it out to the running platform. An optional `keycloak` block extends the brand to the Keycloak login page and Keycloak emails. No source change and no image rebuild are needed.

The kit is published in the documentation repository at [`docs/admin/configuration/white-label/kit`](https://github.com/codemie-ai/docs/tree/main/docs/admin/configuration/white-label/kit) and contains:

| File                                | Purpose                                                                |
| ----------------------------------- | ---------------------------------------------------------------------- |
| `apply-theme`                       | Script that validates, renders, and applies a theme package            |
| `theme-package.schema.json`         | JSON Schema (draft-07) that defines the theme package contract         |
| `theme-package.yaml`                | Annotated template to copy and fill in                                 |
| `examples/acme/`                    | Complete example for the fictional brand "Acme Corp", including assets |
| `.github/workflows/apply-theme.yml` | Example GitHub Actions workflow for pipeline use                       |
| `tests/`                            | Automated tests for the script (bats-core)                             |

:::info Kit version
This page describes **kit version 1** (`kitVersion: "1"` in the page metadata), which works with theme packages that declare `version: '1'`. See [Kit Versions](#kit-versions) for the platform support that each kit feature requires.
:::

:::warning Re-apply the theme after platform upgrades
A subsequent `helm upgrade` without `--reuse-values` will drop the brand theme; always pass `--reuse-values` or re-apply the theme package after upgrades.
:::

## Prerequisites

Install the following tools on the machine, or in the pipeline runner, that executes `apply-theme`:

| Tool                                                | Minimum version | Used for                                              |
| --------------------------------------------------- | --------------- | ----------------------------------------------------- |
| [yq](https://github.com/mikefarah/yq)               | 4               | Reading and converting the theme package YAML         |
| [ajv-cli](https://github.com/ajv-validator/ajv-cli) | 5               | Validating the package against the JSON Schema        |
| [helm](https://helm.sh/docs/intro/install/)         | 3.9             | Upgrading the platform Helm releases (apply phase)    |
| [kubectl](https://kubernetes.io/docs/tasks/tools/)  | 1.25            | Restarting and checking deployments (apply phase)     |
| [bats-core](https://github.com/bats-core/bats-core) | 1.10            | Running the kit test suite (optional, kit developers) |

The apply phase also requires `kubectl` and `helm` to be authenticated against the cluster that hosts AI/Run CodeMie, with permission to upgrade the UI and API Helm releases and restart their deployments in the target namespace. When the package has a `keycloak` block, the permission to upgrade the Keycloak and oauth2-proxy releases in their own namespaces is needed as well. The validate and render phases need no cluster access.

## Quick Start

1. **Fill in the template.** Copy `kit/theme-package.yaml` next to the brand assets and fill in every field marked `REQUIRED`.

   ```bash
   cp kit/theme-package.yaml my-brand/theme-package.yaml
   ```

2. **Validate.** Run the script in `--render-only` mode. It checks the package, renders the Helm values into a temporary directory, and does not contact the cluster.

   ```bash
   kit/apply-theme --render-only my-brand/theme-package.yaml my-brand/assets
   ```

3. **Apply.** Run the script without `--render-only` to upgrade the releases and restart the UI and API deployments. For the Keycloak steps, see [Keycloak Login Page and Emails](#keycloak-login-page-and-emails).

   ```bash
   kit/apply-theme --namespace codemie \
     --chart-ui <repository>/codemie-ui --chart-codemie <repository>/codemie \
     my-brand/theme-package.yaml my-brand/assets
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

File names in the package are resolved relative to the assets directory passed to the script.

### 2. Fill in the theme package

Edit the copy of `theme-package.yaml`. Every field is described in the [Theme Package Reference](./package-reference.md). The main sections are:

- `product` — the product name and short name shown in the browser tab and UI headers.
- `colors` — semantic tokens such as `surface.base.primary`, each with a `dark` and a `light` value in `#rrggbb` format. Tokens that are not listed keep the default values.
- `typography` — CSS font families for UI text, prose, and code. Optionally add `fontFaceCSS` with inline `@font-face` rules.
- `assets` — the file names from the previous step.
- `links` — the name and URL of each help link shown in the UI. Include every link that is enabled in the `customer-config.yaml` file of the deployment; see [Customer Feature Configuration](../codemie/customer-feature-configuration.md).

A complete, valid package for the fictional brand "Acme Corp" is available in `kit/examples/acme/`.

```yaml
version: '1'

product:
  name: 'Acme Corp AI Platform'
  shortName: 'Acme'

colors:
  surface.base.primary:
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
3. Every link that is enabled in `customer-config.yaml` must be present in the package. Pass the file with `--customer-config <file>`, or set `CUSTOMER_CONFIG_PATH`; without either, the script looks for `/app/config/customer/customer-config.yaml` and `/etc/codemie/customer-config.yaml`. If no file is found the script prints a warning that this check was **skipped**. To export the file from a running cluster, use `kubectl get configmap codemie-customer-config -n <namespace> -o 'jsonpath={.data.customer-config\.yaml}'`.
4. Asset file names must be plain file names (letters, digits, `.`, `_`, `-`), unique, not symbolic links, and together smaller than the 1 MiB ConfigMap limit once base64-encoded.
5. If the package has an `email` block, its palette colors must be `#RRGGBB`, `senderName` and every `subject` must not be blank, only the allowed `{...}` tokens may be used, and `email.images.logo` must be a plain file name with a `png`, `jpg`, `jpeg` or `gif` extension. The file must exist, must not be a symbolic link, must be at most 262144 bytes, and its content must match its extension. See [Email](./package-reference.md#email) for all rules.
6. If the package has a `keycloak` block and `--no-keycloak` is not set, the Keycloak checks of the [Keycloak section](#keycloak-login-page-and-emails) apply as well.

If any check fails, the script prints every problem it found and exits with a non-zero code without writing output. Otherwise it writes three files to the output directory (a temporary directory when `--output-dir` is not set). With an active `keycloak` block, two more files are written:

| File                             | Content                                                                                    |
| -------------------------------- | ------------------------------------------------------------------------------------------ |
| `brand.css`                      | CSS custom properties for typography and colors, preceded by `fontFaceCSS`                 |
| `values-codemie-ui.brand.yaml`   | Helm values overlay for the UI release: product names, base64-encoded assets, `brand.css`  |
| `values-codemie.brand.yaml`      | Helm values overlay for the API release: the help links shown in the UI and how they mount |
| `values-keycloak.theme.yaml`     | Keycloak block only: Helm values overlay with the child login and email theme              |
| `values-oauth2-proxy.realm.yaml` | Keycloak block only: Helm values overlay with the realm display name, themes, and SMTP     |

The API overlay adds the `codemie-brand` ConfigMap to `extraObjects`. The ConfigMap holds `brand.yaml` (product name, help links and the optional `email` block) and, when the package names an email logo, the logo file as binary data. The same `codemie-brand` volume is mounted twice through `extraVolumes` and `extraVolumeMounts`: the file `brand.yaml` at `/etc/codemie/brand.yaml`, and the whole volume, read-only, at `/etc/codemie/brand-assets`, where the platform reads the email logo. Re-running the kit on values from an earlier kit version adds the second mount; a second run changes nothing. Because Helm replaces these three lists wholesale, the script appends to the lists of the running release instead of overwriting them: when applying, it reads them with `helm get values --all`. When only rendering, pass the current values with `--codemie-values <file>` (`helm get values <release> --all -o yaml > current.yaml`); without that file the script warns that the rendered lists would replace the existing ones.

Both overlays carry the same `checksum/brand` pod annotation. It is computed from the package and from the content of every asset file, including the email logo. A changed package or image therefore always triggers a new rollout. Because one checksum serves both releases, a change to the email logo alone also restarts the UI pods.

Review `brand.css` and the two values files before applying, especially when the kit runs for the first time.

### 4. Apply to the cluster

```bash
kit/apply-theme \
  --namespace codemie \
  --release-ui codemie-ui \
  --release-codemie codemie \
  --chart-ui <repository>/codemie-ui \
  --chart-codemie <repository>/codemie \
  --customer-config customer-config.yaml \
  my-brand/theme-package.yaml my-brand/assets
```

After validation and rendering, the script:

1. Runs `helm upgrade --reuse-values` for the UI release with `values-codemie-ui.brand.yaml`.
2. Runs `helm upgrade --reuse-values` for the API release with `values-codemie.brand.yaml`.
3. With an active `keycloak` block, runs `helm upgrade --reuse-values --wait` for the Keycloak release and then `helm upgrade --reuse-values` for the oauth2-proxy release. See [Keycloak Login Page and Emails](#keycloak-login-page-and-emails).
4. Restarts the UI and API deployments and waits for the rollouts to finish. The API restart is what makes the platform read a changed email block or logo. The Keycloak release is not restarted by the script.

The script always reuses the values of the running releases. It never sets the image tag, and it pins `--version` to the chart version that is currently installed (read with `helm get metadata`, which needs Helm 3.9 or later), so applying a theme never changes which version of any release is running. For a local chart path the chart's own version applies and no `--version` is passed; use the chart that matches the installed release.

| Option                          | Default               | Description                                                                   |
| ------------------------------- | --------------------- | ----------------------------------------------------------------------------- |
| `--render-only`                 | off                   | Validate and render only; make no cluster changes                             |
| `--namespace <ns>`              | `default`             | Namespace of the UI and API Helm releases                                     |
| `--release-ui <name>`           | `codemie-ui`          | Helm release name of the UI chart                                             |
| `--release-codemie <name>`      | `codemie`             | Helm release name of the API chart                                            |
| `--chart-ui <ref>`              | none                  | Chart reference of the UI release; required unless `--render-only`            |
| `--chart-codemie <ref>`         | none                  | Chart reference of the API release; required unless `--render-only`           |
| `--customer-config <file>`      | see validation step 3 | `customer-config.yaml` used for the enabled-link check                        |
| `--codemie-values <file>`       | read from the cluster | Current API release values to merge the list values into (render only)        |
| `--no-keycloak`                 | off                   | Skip the Keycloak steps for this run, even if the package has the block       |
| `--chart-keycloak <ref>`        | none                  | Chart reference of the Keycloak release; required to apply with the block     |
| `--chart-proxy <ref>`           | none                  | Chart reference of the oauth2-proxy release; required to apply with the block |
| `--release-keycloak <name>`     | `keycloak`            | Helm release name of the Keycloak chart                                       |
| `--release-proxy <name>`        | `oauth2-proxy`        | Helm release name of the oauth2-proxy chart                                   |
| `--namespace-keycloak <ns>`     | `security`            | Namespace of the Keycloak release; `--namespace` does not apply               |
| `--namespace-proxy <ns>`        | `oauth2-proxy`        | Namespace of the oauth2-proxy release; `--namespace` does not apply           |
| `--keycloak-timeout <duration>` | `10m`                 | Wait time of the Keycloak upgrade (`helm --wait --timeout`)                   |
| `--output-dir <dir>`            | temp directory        | Directory for the rendered files                                              |

### 5. Verify in the browser

Reload the platform in a private browser window and confirm the product name in the tab, the logos on the light and dark themes, the favicon, and the help links in the UI.

## Use in a Pipeline

The `--render-only` mode is designed for pipelines: it needs no cluster access, exits non-zero on any validation error, and leaves the rendered files in `--output-dir` so a later job can archive or review them. A typical pipeline runs a validation job on every change to the theme package and a separate, manually triggered job that applies it.

The kit ships an example GitHub Actions workflow in `kit/.github/workflows/apply-theme.yml`. The workflow is triggered manually (`workflow_dispatch`) and has two jobs:

- `validate` runs `apply-theme --render-only` against the package and assets paths that are provided as inputs and keeps the rendered files as a workflow artifact for review.
- `apply` runs only when `validate` succeeds and the reviewers of the `white-label-apply` environment approve it. It writes a kubeconfig from the `KUBECONFIG_DATA` repository secret, exports the running `customer-config.yaml`, runs `apply-theme`, and finishes with a smoke check: both rollouts are complete, `config.js` carries the product name, and `brand.css` and the dark logo are served.

Copy the workflow into the target repository, create the `white-label-apply` environment with required reviewers, store the base64-encoded kubeconfig of a service account with limited rights as the `KUBECONFIG_DATA` secret, and replace the pinned action versions with the current releases when the file is adopted. For other CI systems, run the same sequence: `apply-theme --render-only` first, then `apply-theme` without the flag, then check that the UI serves `/brand.css`.

## Email Branding and Defaults

The optional `email` block brands the emails that the platform sends: account verification, password reset and the budget notifications. A package without the block is valid, and the platform sends emails with neutral wording. Add the block only for the items that must change.

The platform defaults are:

| Item          | Default                                                                                     |
| ------------- | ------------------------------------------------------------------------------------------- |
| `senderName`  | `Platform Notifications`                                                                    |
| `productName` | `Platform` (the kit sets it to `product.name`)                                              |
| `signature`   | `The {productName} Team`                                                                    |
| Message texts | Neutral copy. For example, the verification subject is `Verify your {productName} account`. |

The sender name is chosen in this order: `email.senderName` from the brand, then the `EMAIL_FROM_NAME` environment variable, then `Platform Notifications`.

The email colors are an explicit palette. The kit does not derive them from `colors`. To map them by hand, follow the guidance in [Email Palette](./package-reference.md#email-palette). Omitted roles keep the platform defaults.

:::warning Release note
The default of `EMAIL_FROM_NAME` changes from `CodeMie` to empty, and the email wording is neutral. A deployment that relies on the old default must set `EMAIL_FROM_NAME` or `email.senderName`, or its emails show the sender `Platform Notifications`.
:::

## Keycloak Login Page and Emails

The optional top-level `keycloak` block extends the brand to Keycloak. A package without the block behaves exactly as before: no extra output file, no extra Helm call.

### What is delivered

- A Keycloak child theme named by `keycloak.themeName`, with a login part and an email part. It extends the vendor parent theme `codemie`. The login part carries the product name, the light and dark logos, the favicons, and `brand.css` (copied unchanged). The email part carries the product name and the email palette, signature, and logo URL.
- The realm settings: the display name (`product.name`), the login theme, the email theme, and, when `keycloak.smtp` is a full block, the SMTP connection.
- Nothing else. The kit never sets `extraVolumes` or `extraVolumeMounts`, and it never changes a chart version or an image tag.

The block is configured as follows. The theme name has 3 to 40 characters of `a-z`, `0-9` and `-`, and must not be `codemie`, `base` or `keycloak`.

```yaml
keycloak:
  themeName: 'acme-brand'
  smtp:
    host: 'smtp.acme.example'
    port: 587
    from: 'no-reply@acme.example'
    ssl: false
    starttls: true
    auth:
      username:
        secretKeyRef:
          name: 'acme-smtp'
          key: 'username'
      password:
        secretKeyRef:
          name: 'acme-smtp'
          key: 'password'

email:
  images:
    logoUrl: 'https://static.acme.example/logo.png'
```

The values that Keycloak emails use come from the existing fields: `product.name`, `product.shortName`, the four image assets, `brand.css`, `email.palette`, `email.signature`, and `email.senderName`. The new fields are `keycloak.themeName`, `keycloak.smtp`, and `email.images.logoUrl`. The logo URL is an absolute `https://` URL of a PNG, JPG, or GIF file (SVG is rejected), because mail clients do not load a logo from the cluster. Without `logoUrl`, the mail shows the product name as text. If only `email.images.logo` is set, the script warns that Keycloak mails do not use it.

SMTP credentials are accepted only as `secretKeyRef` entries that point to an existing Kubernetes Secret. A literal username or password is a validation error. The kit does not create Secrets.

### Validation rules

In addition to the general checks, an active block is checked as follows. All problems are listed at once, and nothing is written when any check fails:

- `keycloak.themeName` is required and follows the naming rule above.
- `assets.logoLight` and `assets.logoDark` are required.
- `product.name`, `product.shortName`, `email.signature`, the palette values, and `email.images.logoUrl` must not contain `${`, `<`, `>`, `"` or a backslash, control characters, or leading or trailing whitespace. Only `email.signature` may contain line breaks.
- `keycloak.smtp.host` and `keycloak.smtp.from` are set together or not at all.
- The rendered `brand.css` is not empty.
- The theme content must stay within 400000 bytes: the base64 size of the four assets plus `brand.css`. Above 300000 bytes the script prints a warning, because the Helm release Secret has a limit of 1 MiB and stores the content twice.

:::warning Size limit
Above 400000 bytes the script stops with an error. Reduce the assets (for example, use smaller or optimized images), or deliver the theme as a JAR file that is installed in the Keycloak image instead of the ConfigMap path. The kit does not build or publish a theme image or JAR.
:::

### Prerequisites for the Keycloak steps

:::warning Release order
The order of a rollout is fixed: first release the Keycloak image that contains the vendor parent theme `codemie`, then deploy the Keycloak and oauth2-proxy charts that support the child theme, and only then run `apply-theme`. The parent theme must stay installed in Keycloak. When it is removed, the child theme has nothing to extend and the login page breaks.
:::

The Keycloak release must already carry the child theme hook, which the normal chart deployment adds to its volumes and volume mounts (the marker `keycloak-child-theme`). The script checks this before it changes anything.

### Steps

1. Add the `keycloak` block, and `email.images.logoUrl` if the mails must show a logo, to `theme-package.yaml`.
2. Validate and render without cluster access:

   ```bash
   kit/apply-theme --render-only --output-dir ./rendered my-brand/theme-package.yaml my-brand/assets
   ```

3. Check `values-keycloak.theme.yaml` and `values-oauth2-proxy.realm.yaml` in the output directory.
4. Apply. The Keycloak flags have their own namespace defaults (`security` and `oauth2-proxy`), so `--namespace` is not used for them:

   ```bash
   kit/apply-theme \
     --namespace codemie \
     --chart-ui <repository>/codemie-ui --chart-codemie <repository>/codemie \
     --chart-keycloak <repository>/keycloak-helm --chart-proxy <repository>/oauth2-proxy \
     --customer-config customer-config.yaml \
     my-brand/theme-package.yaml my-brand/assets
   ```

The script validates everything first, renders, and then runs a read-only preflight that also reads the chart versions of all four releases. Only then does it upgrade the releases, in this order: UI, API, Keycloak, and oauth2-proxy. The Keycloak upgrade uses `--reuse-values`, the pinned chart version, and `--wait --timeout` (default `10m`). Keys of the stored child theme that the new package no longer has are set to `null` through a second values file (`values-keycloak.stale.yaml`, written in apply mode only), so removed assets leave the ConfigMap.

If the preflight finds no `keycloak-child-theme` entry in the volumes or volume mounts of the Keycloak release, the script stops before any upgrade and prints that the normal chart deployment of the Keycloak release must be run once first. To skip the Keycloak steps for a single run, pass `--no-keycloak`.

If the Keycloak upgrade fails or the `--wait` times out, the UI and API releases are already upgraded and the deployments are not yet restarted. Fix the cause, then run `apply-theme` again: every step is repeatable. The oauth2-proxy upgrade and the restarts run only when the Keycloak upgrade succeeds.

:::warning Sender name
`email.senderName` reaches Keycloak only as part of a full SMTP block (`host` and `from`). Without the block, the script warns, and Keycloak keeps its own sender. Without a full SMTP block, the realm file sets every SMTP key to `null`, so settings of an earlier run are removed.
:::

:::warning A full chart redeploy resets the brand
A full deployment with `helm-charts.sh` (or any `helm upgrade` without `--reuse-values`) sets the Keycloak and oauth2-proxy values back to the chart defaults, and the brand disappears. Run `apply-theme` again after each such deployment.
:::

### Check after apply

The realm reconcile is asynchronous. A successful `helm upgrade` shows that the values were accepted, not that Keycloak already uses them. Wait for the Keycloak pods and the realm operator to finish, then verify:

```bash
kubectl get pods -n security
helm get values keycloak -n security --all -o yaml | grep -A3 childTheme
```

Then open the login page in a private browser window and confirm the product name, the logos, and the colors. Trigger a test email (for example, a password reset) to check the sender name and the email logo.

### Use render-only output in a custom pipeline

When Helm releases are managed by another tool, `--render-only` makes the two Keycloak value files without a cluster read. The files are applied with the pipeline's own Helm call, on top of the current values:

```bash
kit/apply-theme --render-only --output-dir ./rendered my-brand/theme-package.yaml my-brand/assets

# read the installed chart version of each release first
helm get metadata keycloak -n security -o yaml | yq eval '.version' -

helm upgrade keycloak <repository>/keycloak-helm -n security \
  --reuse-values --version <installed-chart-version> \
  -f ./rendered/values-keycloak.theme.yaml --wait --timeout 10m

helm get metadata oauth2-proxy -n oauth2-proxy -o yaml | yq eval '.version' -

helm upgrade oauth2-proxy <repository>/oauth2-proxy -n oauth2-proxy \
  --reuse-values --version <installed-chart-version> \
  -f ./rendered/values-oauth2-proxy.realm.yaml
```

The rendered theme file never contains `null` values, so keys of an earlier run are not removed by this call. To remove a key, a pipeline passes one more values file that sets it to `null`, after the theme file. The same applies to keys under `data` and under `binaryData`:

```yaml
keycloakx:
  childTheme:
    binaryData:
      img.old-logo.svg: null
```

The same rule applies to optional SMTP keys: the realm file writes unset optional keys as `null`, so no extra step is needed for them.

## Limits and Out-of-Scope Items

- **Asset size.** The five asset files are delivered as base64-encoded ConfigMap data. Keep the combined size of the assets below 1 MiB. The Keycloak theme has its own limit of 400000 bytes; see [Keycloak Login Page and Emails](#keycloak-login-page-and-emails).
- **No font binaries.** Font files are not delivered through the kit. Reference fonts by URL in `typography.fontFaceCSS`, for example `@font-face { font-family: 'Inter'; src: url('https://fonts.acme.example/inter.woff2'); }`, and make sure the URL is reachable from the browsers of users.
- **Variables only.** `brand.css` sets CSS custom properties: every color token is written twice: its `dark` value under `html.codemieDark` and its `light` value under `html.codemieLight`. The two values always travel as a pair, so the brand follows the user's theme switch. Font variables are written in `:root`. The kit does not change component styles or class names.
- **Load order.** The UI adds the favicon, manifest, page title and `brand.css` link when the page starts, so the default title may flash briefly before the brand title appears.
- **Per-user appearance.** The user-level custom appearance settings are not touched by the kit and continue to work as before.
- **Not covered.** The gradient background images on authentication pages and the default AI avatar image (`ai-avatar.png`) are not part of the theme package and keep their default look. The authentication and error pages do show the brand logo.
- **Default versions.** The kit never changes the chart version or the image tag of any release it upgrades, including the Keycloak and oauth2-proxy releases. It does not build or change the Keycloak parent theme image.
- **Keycloak scope.** Only the login and email themes are branded. The account console, locales, and per-mail texts are not part of the kit.
- **Sub-path hosting.** Brand asset URLs follow the base path the UI was built with, so they work with a sub-path deployment of the UI.

## Troubleshooting

| Symptom                                                                                  | Cause and fix                                                                                                                                                                                              |
| ---------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `validation failed` with a list of schema errors                                         | A required field is missing or malformed. Compare the package with the [Theme Package Reference](./package-reference.md).                                                                                  |
| `assets.<name>: file not found`                                                          | The file name in `assets` does not match a file in the assets directory.                                                                                                                                   |
| `links.<id>: enabled in customer-config but absent from package`                         | Add the link to the package, or disable the component in `customer-config.yaml`.                                                                                                                           |
| `--chart-ui is required`                                                                 | Pass the chart reference of each release, for example `<repository>/codemie-ui`.                                                                                                                           |
| `cannot read the installed chart version`                                                | Upgrade Helm to 3.9 or later, and check the release name and namespace.                                                                                                                                    |
| Brand disappears after a platform upgrade                                                | The upgrade ran without `--reuse-values`. Re-run `apply-theme`.                                                                                                                                            |
| `release ... has no keycloak-child-theme entry in extraVolumes` (or `extraVolumeMounts`) | The Keycloak release does not carry the child theme hook. Run the normal chart deployment of the Keycloak release once, then run `apply-theme` again. Nothing was changed.                                 |
| `keycloak: theme assets and brand.css take ... bytes, above the limit of 400000 bytes`   | Shrink the four theme assets, or ship the theme as a JAR file instead.                                                                                                                                     |
| `<field>: must not contain ${`                                                           | The named value (for example `product.name` or `keycloak.themeName`) holds a character that is not allowed in a Keycloak properties file. Remove `${`, `<`, `>`, `"`, backslashes, and control characters. |
| `--chart-keycloak is required unless --render-only or --no-keycloak is set`              | Pass `--chart-keycloak` and `--chart-proxy`, or pass `--no-keycloak`.                                                                                                                                      |
| Theme is applied but the login page is unchanged                                         | The realm reconcile is asynchronous, or the parent theme `codemie` is missing in the Keycloak image. Wait, check the pods, and see [Check after apply](#check-after-apply).                                |
| `email.palette.<role>`, `email.senderName` or another `email.` path in the error list    | Fix the named field. The error lists every problem at once; see [Email](./package-reference.md#email).                                                                                                     |
| `email.images.logo: ...`                                                                 | The logo name, extension, size or content is wrong. Use a plain file name of a PNG, JPEG or GIF file of at most 256 KiB, and make sure the content matches the extension.                                  |
| Emails still show the old sender or logo                                                 | The API deployment was not restarted, or the logo name is unchanged and the file was not replaced in the assets directory. Re-run `apply-theme`.                                                           |
| Browser still shows the old logo                                                         | Hard-reload the page or clear the browser cache; the deployments were restarted but the browser may cache static files.                                                                                    |

## Kit Versions

The kit is versioned independently of the platform, and the `kitVersion` in the metadata of this page is the version it describes. The package `version` field must match the major version of the kit.

| Kit version                            | Package `version` | Required platform support                                                                                                                             |
| -------------------------------------- | ----------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------- |
| 1                                      | `'1'`             | The `brand` chart values and the links overlay.                                                                                                       |
| 1 (with the optional `email` block)    | `'1'`             | An email service that reads `brand.yaml` and the `brand-assets` directory.                                                                            |
| 1 (with the optional `keycloak` block) | `'1'`             | A Keycloak chart with the child theme hook, an oauth2-proxy chart with the realm values, and the vendor parent theme `codemie` in the Keycloak image. |

When the theme package contract changes, this table gains a row.

## Related Topics

- [Theme Package Reference](./package-reference.md)
- [Customer Feature Configuration](../codemie/customer-feature-configuration.md)
