---
id: white-label-overview
title: White-Label Theming Kit
sidebar_label: White-Label Theming
sidebar_position: 1
description: Apply a custom product name, logos, colors, fonts, and help links to AI/Run CodeMie with two theme packages, without rebuilding any image
kitVersion: '1'
pagination_prev: admin/configuration/index
pagination_next: null
---

# White-Label Theming Kit

The white-label theming kit presents AI/Run CodeMie under a customer brand. The brand is described in two independent packages. `theme-package.yaml` is the UI package: product name, colors, typography, logos, favicons, help links, and the platform email brand. `keycloak-theme-package.yaml` is the Keycloak package: the Keycloak login and email theme. The two packages share no file. A deployment can use the UI package alone, the Keycloak package alone, or both.

Two scripts validate the packages and write files. `apply-theme` writes the platform files into a folder of the Helm charts. `apply-keycloak-theme` writes a Keycloak theme folder to any path, and on request a theme jar and a mirror in the Keycloak chart. Neither script encodes base64, writes a values file, or calls a cluster. The DevOps engineer deploys the files with `helm-charts.sh`. No source change and no image rebuild are needed.

The kit is published in the documentation repository at [`docs/admin/configuration/white-label/kit`](https://github.com/codemie-ai/docs/tree/main/docs/admin/configuration/white-label/kit) and contains:

| File                                  | Purpose                                                                                                                                                           |
| ------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `apply-theme`                         | Script that validates the UI package and writes the platform brand files                                                                                          |
| `apply-keycloak-theme`                | Script that validates the Keycloak package and writes the Keycloak theme files                                                                                    |
| `lib/common.sh`                       | Functions that both scripts share (do not run it)                                                                                                                 |
| `theme-package.schema.json`           | JSON Schema (draft-07) of the UI package                                                                                                                          |
| `keycloak-theme-package.schema.json`  | JSON Schema (draft-07) of the Keycloak package                                                                                                                    |
| `theme-package.yaml`                  | Annotated template of the UI package. Copy it and fill it in                                                                                                      |
| `keycloak-theme-package.yaml`         | Annotated template of the Keycloak package. Copy it and fill it in                                                                                                |
| `theme-config.template.yaml`          | The tokens of the UI package, all commented out, for reference                                                                                                    |
| `keycloak-theme-config.template.yaml` | The tokens of the Keycloak package, all commented out, for reference                                                                                              |
| `examples/acme/`                      | Complete example for the fictional brand "Acme Corp": both packages and the assets                                                                                |
| `.github/workflows/apply-theme.yml`   | Example GitHub Actions workflow that prepares the files                                                                                                           |
| `tests/`                              | Automated tests for the scripts (bats-core)                                                                                                                       |
| `brand-inputs.txt`                    | Not part of the kit folder. The file is in `codemie-ui/` of the charts repository. It lists the paths that `helm-charts.sh` hashes to restart pods after a change |

:::info Kit version
This page describes **kit version 1** (`kitVersion: "1"` in the page metadata), which works with packages that declare `version: '1'`. See [Kit Versions](#kit-versions) for the platform support that each kit feature requires.
:::

:::warning Breaking change
This version of the kit replaces the `apply-theme` of earlier versions, which wrote Helm values and upgraded the releases. The old options (`--render-only`, `--namespace`, `--chart-*` and others) are removed. The `keycloak:` block moved from the UI package to the Keycloak package. See [Release Notes](#release-notes) for the items that need a change in existing deployments.
:::

## Prerequisites

Install the following tools on the machine, or in the pipeline runner, that executes the scripts:

| Tool                                                | Minimum version | Used for                                                       |
| --------------------------------------------------- | --------------- | -------------------------------------------------------------- |
| [yq](https://github.com/mikefarah/yq)               | 4               | Reading and converting the package YAML                        |
| [ajv-cli](https://github.com/ajv-validator/ajv-cli) | 5               | Validating the package against the JSON Schema                 |
| `zip`                                               | any             | Building the Keycloak jar. Needed only with the `--jar` option |
| [bats-core](https://github.com/bats-core/bats-core) | 1.10            | Running the kit test suite (optional, kit developers)          |

A manual install of the Keycloak theme in any Keycloak needs one more item: the `codemie-base` parent theme. The login theme of the kit has `parent=codemie-base`, and the jar does not carry the parent. The parent theme is part of the CodeMie Keycloak theme image, together with `codemie`, the theme with the original CodeMie look. Take it from the image of the platform release, and install it in the same Keycloak. The email theme of the kit also has `parent=codemie-base`. For the email theme, the theme `codemie-base` in the image must have the type `email`. The image 2.62.0 has only the type `login`. Use an image that includes the email parent theme of EPMCDME-15168. See [Install in any Keycloak](#install-in-any-keycloak).

The deployment of the files uses `helm-charts.sh` of the charts repository (`codemie-helm-charts`). It needs the tools and the registry access that the normal deployment of the platform needs. The scripts of the kit need no cluster access.

## Working Directory

Both scripts write to paths relative to the current directory. Run them from the root of the charts repository, the folder that holds `codemie-ui/`, `keycloak-helm/` and `helm-charts.sh`. The options are:

| Option         | Script                 | Default             | Meaning                                                                       |
| -------------- | ---------------------- | ------------------- | ----------------------------------------------------------------------------- |
| `--output-dir` | `apply-theme`          | `codemie-ui/assets` | Assets folder of the `codemie-ui` wrapper chart                               |
| `--output-dir` | `apply-keycloak-theme` | none (required)     | Folder that receives the Keycloak theme files. Any path                       |
| `--chart-dir`  | `apply-keycloak-theme` | none (optional)     | Keycloak chart folder. Only with this option does the script mirror and print |
| `--jar`        | `apply-keycloak-theme` | none (optional)     | File name of the Keycloak theme jar to write. Needs `zip`                     |

The kit itself can live anywhere, for example in `./kit`. For `apply-theme`, the charts repository must be the current directory, or `--output-dir` must point to its folder. `apply-theme` stops when the parent folder of `--output-dir` does not exist. `apply-keycloak-theme` creates `--output-dir` when it is missing. It stops when the folder named by `--chart-dir` does not exist.

## Steps

The steps below apply the UI package. For the Keycloak login page and emails, see [Keycloak Login Page and Emails](#keycloak-login-page-and-emails).

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

5. **Enable the brand.** Set `branding.enabled: true` under the key `codemie-ui:` in the values file of the cloud, `codemie-ui/values-<cloud>.yaml`. The default is `false`: the chart ignores the folder and `NOTES.txt` says so. Without this step the package has no effect.

6. **Deploy with `helm upgrade`.** Run `helm-charts.sh` as for a normal deployment of the version. It runs `helm upgrade` for each release, for example:

   ```bash
   ./helm-charts.sh --cloud <cloud> --version <version> --mode update
   ```

   Deploy the UI release before the API release. The API values mount the ConfigMap `codemie-brand-email`, which the UI release creates, and `helm-charts.sh` stops with the message "deploy the UI release first" when it is missing.

7. **Verify in the browser.** Reload the platform in a private browser window and confirm the product name in the tab, the logos on the light and dark themes, the favicon, and the help links.

A plain `helm upgrade` does not restart pods when only brand files changed. `helm-charts.sh` computes one hash over the files listed in `codemie-ui/brand-inputs.txt` (`assets/brand.css`, `assets/brand-config.json`, `assets/platform/*`, `assets/email/*`) and the value of `branding.enabled`. It passes the hash to the UI and to the API, so a change restarts both. A file that is not listed does not change the hash.

### Files written by apply-theme

The script checks all inputs first and builds the files in a temporary folder next to the output folder. Only then does it replace the target paths. A failed check leaves an existing output unchanged. The replacement itself is a series of renames, not one atomic step. If the process stops during it (a kill, a full disk), some targets can hold new files and others old files, and a folder `.kit-stage-*` or `.kit-old-*` can stay next to the output. Delete such folders and run the script again.

| Path in `codemie-ui/assets` | Content                                                                                       |
| --------------------------- | --------------------------------------------------------------------------------------------- |
| `brand.css`                 | CSS custom properties for typography and colors, preceded by `fontFaceCSS`                    |
| `brand-config.json`         | Product name, short name, and the file names of the five assets (the shape that the UI reads) |
| `platform/*`                | The five asset files, copied unchanged                                                        |
| `email/brand.yaml`          | Product name, help links and the optional `email` block, read by the API                      |
| `email/<logo file>`         | The email logo, when the package names one                                                    |

The script replaces the content of `platform/` and `email/` (old files go) and keeps `.gitkeep`. It never touches `theme-config.template.yaml` or the Keycloak folders. It writes no base64 data and no values file.

### Input checks

Both scripts run the same input checks and list all problems at once. If any check fails, the script exits with a non-zero code and writes nothing.

1. The removed tokens are reported by name. `email.senderName` and `smtp` have their own messages, and a `keycloak:` block in the Keycloak package is named as not a token there. A leftover `keycloak:` block in the UI package is reported with the text that it moved to `keycloak-theme-package.yaml`. See [Release Notes](#release-notes).
2. The package is validated against its own schema: `theme-package.schema.json` for `apply-theme`, `keycloak-theme-package.schema.json` for `apply-keycloak-theme`.
3. For `apply-keycloak-theme`, every value that reaches a `.properties` file must not contain `${`, `<`, `>`, `"` or a backslash, control characters, or leading or trailing whitespace. Only `email.signature` may contain line breaks. `apply-theme` writes no `.properties` file and skips this check.
4. Every file named in `assets` (and `email.images.logo` for `apply-theme`) must exist in the source folder, must not be a symbolic link, and must have a plain file name that follows the rule of the charts.

Sizes, the type and content of the email logo, links, and the content of the theme files are not checked by the scripts. The charts check the size limits, and the test harness checks the content of the theme.

### Path guards

A script stops with a message when a target folder or a path inside it is a symbolic link, or when an asset name points outside the source folder. `apply-theme` also stops when the parent folder of `--output-dir` does not exist. `apply-keycloak-theme` refuses `/`, `.`, `..`, the home folder, an empty value and a symbolic link as `--output-dir`.

Neither script replaces or deletes a folder that the user named. `apply-theme` replaces only the paths listed in this page. `apply-keycloak-theme` moves each file that it owns into `--output-dir`, and it keeps every other file there. The only whole-folder replacement is the `theme` folder inside `--chart-dir`, which the script owns.

### Options

Options go before the two positional arguments. A script rejects any argument after `<source-dir>`, so an option at the end cannot be ignored by mistake. See [Working Directory](#working-directory) for the options and their defaults.

## Customer Helm Repository

The two filled-in packages, the source files, and the generated brand files belong in the customer's own Helm repository, next to the copy of the charts that the customer deploys. The kit templates `theme-package.yaml` and `keycloak-theme-package.yaml` are the templates to fill in. The folder `codemie-ui/assets` of the charts repository holds `theme-config.template.yaml`, a copy of `kit/theme-config.template.yaml`. It is not read by any chart. Refresh the copy together with the kit template. The customer repository holds the filled copies, so each brand change is a reviewed commit. The documentation repository never holds a customer brand.

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

- With no brand file, the thought label stays "CodeMie Thoughts" and UI texts keep "CodeMie".
- An invalid brand file stops the API at start. The log has the line "Invalid brand configuration, aborting startup" and names the key, for example `email.messages.verification.subject: token {projectName} is not allowed here`. `apply-theme` rejects the values that the API refuses (a product name with only spaces, an unknown token in an email text, a wrong email logo). Fix the value, run the script again, and restart the API.
- A product name of exactly `Platform`, which is the packaged email default, also gives "CodeMie Thoughts".
- The API reads the brand file once. A brand change on a running platform needs an API restart.

## Use in a Pipeline

The scripts need no cluster access, exit with a non-zero code on any input error, and write only files. A pipeline can therefore run them on every change to a package and keep the files for review.

The kit ships an example GitHub Actions workflow in `kit/.github/workflows/apply-theme.yml`. The workflow is triggered manually (`workflow_dispatch`). It takes the path of each package as an input. It runs `apply-theme`. When the `keycloak` input is set, it runs `apply-keycloak-theme` with `--output-dir` and `--jar`. It keeps the brand files, the Keycloak theme folder and the jar as a workflow artifact. The workflow installs `zip`. The workflow does not log in to a cluster, does not run Helm, and does not restart pods. The files are committed to the Helm repository and deployed with `helm-charts.sh`, as in [Steps](#steps).

Copy the workflow into the Helm repository of the customer, and replace the pinned action versions with the current releases when the file is adopted.

## Email Branding and Defaults

The optional `email` block of the UI package brands the emails that the platform sends: account verification, password reset and the budget notifications. The `email` block of the Keycloak package brands the emails that Keycloak sends. A package without the block is valid, and the platform sends emails with neutral wording. Add the block only for the items that must change.

The platform defaults are:

| Item          | Default                                                                                     |
| ------------- | ------------------------------------------------------------------------------------------- |
| Sender name   | `Platform Notifications`                                                                    |
| `productName` | `Platform` (the kit sets it to `product.name`)                                              |
| `signature`   | `The {productName} Team`                                                                    |
| Message texts | Neutral copy. For example, the verification subject is `Verify your {productName} account`. |

The sender name of platform emails comes from the `EMAIL_FROM_NAME` setting in the API values, or it is `Platform Notifications`. The packages have no sender name token, and no script writes the sender name to `brand.yaml`.

The email colors are an explicit palette. The kit does not derive them from `colors`. To map them by hand, follow the guidance in [Email Palette](./package-reference.md#email-palette). Omitted roles keep the platform defaults.

The API reads `email/brand.yaml` and the email logo from the ConfigMap `codemie-brand-email`. The API values files mount it at `/etc/codemie/brand.yaml` and `/etc/codemie/brand-assets`. A brand change needs an API restart, which the hash of `helm-charts.sh` triggers.

## Keycloak Login Page and Emails

The Keycloak part of the brand has its own package, `keycloak-theme-package.yaml`, and its own script, `apply-keycloak-theme`. `apply-theme` never reads it. The Keycloak script runs alone: it needs only the Keycloak package and the source folder. It needs no charts repository unless `--chart-dir` is set. The Keycloak package is optional. A deployment without it keeps the default login page.

### The Keycloak package

The package has these tokens: `themeName`, `product.name`, `product.shortName`, `colors`, the four image assets (`assets.logoLight`, `assets.logoDark`, `assets.favicon`, `assets.faviconSvg`), and the optional `email` block (`palette`, `signature`, `images.logoUrl`). The package has no typography, no effects, no manifest and no links. The `colors` tokens are the same as in the UI package. The package is written on its own: values that both packages need, for example the product name, are entered in each. Copy `kit/keycloak-theme-package.yaml`, fill in every field marked `REQUIRED`, and see the [Keycloak Theme Package Reference](./keycloak-package-reference.md) for each field. A complete example is `kit/examples/acme/keycloak-theme-package.yaml`.

The theme name has 3 to 40 characters of `a-z`, `0-9` and `-`, and must not be `codemie`, `codemie-base`, `base` or `keycloak`.

```yaml
themeName: 'acme-brand'

email:
  images:
    logoUrl: 'https://static.acme.example/logo.png'
```

The logo URL is an absolute `https://` URL of a PNG, JPG or GIF file, because mail clients do not load a logo from the cluster. Without `logoUrl`, the mail shows the product name as text. The SMTP connection and the sender name of Keycloak emails are not part of the package. They are set in the Keycloak realm settings.

### Build the theme manually

Run the script with the package, the source folder and `--output-dir`. The option is required, and the folder can be at any path. The script creates the folder when it is missing.

```bash
kit/apply-keycloak-theme --output-dir my-brand/keycloak-theme \
  my-brand/keycloak-theme-package.yaml my-brand/assets
```

To write a jar as well, add `--jar` with a file name. The jar needs `zip`.

```bash
kit/apply-keycloak-theme --output-dir my-brand/keycloak-theme --jar my-brand/acme-brand.jar \
  my-brand/keycloak-theme-package.yaml my-brand/assets
```

At the end the script prints one line for each target that it wrote: the folder, the jar, and the mirror. The script runs all checks before it writes a file.

The folder holds these files:

| Path in the theme folder        | Content                                                                         |
| ------------------------------- | ------------------------------------------------------------------------------- |
| `login/theme.properties`        | Parent theme, product name, short name, and the names of the logos and favicons |
| `login/resources/css/brand.css` | CSS custom properties for the colors of the package                             |
| `login/resources/img/<file>`    | The four image assets: `logoLight`, `logoDark`, `favicon` and `faviconSvg`      |
| `email/theme.properties`        | Product name, email palette, signature, and the logo URL of Keycloak emails     |

The script moves only these files into `--output-dir`. It never replaces the folder, and it keeps every other file in it. A file from an earlier run with a different image name stays in the folder. Delete such a file by hand. The theme folder inside the jar has the same layout.

The jar has this layout. The manifest `META-INF/keycloak-themes.json` lists the theme name and the types `login` and `email`. The files are under `theme/<themeName>/login/` and `theme/<themeName>/email/`. Two runs give equal bytes on any machine: the script fixes the time zone to UTC, the file times and the file modes. The jar mode is 0644.

:::warning The jar holds only the files that the script writes
The script builds the jar from the files that it writes, not from the output folder. A custom file in the output folder, for example `email/messages/messages_en.properties`, is not in the jar. To ship such a file, add it to the jar by other means, or install the folder instead of the jar. The folder and the jar can come from different runs if one write fails. In that case the message tells to run the script again. Run it again before the install.
:::

:::warning Edit the package, not the output
Edit only the package and the source folder, then run the script again. A hand edit of a generated file is lost at the next run.
:::

### Install in any Keycloak

The jar installs in any Keycloak that has the `codemie-base` parent theme. The steps are:

1. Install the `codemie-base` parent theme in the same Keycloak. See [Prerequisites](#prerequisites).
2. Copy the jar into the `providers` folder of the Keycloak installation.
3. Rebuild Keycloak so that it registers the theme, and restart it:

   ```bash
   bin/kc.sh build
   ```

4. Select the theme per realm. See [Select the theme per realm](#select-the-theme-per-realm).

**Check the result.** Keycloak reads `META-INF/keycloak-themes.json` and registers the theme under the name `themeName`. With the parent theme installed, the login page of the realm uses the theme. The files `login/resources/css/brand.css` and the images are served from `/auth/resources/<version>/login/<themeName>/`, and they are equal to the files in the jar. The page also carries the `brand.*` values of `theme.properties`, for example the product name.

**Without the parent theme** Keycloak does not load the theme. The login page falls back to the built-in `keycloak.v2` theme, and the files of the theme return `404`. The Keycloak log has these two lines:

```text
WARN  [org.keycloak.theme.DefaultThemeManager] Not found parent theme 'codemie-base' of theme '<themeName>'. Unable to load LOGIN theme '<themeName>' due to this.
ERROR [org.keycloak.theme.DefaultThemeManager] Failed to find LOGIN theme <themeName>, using built-in themes
```

Install the parent theme in the same Keycloak, and restart it.

**Email theme.** The email theme needs a parent theme `codemie-base` of the type `email`. When the image has the type `login` only, the login theme works, but Keycloak does not load the email theme. Keycloak sends the default mail without the brand, and the log has these two lines:

```text
WARN  [org.keycloak.theme.DefaultThemeManager] Not found parent theme 'codemie-base' of theme '<themeName>'. Unable to load EMAIL theme '<themeName>' due to this.
ERROR [org.keycloak.theme.DefaultThemeManager] Failed to find EMAIL theme <themeName>, using built-in themes
```

With the email parent theme installed, the mail has the product name, the colors, the logo URL and the signature of the Keycloak package.

For a theme folder instead of a jar, copy the folder to `themes/<themeName>` in the Keycloak installation. The jar route is the way to deliver a theme that is too large for the chart route. See [Limits](#limits).

### Install with the Keycloak chart

The chart route mirrors the theme into the Keycloak chart. Add `--chart-dir` to the command:

```bash
kit/apply-keycloak-theme --output-dir my-brand/keycloak-theme --chart-dir keycloak-helm \
  my-brand/keycloak-theme-package.yaml my-brand/assets
```

The folder named by `--chart-dir` must exist. The script mirrors the theme into `keycloak-helm/theme`, the folder that the Keycloak chart reads, and replaces that folder as a whole. Only with this option does the script touch a chart folder and print the YAML snippet. The script prints the snippet on standard output and writes no file for it. The snippet holds the names only: `keycloakx.childTheme.images` (file names), `childTheme.name`, and `realm.themes.loginTheme` and `emailTheme` with the theme name. Paste the `keycloakx` part into `keycloak-helm/values-<cloud>.yaml` and the `realm` part into `oauth2-proxy/values-<cloud>.yaml`:

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

Then do these steps:

1. Verify the theme name. The name in `keycloak-helm/values-<cloud>.yaml` (`keycloakx.childTheme.name`), the name in the `oauth2-proxy` values (`realm.themes.loginTheme` and `realm.themes.emailTheme`), and `themeName` in the package must be equal. A typo in one place gives the default login page and no error.
2. Check the [hook preflight](#hook-preflight).
3. Deploy with `helm-charts.sh`, in this order: Keycloak first, wait for the rollout, then the oauth2-proxy release. A realm change does not restart a pod.

A change in the Keycloak files alone does not restart the UI pods, because `brand-inputs.txt` does not list them. `helm-charts.sh` hashes `keycloak-helm/theme` and sets the pod annotation for the Keycloak pod. A deployment that sets another `childTheme.folder` in the Keycloak values must copy the files by hand.

The chart route needs a Keycloak theme image that is built and released separately. See [Theme image](#theme-image).

### Mirror route or jar route

Choose the mirror route for a small theme when there is no access to the Keycloak image. Choose the jar route when the theme is larger than the chart limit, or when the Keycloak is not deployed from these charts. The charts delta (child story 2 of the same epic) owns the later decision on the mirror route. Until it lands, `--chart-dir` keeps the present behavior.

### Select the theme per realm

Keycloak selects a theme per realm, not for the whole server. The kit does not set a server default. Set the theme in each realm that must use it, in one of these ways:

- In the Keycloak admin console: Realm settings, Themes, then set Login theme and Email theme to the theme name.
- In a realm import file: set `loginTheme` and `emailTheme` to the theme name.
- In the `oauth2-proxy` chart: set `realm.themes.loginTheme` and `realm.themes.emailTheme` for the realm that the chart manages. The snippet of the chart route has these values.

### Without Keycloak or with an external identity provider

When the platform has no Keycloak, or sign-in uses an external identity provider, skip the Keycloak script and the Keycloak package. Set `keycloakx.childTheme.enabled` to `false` in the Keycloak values if the chart is deployed. The UI package is enough.

### Theme image

The child theme extends the vendor parent theme `codemie-base`, which is part of the Keycloak theme image. The image also holds the built-in theme `codemie`, which keeps the original CodeMie login look. A realm that selects `codemie` does not change. The theme image is built and released separately from the kit, and the kit does not build or publish it.

:::warning Release order
First release the Keycloak image that contains the vendor themes `codemie-base` (parent) and `codemie`. Then deploy the Keycloak and oauth2-proxy charts that support the child theme. The parent theme must stay installed in Keycloak. When it is removed, the child theme has nothing to extend and the login page breaks. `codemie-base` exists only in the new image, so deploy the charts after the image.
:::

### Hook preflight

The Keycloak release must already carry the child theme hook. The hook is one line in each of the vendor `extraVolumes` and `extraVolumeMounts` strings, with the marker `keycloak-child-theme`. Check both strings before the deployment:

```bash
helm get values <keycloak-release> -o json
```

Both `keycloakx.extraVolumes` and `keycloakx.extraVolumeMounts` must contain `keycloak-child-theme`. If the marker is missing in one of them, run the normal chart deployment of the Keycloak release once. When `childTheme.enabled` is true and the hook is missing, the chart template fails.

### Size limit

The chart route has a size limit. See [Limits](#limits). The scripts do not check it. The jar route has no such limit.

### Restart behavior

A plain `helm upgrade` of the Keycloak release does not restart the pod, because the checksum annotation is set only by `helm-charts.sh`. A change in `theme/` rolls the single Keycloak replica when the annotation changes, and the login is unavailable for a short time. Use `helm-charts.sh` as the deploy path. A jar install needs a `kc.sh build` and a restart of Keycloak.

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
- **Moved the `keycloak:` block.** The `keycloak:` block (`themeName`) and `email.images.logoUrl` moved from `theme-package.yaml` to the new `keycloak-theme-package.yaml`. `apply-theme` now fails on a leftover `keycloak:` block. The message names the block and says that it moved. Move the theme name to the Keycloak package and run `apply-keycloak-theme` with it.
- **Removed `senderName` and `smtp`.** `email.senderName` and `keycloak.smtp` are removed. The sender name of platform emails comes from `EMAIL_FROM_NAME` in the API values (default `Platform Notifications`). The SMTP connection and the sender name of Keycloak emails are set in the Keycloak realm settings. A package that still has these tokens fails with a message that names the token.
- **New `apply-keycloak-theme` options.** `--output-dir` is required and can be any path. `--chart-dir` is optional. The old default `keycloak-helm` is gone, so a call without `--chart-dir` no longer writes `keycloak-helm/theme` and no longer prints the snippet. The new option `--jar` writes a theme jar.
- **New script names.** `apply-theme` writes the platform files. `apply-keycloak-theme` writes the Keycloak files. The old options are removed, and the scripts no longer deploy.

Move to `docs/admin/update/release-notes/release-notes.md` and remove here after the rebase.

## Limits

- **Asset size.** The scripts do not check sizes. A ConfigMap of the wrapper chart must stay below 1 MiB, and the release estimate of the files must stay below 1048576 bytes. The chart render fails above these limits and names the sizes. A measurement on a stand showed that the release Secret grows by about 2.69 bytes for each byte of binary files, and that Kubernetes rejects a Secret above 1048576 bytes. The estimate of the chart uses 8/3 (2.67) and stops the render at about 355 KB of binary files. The measured capacity is about 392 KB.
- **File types.** The chart puts only files with one of these extensions into ConfigMap `data`: `.css`, `.json`, `.svg`, `.yaml`, `.yml`, `.webmanifest`, `.txt`, `.xml`. Every other file, including a file with an unknown extension, goes into `binaryData` and counts at the binary rate above.
- **Keycloak size.** The chart route for the Keycloak theme has its own size limit of 400000 characters (text plus base64 of the images). The jar route has no such limit and is the way past it. See [Mirror route or jar route](#mirror-route-or-jar-route).
- **No font binaries.** Font files are not delivered through the kit. Reference fonts by URL in `typography.fontFaceCSS`, for example `@font-face { font-family: 'Inter'; src: url('https://fonts.acme.example/inter.woff2'); }`, and make sure the URL is reachable from the browsers of users.
- **Variables only.** `brand.css` sets CSS custom properties: every color token is written twice: its `dark` value under `html.codemieDark` and its `light` value under `html.codemieLight`. The two values always travel as a pair, so the brand follows the user's theme switch. Font variables are written in `:root`. The kit does not change component styles or class names.
- **Load order.** The UI adds the favicon, manifest, page title and `brand.css` link when the page starts, so the default title may flash briefly before the brand title appears.
- **Per-user appearance.** The user-level custom appearance settings are not touched by the kit and continue to work as before.
- **Not covered.** The gradient background images on authentication pages and the default AI avatar image (`ai-avatar.png`) are not part of the theme package and keep their default look. The package cannot recolor them. The authentication and error pages do show the brand logo.
- **API sender name.** No script path sets the API sender name of platform emails; see [Email Branding and Defaults](#email-branding-and-defaults).
- **Keycloak scope.** Only the login and email themes are branded. The account console, locales, and per-mail texts are not part of the kit.
- **Another theme folder.** With `--chart-dir`, `apply-keycloak-theme` writes only to `<chart-dir>/theme`. A deployment that sets another `keycloakx.childTheme.folder` copies the files by hand.
- **Jar test in a Keycloak.** The bats tests check the structure and the bytes of the jar. A manual test on 23 November 2026 loaded the jar of the Acme example in Keycloak 26.5.6 on a stand, in a separate test namespace. With the `codemie` parent theme from the theme image 2.62.0, the realm used the theme, and the css and the four images were equal to the jar files. Without the parent theme, Keycloak did not load the theme (see [Install in any Keycloak](#install-in-any-keycloak)). The test started Keycloak with `start-dev`, which builds at start. A separate `kc.sh build` run was not part of the test. The same test on the same day checked the folder route (the folder under `themes/<themeName>`) and the email theme. The folder route gave the same result as the jar route. The image 2.62.0 has no email parent theme, so the email theme did not load. With a stand-in email parent theme, built from the email theme source of the `codemie-ui` branch of EPMCDME-15168, a password-reset mail had the product name, the three colors, the logo URL and the signature. This was true for the jar route and for the folder route. A repeat of the jar route used the real theme jar that the `codemie-ui` branch builds, in place of the stand-in. This jar had two themes, each with the types `login` and `email`. Keycloak loaded both jars without a theme warning, the login page used the theme, the css and the images were equal to the files of the kit, and the password-reset mail had the same six brand values. A realm with the login and email theme of the second theme showed the login page of that theme. On 24 November 2026 the jar route, the folder route, the password-reset mail and a realm with the second theme were tested again on Keycloak 26.8.2, the version of the Keycloak chart on `main`. This test used a theme jar rebuilt from the `codemie-ui` branch after `main` was merged into it. The results were the same, and the Keycloak log had no theme warning. The tests did not use a released image, because no released image has the email parent theme yet. These tests ran before the rename of 26 November 2026. At that time the neutral parent was called `codemie` and the theme with the original look `codemie-default`. After the rename the neutral parent is `codemie-base` and the original look is `codemie`. The rename was not tested again on a stand.
- **Registry pull.** The pull function of `helm-charts.sh` ran against the registry with chart 2.68.0 and `--version`, and Helm accepted the archive. A full run of `helm-charts.sh` on a stand is not part of this check.
- **First upgrade.** A first `helm upgrade` of an existing `codemie-ui` release (registry chart 2.68.0) to the wrapper chart ran on a stand without an object ownership error. It used the locally packaged chart of the first change as the dependency. Repeat it with the released chart.
- **Chart under test.** The names tests ran against the unreleased chart of the first change, not against a released chart.
- **Redeploy.** `helm-charts.sh` does not use `--reuse-values`. A full deployment resets values that were set outside the values files. Keep the brand in the files of the Helm repository so that each deployment applies it again.
- **Sub-path hosting.** Brand asset URLs follow the base path the UI was built with, so they work with a sub-path deployment of the UI.

## Troubleshooting

| Symptom                                                                                               | Cause and fix                                                                                                                                                                                                                                                 |
| ----------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `validation failed` with a list of schema errors                                                      | A required field is missing or malformed. Compare the package with its reference: the [Theme Package Reference](./package-reference.md) for the UI package, the [Keycloak Theme Package Reference](./keycloak-package-reference.md) for the Keycloak package. |
| `assets.<name>: file not found`                                                                       | The file name in `assets` does not match a file in the source folder.                                                                                                                                                                                         |
| `assets.<name>: invalid file name`                                                                    | The name breaks the rule of the charts, for example it has a space. Rename the file and the package field.                                                                                                                                                    |
| `email.senderName is removed` or `keycloak.smtp is removed`                                           | Delete the token from the package. Set the sender name and the SMTP connection of Keycloak in the realm settings. The API sender name comes from `EMAIL_FROM_NAME`.                                                                                           |
| `the keycloak block moved to keycloak-theme-package.yaml`                                             | `apply-theme` found a `keycloak:` block in the UI package. Delete the block there and put the theme name in `keycloak-theme-package.yaml`.                                                                                                                    |
| `parent folder does not exist`                                                                        | `apply-theme` was not run from the root of the charts repository. Change to that folder, or pass `--output-dir`.                                                                                                                                              |
| `chart folder not found`                                                                              | The folder named by `--chart-dir` does not exist. Run `apply-keycloak-theme` from the root of the charts repository, or pass the right folder.                                                                                                                |
| `zip is required for --jar`                                                                           | Install `zip` on the machine, or run the script without `--jar`.                                                                                                                                                                                              |
| `is a symbolic link; refusing to write through it`                                                    | A target folder or file is a symbolic link. Replace it with a real folder or file.                                                                                                                                                                            |
| `<field>: must not contain ${`                                                                        | The named value holds a character that is not allowed in a properties file. Remove `${`, `<`, `>`, `"`, backslashes, and control characters.                                                                                                                  |
| An error that names `themeName`                                                                       | `apply-keycloak-theme` needs a valid `themeName` in the Keycloak package.                                                                                                                                                                                     |
| The render fails with `childTheme.images ... differs from the image files`                            | Paste the `images` list that `apply-keycloak-theme` printed into the Keycloak values again.                                                                                                                                                                   |
| The render fails with `keycloakx.extraVolumes lacks the keycloak-child-theme hook`                    | The Keycloak release does not carry the child theme hook. Run the normal chart deployment of the Keycloak release once. See [Hook preflight](#hook-preflight).                                                                                                |
| `deploy the UI release first`                                                                         | `helm-charts.sh` found no `codemie-brand-email` ConfigMap. Deploy the UI release before the API release.                                                                                                                                                      |
| The deployment shows the default brand                                                                | `branding.enabled` is `false` or the files are not in `codemie-ui/assets`. See [Steps](#steps).                                                                                                                                                               |
| Theme is deployed but the login page is unchanged                                                     | The realm reconcile is asynchronous, the theme names differ between the files, the realm does not select the theme, or the parent theme `codemie-base` is missing in Keycloak. See [Check after deployment](#check-after-deployment).                         |
| The Keycloak log has `Not found parent theme 'codemie-base'`, and the login page has the default look | The theme jar needs the `codemie-base` parent theme in the same Keycloak. Install the parent theme and restart Keycloak. See [Install in any Keycloak](#install-in-any-keycloak).                                                                             |
| The Keycloak log has `Unable to load EMAIL theme`, and mails have no brand                            | The theme `codemie-base` in the Keycloak image has no type `email`. Use an image that includes the email parent theme, and restart Keycloak. See [Install in any Keycloak](#install-in-any-keycloak).                                                         |
| A custom file of the theme folder is missing in the jar                                               | The jar holds only the files that the script writes. See [Build the theme manually](#build-the-theme-manually).                                                                                                                                               |
| Emails still show the old logo                                                                        | The API pods were not restarted, or the logo name is unchanged and the file was not replaced in the source folder. Run the script again and deploy with `helm-charts.sh`.                                                                                     |
| Browser still shows the old logo                                                                      | Hard-reload the page or clear the browser cache; the deployments were restarted but the browser may cache static files.                                                                                                                                       |

## Kit Versions

The kit is versioned independently of the platform, and the `kitVersion` in the metadata of this page is the version it describes. The `version` field of the UI package must match the major version of the kit.

| Kit version                                | Package `version` | Required platform support                                                                                                                                                                        |
| ------------------------------------------ | ----------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| 1                                          | `'1'`             | The `codemie-ui` wrapper chart with the folder `assets` and `branding.enabled`.                                                                                                                  |
| 1 (with the optional `email` block)        | `'1'`             | An email service that reads `brand.yaml` and the `brand-assets` directory.                                                                                                                       |
| 1 (with the Keycloak package, chart route) | none              | A Keycloak chart that reads the folder `theme` with the child theme hook, an oauth2-proxy chart with the realm values, and the vendor themes `codemie-base` and `codemie` in the Keycloak image. |
| 1 (with the Keycloak package, jar route)   | none              | A Keycloak with the `codemie-base` parent theme installed. The jar goes in `providers`, followed by `kc.sh build`.                                                                               |

When the package contract changes, this table gains a row.

## Related Topics

- [Theme Package Reference](./package-reference.md)
- [Keycloak Theme Package Reference](./keycloak-package-reference.md)
- [API Configuration](../codemie/api-configuration.md)
