---
id: hosted-applications
title: Custom Applications (Hosted Applications)
sidebar_label: Custom Applications
sidebar_position: 5
description: Enable, configure, deploy, and operate custom (hosted) static web applications in AI/Run CodeMie
pagination_prev: admin/configuration/index
pagination_next: null
---

# Custom Applications (Hosted Applications)

Hosted applications let CodeMie users upload a small static web page (a single HTML file or a ZIP archive of a prebuilt static build), keep it private, share it with colleagues or the whole organization, and open it inside CodeMie on the **Applications** page. The feature is intended for **presentations**: slides, reports, and demos. It is not a platform for interactive applications.

CodeMie only stores and serves static bytes. It never builds an artifact, never runs uploaded server-side code, and starts no runtime per application. Uploaded code runs in the viewer's browser on a **separate, isolated content origin**, so it cannot read CodeMie cookies, tokens, or storage.

:::info Off by default
The feature is disabled until you turn it on and complete the deployment steps on this page. While it is off, no hosted background work runs, the UI never calls the hosted API, and the Applications page shows only Platform apps.
:::

## Content Restrictions

Uploaded pages run under a fixed browser policy that cannot be changed by configuration. Tell users to design them as self-contained static presentations.

| Area                | Policy                                                                                                                                                                                                  |
| ------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Resources           | Scripts, styles, images, fonts, and media are allowed from the page's own origin only (images and fonts may also use `data:`, media and images `blob:`). External CDNs and sites are blocked.           |
| Network             | `connect-src 'self'`: requests only to the same content origin, so no calls to APIs or other sites.                                                                                                     |
| Forms               | `form-action 'none'` and no `allow-forms` in the sandbox: forms cannot submit.                                                                                                                          |
| Dialogs and windows | The sandbox grants only `allow-scripts` and `allow-same-origin`, so modal dialogs, popups, top-level navigation, and downloads are blocked.                                                             |
| Embedded content    | `frame-src`, `object-src`, `worker-src`, and `manifest-src` are `'none'`. Dynamic evaluation and workers are reported as restricted capabilities.                                                       |
| Device features     | The permissions policy denies camera, microphone, geolocation, payment, USB, and fullscreen.                                                                                                            |
| Allowed file types  | `html`, `htm`, `css`, `js`, `mjs`, `json`, `txt`, `csv`, `svg`, common image and font formats, and `mp3`, `mp4`, `ogg`, `webm` media.                                                                   |
| Rejected content    | Server files (`server.js`, `package.json`, `web.config`, `nginx.conf`), `node_modules`, `.git`, `server` or `ssr` folders, hidden files, source maps, private keys, and SVG with a DOCTYPE or entities. |

A page that references external resources is accepted with an `EXTERNAL_DEPENDENCY` warning, and the resources do not load.

## How It Works

![Hosted Applications high-level architecture](./images/hosted-applications-architecture.drawio.png)

| Component      | Role                                                                                                                             |
| -------------- | -------------------------------------------------------------------------------------------------------------------------------- |
| CodeMie UI     | Applications page, upload and sharing dialogs, and the embedded viewer at `/apps/{id}`.                                          |
| CodeMie API    | Management API (`/v1/hosted-applications*`), content gateway, validation workers, and maintenance loop. One process serves both. |
| Content domain | A separate registrable domain. Every release is served from its own `v-<release>.<content domain>` origin.                       |
| Validator pod  | A private pod with a sandboxed parser and a ClamAV scanner. It checks every upload before it can be served.                      |
| Object storage | A dedicated private S3 or GCS bucket that holds the validated files.                                                             |
| PostgreSQL     | Applications, versions, sharing, sessions, audit records, and the job queue (ten tables in the core schema).                     |

No Redis or other new infrastructure is required.

## Prerequisites

