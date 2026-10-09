---
id: package-reference
title: Theme Package Reference
sidebar_label: Theme Package Reference
sidebar_position: 2
description: Field reference for the white-label theme-package.yaml file, derived from theme-package.schema.json
pagination_prev: admin/configuration/white-label/white-label-overview
pagination_next: null
---

# Theme Package Reference

This page lists every field of `theme-package.yaml`. It is derived from `theme-package.schema.json` in the [theming kit](./index.md), which is the authoritative definition. The package may not contain fields that are not listed here.

## Top-Level Fields

| Path         | Type   | Required | Description                                                              |
| ------------ | ------ | -------- | ------------------------------------------------------------------------ |
| `version`    | string | Yes      | Theme package format version. Must be exactly `"1"`.                     |
| `product`    | object | Yes      | Product naming. See [Product](#product).                                 |
| `colors`     | object | Yes      | Color tokens, each with a dark and a light value. See [Colors](#colors). |
| `typography` | object | Yes      | Font families and optional font-face CSS. See [Typography](#typography). |
| `assets`     | object | Yes      | File names of the brand assets. See [Assets](#assets).                   |
| `links`      | object | Yes      | Help links shown in the UI. See [Links](#links).                         |

## Product

| Path                | Type   | Required | Description                                                                                                                    |
| ------------------- | ------ | -------- | ------------------------------------------------------------------------------------------------------------------------------ |
| `product.name`      | string | Yes      | Product name shown in the browser tab and UI headers. 1 to 100 characters; no `<`, `>`, `"`, backslash, or control characters. |
| `product.shortName` | string | Yes      | Abbreviated name for space-constrained surfaces. 1 to 50 characters; same character rules.                                     |

## Colors

`colors` is a map. Each key is a semantic token path, for example `surface.base.primary`. Token paths use letters, digits, and hyphens, separated by dots. Every dot becomes a hyphen in the generated CSS custom property, so `surface.base.primary` produces `--colors-surface-base-primary`, the variable the UI reads. All color variables are written in a single `:root` block, as space-separated red, green, and blue channels, and no theme-specific block is generated. The generated value is the `dark` value, so it applies to both the dark and the light theme; the `light` value is required and validated but is not written to `brand.css`. Tokens that you do not list keep their default values.

| Path                   | Type   | Required | Description                                                                                                                                                               |
| ---------------------- | ------ | -------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `colors.<token>`       | object | No       | One semantic color token. Add one entry per token to override.                                                                                                            |
| `colors.<token>.dark`  | string | Yes      | Value for the dark theme as a six-digit hex color, for example `#111111`.                                                                                                 |
| `colors.<token>.light` | string | Yes      | Value for the light theme as a six-digit hex color, for example `#ffffff`. Written to `brand.css` together with the `dark` value, so both themes always change as a pair. |

Only the `dark` and `light` keys are allowed inside a token. The hex pattern is `^#[0-9a-fA-F]{6}$`; shorthand colors such as `#fff` are rejected.

## Typography

| Path                         | Type           | Required | Description                                                                                                                                    |
| ---------------------------- | -------------- | -------- | ---------------------------------------------------------------------------------------------------------------------------------------------- |
| `typography.bodyFamily`      | string         | Yes      | CSS font-family list for UI text (`--font-family-body`), for example `Inter, sans-serif`. Not empty; no `; { } < > ( ) !` or backslash.        |
| `typography.bodyProseFamily` | string         | Yes      | CSS font-family list for long-form prose (`--font-family-body-prose`). Same character rules.                                                   |
| `typography.codeFamily`      | string         | Yes      | CSS font-family list for code (`--font-family-code-block`), for example `Fira Code, monospace`. Same character rules.                          |
| `typography.fontFaceCSS`     | string or null | No       | Inline `@font-face` CSS added before the variables. Must not contain `!important`. Font files are not delivered by the kit; use URLs in `src`. |

## Assets

All values are plain file names relative to the assets directory that you pass to `apply-theme`: up to 100 characters from letters, digits, `.`, `_`, and `-`, starting with a letter or digit. Paths, duplicate names, and symbolic links are rejected. The combined size of the files must stay below 1 MiB once base64-encoded (about 750 KB of files).

| Path                | Type   | Required | Description                          |
| ------------------- | ------ | -------- | ------------------------------------ |
| `assets.logoLight`  | string | Yes      | Logo for the light theme. Not empty. |
| `assets.logoDark`   | string | Yes      | Logo for the dark theme. Not empty.  |
| `assets.favicon`    | string | Yes      | Legacy `.ico` favicon. Not empty.    |
| `assets.faviconSvg` | string | Yes      | SVG favicon. Not empty.              |
| `assets.manifest`   | string | Yes      | Web app manifest file. Not empty.    |

## Links

The `links` object is required, but each link inside it is optional in the schema. In practice, include every link that is enabled in your `customer-config.yaml`: `apply-theme` fails validation when an enabled link is missing from the package. Only the link identifiers below are allowed.

| Path                              | Type   | Required | Description                                                                                                     |
| --------------------------------- | ------ | -------- | --------------------------------------------------------------------------------------------------------------- |
| `links.userGuide`                 | object | No       | User guide link.                                                                                                |
| `links.videoPortal`               | object | No       | Video portal link.                                                                                              |
| `links.youtubeChannel`            | object | No       | Video channel link.                                                                                             |
| `links.learningCourses`           | object | No       | Learning courses link.                                                                                          |
| `links.customerSupport`           | object | No       | Customer support link.                                                                                          |
| `links.userSurvey`                | object | No       | User survey link.                                                                                               |
| `links.workflowDocumentation`     | object | No       | Workflow documentation link.                                                                                    |
| `links.workflowYamlDocumentation` | object | No       | Workflow YAML documentation link.                                                                               |
| `links.googleDocsDocumentation`   | object | No       | Google Docs documentation link.                                                                                 |
| `links.<id>.name`                 | string | Yes      | Display name of the link. Required for every link present. Up to 100 characters; must not contain `{{` or `}}`. |
| `links.<id>.url`                  | string | Yes      | Target URL of the link. Required for every link present. Must start with `http://` or `https://`.               |

## Complete Example

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
