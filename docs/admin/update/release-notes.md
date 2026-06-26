---
id: release-notes
title: Release Notes
sidebar_label: Release Notes
sidebar_position: 1
pagination_prev: admin/update/update-overview
pagination_next: null
---

# Release Notes

This page provides information about updated third-party components and configuration changes available in new CodeMie releases.

---

<details>
<summary><strong>CodeMie 2.35.0</strong></summary>

**Release Date:** June 22, 2026 · [GitHub Tag ↗](https://github.com/codemie-ai/codemie/releases/tag/2.35.0)

<h3>Third-Party Component Updates</h3>

No third-party component updates in this release.

<h3>Configuration Changes</h3>

1. **`security.processAuthSecret` removed from AI/Run CodeMie Backend Helm chart** — the static shared-secret approach for inter-process authentication (`INTERNAL_BIND_KEY`) has been replaced with per-request HMAC signing. The key is now generated in-memory at pod startup and no Kubernetes Secret is needed.

   :::tip Configuration housekeeping
   If the **AI/Run CodeMie Backend** Helm chart values still contain `security.processAuthSecret`, it can be safely removed:

   ```yaml
   # Remove the following block from your custom Helm values:
   security:
     processAuthSecret:
       create: false
       name: "internal-bind-key"
       field: "bind-key"
   ```

   If you created a Kubernetes Secret for `INTERNAL_BIND_KEY` manually (e.g. for ArgoRollout deployments), it can also be safely deleted.
   :::

2. **MCP Connect Service isolated to a dedicated Kubernetes namespace** — `codemie-mcp-connect-service` is now deployed in its own `codemie-mcp-connect-service` namespace with Pod Security Admission (`restricted`) enforced. This improves workload isolation and aligns with security best practices.

   :::tip Script deployments
   The provided deployment script handles namespace creation, Pod Security Admission labeling, and service deployment automatically. No manual action is required.
   :::

   :::note Manual migration (without deployment script)
   To apply the same isolation manually:
   1. Create the namespace and apply Pod Security Admission labels:

      ```bash
      kubectl create namespace codemie-mcp-connect-service
      kubectl label namespace codemie-mcp-connect-service \
        pod-security.kubernetes.io/enforce=restricted \
        pod-security.kubernetes.io/enforce-version=latest \
        --overwrite
      ```

   2. Redeploy the Helm chart into the new namespace and update `MCP_CONNECT_URL` in the **AI/Run CodeMie Backend** Helm values:

      ```yaml
      - name: MCP_CONNECT_URL
        value: "http://codemie-mcp-connect-service-{MCP_CONNECT_BUCKET}.codemie-mcp-connect-service-headless.codemie-mcp-connect-service:3000"
      ```

   3. Delete the old deployment from the `codemie` namespace.
      :::

   :::tip Network isolation hardening
   Applying Kubernetes `NetworkPolicy` to the `codemie-mcp-connect-service` namespace is
   recommended to enforce least-privilege traffic controls. See
   [Network Policies for MCP Connect Service](../security/network-policies/mcp-connect-service.mdx) for
   cloud-specific configurations and helper scripts.
   :::

3. **AWS Terraform changes**
   - **KMS hardening** — replaced the account-root `kms:*` wildcard with least-privilege policies. Key administrators now have management permissions only, and the IRSA role has cryptographic operations only. The KMS IAM policy scope is narrowed to the specific key. Review KMS-dependent workloads for access regressions after upgrading.
   - **Multi-AZ enabled by default for all RDS instances** — all RDS instances (main CodeMie, Keycloak, LiteLLM, Langfuse) now run with a standby replica in a secondary Availability Zone, providing automatic failover in case of an AZ outage. The change is applied during the next scheduled RDS maintenance window.

</details>

<details>
<summary><strong>CodeMie 2.34.0</strong></summary>

**Release Date:** June 15, 2026 · [GitHub Tag ↗](https://github.com/codemie-ai/codemie/releases/tag/2.34.0)

<h3>Third-Party Component Updates</h3>

No third-party component updates in this release.

<h3>Configuration Changes</h3>

1. External Secrets Operator IRSA provisioning removed from AWS Terraform code.

2. SSH key pair module and its usage in the EKS cluster configuration removed from AWS Terraform code.

3. Fluent-bit version upgrade from 4.2.3.1 to 5.0.7.

4. Spot node group (`worker_group_spot`) removed from AWS EKS Terraform configuration — the Auto Scaling Group was permanently scaled to zero. Associated IAM role, instance profile, and launch template are destroyed on the next `terraform apply`.

</details>

<details>
<summary><strong>CodeMie 2.33.0</strong></summary>

**Release Date:** June 9, 2026 · [GitHub Tag ↗](https://github.com/codemie-ai/codemie/releases/tag/2.33.0)

<h3>Third-Party Component Updates</h3>

No third-party component updates in this release.

<h3>Configuration Changes</h3>

No breaking configuration changes were introduced in this release.

</details>

<details>
<summary><strong>CodeMie 2.32.0</strong></summary>

**Release Date:** June 4, 2026 · [GitHub Tag ↗](https://github.com/codemie-ai/codemie/releases/tag/2.32.0)

<h3>Third-Party Component Updates</h3>

No third-party component updates in this release.

<h3>Configuration Changes</h3>

1. AWS EKS authentication via ConfigMap no longer supported and removed from terraform scripts.

2. Added optional provisioning AWS Valkey (Redis Cache).

   :::tip Redis usage
   Redis instance is required to enable functionality such as WebHook rate limiter.
   :::

</details>

<details>
<summary><strong>CodeMie 2.31.0</strong></summary>

**Release Date:** June 1, 2026 · [GitHub Tag ↗](https://github.com/codemie-ai/codemie/releases/tag/2.31.0)

<h3>Third-Party Component Updates</h3>

No third-party component updates in this release.

<h3>Configuration Changes</h3>

No breaking configuration changes were introduced in this release.

</details>

<details>
<summary><strong>CodeMie 2.30.0</strong></summary>

**Release Date:** May 27, 2026 · [GitHub Tag ↗](https://github.com/codemie-ai/codemie/releases/tag/2.30.0)

<h3>Third-Party Component Updates</h3>

<h4>Keycloak Operator 1.34.0</h4>

keycloak-operator has been updated from 1.32.0 to 1.34.0 (Helm chart 1.32.0 to 1.34.0). For details, see the [keycloak-operator 1.34.0 Release Notes ↗](https://github.com/epam/edp-keycloak-operator/releases/tag/v1.34.0).

Starting from v1.33.0, keycloak-operator no longer auto-appends the `/auth` context path. If your Keycloak is deployed with a context path (e.g. `/auth`), include it explicitly in `keycloak.url` in your `oauth2-proxy` Helm chart values (e.g. `http://keycloakx-http/auth`). If Keycloak runs without a context path, leave the URL as-is.

<h3>Configuration Changes</h3>

1. **`opsPool` removed from AI/Run CodeMie Backend Helm chart** - this workload was deprecated and is no longer supported. Remove all `opsPool.*` fields from the custom Helm values before upgrading.

   :::tip Configuration housekeeping
   If the **AI/Run CodeMie Backend** Helm chart values still contain `opsPool`, it can be safely removed.
   :::

<h3>Hotfixes</h3>

- **2.30.1** · [GitHub Tag ↗](https://github.com/codemie-ai/codemie/releases/tag/2.30.1) – May 29, 2026

</details>

<details>
<summary><strong>CodeMie 2.29.0</strong></summary>

**Release Date:** May 22, 2026 · [GitHub Tag ↗](https://github.com/codemie-ai/codemie/releases/tag/2.29.0)

<h3>Third-Party Component Updates</h3>

No third-party component updates in this release.

<h3>Configuration Changes</h3>

1. **[BREAKING]** Ingress annotations removed from upstream Helm charts

   :::danger Breaking Change
   These annotations are no longer shipped as defaults in the Helm charts but are still required for oauth2-proxy authentication to work. Add them to the custom Helm values before upgrading to preserve this behavior.
   :::

   The following oauth2-proxy ingress annotations announced for removal in 2.28.0 have been removed from the default values of the **AI/Run CodeMie Backend** and **AI/Run CodeMie UI** Helm charts:

   ```yaml
   nginx.ingress.kubernetes.io/auth-response-headers: X-Auth-Request-Access-Token,Authorization
   nginx.ingress.kubernetes.io/auth-signin: https://$host/oauth2/start?rd=$escaped_request_uri
   nginx.ingress.kubernetes.io/auth-url: http://oauth2-proxy.oauth2-proxy.svc.cluster.local:80/oauth2/auth
   ```

<h3>Hotfixes</h3>

- **2.29.1** · [GitHub Tag ↗](https://github.com/codemie-ai/codemie/releases/tag/2.29.1) – May 25, 2026

</details>

<details>
<summary><strong>CodeMie 2.28.0</strong></summary>

**Release Date:** May 21, 2026 · [GitHub Tag ↗](https://github.com/codemie-ai/codemie/releases/tag/2.28.0)

<h3>Third-Party Component Updates</h3>

No third-party component updates in this release.

<h3>Configuration Changes</h3>

1. **`viteEnableAnalytics` removed from AI/Run CodeMie UI Helm chart** — this value and the corresponding `VITE_ENABLE_ANALYTICS` environment variable were deprecated and are no longer supported.

   :::tip Configuration housekeeping
   If the `AI/Run CodeMie UI` Helm chart values still contain `viteEnableAnalytics`, it can be safely removed.
   :::

2. **Infrastructure logs index renamed** — the default value of `ELASTIC_LOGS_INDEX` changed from `codemie_infra_logs*` to `logs-codemie-infra*`. If this value is set explicitly in the deployment, update it accordingly. See [Logs Retention](../configuration/observability/logs-retention.md) for cleanup and retention configuration.

3. **Upcoming change: ingress annotations** — the following oauth2-proxy ingress annotations will be removed from the **AI/Run CodeMie Backend** and **AI/Run CodeMie UI** Helm charts in a future release:

   :::warning Removed from default Helm chart values in 2.29.0
   These annotations are no longer shipped as defaults in the Helm charts but are still required for oauth2-proxy authentication to work. Add them to the custom Helm values before upgrading to preserve this behavior.

   ```yaml
   nginx.ingress.kubernetes.io/auth-response-headers: X-Auth-Request-Access-Token,Authorization
   nginx.ingress.kubernetes.io/auth-signin: https://$host/oauth2/start?rd=$escaped_request_uri
   nginx.ingress.kubernetes.io/auth-url: http://oauth2-proxy.oauth2-proxy.svc.cluster.local:80/oauth2/auth
   ```

   :::

<h3>Hotfixes</h3>

- **2.28.1** · [GitHub Tag ↗](https://github.com/codemie-ai/codemie/releases/tag/2.28.1) – May 21, 2026

</details>

<details>
<summary><strong>CodeMie 2.27.0</strong></summary>

**Release Date:** May 18, 2026 · [GitHub Tag ↗](https://github.com/codemie-ai/codemie/releases/tag/2.27.0)

<h3>Third-Party Component Updates</h3>

No third-party component updates in this release.

<h3>Configuration Changes</h3>

1. **`USE_POSTGRES` removed from AI/Run CodeMie Backend Helm Chart** — this variable was deprecated and is no longer supported.

   :::tip Configuration housekeeping
   If the `AI/Run CodeMie Backend` Helm Chart values still contain `USE_POSTGRES`, it can be safely removed.
   :::

2. **Post-migration cleanup** — if the Platform-Managed Mode migration has been completed but the one-time migration variables have not yet been removed, this is a good time to clean them up.

   :::tip Post-migration housekeeping
   After a successful migration, the following variables are no longer needed and should be removed from `extraEnv`:
   - `KEYCLOAK_MIGRATION_ENABLED`
   - `KEYCLOAK_ADMIN_URL`
   - `KEYCLOAK_ADMIN_REALM`
   - `KEYCLOAK_ADMIN_CLIENT_ID`
   - `KEYCLOAK_ADMIN_CLIENT_SECRET`

   See [Disable migration after the first run](../configuration/access-control/platform-managed-mode-configuration.md#22-disable-migration-after-the-first-run) for the full cleanup steps.
   :::

3. **`LITELLM_PREMIUM_MODELS_ALIASES` format changed to JSON array** — if this variable is in use, update its value from a comma-separated string to a JSON array.

   :::warning Format change required
   The previous comma-separated format is no longer supported. Update `extraEnv` before upgrading:

   ```yaml
   # Before
   - name: LITELLM_PREMIUM_MODELS_ALIASES
     value: "opus,o1"

   # After
   - name: LITELLM_PREMIUM_MODELS_ALIASES
     value: '["opus", "o1"]'
   ```

   :::

4. **`LITELLM_PREMIUM_MODELS_BUDGET_NAME` removed** — this variable was deprecated and is no longer supported. Remove it from `extraEnv` if still present.

   :::tip Configuration housekeeping
   The budget name is now derived automatically from the `budget_category: premium_models` entry in `budgets-config.yaml`. No replacement variable is needed.
   :::

</details>

<details>
<summary><strong>CodeMie 2.26.0</strong></summary>

**Release Date:** May 12, 2026 · [GitHub Tag ↗](https://github.com/codemie-ai/codemie/releases/tag/2.26.0)

<h3>Third-Party Component Updates</h3>

No third-party component updates in this release.

<h3>Configuration Changes</h3>

1. **Update LiteLLM budget env vars** — remove `LITELLM_SPEND_COLLECTOR_SCHEDULE` and set `LLM_PROXY_BUDGET_BACKFILL_ENABLED: "true"`. See [Budget Configuration](../configuration/extensions/litellm-proxy/budget-configuration.md).

2. **One-time reconciliation via `LLM_PROXY_BUDGET_RECONCILIATION_ENABLED`**

   :::warning One-time operation
   Enable only on a **single API replica**, wait for reconciliation to complete (check pod logs), then disable and scale replicas back.
   :::

   Steps:
   1. Scale API to 1 replica.
   2. Set `LLM_PROXY_BUDGET_RECONCILIATION_ENABLED: "true"`.
   3. Wait for reconciliation log confirmation.
   4. Remove or set the variable to `"false"`.
   5. Scale API replicas back to the desired count.

<h3>Hotfixes</h3>

- **2.26.1** · [GitHub Tag ↗](https://github.com/codemie-ai/codemie/releases/tag/2.26.1) – May 13, 2026

</details>

<details>
<summary><strong>CodeMie 2.25.0</strong></summary>

**Release Date:** May 8, 2026 · [GitHub Tag ↗](https://github.com/codemie-ai/codemie/releases/tag/2.25.0)

<h3>Third-Party Component Updates</h3>

No third-party component updates in this release.

<h3>Configuration Changes</h3>

No breaking configuration changes were introduced in this release.

<h3>Known Issues</h3>

:::warning Skip to 2.26.0 if using LiteLLM integration
If your deployment has the **LiteLLM proxy integration enabled**, it is strongly recommended to **skip this version and upgrade directly to CodeMie 2.26.0**.

Version 2.25.0 contains a known issue that causes instability in environments with LiteLLM configured. Upgrading to 2.26.0 resolves this issue.
:::

</details>

<details>
<summary><strong>CodeMie 2.24.0</strong></summary>

**Release Date:** April 23, 2026 · [GitHub Tag ↗](https://github.com/codemie-ai/codemie/releases/tag/2.24.0)

<h3>Third-Party Component Updates</h3>

<h4>LiteLLM 1.83.7 (CodeMie 2.24.1)</h4>

Updated from 1.81.0. For details, see the [LiteLLM 1.83.7 Release Notes ↗](https://github.com/BerriAI/litellm/releases/tag/v1.83.7-stable).

<h3>Configuration Changes</h3>

1. **[BREAKING]** Fluent Bit: Remove `span_id` and `trace_id` from Metrics Logs

   :::danger Breaking Change
   Without this configuration update, **no metrics will be written** to the `codemie_metrics_logs` Elasticsearch index. Apply this change before or during the upgrade to CodeMie 2.24.0.
   :::

   A new `[FILTER]` block must be added to `fluent-bit/values.yaml` to strip `span_id` and `trace_id` fields from CodeMie metrics logs before they are forwarded to Elasticsearch.

   **Why:** Starting with CodeMie 2.24.0, the backend includes `span_id` and `trace_id` fields in its log output. These fields are not accepted by the `codemie_metrics_logs` Elasticsearch index, causing all metrics ingestion to fail.

   **Required change in `fluent-bit/values.yaml`:**

   ```ini
   [FILTER]
       Name         record_modifier
       Match        kube.codemie-metrics.*
       Remove_key   span_id
       Remove_key   trace_id
   ```

   This filter is included in the updated `codemie-helm-charts`. No manual action is required if you are upgrading using the provided Helm charts.

2. **Keycloak Login Theme**

   The CodeMie login theme (`codemie`) is now automatically applied to the `codemie-prod` realm via the `oauth2-proxy` Helm chart.

   **Upgrade instructions:** [Keycloak Theme Setup](./keycloak/keycloak-theme-setup.md)

3. **New Environment Variable:** `INTERNAL_BIND_KEY`

   A new `INTERNAL_BIND_KEY` environment variable has been introduced.
   It is a shared secret for inter-process communication.
   Without it, webhook trigger may fail when running multiple workers (`WORKERS > 1`) or multiple pod replicas.

   **If upgrading using Helm charts:**

   The updated Helm chart automatically creates a Kubernetes Secret with a random value for `INTERNAL_BIND_KEY`.
   No manual action is required for standard deployments.

   :::warning ArgoRollout deployments
   Automatic secret generation is skipped when `argoRollout` is enabled.
   Create the Kubernetes Secret manually and reference it via `security.processAuthSecret.name` and `security.processAuthSecret.field`.
   :::

   **If deploying without Helm charts:**

   Set `INTERNAL_BIND_KEY` to the same strong random value across all workers and pods.
   Generate with: `openssl rand -hex 32`. Store in a secrets manager or Kubernetes Secret.

   See [API Configuration](../configuration/codemie/api-configuration.md) for full details.

<h3>Hotfixes</h3>

- **2.24.1** – April 29, 2026

  Updated LiteLLM to 1.83.7. For details, see the [LiteLLM 1.83.7 Release Notes ↗](https://github.com/BerriAI/litellm/releases/tag/v1.83.7-stable).

</details>

<details>
<summary><strong>CodeMie 2.23.0</strong></summary>

**Release Date:** April 15, 2026 · [GitHub Tag ↗](https://github.com/codemie-ai/codemie/releases/tag/2.23.0)

<h3>Third-Party Component Updates</h3>

No third-party component updates in this release.

<h3>Configuration Changes</h3>

#### Budget Enforcement Environment Variables

Three new environment variables have been introduced to control LLM budget enforcement. All default to `false` (disabled):

| Variable                            | Default | Description                                                                      |
| ----------------------------------- | ------- | -------------------------------------------------------------------------------- |
| `LLM_PROXY_BUDGET_CHECK_ENABLED`    | `false` | Enables budget limit checking for LLM proxy requests                             |
| `LLM_PROXY_BUDGET_SYNC_ENABLED`     | `false` | Syncs predefined budgets from `budgets-config.yaml` into the database on startup |
| `LLM_PROXY_BUDGET_BACKFILL_ENABLED` | `false` | Backfills user budget assignments from LiteLLM on startup for existing users     |

See [Budget Configuration](../configuration/extensions/litellm-proxy/budget-configuration.md) and [API Configuration](../configuration/codemie/api-configuration.md) for details.

#### Deprecated Budget Environment Variables

The following environment variables are deprecated and will be removed in a future release. Replace them with the corresponding `budgets-config.yaml` fields:

| Deprecated Variable                  | Type   | Default     | Replacement in `budgets-config.yaml` |
| ------------------------------------ | ------ | ----------- | ------------------------------------ |
| `DEFAULT_SOFT_BUDGET_LIMIT`          | float  | `200`       | `soft_budget`                        |
| `DEFAULT_HARD_BUDGET_LIMIT`          | float  | `500`       | `max_budget`                         |
| `DEFAULT_BUDGET_DURATION`            | string | `"30d"`     | `budget_duration`                    |
| `DEFAULT_BUDGET_ID`                  | string | `"default"` | `budget_id`                          |
| `LITELLM_PREMIUM_MODELS_BUDGET_NAME` | string | `""`        | `premium_models` category entry      |
| `LITELLM_CLI_BUDGET_NAME`            | string | `""`        | `cli` category entry                 |

See [Budget Configuration](../configuration/extensions/litellm-proxy/budget-configuration.md) for migration details.

<h3>Hotfixes</h3>

- **2.23.1** · [GitHub Tag ↗](https://github.com/codemie-ai/codemie/releases/tag/2.23.1) – April 15, 2026
- **2.23.2** · [GitHub Tag ↗](https://github.com/codemie-ai/codemie/releases/tag/2.23.2) – April 16, 2026
- **2.23.3** · [GitHub Tag ↗](https://github.com/codemie-ai/codemie/releases/tag/2.23.3) – April 21, 2026
- **2.23.4** · [GitHub Tag ↗](https://github.com/codemie-ai/codemie/releases/tag/2.23.4) – April 20, 2026

</details>

<details>
<summary><strong>CodeMie 2.22.0</strong></summary>

**Release Date:** April 9, 2026 · [GitHub Tag ↗](https://github.com/codemie-ai/codemie/releases/tag/2.22.0)

<h3>Third-Party Component Updates</h3>

No third-party component updates in this release.

<h3>Configuration Changes</h3>

No breaking configuration changes were introduced in this release.

<h3>Hotfixes</h3>

- **2.22.1** · [GitHub Tag ↗](https://github.com/codemie-ai/codemie/releases/tag/2.22.1) – April 9, 2026

</details>

<details>
<summary><strong>CodeMie 2.21.0</strong></summary>

**Release Date:** April 8, 2026 · [GitHub Tag ↗](https://github.com/codemie-ai/codemie/releases/tag/2.21.0)

<h3>Third-Party Component Updates</h3>

---

<h4>oauth2-proxy 7.15.1 (Chart 10.4.2)</h4>

Updated oauth2-proxy from 7.14.2 to 7.15.1 (Helm chart 10.1.0 to 10.4.2). For details, see the [oauth2-proxy 7.15.1 Release Notes ↗](https://github.com/oauth2-proxy/oauth2-proxy/releases/tag/v7.15.1).

<h3>Configuration Changes</h3>

No breaking configuration changes were introduced in this release.

</details>

<details>
<summary><strong>CodeMie 2.20.0</strong></summary>

**Release Date:** April 2, 2026 · [GitHub Tag ↗](https://github.com/codemie-ai/codemie/releases/tag/2.20.0)

<h3>Third-Party Component Updates</h3>

---

<h4>ElasticSearch / Kibana 8.19.12</h4>

Updated from 8.18.4. For details, see the [Elastic 8.19.12 Release Notes ↗](https://www.elastic.co/guide/en/security/8.19/release-notes-header-8.19.0.html#release-notes-8.19.12).

**Upgrade instructions:** [ElasticSearch and Kibana Upgrade Guide](./elasticsearch-kibana-upgrade.md)

---

<h4>NATS Chart 1.3.0 (NATS 2.11.0, Reloader 0.22.3)</h4>

Updated NATS Helm chart from 1.2.6 to 1.3.0, which includes NATS server 2.11.0 (up from 2.10.22) and NATS Reloader 0.22.3 (up from 0.16.0).

**Upgrade instructions:** [NATS Upgrade Guide](./nats-upgrade.md)

---

<h4>Keycloak 26.5.6 (keycloakx 7.1.9)</h4>

Updated Keycloak to 26.5.6 (up from 26.4.5) and keycloakx chart to 7.1.9 (up from 7.1.5). For details, see the [Keycloak 26.5 Release Notes ↗](https://www.keycloak.org/docs/latest/release_notes/).

**Upgrade instructions:** [Keycloak Upgrade Guide](./keycloak/keycloak-upgrade/index.md)

---

<h4>Nginx 1.15.1</h4>

Updated nginx ingress controller to version 1.15.1 (up from 1.14.3).

<h3>Configuration Changes</h3>

No breaking configuration changes were introduced in this release.

</details>

<details>
<summary><strong>CodeMie 2.19.0</strong></summary>

**Release Date:** March 27, 2026 · [GitHub Tag ↗](https://github.com/codemie-ai/codemie/releases/tag/2.19.0)

<h3>Third-Party Component Updates</h3>

<h4>Postgres Operator Removed</h4>

CodeMie 2.19.0 removes the `postgres-operator` Helm chart (PGO 5.4.3) used for Keycloak's in-cluster PostgreSQL. It is replaced by two new database options:

- **Dedicated database instance** — a separate, Terraform-provisioned database instance for Keycloak (default for Terraform deployments)
- **Shared CodeMie database** — Keycloak reuses the existing CodeMie database instance; a Helm hook Job automatically creates the required database and user on first install

See the [Keycloak Database Migration Guide](./keycloak/database-migration.md) for upgrade instructions.

:::note
Migration to an external database is optional. If you prefer to continue using the in-cluster PostgreSQL, no migration is required when upgrading to 2.19.0.
:::

<h3>Configuration Changes</h3>

No breaking configuration changes were introduced in this release.

</details>

<details>
<summary><strong>CodeMie 2.18.0</strong></summary>

**Release Date:** March 24, 2026 · [GitHub Tag ↗](https://github.com/codemie-ai/codemie/releases/tag/2.18.0)

<h3>Third-Party Component Updates</h3>

No third-party component updates in this release.

<h3>Configuration Changes</h3>

No breaking configuration changes were introduced in this release.

</details>

<details>
<summary><strong>CodeMie 2.17.0</strong></summary>

**Release Date:** March 20, 2026 · [GitHub Tag ↗](https://github.com/codemie-ai/codemie/releases/tag/2.17.0)

<h3>Third-Party Component Updates</h3>

No third-party component updates in this release.

<h3>Configuration Changes</h3>

No breaking configuration changes were introduced in this release.

</details>

<details>
<summary><strong>CodeMie 2.16.0</strong></summary>

**Release Date:** March 18, 2026 · [GitHub Tag ↗](https://github.com/codemie-ai/codemie/releases/tag/2.16.0)

<h3>Third-Party Component Updates</h3>

No third-party component updates in this release.

<h3>Configuration Changes</h3>

No breaking configuration changes were introduced in this release.

</details>

<details>
<summary><strong>CodeMie 2.15.0</strong></summary>

**Release Date:** March 16, 2026 · [GitHub Tag ↗](https://github.com/codemie-ai/codemie/releases/tag/2.15.0)

<h3>Third-Party Component Updates</h3>

<h4>Fluent Bit 4.2.3.1</h4>

CodeMie 2.15.0 includes Fluent Bit version 4.2.3.1, providing improved log collection and processing capabilities.

**What's new:**

For detailed information about changes, improvements, and bug fixes, see the [Fluent Bit 4.2.3.1 Release Notes](https://github.com/fluent/fluent-bit/releases/tag/v4.2.3.1).

**Upgrade instructions:**

To upgrade Fluent Bit to version 4.2.3.1, follow the [Fluent Bit Upgrade Guide](./fluent-bit-upgrade.md).

<h3>Configuration Changes</h3>

No breaking configuration changes were introduced in this release. All existing Fluent Bit configurations remain compatible.

</details>
