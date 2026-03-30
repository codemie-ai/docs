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
<summary><strong>CodeMie 2.19.0</strong></summary>

**Release Date:** March 27, 2026 · [GitHub Tag ↗](https://github.com/codemie-ai/codemie/releases/tag/2.19.0)

<h3>Third-Party Component Updates</h3>

<h4>Postgres Operator Removed</h4>

CodeMie 2.19.0 removes the `postgres-operator` Helm chart (PGO 5.4.3) used for Keycloak's in-cluster PostgreSQL. It is replaced by two new database options:

- **Dedicated database instance** — a separate, Terraform-provisioned database instance for Keycloak (default for Terraform deployments)
- **Shared CodeMie database** — Keycloak reuses the existing CodeMie database instance; a Helm hook Job automatically creates the required database and user on first install

See the [Keycloak Database Migration Guide](./keycloak/keycloak-database-migration) for upgrade instructions.

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

To upgrade Fluent Bit to version 4.2.3.1, follow the [Fluent Bit Upgrade Guide](./fluent-bit-upgrade).

<h3>Configuration Changes</h3>

No breaking configuration changes were introduced in this release. All existing Fluent Bit configurations remain compatible.

</details>
