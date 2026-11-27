# How do I apply a white-label theme package to AI/Run CodeMie?

A white-label brand has two independent packages. `theme-package.yaml` is the UI package: product name, colors, fonts, logos and the platform email brand. `keycloak-theme-package.yaml` is the Keycloak package: the Keycloak login page and emails. The two packages share no file, and a deployment can use one or both. Two scripts of the theming kit validate the packages and write files. The scripts do not call a cluster. The deployment is done by `helm-charts.sh`.

UI package:

1. Copy `kit/theme-package.yaml` and fill in every field marked `REQUIRED`. Put the asset files in one source folder.
2. In the root of the charts repository, run `kit/apply-theme my-brand/theme-package.yaml my-brand/assets`. The script writes `brand.css`, `brand-config.json`, `platform/` and `email/` into `codemie-ui/assets`.
3. Set `branding.enabled: true` in the values file of the cloud (`codemie-ui/values-<cloud>.yaml`).
4. Deploy with `helm-charts.sh`. Deploy the UI release before the API release.

Keycloak package:

1. Copy `kit/keycloak-theme-package.yaml` and fill in every field marked `REQUIRED`.
2. Run `kit/apply-keycloak-theme --output-dir my-brand/keycloak-theme my-brand/keycloak-theme-package.yaml my-brand/assets`. The folder can be at any path.
3. To get a jar for a Keycloak that is not deployed from the charts, add `--jar my-brand/acme-brand.jar`. The jar needs `zip`. Copy the jar to the `providers` folder of Keycloak and run `kc.sh build`.
4. To use the Keycloak chart, add `--chart-dir keycloak-helm`. The script mirrors the theme into `keycloak-helm/theme` and prints the names-only YAML for the values of `keycloak-helm` and `oauth2-proxy`.

The scripts stop with a message when an input check fails. A plain `helm upgrade` does not restart pods when only brand files changed: `helm-charts.sh` adds a hash of the brand files for that purpose.

## Sources

- [White-Label Theming Kit](https://docs.codemie.ai/admin/configuration/white-label/)
- [Theme Package Reference](https://docs.codemie.ai/admin/configuration/white-label/package-reference)
- [Keycloak Theme Package Reference](https://docs.codemie.ai/admin/configuration/white-label/keycloak-package-reference)
