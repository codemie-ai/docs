# How do I filter GitHub webhook events by payload content in CodeMie?

The **GitHub JSON Path Filter** field in a Webhook integration allows filtering GitHub events
based on payload content, beyond just the event type. The filter is evaluated after the
**GitHub Event Filter** (if configured), so only events that pass the event-type check are
tested against the JSONPath expression.

To configure it:

1. Open the Webhook integration settings (**Integrations → Project** → select or create a
   Webhook integration).
2. Ensure **GitHub Webhook Secret** is set — a JSON Path Filter requires a configured webhook
   secret. Saving without one returns a validation error.
3. Enter a JSONPath expression in the **GitHub JSON Path Filter** field:
   - **Existence check**: `$.pull_request.draft` — matches if the field is present in the
     payload, regardless of its value.
   - **Value comparison**: `$[?(@.pull_request.draft==false)]` — matches if the field equals
     the specified value.
4. Save the integration. The filter takes effect immediately for new incoming webhook deliveries.

## Sources

- [Webhook](https://docs.codemie.ai/user-guide/tools_integrations/tools/webhook)
