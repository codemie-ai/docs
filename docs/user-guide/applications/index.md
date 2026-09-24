---
id: index
title: Applications
sidebar_label: Overview
pagination_prev: user-guide/index
pagination_next: null
sidebar_position: 6
---

import {
ProvidesCompare,
LevelCards,
ScanStrip,
TierCards,
DoAvoid,
StepCards,
} from '@site/src/components/Applications';

# Applications

The **Applications** tab lists tools that other teams build on top of AI/Run CodeMie. CodeMie can list an application, embed it in the CodeMie page, or host it, and can give it corporate sign-in, AI models, and the CodeMie platform API. In return, applications shown inside CodeMie or hosted by it run regular security scans.

This page is for project and delivery managers. The engineering details are in the [Integration Guide](./integration-guide.md).

## What CodeMie provides and what the application team provides

<ProvidesCompare
provides={[
{ icon: 'tile', title: 'A tile in the Applications tab', text: 'Application name and icon, visible to every CodeMie user' },
{ icon: 'user', title: 'Corporate sign-in', text: 'The same login as CodeMie. Hosted applications need no extra login step' },
{ icon: 'model', title: 'AI models', text: 'GPT, Claude, and Gemini through one gateway, with per-user cost tracking and budgets' },
{ icon: 'code', title: 'CodeMie platform API', text: 'Assistants, workflows, indexed project data, and existing Jira, Git, and Confluence connections' },
{ icon: 'share', title: 'A place in CodeMie assistants', text: 'Application features become tools that any CodeMie assistant can call' },
{ icon: 'server', title: 'Hosting (by agreement)', text: 'Cluster, CodeMie web address, certificates, secret store, database, preview environment, and managed releases' },
]}
expects={[
{ icon: 'owner', title: 'A named owner', text: 'A product owner, a support contact, and an escalation path. Users report problems to CodeMie support first' },
{ icon: 'lock', title: 'Access control', text: 'The application decides who can do what. CodeMie shows every tile to every user' },
{ icon: 'shield', title: 'Regular security scans', text: 'Code, dependency, container, and web scans, with no open critical findings' },
{ icon: 'cycle', title: 'An automated release pipeline', text: 'Builds come from a corporate repository, never copied by hand' },
{ icon: 'data', title: 'Protected data', text: 'Encrypted, no personal data in logs, secrets kept only in a secret store' },
{ icon: 'pulse', title: 'AI calls through CodeMie', text: 'Guardrails, budgets, and cost reporting apply to every user' },
]}
/>

## Three levels of integration

Each level adds capabilities and adds requirements. Start at the lowest level that meets the need.

<LevelCards
levels={[
{
n: 1,
title: 'Linked',
preview: 'link',
text: 'The tile opens the application in a new browser tab. The application runs wherever its team runs it.',
facts: [
['Runs on', 'Application team infrastructure'],
['Sign-in', "The application's own corporate login"],
],
effort: 1,
},
{
n: 2,
title: 'Embedded',
preview: 'embedded',
text: 'The application appears inside the CodeMie page, so users never leave CodeMie.',
facts: [
['Runs on', 'Application team infrastructure'],
['Sign-in', 'Must work inside the CodeMie page, which often breaks on another domain'],
],
effort: 2,
},
{
n: 3,
title: 'Hosted',
preview: 'hosted',
text: "The application runs in CodeMie's cluster under a CodeMie web address, embedded in the page.",
facts: [
['Runs on', "CodeMie's cluster"],
['Sign-in', 'Automatic, shared with CodeMie'],
],
effort: 3,
highlight: true,
},
]}
/>

:::info Plug-in variant
An application can also load as a component inside CodeMie's own page, running with the user's CodeMie session. This variant needs the highest trust and a code review by the corporate operations team before each release.
:::

:::tip Connected at any level
At any level, an application can expose its features as tools that CodeMie assistants call. Users can then work with the application from a chat.
:::

## What each level gets

