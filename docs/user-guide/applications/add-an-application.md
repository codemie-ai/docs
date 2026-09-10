---
id: add-an-application
title: Bringing an Application to CodeMie
sidebar_label: Add an Application
sidebar_position: 1
description: A plain-language guide for teams who want their own product to show up in CodeMie, whether it already exists or is being built for it.
pagination_prev: user-guide/applications/index
pagination_next: null
---

# Bringing an application to CodeMie

**Who this is for:** a team that wants its own product to show up inside CodeMie, next to the built-in features. It applies whether the product already runs somewhere (a web app, a dashboard, an internal tool) or you're building it specifically to live inside CodeMie.

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

## Picking how it shows up

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

**Reusing CodeMie's own capabilities.** The shipped pattern is server-side: a co-deployed product gets its own API key for CodeMie's LiteLLM proxy and calls the same LLM gateway CodeMie uses. MF Lens does this. Ask the operator for a key. A **module** additionally runs on CodeMie's origin and can reach CodeMie's API on the signed-in user's session, but nothing registered today relies on that and it isn't a documented contract, so confirm before you depend on it.

### Co-deployment: a separate question

Does your product have to run inside the operator's own cluster, for example because of data residency requirements? If yes, that's a **co-deployment**. It's independent of the three types above: you still pick one of them for how the tile renders, and you additionally own the deployment images, the Helm chart, and an infrastructure and security review.

### Examples

- **link (hypothetical).** A team already runs an internal incident dashboard on its own host with its own sign-on. They want it one click from CodeMie, not embedded. A link tile pointing at the dashboard's sign-on entry point opens it in a new tab, with no integration work beyond registering the tile.
- **iframe.** AI Code Explorer (AICE), from the AICE Team, is a code analysis and exploration product. It runs in the operator's cluster and is framed from a path on CodeMie's own host, so it needs no third-party-cookie or framing work.
- **iframe, co-deployed.** MF Lens, from the AIMF Team, does the same for mainframe code. It deploys its own backend, frontend and graph database into the cluster, making it a co-deployment as well as a tile.
- **module.** Technology Copilot ships its UI as a module and brings its own identity-provider client config through `arguments`.

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

**Your product authenticates its own users.** CodeMie runs no handshake with it: no token, no session, no `postMessage`. To get single sign-on, register your product as a client with the same identity provider that deployment uses, so your own login completes silently against the session the user already has. Ask the operator for that; the provider differs per deployment. For an `iframe`, silent login also depends on third-party cookies and on whether your identity provider tolerates being framed, unless it is served from a path on CodeMie's own host, as AICE and MF Lens are.

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
