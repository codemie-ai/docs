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

| Path         | Type   | Required | Description                                                                |
| ------------ | ------ | -------- | -------------------------------------------------------------------------- |
| `version`    | string | Yes      | Theme package format version. Must be exactly `"1"`.                       |
| `product`    | object | Yes      | Product naming. See [Product](#product).                                   |
| `colors`     | object | Yes      | Color tokens, each with a dark and a light value. See [Colors](#colors).   |
| `typography` | object | Yes      | Font families and optional font-face CSS. See [Typography](#typography).   |
| `effects`    | object | No       | Visual effects, for example background gradients. See [Effects](#effects). |
| `assets`     | object | Yes      | File names of the brand assets. See [Assets](#assets).                     |
| `links`      | object | Yes      | Help links shown in the UI. See [Links](#links).                           |
| `email`      | object | No       | Branding of platform emails. See [Email](#email).                          |
| `keycloak`   | object | No       | Keycloak login page and emails. See [Keycloak](#keycloak).                 |

## Product

| Path                | Type   | Required | Description                                                                                                                    |
| ------------------- | ------ | -------- | ------------------------------------------------------------------------------------------------------------------------------ |
| `product.name`      | string | Yes      | Product name shown in the browser tab and UI headers. 1 to 100 characters; no `<`, `>`, `"`, backslash, or control characters. |
| `product.shortName` | string | Yes      | Abbreviated name for space-constrained surfaces. 1 to 50 characters; same character rules.                                     |

## Colors

`colors` is a map. Each key is a semantic token path, for example `surface.base.primary`. Token paths use letters, digits, and hyphens, separated by dots. Every dot becomes a hyphen in the generated CSS custom property, so `surface.base.primary` produces `--colors-surface-base-primary`, the variable the UI reads. Values are written as space-separated red, green, and blue channels. Each token is written twice in `brand.css`: the `dark` value under `html.codemieDark` and the `light` value under `html.codemieLight`. The brand therefore follows the theme switch of the user. Tokens that are not listed keep their default values.

| Path                   | Type   | Required | Description                                                                                                                                                                                          |
| ---------------------- | ------ | -------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `colors.<token>`       | object | No       | One semantic color token. Add one entry per token to override.                                                                                                                                       |
| `colors.<token>.dark`  | string | Yes      | Value for the dark theme as a six-digit hex color, for example `#111111`. Written to `brand.css` under `html.codemieDark`.                                                                           |
| `colors.<token>.light` | string | Yes      | Value for the light theme as a six-digit hex color, for example `#ffffff`. Written to `brand.css` under `html.codemieLight`, together with the `dark` value, so both themes always change as a pair. |

Only the `dark` and `light` keys are allowed inside a token. The hex pattern is `^#[0-9a-fA-F]{6}$`; shorthand colors such as `#fff` are rejected.

### Side Panel and Gradient Tokens

The UI has two side panels: the main navigation on the left and a secondary side panel next to it. These tokens set their colors:

| Token                                                                     | Where it applies                                                                                                                                                                           |
| ------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| `surface.base.navigation`                                                 | Background of the main navigation panel. Applies only when [`effects.gradients`](#effects) is `none`. With the default gradients, the panel shows a fixed gradient and ignores this token. |
| `surface.specific.navigation-link`                                        | Background of a navigation item.                                                                                                                                                           |
| `text.specific.navigation-link`, `text.specific.navigation-link-hover`    | Text of a navigation item and its hover state.                                                                                                                                             |
| `text.specific.navigation-icon`, `text.specific.navigation-icon-hover`    | Icons of navigation items and their hover state.                                                                                                                                           |
| `text.specific.navigation-badge`, `text.specific.bottom-navigation-label` | Badge text and the labels at the bottom of the navigation panel.                                                                                                                           |
| `surface.base.sidebar`                                                    | Background of the secondary side panel. The same token also colors the app background behind the panels, the chat settings area, and the assistant form headers.                           |
| `surface.specific.sidebar-toggle`                                         | Button that opens and closes the side panel.                                                                                                                                               |
| `border.specific.sidebar`                                                 | Border line of the side panel.                                                                                                                                                             |
| `surface.specific.gradient`                                               | Color of the glow behind the side panels. Without this token, the UI keeps its default purple glow.                                                                                        |

A navigation panel with a dark background in the light theme needs light values for the navigation text and icon tokens as well. To remove the glow and all other background gradients instead of recoloring them, set [`effects.gradients`](#effects) to `none`.

## Typography

| Path                         | Type           | Required | Description                                                                                                                                    |
| ---------------------------- | -------------- | -------- | ---------------------------------------------------------------------------------------------------------------------------------------------- |
| `typography.bodyFamily`      | string         | Yes      | CSS font-family list for UI text (`--font-family-body`), for example `Inter, sans-serif`. Not empty; no `; { } < > ( ) !` or backslash.        |
| `typography.bodyProseFamily` | string         | Yes      | CSS font-family list for long-form prose (`--font-family-body-prose`). Same character rules.                                                   |
| `typography.codeFamily`      | string         | Yes      | CSS font-family list for code (`--font-family-code-block`), for example `Fira Code, monospace`. Same character rules.                          |
| `typography.fontFaceCSS`     | string or null | No       | Inline `@font-face` CSS added before the variables. Must not contain `!important`. Font files are not delivered by the kit; use URLs in `src`. |

## Effects

The `effects` block is optional. A package without it keeps all default effects.

| Path                | Type   | Required | Description                                                                                                                                        |
| ------------------- | ------ | -------- | -------------------------------------------------------------------------------------------------------------------------------------------------- |
| `effects.gradients` | string | No       | `default` keeps the background gradients. `none` removes all of them. Any other value is rejected. A missing key has the same effect as `default`. |

With `none`, the kit writes `--brand-gradients: none;` into the `:root` block of `brand.css`. The UI then removes these gradients:

- the glow behind the side panels, and the overlay on the secondary side panel;
- the fixed gradient behind the main navigation panel. The panel then uses the `surface.base.navigation` color;
- the background image behind the page content and the pagination bar in the light theme;
- the gradients on cards and workflow cards;
- the gradients on the standalone pages, including the Keycloak login page.

The option wins over the per-user Custom Appearance setting for gradients. Buttons and other control styles are not background gradients and stay unchanged. When `none` is set, the `surface.specific.gradient` token has no visible effect.

## Assets

All values are plain file names relative to the assets directory that is passed to `apply-theme`: up to 100 characters from letters, digits, `.`, `_`, and `-`, starting with a letter or digit. Paths, duplicate names, and symbolic links are rejected. The combined size of the files must stay below 1 MiB once base64-encoded (about 750 KB of files).

| Path                | Type   | Required | Description                          |
| ------------------- | ------ | -------- | ------------------------------------ |
| `assets.logoLight`  | string | Yes      | Logo for the light theme. Not empty. |
| `assets.logoDark`   | string | Yes      | Logo for the dark theme. Not empty.  |
| `assets.favicon`    | string | Yes      | Legacy `.ico` favicon. Not empty.    |
| `assets.faviconSvg` | string | Yes      | SVG favicon. Not empty.              |
| `assets.manifest`   | string | Yes      | Web app manifest file. Not empty.    |

## Links

The `links` object is required, but each link inside it is optional in the schema. In practice, include every link that is enabled in `customer-config.yaml`: `apply-theme` fails validation when an enabled link is missing from the package. Only the link identifiers below are allowed.

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

## Email

The `email` block is optional. A package without it works: the platform sends emails with its neutral defaults. When the block is present, every key inside it is optional, and omitted keys keep the platform defaults. No key may be added that is not listed here. The rules match the validation of the platform backend.

| Path                              | Type   | Required | Description                                                                                                                    |
| --------------------------------- | ------ | -------- | ------------------------------------------------------------------------------------------------------------------------------ |
| `email.senderName`                | string | No       | Display name of the sender. Must not be blank. May use `{productName}`.                                                        |
| `email.signature`                 | string | No       | Closing line of every email. May use `{productName}`.                                                                          |
| `email.palette`                   | object | No       | Email colors. Allowed roles: `primary`, `primaryText`, `text`, `background`, `surface`.                                        |
| `email.palette.<role>`            | string | No       | Six-digit hex color `#RRGGBB`, upper case or lower case. Shorthand such as `#fff` is rejected.                                 |
| `email.images.logo`               | string | No       | File name of the email logo in the assets directory, for platform emails. See [Email Logo](#email-logo).                       |
| `email.images.logoUrl`            | string | No       | Absolute `https://` URL of the logo for Keycloak emails. See [Keycloak Email Logo URL](#keycloak-email-logo-url).              |
| `email.messages.<id>`             | object | No       | Texts of one message. Allowed ids: `verification`, `password_reset`, `budget_soft_limit`, `budget_stopped`, `budget_restored`. |
| `email.messages.<id>.subject`     | string | No       | Subject line. Must not be blank.                                                                                               |
| `email.messages.<id>.heading`     | string | No       | Heading of the email.                                                                                                          |
| `email.messages.<id>.intro`       | string | No       | Introduction text.                                                                                                             |
| `email.messages.<id>.buttonLabel` | string | No       | Button label. Only for `verification`, `password_reset` and `budget_soft_limit`.                                               |
| `email.messages.<id>.footer`      | string | No       | Footer text. Only for `verification`, `password_reset` and `budget_soft_limit`.                                                |

`budget_stopped` and `budget_restored` accept `subject`, `heading` and `intro` only.

### Email Palette

The email palette is explicit. It is not derived from `colors`, because the UI colors are semantic tokens with separate dark and light values and an email has one fixed look. The roles are mapped by hand:

| Role          | Source in the brand                             |
| ------------- | ----------------------------------------------- |
| `primary`     | The accent color of the brand (buttons, links). |
| `primaryText` | The text color used on top of the accent color. |
| `text`        | The body text color of the light theme.         |
| `background`  | The page background color of the light theme.   |
| `surface`     | The card surface color of the light theme.      |

Omitted roles use the platform defaults: `primary` `#4F46E5`, `primaryText` `#FFFFFF`, `text` `#333333`, `background` `#F4F4F5`, `surface` `#FFFFFF`.

### Email Tokens

A token is a name in braces, for example `{productName}`. A string such as `{a b}` or `{}` is not a token and is kept as written. Any other token name is rejected.

| Token              | Allowed in                                                                             |
| ------------------ | -------------------------------------------------------------------------------------- |
| `{productName}`    | Every text field, including `senderName` and `signature`. Its value is `product.name`. |
| `{projectName}`    | `subject` and `intro` of `budget_stopped` and `budget_restored`.                       |
| `{costCenterName}` | `subject` and `intro` of `budget_stopped`.                                             |

### Email Logo

`email.images.logo` is used by platform emails. Keycloak emails do not use it; see [Keycloak Email Logo URL](#keycloak-email-logo-url).

- Use the file name only. A name with `/`, a backslash or `..` is rejected.
- Allowed extensions: `png`, `jpg`, `jpeg`, `gif`. The extension is not case-sensitive.
- The file must exist in the assets directory and must not be a symbolic link.
- Maximum size: 262144 bytes (256 KiB).
- The file content must match the extension: PNG, JPEG or GIF (`GIF87a` or `GIF89a`) signature.

## Keycloak

The `keycloak` block is optional. A package without it behaves exactly as before: no Keycloak output file and no Keycloak Helm call. The block is also skipped for a single run with `--no-keycloak`. When the block is present, `keycloak.themeName` is required and the other keys are optional. No key may be added that is not listed here. The rollout steps are described in [Keycloak Login Page and Emails](./index.md#keycloak-login-page-and-emails).

| Path                              | Type    | Required | Description                                                                                                                 |
| --------------------------------- | ------- | -------- | --------------------------------------------------------------------------------------------------------------------------- |
| `keycloak.themeName`              | string  | Yes      | Name of the Keycloak child theme. See [Theme Name](#theme-name).                                                            |
| `keycloak.smtp`                   | object  | No       | SMTP connection of the realm. See [SMTP](#smtp).                                                                            |
| `keycloak.smtp.host`              | string  | No       | SMTP server host name. 1 to 253 characters of letters, digits, `.` and `-`. Set together with `from`.                       |
| `keycloak.smtp.port`              | integer | No       | SMTP server port, from 1 to 65535.                                                                                          |
| `keycloak.smtp.from`              | string  | No       | Sender address, for example `no-reply@acme.example`. 3 to 254 characters. Set together with `host`.                         |
| `keycloak.smtp.ssl`               | boolean | No       | Use SSL for the connection.                                                                                                 |
| `keycloak.smtp.starttls`          | boolean | No       | Use STARTTLS for the connection.                                                                                            |
| `keycloak.smtp.auth`              | object  | No       | SMTP credentials. Allowed keys: `username` and `password`.                                                                  |
| `keycloak.smtp.auth.<credential>` | object  | No       | One credential, `username` or `password`. Only a secret reference is accepted. See [Secret References](#secret-references). |

### Theme Name

The theme name must match `^[a-z0-9-]{3,40}$`: 3 to 40 characters of `a-z`, `0-9` and `-`. The names `codemie`, `base` and `keycloak` are reserved and are rejected. `codemie` is the vendor parent theme that the child theme extends, so it must stay unchanged.

### SMTP

- `keycloak.smtp.host` and `keycloak.smtp.from` are set together or not at all. A block that has only one of them fails validation.
- A full block (`host` and `from`) writes the SMTP connection to the realm settings. Without the block, the realm file has no SMTP settings and Keycloak keeps its own sender.
- `email.senderName` reaches Keycloak only through a full SMTP block. Without it, the script warns that the sender name is not used.
- Keys other than `host`, `port`, `from`, `ssl`, `starttls` and `auth` are rejected.

### Secret References

SMTP credentials are accepted only as references to an existing Kubernetes Secret. A literal username or password is a validation error. The kit does not create Secrets.

| Path                                                | Type   | Required | Description                                 |
| --------------------------------------------------- | ------ | -------- | ------------------------------------------- |
| `keycloak.smtp.auth.<credential>.secretKeyRef`      | object | Yes      | Reference to a key of a Kubernetes Secret.  |
| `keycloak.smtp.auth.<credential>.secretKeyRef.name` | string | Yes      | Secret name. 1 to 253 characters.           |
| `keycloak.smtp.auth.<credential>.secretKeyRef.key`  | string | Yes      | Key inside the Secret. 1 to 253 characters. |

### Keycloak Email Logo URL

`email.images.logoUrl` is the logo of Keycloak emails. Mail clients do not load a logo from the cluster, so the value is an absolute URL.

- The URL starts with `https://` and has 1 to 2000 characters after it. It must not contain whitespace, `$`, `{`, `}`, `<`, `>`, `"` or a backslash.
- The file is a PNG, JPG or GIF image. A URL whose path ends in `.svg` is rejected, because email clients do not render SVG.
- When `logoUrl` is not set, the mail shows the product name as text. A data URI is not accepted.
- When only `email.images.logo` is set, the script warns that Keycloak emails do not use it.

### Keycloak Value Policy

When the `keycloak` block is active, the values that reach Keycloak properties files are checked. The checked values are `product.name`, `product.shortName`, `email.signature`, the values of `email.palette`, and `email.images.logoUrl`. Each of them is rejected when it contains:

- `${`
- `<`, `>`, `"` or a backslash
- control characters. Only `email.signature` may contain line breaks.
- leading or trailing whitespace

`keycloak.themeName` has its own pattern, described in [Theme Name](#theme-name). In addition, `assets.logoLight` and `assets.logoDark` are required, and the theme content must stay within 400000 bytes. All problems are listed at once, and nothing is written when any check fails.

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

email:
  senderName: 'Acme Notifications'
  signature: 'The {productName} Team'
  palette:
    primary: '#0B5FFF'
  images:
    logo: 'email-logo.png'
    logoUrl: 'https://static.acme.example/logo.png'
  messages:
    verification:
      subject: 'Confirm your {productName} account'

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
```
