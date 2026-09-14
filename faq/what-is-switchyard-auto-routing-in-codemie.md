# What is Switchyard auto-routing in CodeMie?

Switchyard is a per-call routing layer that decides, request by request, whether to send an
LLM call to a higher-quality "capable" model or a cheaper "efficient" model from the same
family, without any manual model switching. The decision uses either lightweight heuristics
with no extra LLM calls (`signal` mode) or a small classifier call that assesses request
complexity first (`classifier` mode).

Administrators enable it by declaring one or more routers on a capable model's entry in the
LLM model configuration YAML, and setting `SWITCHYARD_ENABLED=true` (the platform-wide master
switch, off by default). Each router then appears as a selectable entry in the LLM model
dropdown — commonly labeled with an `SY` prefix — that routes each call in the conversation to
either tier depending on the request.

## Sources

- [Switchyard Auto-Routing](https://docs.codemie.ai/admin/configuration/codemie/ai-models-integration/switchyard-model-routing)
