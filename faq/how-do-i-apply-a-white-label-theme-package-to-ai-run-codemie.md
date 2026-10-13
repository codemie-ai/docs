# How do I apply a white-label theme package to AI/Run CodeMie?

A white-label theme package is a `theme-package.yaml` file plus a directory of brand assets (logos, favicons, web manifest). The `apply-theme` script of the theming kit validates the package, renders Helm values, and rolls them out without any image rebuild.

1. Copy `kit/theme-package.yaml` and fill in every field marked `REQUIRED`. Place the five asset files in one directory.
2. Validate and render locally with `kit/apply-theme --render-only my-brand/theme-package.yaml my-brand/assets`. This step needs no cluster access.
3. Apply to the cluster with `kit/apply-theme --namespace codemie --chart-ui <repository>/codemie-ui --chart-codemie <repository>/codemie my-brand/theme-package.yaml my-brand/assets`.

The script upgrades the UI and API Helm releases with `--reuse-values` and restarts both deployments. A later `helm upgrade` without `--reuse-values` removes the brand, so the theme must be re-applied after such an upgrade.

## Sources

- [White-Label Theming Kit](https://docs.codemie.ai/admin/configuration/white-label/)
- [Theme Package Reference](https://docs.codemie.ai/admin/configuration/white-label/package-reference)
