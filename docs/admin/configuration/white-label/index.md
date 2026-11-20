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

The white-label theming kit presents AI/Run CodeMie under a customer brand. The brand is described in a single `theme-package.yaml` file: product name, colors, typography, logos, favicons, and help links. Two scripts validate the package and write the brand files into folders of the Helm charts. `apply-theme` writes the platform files. `apply-keycloak-theme` writes the Keycloak login and email theme. Neither script encodes base64, writes a values file, or calls a cluster. The DevOps engineer deploys the files with `helm-charts.sh`. No source change and no image rebuild are needed.

The kit is published in the documentation repository at [`docs/admin/configuration/white-label/kit`](https://github.com/codemie-ai/docs/tree/main/docs/admin/configuration/white-label/kit) and contains:

| File                                | Purpose                                                                      |
| ----------------------------------- | ---------------------------------------------------------------------------- |
| `apply-theme`                       | Script that validates a theme package and writes the platform brand files    |
| `apply-keycloak-theme`              | Script that validates a theme package and writes the Keycloak theme files    |
| `lib/common.sh`                     | Functions that both scripts share (do not run it)                            |
| `theme-package.schema.json`         | JSON Schema (draft-07) that defines the theme package contract               |
| `theme-package.yaml`                | Annotated template to copy and fill in. This is the only template to fill in |
| `theme-config.template.yaml`        | The same tokens, all commented out, for reference                            |
| `examples/acme/`                    | Complete example for the fictional brand "Acme Corp", including assets       |
| `.github/workflows/apply-theme.yml` | Example GitHub Actions workflow that prepares the files                      |
| `tests/`                            | Automated tests for the scripts (bats-core)                                  |

:::info Kit version
This page describes **kit version 1** (`kitVersion: "1"` in the page metadata), which works with theme packages that declare `version: '1'`. See [Kit Versions](#kit-versions) for the platform support that each kit feature requires.
:::

:::warning Breaking change
This version of the kit replaces the `apply-theme` of earlier versions, which wrote Helm values and upgraded the releases. The old options (`--render-only`, `--namespace`, `--chart-*` and others) are removed. See [Release Notes](#release-notes) for the items that need a change in existing deployments.
:::

## Prerequisites

Install the following tools on the machine, or in the pipeline runner, that executes the scripts:

| Tool                                                | Minimum version | Used for                                              |
| --------------------------------------------------- | --------------- | ----------------------------------------------------- |
| [yq](https://github.com/mikefarah/yq)               | 4               | Reading and converting the theme package YAML         |
| [ajv-cli](https://github.com/ajv-validator/ajv-cli) | 5               | Validating the package against the JSON Schema        |
| [bats-core](https://github.com/bats-core/bats-core) | 1.10            | Running the kit test suite (optional, kit developers) |

The deployment of the files uses `helm-charts.sh` of the charts repository (`codemie-helm-charts`). It needs the tools and the registry access that the normal deployment of the platform needs. The scripts of the kit need no cluster access.

## Working Directory

Both scripts write to paths relative to the current directory. Run them from the root of the charts repository, the folder that holds `codemie-ui/`, `keycloak-helm/` and `helm-charts.sh`. The defaults are:

| Option         | Default             | Meaning                                             |
| -------------- | ------------------- | --------------------------------------------------- |
| `--output-dir` | `codemie-ui/assets` | Assets folder of the `codemie-ui` wrapper chart     |
| `--chart-dir`  | `keycloak-helm`     | Keycloak chart folder (only `apply-keycloak-theme`) |

The kit itself can live anywhere, for example in `./kit`. The charts repository must be the current directory, or the options must point to its folders. A script stops when the parent folder of `--output-dir` or the folder `--chart-dir` does not exist.

## Steps

1. **Prepare the source folder.** Create a folder that holds the brand files named in the `assets` section of the package, and the email logo when the package has one:

   | Package field       | Typical file       | Notes                         |
   | ------------------- | ------------------ | ----------------------------- |
   | `assets.logoLight`  | `logo-light.svg`   | Logo shown on the light theme |
   | `assets.logoDark`   | `logo-dark.svg`    | Logo shown on the dark theme  |
   | `assets.favicon`    | `favicon.ico`      | Legacy browser icon           |
   | `assets.faviconSvg` | `favicon.svg`      | Vector browser icon           |
   | `assets.manifest`   | `site.webmanifest` | Web app manifest              |

   A file name starts with a letter or digit and has only letters, digits, `.`, `_` and `-`, at most 100 characters. A name such as `Logo Light.svg` is rejected.

2. **Fill in the template.** Copy `kit/theme-package.yaml` and fill in every field marked `REQUIRED`. Every field is described in the [Theme Package Reference](./package-reference.md). A complete package for the fictional brand "Acme Corp" is in `kit/examples/acme/`.

   ```bash
   cp kit/theme-package.yaml my-brand/theme-package.yaml
   ```

3. **Run `apply-theme`.** The first argument is the package. The second argument is the source folder of step 1.

   ```bash
   kit/apply-theme my-brand/theme-package.yaml my-brand/assets
   ```

4. **Check the files.** The script writes the files in the next section into `codemie-ui/assets`. Review `brand.css` and `brand-config.json`, especially at the first run.

5. **Enable the brand.** Set `branding.enabled: true` at the top level of the values file of the cloud, `codemie-ui/values-<cloud>.yaml`. The default is `false`: the chart ignores the folder and `NOTES.txt` says so.

6. **Deploy.** Run `helm-charts.sh` as for a normal deployment of the version, for example:

   ```bash
   ./helm-charts.sh --cloud <cloud> --version <version> --mode update
   ```

   Deploy the UI release before the API release. The API values mount the ConfigMap `codemie-brand-email`, which the UI release creates, and `helm-charts.sh` stops with the message "deploy the UI release first" when it is missing.

7. **Verify in the browser.** Reload the platform in a private browser window and confirm the product name in the tab, the logos on the light and dark themes, the favicon, and the help links.

A plain `helm upgrade` does not restart pods when only brand files changed. `helm-charts.sh` computes one hash over the files listed in `codemie-ui/brand-inputs.txt` (`assets/brand.css`, `assets/brand-config.json`, `assets/platform/*`, `assets/email/*`) and the value of `branding.enabled`. It passes the hash to the UI and to the API, so a change restarts both. A file that is not listed, for example `assets/keycloak`, does not change the hash.

### Files written by apply-theme

The script checks all inputs first and builds the files in a temporary folder next to the output folder. Only then does it replace the target paths. A failed check leaves an existing output unchanged.

| Path in `codemie-ui/assets` | Content                                                                                       |
| --------------------------- | --------------------------------------------------------------------------------------------- |
| `brand.css`                 | CSS custom properties for typography and colors, preceded by `fontFaceCSS`                    |
| `brand-config.json`         | Product name, short name, and the file names of the five assets (the shape that the UI reads) |
| `platform/*`                | The five asset files, copied unchanged                                                        |
| `email/brand.yaml`          | Product name, help links and the optional `email` block, read by the API                      |
| `email/<logo file>`         | The email logo, when the package names one                                                    |

The script replaces the content of `platform/` and `email/` (old files go) and keeps `.gitkeep`. It never touches `keycloak/`, `theme-config.template.yaml` or `keycloak-helm`. It writes no base64 data and no values file.

### Input checks

Each script runs the same input checks, in one function, and lists all problems at once. If any check fails, it exits with a non-zero code and writes nothing.

1. The removed tokens `email.senderName` and `keycloak.smtp` are reported by name, with the text that sends the reader to the realm settings. See [Release Notes](#release-notes).
2. The package is validated against `theme-package.schema.json`.
3. Every value that reaches a `.properties` file must not contain `${`, `<`, `>`, `"` or a backslash, control characters, or leading or trailing whitespace. Only `email.signature` may contain line breaks.
4. Every file named in `assets` and `email.images.logo` must exist in the source folder, must not be a symbolic link, and must have a plain file name that follows the rule of the charts.

Sizes, the type and content of the email logo, links, and the content of the theme files are not checked by the scripts. The charts check the size limits, and the test harness checks the content of the theme.

### Path guards

A script stops with a message when the parent folder of `--output-dir` does not exist, when the target folder or a path inside it is a symbolic link, or when an asset name points outside the source folder. A script replaces only the paths listed in this page, never a whole folder that the user named, and it keeps every file it does not own.

### Options

Options go before the two positional arguments. A script rejects any argument after `<source-dir>`, so an option at the end cannot be ignored by mistake.

| Option               | Script                                | Default             | Description                                             |
| -------------------- | ------------------------------------- | ------------------- | ------------------------------------------------------- |
| `--output-dir <dir>` | `apply-theme`, `apply-keycloak-theme` | `codemie-ui/assets` | Assets folder of the wrapper chart                      |
| `--chart-dir <dir>`  | `apply-keycloak-theme`                | `keycloak-helm`     | Keycloak chart folder; the script writes `theme/` in it |

## Customer Helm Repository

The filled-in `theme-package.yaml`, the source files, and the generated brand files belong in the customer's own Helm repository, next to the copy of the charts that the customer deploys. The kit template `theme-package.yaml` is the only template to fill in. The folder `codemie-ui/assets` of the charts repository holds `theme-config.template.yaml`, a copy of `kit/theme-config.template.yaml`. It is not read by any chart. Refresh the copy together with the kit template. The customer repository holds the filled copy, so each brand change is a reviewed commit. The documentation repository never holds a customer brand.

## Where the Product Name Appears

The value of `product.name` replaces "CodeMie" in the texts below. Names that contain `&` or `'`, for example `R&D's Hub`, show as plain text.

**Texts that follow the brand:**

- The first-time welcome message and the release popup.
- The title of the Help page and of the Help popup.
- The onboarding tours.
- The sign-in page, the login-success page, and the terms page.
- The SharePoint sign-in labels.
- The thought label in chat, written as `<product name> Thoughts`, for example "Acme Corp AI Platform Thoughts".
- The five platform emails.
- The Keycloak login title and heading.

**Texts that do not change:**

- Pre-built assistant templates, katas, and onboarding documents.
- Release notes.
- Assistants that users created.
- The support address `AskCodeMie@epam.com`.
- The default browser tab title, "EPAM AI/Run CodeMie", when no brand is set.
- Old chats. A chat keeps the thought label that was stored with it, so old chats show "CodeMie Thoughts" correctly. A chat that was stored under one brand is not re-labelled when the brand changes.

**Fallbacks and restart:**

- With no brand file, or with a blank product name, the thought label stays "CodeMie Thoughts" and UI texts keep "CodeMie".
- An invalid brand file makes the thought label fall back to "CodeMie Thoughts". Chats show no error.
- A product name of exactly `Platform`, which is the packaged email default, also gives "CodeMie Thoughts".
- The API reads the brand file once. A brand change on a running platform needs an API restart.

## Use in a Pipeline

The scripts need no cluster access, exit with a non-zero code on any input error, and write only files. A pipeline can therefore run them on every change to the theme package and keep the files for review.

The kit ships an example GitHub Actions workflow in `kit/.github/workflows/apply-theme.yml`. The workflow is triggered manually (`workflow_dispatch`). It runs `apply-theme`, runs `apply-keycloak-theme` when the `keycloak` input is set, and keeps the brand files and the names-only YAML as a workflow artifact. The workflow does not log in to a cluster, does not run Helm, and does not restart pods. The files are committed to the Helm repository and deployed with `helm-charts.sh`, as in [Steps](#steps).

Copy the workflow into the Helm repository of the customer, and replace the pinned action versions with the current releases when the file is adopted.

## Email Branding and Defaults

The optional `email` block brands the emails that the platform sends: account verification, password reset and the budget notifications. A package without the block is valid, and the platform sends emails with neutral wording. Add the block only for the items that must change.

The platform defaults are:

| Item          | Default                                                                                     |
| ------------- | ------------------------------------------------------------------------------------------- |
| Sender name   | `Platform Notifications`                                                                    |
| `productName` | `Platform` (the kit sets it to `product.name`)                                              |
| `signature`   | `The {productName} Team`                                                                    |
| Message texts | Neutral copy. For example, the verification subject is `Verify your {productName} account`. |

The sender name of platform emails comes from the `EMAIL_FROM_NAME` setting in the API values, or it is `Platform Notifications`. The theme package has no sender name token, and no script writes the sender name to `brand.yaml`.

The email colors are an explicit palette. The kit does not derive them from `colors`. To map them by hand, follow the guidance in [Email Palette](./package-reference.md#email-palette). Omitted roles keep the platform defaults.

The API reads `email/brand.yaml` and the email logo from the ConfigMap `codemie-brand-email`. The API values files mount it at `/etc/codemie/brand.yaml` and `/etc/codemie/brand-assets`. A brand change needs an API restart, which the hash of `helm-charts.sh` triggers.

## Keycloak Login Page and Emails

The Keycloak part of the brand is optional and has its own script, `apply-keycloak-theme`. `apply-theme` ignores the `keycloak` block of the package. The Keycloak script runs alone: it needs only the package, the source folder and the charts repository.

### What the script writes

The script writes the same files twice. `codemie-ui/assets/keycloak` is the written copy. `keycloak-helm/theme` is its mirror, the folder that the Keycloak chart reads. Only `apply-keycloak-theme` writes either of them, and both get the same bytes for these paths:

| Path in the theme folder        | Content                                                                     |
| ------------------------------- | --------------------------------------------------------------------------- |
| `login/theme.properties`        | Product name, short name, and the names of the logos and favicons           |
| `login/resources/css/brand.css` | The same `brand.css` as the platform file, byte for byte                    |
| `login/resources/img/<file>`    | The four image assets: `logoLight`, `logoDark`, `favicon` and `faviconSvg`  |
| `email/theme.properties`        | Product name, email palette, signature, and the logo URL of Keycloak emails |

The script replaces the files in `login/resources/img/` (old images go) and keeps `.gitkeep`. It keeps every other file, for example `email/messages/messages_en.properties`, which the script does not generate. The chart volume for that file is optional.

:::warning Edit the template, not the output
Edit only the package and the source folder, then run the script again. Never edit `assets/keycloak` or `theme/` by hand. Nothing stops a hand edit of `theme/`, and the next run replaces it.
:::

A change in the Keycloak files alone does not restart the UI pods, because `brand-inputs.txt` does not list `assets/keycloak`. `helm-charts.sh` hashes `keycloak-helm/theme` and sets the pod annotation for the Keycloak pod.

The script writes into `theme/` only. A deployment that sets another `childTheme.folder` in the Keycloak values must copy the files by hand. See [Limits](#limits).

### Configure the block

The block needs a theme name. The name has 3 to 40 characters of `a-z`, `0-9` and `-`, and must not be `codemie`, `codemie-default`, `base` or `keycloak`.

```yaml
keycloak:
  themeName: 'acme-brand'

email:
  images:
    logoUrl: 'https://static.acme.example/logo.png'
```

The values that Keycloak emails use come from the existing fields: `product.name`, `product.shortName`, the four image assets, `brand.css`, `email.palette` and `email.signature`. The new fields are `keycloak.themeName` and `email.images.logoUrl`. The logo URL is an absolute `https://` URL of a PNG, JPG or GIF file, because mail clients do not load a logo from the cluster. Without `logoUrl`, the mail shows the product name as text.

The SMTP connection and the sender name of Keycloak emails are not part of the package. They are set in the Keycloak realm settings.

### Steps for Keycloak

1. Add the `keycloak` block, and `email.images.logoUrl` if the mails must show a logo, to `theme-package.yaml`.
2. Run the script from the root of the charts repository:

   ```bash
   kit/apply-keycloak-theme my-brand/theme-package.yaml my-brand/assets
   ```

3. The script prints a YAML snippet on standard output and writes no file for it. The snippet holds the names only: `keycloakx.childTheme.images` (file names), `childTheme.name`, and `realm.themes.loginTheme` and `emailTheme` with the theme name. Paste the `keycloakx` part into `keycloak-helm/values-<cloud>.yaml` and the `realm` part into `oauth2-proxy/values-<cloud>.yaml`:

   ```yaml
   keycloakx:
     childTheme:
       enabled: true
       name: acme-brand
       images:
         - favicon.ico
         - favicon.svg
         - logo-dark.svg
         - logo-light.svg
   realm:
     themes:
       loginTheme: acme-brand
       emailTheme: acme-brand
   ```

   The chart fails the render when `images` differs from the image files in the theme folder, so paste the list again after each change of the image names.

4. Verify the theme name. The name in `keycloak-helm/values-<cloud>.yaml` (`keycloakx.childTheme.name`), the name in the `oauth2-proxy` values (`realm.themes.loginTheme` and `realm.themes.emailTheme`), and `keycloak.themeName` in the package must be equal. A typo in one place gives the default login page and no error.
5. Check the hook preflight below.
6. Deploy with `helm-charts.sh`, in this order: Keycloak first, wait for the rollout, then the oauth2-proxy release. A realm change does not restart a pod.

### Theme image

The child theme extends the vendor parent theme `codemie`, which is part of the Keycloak theme image. The image also holds the built-in theme `codemie-default`, which keeps the original CodeMie login look. The theme image is built and released separately from the kit, and the kit does not build or publish it.

:::warning Release order
First release the Keycloak image that contains the vendor themes `codemie` (parent) and `codemie-default`. Then deploy the Keycloak and oauth2-proxy charts that support the child theme. The parent theme must stay installed in Keycloak. When it is removed, the child theme has nothing to extend and the login page breaks. `codemie-default` exists only in the new image, so deploy the charts after the image.
:::

### Hook preflight

The Keycloak release must already carry the child theme hook. The hook is one line in each of the vendor `extraVolumes` and `extraVolumeMounts` strings, with the marker `keycloak-child-theme`. Check both strings before the deployment:

```bash
helm get values <keycloak-release> -o json
```

Both `keycloakx.extraVolumes` and `keycloakx.extraVolumeMounts` must contain `keycloak-child-theme`. If the marker is missing in one of them, run the normal chart deployment of the Keycloak release once. When `childTheme.enabled` is true and the hook is missing, the chart template fails.

### Size limit

The chart template fails when the theme folder holds more than 400000 characters (text plus base64 of the images). The scripts do not check this limit. Reduce the images (smaller or optimized files), or deliver the theme as a JAR file that is installed in the Keycloak image instead of the ConfigMap path.

### Restart behavior

A plain `helm upgrade` of the Keycloak release does not restart the pod, because the checksum annotation is set only by `helm-charts.sh`. A change in `theme/` rolls the single Keycloak replica when the annotation changes, and the login is unavailable for a short time. Use `helm-charts.sh` as the deploy path.

### Check after deployment

The realm reconcile is asynchronous. A successful deployment shows that the values were accepted, not that Keycloak already uses them. Wait for the Keycloak pods and the realm operator to finish, then verify:

```bash
kubectl get pods -n security
helm get values keycloak -n security -o yaml | grep -A6 childTheme
```

Then open the login page in a private browser window and confirm the product name, the logos, and the colors. Trigger a test email (for example, a password reset) to check the sender name and the email logo.

## Release Notes

This section lists the changes of this version for existing deployments. It stays on this page until the release notes page can take it.

- **Removed `brand.*` keys of the `codemie-ui` chart.** The brand now comes from the folder `codemie-ui/assets` of the wrapper chart. Remove the keys of the old kit from the customer values.
- **Removed objects of the old kit.** The old `apply-theme` wrote `extraObjects`, `extraVolumes` and `extraVolumeMounts` into the API values. Remove these entries, including the ConfigMap `codemie-brand` and the old mount of `/etc/codemie/brand.yaml`. `helm-charts.sh` stops when the API values mount `/etc/codemie/brand.yaml` twice.
- **Moved values files.** The files `codemie-ui/values-<cloud>.yaml` now hold the settings of the `codemie-ui` chart under the key `codemie-ui:`. An old flat values file fails the render, and the error names the key.
- **Removed `childTheme.data` and `childTheme.binaryData`.** The Keycloak theme files are in the folder `keycloak-helm/theme`. A value in either key makes the chart template fail.
- **Removed `email.senderName` and `keycloak.smtp`.** The sender name of platform emails comes from `EMAIL_FROM_NAME` in the API values, or it is `Platform Notifications`. The way to set the API sender name through `brand.yaml` is gone. The SMTP connection and the sender name of Keycloak emails are set in the Keycloak realm settings. A package that still has these tokens fails with a message that names the token.
- **New script names.** `apply-theme` writes the platform files. `apply-keycloak-theme` writes the Keycloak files. The old options are removed, and the scripts no longer deploy.

Move to `docs/admin/update/release-notes/release-notes.md` and remove here after the rebase.

## Limits

- **Asset size.** The scripts do not check sizes. A ConfigMap of the wrapper chart must stay below 1 MiB, and the release estimate of the files must stay below 1048576 bytes. The chart render fails above these limits and names the sizes. The release Secret size coefficient of that estimate is not measured on a stand.
- **Keycloak size.** The Keycloak theme folder is limited to 400000 characters; see [Size limit](#size-limit).
- **No font binaries.** Font files are not delivered through the kit. Reference fonts by URL in `typography.fontFaceCSS`, for example `@font-face { font-family: 'Inter'; src: url('https://fonts.acme.example/inter.woff2'); }`, and make sure the URL is reachable from the browsers of users.
- **Variables only.** `brand.css` sets CSS custom properties: every color token is written twice: its `dark` value under `html.codemieDark` and its `light` value under `html.codemieLight`. The two values always travel as a pair, so the brand follows the user's theme switch. Font variables are written in `:root`. The kit does not change component styles or class names.
- **Load order.** The UI adds the favicon, manifest, page title and `brand.css` link when the page starts, so the default title may flash briefly before the brand title appears.
- **Per-user appearance.** The user-level custom appearance settings are not touched by the kit and continue to work as before.
- **Not covered.** The gradient background images on authentication pages and the default AI avatar image (`ai-avatar.png`) are not part of the theme package and keep their default look. The authentication and error pages do show the brand logo.
- **API sender name.** No script path sets the API sender name of platform emails; see [Email Branding and Defaults](#email-branding-and-defaults).
- **Keycloak scope.** Only the login and email themes are branded. The account console, locales, and per-mail texts are not part of the kit.
- **Another theme folder.** `apply-keycloak-theme` writes only to `keycloak-helm/theme`. A deployment that sets another `keycloakx.childTheme.folder` copies the files by hand.
- **Registry pull.** `helm-charts.sh` pulls the registry chart with `helm pull --version ${ai_run_version}`. This flow is proven only by a test with a stub, not by a deployment.
- **First upgrade.** The first `helm upgrade` of an existing `codemie-ui` release with the wrapper chart is not checked for object ownership errors. Check it on a stand first.
- **Chart under test.** The names tests ran against the unreleased chart of the first change, not against a released chart.
- **Redeploy.** `helm-charts.sh` does not use `--reuse-values`. A full deployment resets values that were set outside the values files. Keep the brand in the files of the Helm repository so that each deployment applies it again.
- **Sub-path hosting.** Brand asset URLs follow the base path the UI was built with, so they work with a sub-path deployment of the UI.

## Troubleshooting

| Symptom                                                                            | Cause and fix                                                                                                                                                                                                                       |
| ---------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `validation failed` with a list of schema errors                                   | A required field is missing or malformed. Compare the package with the [Theme Package Reference](./package-reference.md).                                                                                                           |
| `assets.<name>: file not found`                                                    | The file name in `assets` does not match a file in the source folder.                                                                                                                                                               |
| `assets.<name>: invalid file name`                                                 | The name breaks the rule of the charts, for example it has a space. Rename the file and the package field.                                                                                                                          |
| `email.senderName is removed` or `keycloak.smtp is removed`                        | Delete the token from the package. Set the sender name and the SMTP connection of Keycloak in the realm settings. The API sender name comes from `EMAIL_FROM_NAME`.                                                                 |
| `parent folder does not exist`                                                     | The script was not run from the root of the charts repository. Change to that folder, or pass `--output-dir` and `--chart-dir`.                                                                                                     |
| `is a symbolic link; refusing to write through it`                                 | A target folder or file is a symbolic link. Replace it with a real folder or file.                                                                                                                                                  |
| `<field>: must not contain ${`                                                     | The named value holds a character that is not allowed in a properties file. Remove `${`, `<`, `>`, `"`, backslashes, and control characters.                                                                                        |
| `keycloak.themeName: required`                                                     | `apply-keycloak-theme` needs the `keycloak` block with a theme name.                                                                                                                                                                |
| The render fails with `childTheme.images ... differs from the image files`         | Paste the `images` list that `apply-keycloak-theme` printed into the Keycloak values again.                                                                                                                                         |
| The render fails with `keycloakx.extraVolumes lacks the keycloak-child-theme hook` | The Keycloak release does not carry the child theme hook. Run the normal chart deployment of the Keycloak release once. See [Hook preflight](#hook-preflight).                                                                      |
| `deploy the UI release first`                                                      | `helm-charts.sh` found no `codemie-brand-email` ConfigMap. Deploy the UI release before the API release.                                                                                                                            |
| The deployment shows the default brand                                             | `branding.enabled` is `false` or the files are not in `codemie-ui/assets`. See [Steps](#steps).                                                                                                                                     |
| Theme is deployed but the login page is unchanged                                  | The realm reconcile is asynchronous, the theme names differ between the files, or the parent theme `codemie` is missing in the Keycloak image. Check the names and the pods; see [Check after deployment](#check-after-deployment). |
| Emails still show the old logo                                                     | The API pods were not restarted, or the logo name is unchanged and the file was not replaced in the source folder. Run the script again and deploy with `helm-charts.sh`.                                                           |
| Browser still shows the old logo                                                   | Hard-reload the page or clear the browser cache; the deployments were restarted but the browser may cache static files.                                                                                                             |

## Kit Versions

The kit is versioned independently of the platform, and the `kitVersion` in the metadata of this page is the version it describes. The package `version` field must match the major version of the kit.

| Kit version                            | Package `version` | Required platform support                                                                                                                                                                           |
| -------------------------------------- | ----------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| 1                                      | `'1'`             | The `codemie-ui` wrapper chart with the folder `assets` and `branding.enabled`.                                                                                                                     |
| 1 (with the optional `email` block)    | `'1'`             | An email service that reads `brand.yaml` and the `brand-assets` directory.                                                                                                                          |
| 1 (with the optional `keycloak` block) | `'1'`             | A Keycloak chart that reads the folder `theme` with the child theme hook, an oauth2-proxy chart with the realm values, and the vendor themes `codemie` and `codemie-default` in the Keycloak image. |

When the theme package contract changes, this table gains a row.

## Related Topics

- [Theme Package Reference](./package-reference.md)
- [API Configuration](../codemie/api-configuration.md)
