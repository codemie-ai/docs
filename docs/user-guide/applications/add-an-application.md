---
id: add-an-application
title: Bringing an Application to CodeMie
sidebar_label: Add an Application
sidebar_position: 1
description: A plain-language guide for teams who already have their own product and want it to show up in CodeMie.
pagination_prev: user-guide/applications/index
pagination_next: null
---

# Bringing an application to CodeMie

**Who this is for:** a team that already built its own product (a web app, a dashboard, an internal tool) and wants it to show up inside CodeMie, next to the built-in features.

**Terms:** "you" means your team, the one that owns the product being added. "The operator" means whoever runs the CodeMie deployment you're targeting: EPAM for EPAM's own instance, or a client's own team for an on-premises deployment.

---

## What "adding to CodeMie" actually means

An **application** in CodeMie is a tile on the Applications page. A user clicks it, and your product opens, either in a new tab, framed inside CodeMie, or running as part of CodeMie's own page. The left navigation gets one **Applications** entry, shown only once at least one application is enabled; your product is a tile behind it, not a nav item of its own.

**Registering a tile gets your product opened, not run.** CodeMie does not build it, and the tile grants it no place to run: by default you keep operating it wherever it already lives. Running inside the operator's cluster is a separate arrangement that the tile does not give you (see co-deployment below).

There's no self-service button and no API for this today: the operator registers it for you.

If what you actually want is for an AI assistant to _call_ your product, rather than a human clicking a tile, you probably want something cheaper to build than an application tile:

| What you want                                                | What to build instead             |
| ------------------------------------------------------------ | --------------------------------- |
| An assistant that can call your API or trigger your logic    | An **MCP server**                 |
| A repeatable procedure assistants can follow                 | A **Skill**                       |
| A chain of steps run as one automation                       | A **Workflow**                    |
| Your product's own screen, opened by a human, inside CodeMie | An **Application** (keep reading) |

Only the last row is covered here, and it's the most expensive of the four. If an MCP server, skill, or workflow would also do, build that first: days of work, no platform sign-off. (Your backend calling CodeMie's assistants or workflows is a documented API, no tile needed.)

---

## Picking how it shows up: three options

There are three ways your tile can open your product. Pick the lightest one that actually meets the need, don't reach for the most "integrated" option by default.

| Option     | What happens when a user clicks the tile                       | What you host                                        | How much it "feels like" CodeMie          | Typical effort |
| ---------- | -------------------------------------------------------------- | ---------------------------------------------------- | ----------------------------------------- | -------------- |
| **Link**   | Your product opens in a brand-new browser tab                  | Just a URL                                           | Not at all, it's a separate app           | Days           |
| **iframe** | Your product's own page opens, framed inside CodeMie's layout  | A normal web app                                     | Mostly, but it's still your page in a box | Days to weeks  |
| **Module** | Your product's UI code runs directly inside CodeMie's own page | A built JavaScript bundle (see the module checklist) | Fully, shared layout and navigation       | Weeks          |

A rule of thumb for choosing:

- **Already have a working web app with its own login screen, and don't need it to feel embedded?** Use **Link**.
- **Have a web app, and want it to look embedded without changing much?** Use **iframe**.
- **Need it to genuinely feel like a native part of CodeMie** (shared navigation, no "scrollbar inside a scrollbar")? Use **Module**. This is the heaviest option for both sides and comes with the strictest review, so only reach for it when the surface truly needs to feel native.

**Reusing CodeMie's own capabilities.** A **module** runs inside CodeMie's page, on CodeMie's origin, so it can call CodeMie's API (assistants, workflows, LLMs) as the signed-in user without being handed a token. An **iframe** or **link** is a separate origin and cannot; those call the CodeMie API like any external backend, using their own service-account credentials. Confirm this with the operator before you depend on it: it follows from how modules are mounted, not from a documented contract.

**One more question, independent of the three above: does your product have to run inside the operator's own cluster** (for example, because of data residency requirements)? If yes, that's a co-deployment: beyond registering the tile, you also own the deployment images, the Helm chart, and an infrastructure/security review, on top of whichever of the three types above fits how the product actually renders once it's running there.

### Real-world examples

- **"We already have a support desk, wiki, or vendor tool running somewhere, and just want a shortcut to it."** That's a **Link**. No integration work beyond registering the tile; the product keeps running exactly where it already does, opening in its own tab.
- **"We have a working web app with its own frontend, and want it to look embedded without a rebuild."** That's an **iframe**. A monitoring dashboard or an internal ticketing tool with its own UI is a typical case: it should look native without deep integration work.
- **"We're building a small panel that needs to feel truly native, sharing layout and navigation with CodeMie itself, like a live build-status widget."** That's a **Module**. Heavier to build and review, but it disappears into the rest of the CodeMie UI instead of looking like a guest.

