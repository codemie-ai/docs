# How is my AI Champions Leaderboard score calculated?

Your score is a weighted sum of six dimension scores, each normalized to a 0–1 range and
multiplied by the dimension's weight. The final result is scaled to 0–100.

| Dimension                     | Weight |
| ----------------------------- | ------ |
| D1: Core Platform Usage       | 20%    |
| D2: Core Platform Creation    | 20%    |
| D3: Workflow Usage            | 10%    |
| D4: Workflow Creation         | 10%    |
| D5: CLI & Agentic Engineering | 30%    |
| D6: Impact & Knowledge        | 10%    |

CLI and agentic engineering (D5) carries the highest weight at 30%, reflecting that
command-line and agent-based AI usage represents the most advanced form of platform
engagement.

Each dimension is itself composed of weighted sub-components — for example, D1 counts
active days, number of conversations, assistants used, and platform feature breadth. To
improve your score, focus on expanding usage across more dimensions, especially D5.

## Sources

- [AI Champions Leaderboard](https://codemie-ai.github.io/docs/user-guide/analytics/ai-champions-leaderboard)
