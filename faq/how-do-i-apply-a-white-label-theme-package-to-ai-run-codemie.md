# How do I apply a white-label theme package to AI/Run CodeMie?

A white-label theme package is a `theme-package.yaml` file plus a folder of brand files (logos, favicons, web manifest). Two scripts of the theming kit validate the package and write the brand files into the folders of the Helm charts. The scripts do not call a cluster. The deployment is done by `helm-charts.sh`.

1. Copy `kit/theme-package.yaml` and fill in every field marked `REQUIRED`. Put the asset files in one source folder.
2. In the root of the charts repository, run `kit/apply-theme my-brand/theme-package.yaml my-brand/assets`. The script writes `brand.css`, `brand-config.json`, `platform/` and `email/` into `codemie-ui/assets`.
3. For the Keycloak login page and emails, add a `keycloak` block with `themeName` to the package and run `kit/apply-keycloak-theme my-brand/theme-package.yaml my-brand/assets`. The script writes `codemie-ui/assets/keycloak` and `keycloak-helm/theme`, and prints the names-only YAML for the values of `keycloak-helm` and `oauth2-proxy`.
4. Set `branding.enabled: true` in the values file of the cloud (`codemie-ui/values-<cloud>.yaml`).
5. Deploy with `helm-charts.sh`. Deploy the UI release before the API release.

The scripts stop with a message when an input check fails, and an existing output stays unchanged. A plain `helm upgrade` does not restart pods when only brand files changed: `helm-charts.sh` adds a hash of the brand files for that purpose.

## Sources

- [White-Label Theming Kit](https://docs.codemie.ai/admin/configuration/white-label/)
- [Theme Package Reference](https://docs.codemie.ai/admin/configuration/white-label/package-reference)
