# How do I automatically generate YAML for workflows? How do I generate a workflow with AI in CodeMie? How to convert workflow requirements into YAML configurations?

CodeMie can draft a workflow configuration from a plain-language description, and can apply
plain-language changes to a configuration you already have. Two features cover this:

- **Generate Workflow with AI** — creates a new workflow from a description
- **Refine Workflow with AI** — rewrites an existing workflow's YAML from an instruction

Both are available in the workflow editor. If you do not see them, AI workflow generation is not
enabled on your CodeMie instance — ask your administrator.

## Generate a New Workflow

1. Go to **Workflows** and click **+ Create Workflow**
2. Open the **Generate Workflow with AI** dialog
3. Describe what the workflow should do, for example:

   > I need a workflow that processes incoming support tickets, categorizes them by priority, and
   > routes them to the appropriate team

4. Click **Generate with AI**
5. The generated configuration opens in the editor — review it in either the visual view or the
   YAML view before saving

The generated configuration is not saved automatically. Nothing changes on the platform until you
click **Save**.

## Refine an Existing Workflow

1. Open the workflow and enter edit mode
2. Open the **Refine Workflow with AI** dialog
3. Describe the change you want, for example:

   > Add retry logic to the LLM step and improve error handling throughout the workflow

4. Click **Refine with AI**
5. The rewritten YAML replaces the editor's current contents — review it, then save or discard

Refinement rewrites the whole configuration rather than patching it, so review the full diff
rather than just the part you asked about.

## What AI Generation Produces — and What It Does Not

Both features build workflows out of **assistant states**: each step is an LLM call against an
assistant, wired together with sequential, conditional, switch, parallel, or iterative
transitions.

They do **not** produce:

- **Tool states** — direct tool calls that run without an LLM
- **Custom node states** — including Transform Nodes, the standard way to reshape webhook payloads
  and API responses without an LLM call
- **Sub-workflow states** — calls into another workflow

Workflows built mostly from tool calls and Transform Nodes — webhook handlers, compliance checks,
API orchestration — have to be written directly, either in the YAML view or by assembling nodes in
the [Visual Editor](https://docs.codemie.ai/user-guide/workflows/create-workflow). A good approach
is to generate the assistant-driven part first, then add the tool and transform steps by hand.

## Tips for Better Results

1. **Be specific about inputs and outputs.** Say what the workflow receives and what each step
   should produce, not just what it should do.
2. **Name the branches.** Describe the decision points and what happens on each side, so the
   generator produces conditions rather than a straight line.
3. **Start small, then refine.** Generate a three or four step version, check it runs, then use
   **Refine with AI** to add error handling and edge cases.
4. **Check conditional expressions.** These are Python expressions evaluated against the deciding
   state's own output. Verify that every variable a condition references is actually a field of
   that state's output — see
   [Conditional Transitions](https://docs.codemie.ai/user-guide/workflows/configuration/state-transitions).
5. **Set `output_schema` on any state a condition reads.** A real JSON Schema makes the fields
   guaranteed; a plain example shape does not.

## Sources

- [Create Workflow](https://docs.codemie.ai/user-guide/workflows/create-workflow)
- [Configuration Reference](https://docs.codemie.ai/user-guide/workflows/configuration/configuration-reference)
- [State Transitions](https://docs.codemie.ai/user-guide/workflows/configuration/state-transitions)
- [Examples](https://docs.codemie.ai/user-guide/workflows/configuration/examples)
