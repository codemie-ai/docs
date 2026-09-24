# Why are CodeMie pods stuck in ImagePullBackOff after an update?

`ImagePullBackOff` or `ErrImagePull` errors after a CodeMie update most commonly mean that
the `gcp-artifact-registry` Kubernetes image pull secret contains expired GCP service account
credentials. Service account keys have a **90-day retention period** and expire automatically.

To resolve this, request a new `key.json` from the AI/Run CodeMie support team and follow
the [Update Image Pull Secret](https://docs.codemie.ai/admin/update/codemie-platform/update-image-pull-secret)
guide to recreate the secret in the cluster.

## Recommended Approach

To prevent `ImagePullBackOff` errors in the cluster, mirror AI/Run CodeMie container
images to a client-owned private registry. When the Kubernetes cluster pulls images from
a client-owned registry, expired `gcp-artifact-registry` credentials have no impact on
pod scheduling.

Note: the GCP service account key still requires rotation on the same 90-day cycle.
However, the rotation is applied to the image mirroring pipeline — the component
responsible for pulling images from the AI/Run CodeMie GCP Artifact Registry and pushing
them to the client registry — rather than to the Kubernetes cluster itself.

A private registry can be provisioned using:

- **Terraform automation** — the AI/Run CodeMie deployment repository includes Terraform
  modules that can provision a private container registry as part of the infrastructure
  setup.
- **Self-hosted registry** — an existing private container registry can be configured to
  mirror and cache CodeMie images.

## Sources

- [Update Image Pull Secret](https://docs.codemie.ai/admin/update/codemie-platform/update-image-pull-secret)
- [Update AI/Run CodeMie — Troubleshooting](https://docs.codemie.ai/admin/update/codemie-platform/update-core-components)
