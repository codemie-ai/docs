# How do I attach skills to assistant in a workflow?

To attach skills to a assistant defined in workflow YAML:

1. Open the skill in CodeMie, navigate to **Skill Details**, and copy the **Skill ID** (UUID) from the right panel.
2. In the workflow builder, open **Workflow Config** → **YAML** tab.
3. Under the `assistants` section, add a `skill_ids` list with the skill UUID(s):

```yaml
assistants:
  - id: html_generating_assistant
    model: gpt-4.1
    system_prompt: |
      Your assistant instructions here.
    skill_ids:
      - 660c5b0e-****-****-****-a0ea50db3042
```

4. Click **Save** and run the workflow. The assistant loads the configured skills on demand during execution.

You can attach multiple skills to one assistant by listing multiple IDs under `skills`.

## Sources

- [Skills in Workflow Assistants](https://codemie-ai.github.io/docs/user-guide/skills/skills-in-workflow-assistants)
