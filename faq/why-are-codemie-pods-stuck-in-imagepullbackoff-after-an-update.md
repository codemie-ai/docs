# Why are CodeMie pods stuck in ImagePullBackOff after an update?

`ImagePullBackOff` or `ErrImagePull` errors after a CodeMie update most commonly mean that
the `gcp-artifact-registry` Kubernetes image pull secret contains expired GCP service account
credentials. Service account keys have a **90-day retention period** and expire automatically.

To resolve this, request a new `key.json` from the AI/Run CodeMie support team and follow
the [Update Image Pull Secret](https://docs.codemie.ai/admin/update/codemie/update-image-pull-secret)
guide to recreate the secret in the cluster.

## Sources

- [Update Image Pull Secret](https://docs.codemie.ai/admin/update/codemie/update-image-pull-secret)
- [Update AI/Run CodeMie — Troubleshooting](https://docs.codemie.ai/admin/update/codemie/update-version)