| Capability                      | 1 · Linked                        | 2 · Embedded                      | 3 · Hosted                                                           |
| ------------------------------- | --------------------------------- | --------------------------------- | -------------------------------------------------------------------- |
| Tile in the Applications tab    | ✅ Yes                            | ✅ Yes                            | ✅ Yes                                                               |
| Corporate sign-in               | ➖ The application runs the login | ➖ The application runs the login | ✅ Automatic                                                         |
| AI models through CodeMie       | ✅ Yes                            | ✅ Yes                            | ✅ Yes                                                               |
| CodeMie platform API            | ✅ From the application server    | ✅ From the application server    | ✅ From the application server                                       |
| Tools inside CodeMie assistants | ✅ Yes                            | ✅ Yes                            | ✅ Yes                                                               |
| Web address under CodeMie       | ❌ No                             | ❌ No                             | ✅ `/your-app`                                                       |
| Hosting, database, secrets      | ❌ Application team               | ❌ Application team               | ✅ CodeMie cluster                                                   |
| Preview environment             | ❌ Application team               | ❌ Application team               | ✅ Included                                                          |
| Releases                        | ❌ Application team               | ❌ Application team               | ➖ The team's pipeline builds; the corporate operations team deploys |

✅ provided by CodeMie · ➖ shared work · ❌ not provided

## What CodeMie expects

These requirements apply to **embedded and hosted applications** (levels 2 and 3). Scans run regularly, not only once before go-live.

<ScanStrip
items={[
{ title: 'Code scan', text: 'SAST on every release' },
{ title: 'Dependency scan', text: 'Every release and weekly' },
{ title: 'Container scan', text: 'Trivy on every image, every release and weekly' },
{ title: 'Web scan', text: 'DAST against the running application, regularly' },
{ title: 'Secret scan', text: 'On every commit' },
]}
/>

<TierCards
tiers={[
{
title: 'Embedded and hosted',
levels: [2, 3],
items: [
'All scans above run on schedule, with reports shared with the corporate operations team',
'No open Critical or Urgent findings; fixes land before the next release',
'A named owner, support contact, and escalation path',
'Access control inside the application, because every user can see the tile',
'HTTPS and a stable web address',
'No passwords or keys in the tile settings, because every user can read them',
'Sign-in and every screen work inside the CodeMie page',
'The layout fits CodeMie: no second header, no broken styles',
'Plug-in variant: the corporate operations team reviews the code before each release',
],
},
{
title: 'Hosted, in addition',
levels: [3],
highlight: true,
items: [
'Scans are built into the release pipeline, so an image cannot ship without them',
'Builds come from a corporate repository through an automated pipeline',
'No credentials in source code or container images',
"Secrets only in CodeMie's secret store; no personal data in logs",
'All AI calls go through CodeMie and are tied to the signed-in user',
'At least one release runs on preview before production',
],
},
]}
/>

## Do and don't

<DoAvoid
dos={[
'Use the shared sign-in, so users move from CodeMie to the application without a second login',
'Send every release to preview first, then production, through a reviewed change',
'Give the application team read-only access to its own logs and status',
'Expose application features as tools that assistants can use in chat',
'Keep a separate database per application, with passwordless cloud access',
]}
avoid={[
'Ship container images from personal accounts or copy them by hand',
'Run a release pipeline with tests but no security scanning',
'Write access tokens or keys into source code',
'Use one shared AI key for all users, which hides who spends what',
'Ignore which user is signed in',
'Give every user power-user rights by default',
]}
/>

## Onboarding

Purple steps apply to hosted applications only.

<StepCards
steps={[
{ title: 'Intake', text: 'Purpose, owner, integration level, users, and the data the application touches.', who: 'application team' },
{ title: 'Access', text: 'Sign-in client, CodeMie project, and AI model access.', who: 'operations team' },
{ title: 'Preview', text: 'Deployed to the preview environment and tested end to end.', who: 'both', highlight: true },
{ title: 'Security review', text: 'Embedded and hosted applications: scan reports and checklist reviewed against the requirements above.', who: 'application team' },
{ title: 'Go-live', text: 'The tile is added and CodeMie is restarted. Hosted applications also deploy to production.', who: 'operations team' },
{ title: 'Run', text: 'The application team handles incidents and releases, and every release repeats the scans.', who: 'application team' },
]}
/>

:::note
Adding or changing a tile requires a CodeMie configuration change and a restart by the corporate operations team. There is no self-service screen, so agree on a date early.
:::