---

## What you actually submit

A tile is one entry in a YAML file called `customer-config.yaml`, and it appears after the CodeMie backend restarts. **Ask the operator where to send that entry.** On most deployments the live copy is managed outside the backend repository, so a pull request there can quietly do nothing.

Whichever option you picked, registration starts as a YAML entry like this one:

```yaml
- id: 'applications:your-slug'
  settings:
    enabled: true
    name: 'Your Product'
    description: 'One line. Body text on the tile, cut off after two lines.'
    type: 'link' # link | iframe | module
    url: 'https://your-product.example.com/'
    icon_url: 'https://your-product.example.com/icon.svg'
    created_by: 'Your Team'
```

A few things worth knowing before you write this file, because they're easy to get wrong and the failure mode is not gentle:

**One malformed entry blanks the Applications page for everyone on that deployment, not just your app.** `url`, `name`, and `type` are all required and nothing validates them: a typo is accepted silently, and the whole page stops loading. Test before you submit.

**The URL must be reachable from a user's browser, not from CodeMie's own servers.** It must use HTTPS on any real deployment, and must be pinned to a specific version rather than a URL whose content can silently change after review, since there's no integrity check on what gets loaded today.

**Nothing under `arguments` (if you add any) is private.** Anyone, logged in or not, can read the full application list including `arguments`. Put endpoints and configuration paths there, never tokens, keys, or secrets.

**Your product handles its own login.** CodeMie passes it no identity or session at all. Whether your login completes silently depends on your product and that deployment sharing an identity provider, which you must confirm per deployment. Test the logged-out case and the cookies-blocked case: the default there is a blank screen.

---

## Test it first

**Against your own app, with no CodeMie involved.**

- **module:** mount it, then navigate away and back at least twice. That's what exposes an incomplete `unmount()`.
- **iframe:** load it logged out, and again with third-party cookies blocked.

**This one needs a running deployment, so it belongs to whoever owns the live `customer-config.yaml`.** Ask them to point `url` at your dev server, restart, and confirm `GET /v1/applications` lists your entry with the fields you expect, then launch the tile at `/applications`. No auth needed, so `curl` works.

---

## Before you submit

Nothing below is enforced by the platform. Skipping an item doesn't block registration; it surfaces later as a blank rectangle, a leaked session, or a page that won't load.

**Every type:**

- [ ] A named owner for this integration, reachable a year from now
- [ ] `url` is HTTPS and resolves from a browser, not just from inside your network
- [ ] `url` is pinned to a version, not a mutable "latest" (nothing checks the integrity of what loads)
- [ ] `icon_url` is HTTPS, on a host you control
- [ ] Nothing secret is in `arguments` (the whole list is readable by anyone, logged in or not)
- [ ] The description says what the product does (it's the tile's body text, cut off after two lines)
- [ ] A user who isn't entitled to your product sees something readable, not a blank page

**iframe, additionally:**

- [ ] A `Content-Security-Policy: frame-ancestors` header naming CodeMie's host, with no `X-Frame-Options: DENY` or `SAMEORIGIN` (either one overrides the CSP and blocks framing outright)
- [ ] Session cookies are `SameSite=None; Secure`, or auth is token-based (same cluster does not mean same origin)
- [ ] Logged-out and session-expired states show something readable, with an "open in a new tab" escape if your identity provider refuses to be framed
- [ ] Nothing inside the frame tries to break out of it or navigate the top window

**module, additionally:**

- [ ] A real ES module build (`import`/`export`, not CommonJS or UMD), loadable with a plain `import()`
- [ ] A component named exactly `CodemieEntryComponent`, exposed with no leading `./` in the bundler's expose map (the leading dot is the usual cause of "module not found")
- [ ] A default export with `mount(el, args)` returning `{ unmount() }`, where `unmount()` releases every timer, listener, subscription, and DOM node it created (the module loads once per page load, so leftovers pile up each time a user navigates away and back)
- [ ] The framework runtime is bundled in, with nothing marked external expecting the host to supply it (CodeMie shares nothing with it)
- [ ] CORS and content type verified on the entry file and every lazily loaded chunk, each being a separate cross-origin request
- [ ] Nothing assumes it owns the page: the Shadow DOM boundary isolates CSS, not origin, cookies, or the JavaScript environment
- [ ] Frontend and architecture sign-off recorded

**co-deployment, additionally:**

- [ ] Container images from a scanned registry, pinned by digest
- [ ] A Helm chart with resource limits and a non-root security context
- [ ] Data storage, backup, and retention ownership named
- [ ] Infrastructure and security review recorded
