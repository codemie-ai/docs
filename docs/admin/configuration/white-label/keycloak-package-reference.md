---
id: keycloak-package-reference
title: Keycloak Theme Package Reference
sidebar_label: Keycloak Theme Package Reference
sidebar_position: 3
description: Field reference for the white-label keycloak-theme-package.yaml file, derived from keycloak-theme-package.schema.json
pagination_prev: admin/configuration/white-label/white-label-overview
pagination_next: null
---

# Keycloak Theme Package Reference

This page lists every field of `keycloak-theme-package.yaml`. It is derived from `keycloak-theme-package.schema.json` in the [theming kit](./index.md), which is the authoritative definition. The package may not contain fields that are not listed here.

The Keycloak package is separate from the UI package. The two packages share no file. The UI package is described in the [Theme Package Reference](./package-reference.md). The steps that use the Keycloak package are in [Keycloak Login Page and Emails](./index.md#keycloak-login-page-and-emails).

## Top-Level Fields

The package has no `version` field, no `typography`, no `effects`, no `links` and no `assets.manifest`.

| Path        | Type   | Required | Description                                                              |
| ----------- | ------ | -------- | ------------------------------------------------------------------------ |
| `themeName` | string | Yes      | Name of the Keycloak child theme. See [Theme Name](#theme-name).         |
| `product`   | object | Yes      | Product naming. See [Product](#product).                                 |
| `colors`    | object | Yes      | Color tokens, each with a dark and a light value. See [Colors](#colors). |
| `assets`    | object | Yes      | File names of the images of the login page. See [Assets](#assets).       |
| `email`     | object | No       | Branding of the emails that Keycloak sends. See [Email](#email).         |

## Theme Name

The theme name must match `^[a-z0-9-]{3,40}$`: 3 to 40 characters of `a-z`, `0-9` and `-`. The names `codemie`, `codemie-base`, `base` and `keycloak` are reserved and are rejected. `codemie-base` is the neutral vendor parent theme that the child theme extends, so it must stay unchanged. `codemie` is the built-in theme with the original CodeMie login look. It is the default login theme of a deployment that has no child theme.

## Product

| Path                | Type   | Required | Description                                                                                                                           |
| ------------------- | ------ | -------- | ------------------------------------------------------------------------------------------------------------------------------------- |
| `product.name`      | string | Yes      | Product name shown on the login page and in Keycloak emails. 1 to 100 characters; no `<`, `>`, `"`, backslash, or control characters. |
| `product.shortName` | string | Yes      | Abbreviated name for space-constrained surfaces. 1 to 50 characters; same character rules.                                            |

The product name is entered in each package. The scripts do not compare it with the value of the UI package.

## Colors

`colors` is a map. Each key is a semantic token path, for example `surface.base.primary`. Token paths use letters, digits, and hyphens, separated by dots. Every dot becomes a hyphen in the generated CSS custom property, so `surface.base.primary` produces `--colors-surface-base-primary`. The token names are the same as in the UI package. Each token is written twice in `login/resources/css/brand.css`: the `dark` value under `html.codemieDark` and the `light` value under `html.codemieLight`. Tokens that are not listed keep their default values.

| Path                   | Type   | Required | Description                                                                                              |
| ---------------------- | ------ | -------- | -------------------------------------------------------------------------------------------------------- |
| `colors.<token>`       | object | No       | One semantic color token. Add one entry per token to override.                                           |
| `colors.<token>.dark`  | string | Yes      | Value for the dark theme as a six-digit hex color, for example `#111111`.                                |
| `colors.<token>.light` | string | Yes      | Value for the light theme as a six-digit hex color, for example `#ffffff`. Both themes change as a pair. |

Only the `dark` and `light` keys are allowed inside a token. The hex pattern is `^#[0-9a-fA-F]{6}$`; shorthand colors such as `#fff` are rejected. The map `colors` is required, but it can be empty. The list of tokens and the places where the UI uses them are in [Colors](./package-reference.md#colors) of the UI package reference.

## Assets

All values are plain file names of files in the source folder that is passed to `apply-keycloak-theme` (`<source-dir>`). A name has up to 100 characters from letters, digits, `.`, `_`, and `-`, and starts with a letter or digit. This is the file-name rule of the charts. A name with a path, a name that breaks the rule (for example `Logo Light.svg`), a missing file, and a symbolic link are rejected. The script copies each file by name to `login/resources/img/`, so the name in the package is the name in the theme. The size of the files is not checked by the script. See [Limits](./index.md#limits).

| Path                | Type   | Required | Description                          |
| ------------------- | ------ | -------- | ------------------------------------ |
| `assets.logoLight`  | string | Yes      | Logo for the light theme. Not empty. |
| `assets.logoDark`   | string | Yes      | Logo for the dark theme. Not empty.  |
| `assets.favicon`    | string | Yes      | Legacy `.ico` favicon. Not empty.    |
| `assets.faviconSvg` | string | Yes      | SVG favicon. Not empty.              |

## Email

The `email` block is optional. A package without it works: Keycloak emails keep the defaults of the theme. When the block is present, every key inside it is optional, and omitted keys keep the defaults. No key may be added that is not listed here.

| Path                   | Type   | Required | Description                                                                                          |
| ---------------------- | ------ | -------- | ---------------------------------------------------------------------------------------------------- |
| `email.signature`      | string | No       | Closing line of every email. May use `{productName}`, which the script replaces with `product.name`. |
| `email.palette`        | object | No       | Email colors. Allowed roles: `primary`, `primaryText`, `text`, `background`, `surface`.              |
| `email.palette.<role>` | string | No       | Six-digit hex color `#RRGGBB`, upper case or lower case. Shorthand such as `#fff` is rejected.       |
| `email.images.logoUrl` | string | No       | Absolute `https://` URL of the logo for Keycloak emails. See [Email Logo URL](#email-logo-url).      |

Omitted palette roles use the defaults of the theme. The roles have the same meaning as in the [Email Palette](./package-reference.md#email-palette) of the UI package.

### Email Logo URL

`email.images.logoUrl` is the logo of Keycloak emails. Mail clients do not load a logo from the cluster, so the value is an absolute URL.

- The URL starts with `https://` and has 1 to 2000 characters after it. It must not contain whitespace, `$`, `{`, `}`, `<`, `>`, `"` or a backslash.
- The file is a PNG, JPG or GIF image. A SVG image does not show in email clients. The script does not check the type of the file behind the URL.
- When `logoUrl` is not set, the mail shows the product name as text. A data URI is not accepted.

:::note Removed tokens
`email.senderName` and `smtp` are removed. The SMTP connection and the sender name of Keycloak emails are set in the Keycloak realm settings. A package that still has one of these tokens fails with a message that names the token.
:::

## Value Policy

`apply-keycloak-theme` checks the values that reach a `.properties` file. The checked values are `product.name`, `product.shortName`, `email.signature`, the values of `email.palette`, and `email.images.logoUrl`. Each of them is rejected when it contains:

- `${`
- `<`, `>`, `"` or a backslash
- control characters. Only `email.signature` may contain line breaks.
- leading or trailing whitespace

`themeName` has its own pattern, described in [Theme Name](#theme-name). All problems are listed at once, and nothing is written when any check fails.

## Complete Example

The complete example is `kit/examples/acme/keycloak-theme-package.yaml`.

```yaml
themeName: 'acme-brand'

product:
  name: 'Acme Corp AI Platform'
  shortName: 'Acme'

colors:
  surface.base.primary:
    dark: '#121826'
    light: '#ffffff'

assets:
  logoLight: 'logo-light.svg'
  logoDark: 'logo-dark.svg'
  favicon: 'favicon.ico'
  faviconSvg: 'favicon.svg'

email:
  signature: 'The {productName} Team'
  palette:
    primary: '#0B5FFF'
  images:
    logoUrl: 'https://static.acme.example/logo.png'
```
