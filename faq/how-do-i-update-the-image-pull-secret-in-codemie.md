# How do I update the image pull secret in a CodeMie deployment?

Delete the existing secret and recreate it with the new `key.json` credentials:

```bash
kubectl delete secret gcp-artifact-registry -n codemie
kubectl create secret docker-registry gcp-artifact-registry \
  --docker-server=https://europe-west3-docker.pkg.dev \
  --docker-email=<client_email_from_key.json> \
  --docker-username=_json_key \
  --docker-password="$(cat key.json)" \
  -n codemie
```

A new `key.json` must be requested from the AI/Run CodeMie support team before running this
command. The `client_email` value to pass to `--docker-email` is found inside the `key.json`
file itself.

## Sources

- [Update Image Pull Secret](https://docs.codemie.ai/admin/update/codemie/update-image-pull-secret)