| Area            | Requirement                                                                                                                                                                                                                                |
| --------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| Content domain  | A **separate registrable domain** (for example `apps-content.example.net` when CodeMie runs on `example.com`). Never a subdomain of CodeMie, the identity provider, or any other first-party site.                                         |
| DNS and TLS     | Wildcard DNS record `*.<content domain>` pointing to the ingress, and a valid wildcard certificate for `*.<content domain>` on port 443.                                                                                                   |
| Ingress         | Host header preserved, no rewriting of `X-Forwarded-Host`, no caching or authentication on content hosts. See [Ingress](#ingress).                                                                                                         |
| Identity        | User management enabled (`ENABLE_USER_MANAGEMENT=true`). Any `IDP_PROVIDER` works, with JWKS validation on or off. See [Identity](#identity).                                                                                              |
| Storage         | A dedicated private bucket on S3 (`FILES_STORAGE_TYPE=aws`) or GCS (`FILES_STORAGE_TYPE=gcp`), used by one deployment only. Azure is not supported yet.                                                                                    |
| Validator nodes | Linux **amd64** nodes (the pinned ClamAV image is amd64-only) with **Landlock ABI 3 or later** (normally Linux 6.2+) and a runtime seccomp profile that permits Landlock system calls. The validator refuses to start without confinement. |
| Database        | Alembic revisions `16001d9b0c1d` and `5c7e1a93b0d4`, applied by the normal migration step.                                                                                                                                                 |
| Validator image | Built from the **same commit** as the API image. Both compute the same validation policy digest, and a mismatch makes validation unavailable.                                                                                              |

## Configuration Overview

Enabling the feature touches four places:

| Where                                           | What                                                                      | Section                                       |
| ----------------------------------------------- | ------------------------------------------------------------------------- | --------------------------------------------- |
| Customer configuration (`customer-config.yaml`) | The `features:hostedApplications` switch, read by both the API and the UI | [Feature switch](#feature-switch-api-and-ui)  |
| CodeMie API environment variables               | Content domain, secrets, storage, validator connection, quota             | [Backend parameters](#backend-parameters)     |
| Validator pod environment variables             | Service key, ClamAV connection, bind address                              | [Validator parameters](#validator-parameters) |
| Ingress and DNS                                 | Wildcard content host, upload limits and timeouts                         | [Ingress](#ingress)                           |

The CodeMie UI needs **no dedicated configuration**. See [UI configuration](#ui-configuration).

## Feature Switch (API and UI)

Set `enabled: true` on the `features:hostedApplications` component of the customer configuration. See [Customer Feature Configuration](./customer-feature-configuration.md) for how the file is deployed.

```yaml
components:
  - id: "features:hostedApplications"
    settings:
      enabled: true
      name: "Custom Applications"
      description: "Upload, share and open custom static web applications on the Applications page"
```

| Aspect               | Behavior                                                                                                                                                                                                              |
| -------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Environment override | `FEATURE_HOSTED_APPLICATIONS=true\|false` overrides `enabled`, like every `features:*` flag, but **only where the component exists**. A customer ConfigMap that replaces the default file must include the component. |
| UI and API agreement | The UI reads the same flag from `GET /v1/config`, so both always agree.                                                                                                                                               |
| When it is read      | At API startup. Restart the API after changing it.                                                                                                                                                                    |

### Startup checks

When the flag is on, the API checks the deployment. If the deployment cannot run the feature safely, the feature **stays off** and one warning is logged:

```text
Hosted applications are enabled but unavailable: <reason>
```

The reason names the failing setting and never a configured value. If the hosted runtime fails to start, the API still starts, logs `Hosted applications failed to start and stay unavailable: <error class>` at error level, and serves the feature as off (`403 FEATURE_DISABLED` on management routes, closed `503` on content hosts). The UI then shows only Platform apps.

| Reason (log text)                                                                         | Fix                                                                                                          |
| ----------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------ |
| `HOSTED_APPS_CONTENT_DOMAIN is not set`                                                   | Set the content domain.                                                                                      |
| `HOSTED_APPS_CREDENTIAL_SECRET must be at least 32 characters`                            | Generate a longer secret.                                                                                    |
| `Production content requires a registrable HTTPS domain`                                  | Use a real registrable domain without a port (a port is only allowed for `apps.localhost` with `ENV=local`). |
| `FRONTEND_URL must be the HTTPS address of the CodeMie UI`                                | Set `FRONTEND_URL` to the HTTPS UI address.                                                                  |
| `Content must use a registrable domain separate from <SETTING>`                           | The content domain shares a registrable domain with the named first-party or identity provider URL setting.  |
| `Hosted applications need user management (ENABLE_USER_MANAGEMENT=true)`                  | Enable user management.                                                                                      |
| `JWT_ISSUER must be 1 to 255 characters`                                                  | Set `JWT_ISSUER`.                                                                                            |
| `The configured identity provider is not installed`                                       | Non-`local` providers need the enterprise package.                                                           |
| `Hosted applications do not support Azure storage yet`                                    | Use `aws` or `gcp` for `FILES_STORAGE_TYPE`.                                                                 |
| `HOSTED_APPS_STORAGE_BUCKET is required for object storage`                               | Set the dedicated bucket.                                                                                    |
| `HOSTED_APPS_STORAGE_DIR must be an absolute path` / `cannot be inside FILES_STORAGE_DIR` | Only for `filesystem` (development).                                                                         |
| `HOSTED_APPS_VALIDATOR_KEY must be at least 32 characters`                                | Generate a longer key.                                                                                       |
| `A valid validation service URL is required`                                              | `HOSTED_APPS_VALIDATOR_URL` must be a plain `http(s)://host[:port]` without path, query, or credentials.     |

Accounts that cannot use the feature (for example external or service accounts, or requests with no usable sign-in token) see it as unavailable: capabilities answer `view: false` and hosted routes answer `403 ACCOUNT_NOT_SUPPORTED`. They never receive a `401`, which would send them back to sign-in.

## Backend Parameters

All parameters are environment variables of the CodeMie API. In the `codemie-api` Helm chart, set them through `extraEnv`. Secrets must come from the platform secret manager (Kubernetes Secrets, External Secrets, Vault), never from source control or plain values.

### Required

| Parameter                       | Example                       | Description                                                                                                                                                                                                                                                                                  |
| ------------------------------- | ----------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `FEATURE_HOSTED_APPLICATIONS`   | `true`                        | Optional override of the customer-config switch. See [Feature switch](#feature-switch-api-and-ui).                                                                                                                                                                                           |
| `HOSTED_APPS_CONTENT_DOMAIN`    | `apps-content.example.net`    | Registrable domain, separate from every first-party domain. Releases are served from `v-<release>.<domain>` on port 443. Setting it installs host dispatch even while the feature is off, so content hosts stay closed. Local development: `apps.localhost:<backend port>` with `ENV=local`. |
| `HOSTED_APPS_CREDENTIAL_SECRET` | secret, 32 bytes or more      | HMAC key for content sessions, launch tickets, pagination cursors, and idempotency records. Independent from every other secret. Read [Secrets and rotation](#secrets-and-rotation) before rotating.                                                                                         |
| `HOSTED_APPS_VALIDATOR_KEY`     | secret, 32 characters or more | Service key shared with the validator pod as `VALIDATOR_SERVICE_KEY`.                                                                                                                                                                                                                        |
| `FILES_STORAGE_TYPE`            | `aws` or `gcp`                | Selects the hosted storage backend: `aws` uses S3, `gcp` uses GCS. `filesystem` is for local development and tests only. `azure` keeps the feature unavailable.                                                                                                                              |
| `HOSTED_APPS_STORAGE_BUCKET`    | `codemie-hosted-apps`         | Required for `aws` and `gcp`. A dedicated bucket, never the generic files bucket. The API never creates it.                                                                                                                                                                                  |

### Optional

| Parameter                                  | Default                 | Description                                                                                                                                                                                             |
| ------------------------------------------ | ----------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `HOSTED_APPS_VALIDATOR_URL`                | `http://127.0.0.1:8091` | Validator Service address. In a cluster use `http://codemie-hosted-validator:8091`. No path, query, or credentials. Plain HTTP stays inside the cluster; use `https://` if the validator serves TLS.    |
| `HOSTED_APPS_QUOTA_BYTES`                  | `2147483648` (2 GiB)    | Storage per owner: every retained version, covers, and uploads in progress. Minimum 1 MiB.                                                                                                              |
| `HOSTED_APPS_STORAGE_S3_GRACE_SECONDS`     | `30`                    | S3 only. Not negative. Cleanup waits for the writer lease end plus this grace. Startup refuses S3 when the clock skew between S3, the database, and the pod exceeds it (log code `STORAGE_CLOCK_SKEW`). |
| `HOSTED_APPS_STORAGE_SWEEP_SECONDS`        | `3600`                  | Interval of the `hosted-storage-sweep` task that deletes old orphaned objects (S3 and GCS only).                                                                                                        |
| `HOSTED_APPS_STORAGE_SWEEP_BUDGET_SECONDS` | `20`                    | Time budget of one sweep run.                                                                                                                                                                           |
| `HOSTED_APPS_STORAGE_DIR`                  | empty                   | `filesystem` storage only (development and tests). Absolute path that is not `FILES_STORAGE_DIR` and not inside it.                                                                                     |

### Platform settings the feature reuses

These already exist in a CodeMie deployment. Check that they are correct before enabling the feature.

| Value                                               | Source                                                                                                                                         | Why it matters                                                                                                                                            |
| --------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------- |
| UI origin                                           | `FRONTEND_URL`                                                                                                                                 | The only origin allowed to frame content and send mutations (content `frame-ancestors`, CSRF checks, launch policy). Must be the HTTPS address of the UI. |
| Organization ID                                     | `JWT_ISSUER`                                                                                                                                   | Identifies the organization. Changing it later hides existing applications (see [Identity](#identity)).                                                   |
| Identity provider                                   | `IDP_PROVIDER`, `ENABLE_USER_MANAGEMENT`, optional `JWKS_*`                                                                                    | Selects how the user's sign-in token is read. See [Identity](#identity).                                                                                  |
| First-party URLs checked against the content domain | `CALLBACK_API_BASE_URL`, `KEYCLOAK_LOGOUT_URL`, `KEYCLOAK_ADMIN_URL`, `TOKEN_EXCHANGE_URL`, `BROKER_AUTH_LOCATION_URL`, `JWKS_TRUSTED_ISSUERS` | None of them may share a registrable domain with `HOSTED_APPS_CONTENT_DOMAIN`.                                                                            |
| Storage region and credentials                      | `AWS_S3_REGION` (then `AWS_DEFAULT_REGION`) and the default credential chain; GCS default credentials                                          | The hosted backends take region and credentials from the files-storage settings. A custom S3 endpoint (MinIO, Ceph) is not supported.                     |
| Directory (membership, people search)               | PostgreSQL `users` table                                                                                                                       | The feature calls no identity provider API.                                                                                                               |

### Helm values example

```yaml
# codemie-api values.yaml
extraEnv:
  - name: FEATURE_HOSTED_APPLICATIONS
    value: "true"
  - name: HOSTED_APPS_CONTENT_DOMAIN
    value: "apps-content.example.net"
  - name: FILES_STORAGE_TYPE
    value: "aws" # or "gcp"
  - name: HOSTED_APPS_STORAGE_BUCKET
    value: "codemie-hosted-apps"
  - name: HOSTED_APPS_VALIDATOR_URL
    value: "http://codemie-hosted-validator:8091"
  - name: HOSTED_APPS_CREDENTIAL_SECRET
    valueFrom:
      secretKeyRef:
        name: codemie-hosted-applications
        key: credential-secret
  - name: HOSTED_APPS_VALIDATOR_KEY
    valueFrom:
      secretKeyRef:
        name: codemie-hosted-applications
        key: validator-key
```

Create the secret before the rollout:

```bash
kubectl -n codemie create secret generic codemie-hosted-applications \
  --from-literal=credential-secret="$(openssl rand -base64 48)" \
  --from-literal=validator-key="$(openssl rand -base64 48)"
```

:::warning Dedicated storage
`FILES_STORAGE_TYPE` is a platform-wide setting that also selects the backend for generic CodeMie files. The hosted feature uses the same type but always a **different bucket** (`HOSTED_APPS_STORAGE_BUCKET`). A deployment on Azure Blob Storage cannot use this feature yet.
:::

### Fixed limits

These values are constants in the code. Changing one requires a code change, not a setting.

| Area             | Value                                                                                                                                                               |
| ---------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Uploads          | HTML up to 20 MiB. ZIP up to 100 MiB, 500 MiB unpacked, 50 MiB per file, 5,000 files. One upload may take 900 seconds and may stall for 60 seconds.                 |
| Card cover image | One PNG, JPEG, or WebP per application, up to 1 MiB. Counts toward the owner quota.                                                                                 |
| Per person       | 500 applications (trashed ones count until permanently deleted), 500 folders, 4 uploads in progress, 2 validations at a time.                                       |
| Versions         | 10 accepted versions per application, plus the live and selected versions. An application keeps at most 100 versions of any state.                                  |
| Retention        | Rejected, failed, or canceled versions 30 days. Trash 30 days. Audit records 180 days.                                                                              |
| Sessions         | Launch ticket 30 seconds. Viewing session 15 minutes, bounded by the sign-in (see [Identity](#identity)).                                                           |
| Workers          | 2 validation workers per API process. Jobs are leased in PostgreSQL, so every replica can run them.                                                                 |
| Database         | A separate pool of 10 connections per API process. A request that waits 2 seconds fails with `503 SERVICE_BUSY`. Add the pool to the per-replica connection budget. |
| Content capacity | Per process: 64 requests in flight, at most 16 for one viewer. A request waits at most 5 seconds for a slot and takes at most 120 seconds.                          |
| JSON requests    | 32 KiB for hosted JSON requests.                                                                                                                                    |

There are no per-user request rate limits. Floods from outside the platform are handled at the edge, as for every other CodeMie route.

## UI Configuration

The CodeMie UI has **no environment variable, build argument, or Helm value of its own** for this feature.

| Aspect                   | Behavior                                                                                                                                                                                                                                |
| ------------------------ | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Feature visibility       | The UI reads `features:hostedApplications` from `GET /v1/config`. When it is off, the Applications page lists only Platform apps and the `/apps/{id}` and `/apps/{id}/manage` routes redirect there. The UI never calls the hosted API. |
| API address              | The UI uses the same API base URL as for every other CodeMie call.                                                                                                                                                                      |
| Content origin           | Not configured in the UI. The API returns the release origin in the launch response (`POST /v1/hosted-applications/{id}/launch`), and the UI validates it before use.                                                                   |
| UI origin trusted by API | `FRONTEND_URL` on the **API** side. If it does not match the address in the browser, the viewer is refused.                                                                                                                             |
| Per-user availability    | `GET /v1/hosted-applications/capabilities` tells the UI whether the signed-in user can view and create applications.                                                                                                                    |

### What the UI does at runtime

1. The user opens `/apps/{id}`. The UI asks the API for a launch ticket.
2. The UI renders a fixed, trusted scaffold page with its own strict `Content-Security-Policy` (`frame-src` limited to the single release origin).
3. The UI posts the one-time ticket to the content origin (`POST /_platform/launch`) into the scaffold's child frame.
4. The content origin sets a cookie scoped to the user, application, release, and purpose, then serves the application.

The UI refuses to launch if the content origin is not HTTPS (plain HTTP is accepted only for `*.localhost`), if it differs from the origin of the returned form action, or if it has the same host as the CodeMie UI.

### UI routes

| Route                                                                     | Purpose                                |
| ------------------------------------------------------------------------- | -------------------------------------- |
| `/apps`, `/apps/shared`, `/apps/explore`, `/apps/trash`, `/apps/platform` | Catalog per collection                 |
| `/apps/folders/:folderId`                                                 | Folder view                            |
| `/apps/new`                                                               | Create dialog (deep link)              |
| `/apps/:id`                                                               | Embedded viewer                        |
| `/apps/:id/preview/:releaseId`                                            | Owner preview of one version           |
| `/apps/:id/manage`                                                        | Details, versions, sharing, lifecycle  |
| `/applications`                                                           | Redirects to `/apps` (old entry point) |

### Things to check on the UI side

- **Response headers on the UI host.** The shipped UI `nginx.conf` sets no `Content-Security-Policy`, `X-Frame-Options`, or `Permissions-Policy`. If your edge adds a CSP to the UI host, its `frame-src` (or `child-src`) must allow `https://*.<content domain>`, and `connect-src` for the API must stay unchanged. Otherwise the viewer shows an empty frame.
- **Cookies in embedded mode.** The content cookie is a third-party, partitioned cookie. Browsers that block third-party storage entirely can fail to start the embedded viewer. The viewer then offers **Open in new tab**. Verify both paths in your target browsers.
- **Opener.** The content origin sends `Cross-Origin-Opener-Policy: same-origin`, so a tab opened for an application has no link back to the CodeMie tab. This is intentional.
- **Matching versions.** Deploy a UI version and an API version that both include the feature. A UI release without it never shows the feature, whatever the API reports.

## Ingress

### Content hosts (wildcard)

Route `*.<content domain>`, and only that, to the CodeMie API Service with the wildcard certificate. The `hosted-applications/kubernetes.yaml` manifest in the CodeMie repository contains a controller-neutral Ingress without annotations. Configure your controller so that it:

- keeps Host, path, and query unchanged (the `?preview=static` query must stay intact);
- sends `X-Forwarded-Host` only as an exact copy of Host, or not at all, and sends no `Forwarded` or `X-Original-Host` header (anything else is refused with a closed `400`);
- allows responses of 130 seconds and request bodies of 64 KiB (only the small launch form is posted here);
- adds no authentication proxy (oauth2-proxy), rewrite, shared cache, CORS, SPA fallback, static-file alias, CDN, or public bucket for hosted bytes;
- logs no request or response bodies and redacts `Cookie`, `Set-Cookie`, and `Authorization`.

:::note Retired controller
The community ingress-nginx controller was retired in March 2026 and no longer receives security fixes. Whichever maintained controller serves the platform should serve the content hosts with the behavior above.
:::

### Management host (existing CodeMie API ingress)

| Setting                | Value                                                                                                                                     |
| ---------------------- | ----------------------------------------------------------------------------------------------------------------------------------------- |
| Request body limit     | At least `110m` (artifact uploads carry up to 100 MiB). For ingress-nginx: `nginx.ingress.kubernetes.io/proxy-body-size: 110m` or higher. |
| Read and send timeouts | At least `900` seconds, the upload time limit. For ingress-nginx: `proxy-read-timeout` and `proxy-send-timeout`.                          |
| Request buffering      | Stream request bodies to the backend instead of buffering them on the ingress disk, where the controller allows it.                       |
| Rate limits            | Per-client limits for `/v1/hosted-applications*`, `/v1/sharing/recipients`, and the content host are recommended at the edge.             |

The default `codemie-api` chart already sets `proxy-body-size: 900m` and `proxy-read-timeout: "600"`. Raise `proxy-read-timeout` to `900` and add `proxy-send-timeout: "900"` before enabling the feature.

### Probes and network

Kubelet HTTP probes reach the API by pod IP, which is outside the content namespace, so the existing `/v1/healthcheck` startup, liveness, and readiness probes keep working. The API pods need egress to the validator Service on port 8091. The validator pod needs only DNS and HTTPS to the ClamAV signature mirror (prefer a private mirror).

## Identity

Hosted endpoints require a verified identity. The API records it after the platform has authenticated the request and loaded the user. Hosted applications trust CodeMie's own authentication and need no identity provider API.

- Set `ENABLE_USER_MANAGEMENT=true`.
- Every `IDP_PROVIDER` works (`local`, `keycloak`, `oidc`, `entraid-oidc`), with JWKS validation on or off.
- The organization ID is `JWT_ISSUER`. The principal is the CodeMie user ID.
- Membership checks and people search read only the `users` table: a row with `is_active` true, `deleted_at` empty, and `user_type` `regular`. No `KEYCLOAK_ADMIN_*` setting is needed.
- Only regular accounts can use the feature.

### Which token is used

| Provider                             | Token                                                         |
| ------------------------------------ | ------------------------------------------------------------- |
| `local`                              | The validated local JWT.                                      |
| `keycloak`                           | The access token in the `x-auth-request-access-token` header. |
| `oidc`, `entraid-oidc`               | The token in `Authorization: Bearer`.                         |
| Any provider with JWKS validation on | The token that the JWKS validator verified.                   |

### Token expiry

Hosted applications check token expiry exactly where the platform does.

| Mode (audit value)                                                          | Behavior                                                                                                                                                                                                                              |
| --------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `local_jwt`, `jwks`                                                         | An expired token is refused. The token's `exp` ends the viewing session, and `auth_time` limits it to 24 hours after sign-in.                                                                                                         |
| `platform_jwt` (`keycloak`, `oidc`, `entraid-oidc` without JWKS validation) | The platform accepts the forwarded token whatever its `exp`; oauth2-proxy decides how long the sign-in lasts. Each request the platform accepts keeps the sign-in valid for another 24 hours. Viewing sessions still last 15 minutes. |

### Operational notes

- **No leeway after `exp`.** The JWKS validator accepts a token for up to `JWKS_LEEWAY_SECONDS` after `exp`. Hosted applications refuse it at `exp`.
- **Tokens without `sid`.** Entra ID access tokens and many OIDC access tokens carry no `sid`. A `local_jwt` or `jwks` viewing session then lasts one token lifetime.
- **Without JWKS validation** the API trusts the token that oauth2-proxy forwards and decodes its claims without checking the signature again. The API must be reachable only through the ingress.
- **Content domain versus identity provider.** The content domain must not share a registrable domain with the identity provider. Startup cannot check this for `oidc` and `entraid-oidc` without JWKS validation, so verify it manually.
- **Missing token log.** `Hosted applications found no usable sign-in token: cause=<cause> IDP_PROVIDER=<provider>` is logged at most once per 10 minutes per cause per process. Causes: `missing`, `not_jwt`, `expired`, `future_iat`, `bad_sid`, `bad_claims`, `bad_principal`.
- **Known gap.** A user disabled or deleted only in the identity provider stays active in `users` until a CodeMie administrator deactivates them. That user cannot sign in again, so cannot start a new viewing session, but still appears in people search.
- **Organization boundary.** The organization is every active regular user of the issuer. It is not a CodeMie project, team, or tenant. "Everyone in the organization" sharing reaches every active user. Do not use organization-wide sharing when several mutually isolated customers share one deployment.

:::warning Upgrading from Keycloak-based identity
A deployment that ran hosted applications earlier with Keycloak stored `org_id` as the Keycloak realm URL. After the upgrade the organization is `JWT_ISSUER`, and applications stored under the old value are no longer visible. No migration moves them, and their stored objects stay in storage. Remove the old rows and objects manually if you want the space back.
:::

## Storage

- Use a **dedicated private bucket**, never the generic files bucket (`AWS_S3_BUCKET_NAME`, per-owner GCS buckets). Create it before the rollout. The API never creates buckets.
- **One bucket per deployment.** Two deployments on one bucket read the same `.hosted/storage-id` marker and each sweep deletes the objects of the other.
- Bucket settings: versioning off, no Object Lock, public access blocked. Never expose the bucket through a static-file server and never grant it to the validator pod.
- Reserved keys: `.hosted/storage-id` (bucket marker, never delete), `.fences/` and `.staging/` (GCS write state).
- Owner-uploaded card covers are not in the bucket. They live in the database table `application_covers`, so database backups include them.

| Backend | Lifecycle rule                                               | IAM                                                                                                                                                                          |
| ------- | ------------------------------------------------------------ | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| S3      | Abort incomplete multipart uploads after 1 day.              | `s3:GetObject`, `s3:PutObject`, `s3:DeleteObject`, `s3:ListBucket`, `s3:ListBucketMultipartUploads`, `s3:AbortMultipartUpload`, `s3:ListMultipartUploadParts` on the bucket. |
| GCS     | Delete objects under `.staging/` and `.fences/` after 1 day. | `roles/storage.objectUser` on the bucket. No `storage.buckets.get` and no Token Creator role: the API uses no signed URLs.                                                   |

S3 writes are multipart uploads signed against the database writer lease. Keep the clocks of the API pods and the database in sync.

A cleanup task (`hosted-storage-sweep`) runs every `HOSTED_APPS_STORAGE_SWEEP_SECONDS`. It deletes objects older than 1 day under prefixes of deleted attempts or with no attempt row, skips reserved keys, and logs an `ERROR` event `hosted_storage_orphans_deleted` with the key count. A slow or unavailable bucket stalls hosted requests, not the rest of the API.

## Validator Pod

The validator checks static-bundle structure, paths, file types, expansion limits, and manifests in a sandboxed parser (Landlock, seccomp, resource limits). A ClamAV daemon scans for malware. Both run together in **one private pod** outside the API pods. The pod has no service-account token, no platform secrets except the validator key, and a NetworkPolicy that admits only API pods.

:::caution Exactly one replica
A validation result lives in the pod that produced it, and the API fetches validated files from that same pod. Do not scale the validator above one replica. While the pod restarts, validation pauses and queued uploads wait. Viewing is unaffected.
:::

### Build and deploy

The files live in the `hosted-applications/` directory of the CodeMie repository.

```bash
# Validator: same commit as the API image
docker build -f hosted-applications/Dockerfile.validator \
  -t <registry>/codemie-hosted-validator:<commit> .

# Scanner: amd64 only
docker build --platform linux/amd64 -f hosted-applications/Dockerfile.scanner \
  -t <registry>/codemie-hosted-scanner:<revision> .

# ClamAV configuration, mounted read-only into both containers
kubectl -n codemie create configmap codemie-hosted-clamd \
  --from-file=clamd.conf=hosted-applications/clamd.conf

# Validator Deployment, Service, NetworkPolicy and wildcard content Ingress
kubectl -n codemie apply -f hosted-applications/kubernetes.yaml
```

Before applying the manifest, replace the image placeholders with immutable digests, set the ingress class, the wildcard host, and the TLS secret name. Scan both final images and publish them through your normal image pipeline.

The supplied manifest runs one replica with the `Recreate` strategy, a read-only root filesystem, all capabilities dropped, no privilege escalation, a `RuntimeDefault` seccomp profile, CPU and memory limits, and a size-limited `emptyDir` at `/work`. Never mount user workspaces, cloud credentials, the Docker socket, or API secrets other than the validator key into it.

### Validator parameters

| Variable                                            | Default          | Description                                                                                                                          |
| --------------------------------------------------- | ---------------- | ------------------------------------------------------------------------------------------------------------------------------------ |
| `VALIDATOR_SERVICE_KEY`                             | required         | Same value as `HOSTED_APPS_VALIDATOR_KEY`.                                                                                           |
| `VALIDATOR_BIND_HOST`                               | `127.0.0.1`      | Use `0.0.0.0` in the pod so the Service can reach it.                                                                                |
| `VALIDATOR_PORT`                                    | `8091`           | Listener port.                                                                                                                       |
| `VALIDATOR_TLS_CERT_FILE`, `VALIDATOR_TLS_KEY_FILE` | unset            | Set both to serve HTTPS. The API then needs a certificate it trusts. Setting only one refuses to start.                              |
| `VALIDATOR_WORKSPACE`                               | `/work`          | Scratch volume. A private `jobs` directory inside it is recreated at every start and checked for owner and mode `0700`.              |
| `CLAMD_HOST`, `CLAMD_PORT`                          | required, `3310` | `127.0.0.1` and `3310`, because clamd runs in the same pod.                                                                          |
| `CLAMD_CONFIGURATION`                               | required         | Path of the same read-only `clamd.conf` mounted into clamd. The validator refuses to scan when the policy limits in it do not match. |

Probes: `GET /livez` (unauthenticated, `204`) for liveness and readiness. `GET /health` (scanner version and signature age) requires the service key and is used by the API to decide whether to claim validation jobs.

### Scanner notes

- Keep the private Unix socket `/run/clamav/clamd.sock` in `clamd.conf`. The upstream entrypoint waits for it and startup stalls without it.
- ClamAV scan limits are part of the immutable validation policy. A missing or different configuration makes validation unavailable and never accepts a file.
- Signatures must be newer than 48 hours. freshclam checks roughly every 6 hours (`FRESHCLAM_CHECKS=4`). Monitor signature age. Prefer a private signature mirror.
- A file that exceeds ClamAV scan limits is rejected as too large or complex to scan, never reported as malware and never accepted.
- The clamd liveness probe also restarts the container when freshclam is not running. Do not clear the `signatures` volume to fix repeated restarts: a full re-download can trigger the mirror's rate limit.
- After every image change test clean, EICAR, timeout, oversized, and stale-signature cases.

## Secrets and Rotation

| Secret                                                | Used by               | Rotation                                                                                                   |
| ----------------------------------------------------- | --------------------- | ---------------------------------------------------------------------------------------------------------- |
| `HOSTED_APPS_CREDENTIAL_SECRET`                       | API                   | Maintenance window only (procedure below).                                                                 |
| `HOSTED_APPS_VALIDATOR_KEY` / `VALIDATOR_SERVICE_KEY` | API and validator pod | Update the Secret, restart the validator pod, then the API pods. Validations in between wait and continue. |

Never log or print these secrets. The configuration dump masks settings whose names end in `SECRET` or `KEY`.

### Rotating `HOSTED_APPS_CREDENTIAL_SECRET`

Every hosted credential digest is an HMAC under this secret. A new secret invalidates all open content sessions, launch tickets, pagination cursors, and idempotency records. It also changes the binding digest of SID-bound sign-ins, so a sign-in revoked before the rotation could open hosted content again until its token expires. Until key versioning exists, rotate as follows:

1. Announce a maintenance window and turn the feature off (`FEATURE_HOSTED_APPLICATIONS=false`, then restart the API) or disable the content ingress.
2. Deploy the new secret to every replica.
3. Set a global revocation cutoff:

   ```sql
   BEGIN;
   UPDATE application_user_state
      SET auth_revoked_before = GREATEST(auth_revoked_before, clock_timestamp() + interval '5 seconds'),
          revision = revision + 1,
          updated_at = clock_timestamp();
   UPDATE application_view_sessions SET revoked_at = clock_timestamp() WHERE revoked_at IS NULL;
   COMMIT;
   ```

4. Turn the feature back on. Users sign in to CodeMie again before opening hosted applications.

## Sign-out and Session Revocation

Platform sign-out never depends on hosted revocation. After the platform finishes the sign-out (`POST /v1/local-auth/logout`, `GET /v1/user/log_out`), CodeMie ends every hosted session of that user, on every device, within 2 seconds at most. The revocation is best effort: failures are logged as warnings and counted in `hosted_applications_logout_revocations`. If it fails, open content sessions end at their own expiry, at most 15 minutes later. A sign-out performed only at the identity provider, without a back-channel signal, is bounded by token and session expiry.

## Rollout Checklist

1. Apply the Alembic migration with traffic gated.
2. Provision DNS (`*.<content domain>`), the wildcard TLS certificate, the dedicated bucket (with its settings, lifecycle rule, and IAM), the `codemie-hosted-applications` Secret, the `codemie-hosted-clamd` ConfigMap, and the objects from `kubernetes.yaml`.
3. Raise the management ingress limits (body size, read and send timeouts).
4. Add the hosted settings to the `codemie-api` values and the `features:hostedApplications` component to the customer configuration.
5. Enable the feature in one environment. Confirm that:
   - there is no `Hosted applications are enabled but unavailable` warning in the API log;
   - the validator pod is ready (both containers);
   - `GET /v1/config` reports the feature as enabled;
   - kubelet probes and in-cluster callers (for example `codemie:8080`) still reach the API.
6. Pilot private uploads, then selected-user and organization publishing.
7. Before production traffic, test with real browsers: embedded viewing with partitioned cookies, the **Open in new tab** fallback, sign-out, and the load targets of the deployment.

### Smoke test

1. Open **Applications** and create a new application with a one-file `index.html`.
2. Wait until the version is validated and ready.
3. Open the application. The viewer header names the publisher.
4. Upload a test file containing the EICAR string and confirm that the version is rejected.
5. Share the application with a second user and confirm they can open it.
6. Sign out and confirm the viewing session ends.

## Monitoring

Metrics are exported by the OpenTelemetry meter `codemie-business-metrics`. Labels never contain organizations, users, applications, releases, paths, or file names.

| Instrument                                                                     | Labels                      | Meaning                                                                                                                         |
| ------------------------------------------------------------------------------ | --------------------------- | ------------------------------------------------------------------------------------------------------------------------------- |
| `hosted_applications_content_requests`                                         | `status`, `route`, `result` | Every content response. `result`: `served`, `denied` (401/403), `rejected` (other 4xx), `throttled` (429), `unavailable` (5xx). |
| `hosted_applications_content_denials`                                          | same                        | Only `denied` and `rejected`.                                                                                                   |
| `hosted_applications_content_unavailable`                                      | same                        | Only `throttled` and `unavailable`.                                                                                             |
| `hosted_applications_content_seconds`, `hosted_applications_content_bytes`     | same                        | Latency and bytes sent.                                                                                                         |
| `hosted_applications_directory_seconds`                                        | `result`                    | Membership lookup latency: `allowed`, `denied`, `unavailable`.                                                                  |
| `hosted_applications_directory_searches`                                       | `source`, `page`, `outcome` | People searches (never the query text).                                                                                         |
| `hosted_applications_validation_failures`                                      | `kind`                      | `artifact_rejected` or `service_unavailable`.                                                                                   |
| `hosted_applications_logout_revocations`                                       | `result`                    | `revoked`, `failed`, `timeout`.                                                                                                 |
| `hosted_applications_completed_work`, `_deferred_work`, `_work_seconds`        | `operation`                 | Durable worker steps.                                                                                                           |
| `hosted_applications_queue_jobs`, `hosted_applications_oldest_queue_seconds`   | `kind`, `state`             | Queue depth and age.                                                                                                            |
| `hosted_applications_stored_bytes`, `_reserved_bytes`, `_snapshot_age_seconds` | none                        | Storage accounting and snapshot freshness.                                                                                      |

Unexpected failures on hosted management routes return `503 APPLICATION_UNAVAILABLE` with an `error_id` and are logged at error level with that ID, the route template, and the stack trace. Content host failures (`5xx`) are logged the same way, without paths. Request bodies and credentials are never logged.

### Suggested alerts

Tune per deployment:

- sustained `unavailable` or `throttled` results, and spikes of `denied`;
- directory `unavailable`;
- `logout_revocations` with `failed` or `timeout`;
- oldest queue age above 5 minutes (for example while the validator pod is down);
- snapshot age above 120 seconds and growing reserved bytes;
- ClamAV signature age approaching 48 hours;
- clamd container restarts, together with the event `Liveness probe failed: freshclam is not running`;
- log event `hosted_storage_orphans_deleted` with a high key count.

## Operations

### Take an application down

A platform administrator can suspend an application immediately. There is no UI for it. Suspension unpublishes the application, removes every share, and ends open viewing sessions.

```bash
curl -X POST "$CODEMIE_API/v1/admin/hosted-applications/<application id>/security/suspend" \
  -H "Authorization: Bearer $ADMIN_TOKEN" -H "Content-Type: application/json" \
  -H "Idempotency-Key: $(uuidgen)" -d '{"reason": "Phishing report"}'
```

The application ID is the one in its CodeMie link (`/apps/<id>`). Use `reinstate` instead of `suspend` to clear a suspension (`409 NOT_SUSPENDED` otherwise). After reinstatement the application stays private and the owner must publish it again. Nobody can reinstate their own application.

### Stop everything

To stop serving all hosted content in an incident, turn the feature off (`FEATURE_HOSTED_APPLICATIONS=false` and restart) or disable the content ingress. Never weaken the content CSP or authentication, or make storage public, to restore availability.

### Failed jobs and cleanup

Transient validation failures retry at most 3 times with backoff. A validator that is down or busy does not use up those retries. Hard artifact failures need a corrected upload. Cleanup proves deletion in the bound bucket before releasing quota. Unavailable storage or a wrong bucket marker keeps deletion pending and charged. Never zero counters or force a purge state by hand.

### Backup and restore

Back up the database and the hosted bucket, including `.hosted/storage-id`, **as a pair**, with mutations and workers stopped or from a consistent snapshot. Restore the database to the same bucket and marker. A database restored to an older point turns newer attempts into orphans, and the sweep removes them after 1 day.

Keep the feature off after a restore until both steps below have run, in this order:

1. Apply the revocation cutoff from [Rotating `HOSTED_APPS_CREDENTIAL_SECRET`](#rotating-hosted_apps_credential_secret) so that no restored session or ticket is accepted.
2. Withdraw shares so that shares and publications removed after the backup cannot come back. Owners then publish again, and administrators re-apply any suspension made after the backup.

   ```sql
   BEGIN;
   DELETE FROM application_grants;
   UPDATE hosted_applications
      SET publication_state = CASE WHEN publication_state = 'published' THEN 'unpublished' ELSE publication_state END,
          audience = 'private', discoverable = false,
          access_revision = access_revision + 1, revision = revision + 1, updated_at = clock_timestamp()
    WHERE lifecycle_state = 'active';
   COMMIT;
   ```

## Troubleshooting

| Symptom                                                        | Likely cause                                                                                            | Action                                                                                        |
| -------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------- |
| UI shows only Platform apps                                    | Flag off, or startup checks failed                                                                      | Check the API log for `Hosted applications are enabled but unavailable` and `GET /v1/config`. |
| Hosted routes answer `403 FEATURE_DISABLED`                    | Same as above, or the runtime failed to start                                                           | Search the log for `Hosted applications failed to start and stay unavailable`.                |
| Hosted routes answer `403 ACCOUNT_NOT_SUPPORTED`               | No usable sign-in token, or an external or service account                                              | Search the log for `found no usable sign-in token` and read the `cause`.                      |
| Uploads stay queued                                            | Validator pod down, unhealthy, or not on a Landlock-capable node                                        | `kubectl get pods`, check both containers, and the validator log. Queue age metric rises.     |
| Validator crash-loops at start                                 | Node without Landlock ABI 3 or sandbox probe failed                                                     | Schedule the pod on qualified nodes (Linux 6.2+).                                             |
| Validation always unavailable after a rollout                  | API and validator images built from different commits (policy digest mismatch), or `clamd.conf` differs | Rebuild both from the same commit. Mount the reviewed `clamd.conf` in both containers.        |
| Upload fails with `413` or the connection drops on large files | Ingress body size or timeout too low                                                                    | Body size at least `110m`, read and send timeouts at least `900` seconds.                     |
| Viewer frame is empty                                          | CSP on the UI host blocks the content origin, or third-party cookies blocked                            | Allow `frame-src https://*.<content domain>`. Use **Open in new tab**.                        |
| Content host answers `400`                                     | Forwarding headers disagree with Host                                                                   | Remove `Forwarded` and `X-Original-Host`, and send `X-Forwarded-Host` only as a copy of Host. |
| Content host answers `404`                                     | Host is not a valid release host (`v-<release>` or `w-<release>`)                                       | Use only the origin returned by the launch call.                                              |
| Content host answers `503`                                     | Feature off or not ready                                                                                | See the first rows.                                                                           |
| Startup refuses S3 with `STORAGE_CLOCK_SKEW`                   | Clock skew between pod, database, and S3 above the grace                                                | Fix time sync, or raise `HOSTED_APPS_STORAGE_S3_GRACE_SECONDS` carefully.                     |
| `503 SERVICE_BUSY`                                             | Hosted database pool (10 connections) saturated                                                         | Check database load and the per-replica connection budget.                                    |
| `409 QUOTA_EXCEEDED`                                           | Owner reached `HOSTED_APPS_QUOTA_BYTES`                                                                 | Owner removes old versions or applications, or raise the quota.                               |
| Applications disappeared after an upgrade                      | `JWT_ISSUER` changed (organization ID)                                                                  | Restore the previous issuer value.                                                            |

## Local Development

| Setting                                                      | Value                                                                                            |
| ------------------------------------------------------------ | ------------------------------------------------------------------------------------------------ |
| `ENV`                                                        | `local`                                                                                          |
| `FEATURE_HOSTED_APPLICATIONS`                                | `true`                                                                                           |
| `HOSTED_APPS_CONTENT_DOMAIN`                                 | `apps.localhost:<backend port>`, for example `apps.localhost:8080`                               |
| `FRONTEND_URL`                                               | `http://localhost:<UI port>`                                                                     |
| `ENABLE_USER_MANAGEMENT`                                     | `true`                                                                                           |
| `FILES_STORAGE_TYPE`                                         | `filesystem`, with `HOSTED_APPS_STORAGE_DIR` set to an absolute path outside `FILES_STORAGE_DIR` |
| `HOSTED_APPS_VALIDATOR_URL`                                  | A validator on loopback, for example `http://127.0.0.1:18091`                                    |
| `HOSTED_APPS_CREDENTIAL_SECRET`, `HOSTED_APPS_VALIDATOR_KEY` | Any 32+ character values                                                                         |

Run the validator and a standalone clamd container locally. The local clamd needs a copy of `clamd.conf` with `TCPAddr 0.0.0.0` and its port published on host loopback only. The validator container needs `VALIDATOR_BIND_HOST=0.0.0.0` and `docker run -p 127.0.0.1:18091:8091`. The filesystem adapter is never supported in production.

## Known Limitations and Residual Risks

- **Exfiltration by uploaded code.** Content runs under a restrictive CSP, but browsers cannot fully prevent WebRTC or DNS-prefetch egress. A malicious application can send out what a viewer types into it. It cannot read CodeMie cookies, tokens, or storage.
- **In-frame phishing.** An application can draw a fake sign-in form. The viewer labels uploaded content and names the publisher. Suspension is the control. Tell users that CodeMie never asks for credentials inside an application.
- **ClamAV parses hostile input** outside the parser sandbox, in a pod with no platform credentials and a restrictive NetworkPolicy. Keep its image patched.
- **One validator replica.** Validation pauses while the pod restarts.
- **Sign-out during an outage.** An open content session can last up to 15 minutes if the revocation write fails.
- **Azure storage** is not supported yet.
- **Custom S3 endpoints** (MinIO, Ceph) are not supported.
- **Sweep duplication.** Every API replica walks the bucket during the sweep.

## Reference

| Document                                              | Location in the CodeMie repository                                   |
| ----------------------------------------------------- | -------------------------------------------------------------------- |
| Operations runbook                                    | `hosted-applications/README.md`                                      |
| Kubernetes objects, Dockerfiles, ClamAV configuration | `hosted-applications/`                                               |
| Architecture and data model                           | `docs/hosted-applications/architecture.md`                           |
| Production readiness review                           | `docs/hosted-applications/production-readiness-review-2026-10-07.md` |

For end-user instructions see [Hosted Applications](../../../user-guide/applications/hosted-applications.md). For the customer configuration file, see [Customer Feature Configuration](./customer-feature-configuration.md).
