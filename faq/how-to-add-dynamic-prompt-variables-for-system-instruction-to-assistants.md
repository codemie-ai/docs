# How to add dynamic prompt variables for system instruction to assistants? How to edit prompt variables in system instruction? How to customized prompt variables for assistant published on Marketplace?

Dynamic prompt variables enable you to define and manage a set of key-value pairs for assistant system prompts via jinja-style `{{ key }}` templates.  
Key-values are referenced in system instructions and can be user-defined in free form. During assistant creation or editing, missing variables could be prompted for input, with integrations automatically created or updated and linked to assistant and project context.

How to add dynamic variables:

1. Open Create/ Edit assistant page (also available by navigating to Chats -> Configuration -> Configure & Test)
2. On system instruction section click on '**Manage Prompt Vars**' button
3. In the modal window click on **+Add variable** button
4. Fill the fields:

- Key field is required (allowed: lower case characters and “\_” (underscore))
- Default Value field is optional
- Description field is optional

5. After variable is added press on **Add**, and **Save** buttons
6. Newly added variable will appear under the System instruction in variables field
7. Add variable to system instruction by clicking on it
8. It will appear where the cursor is present in system instruction

For editing variables:

1. Open Manage Prompt Vars modal window
2. Press on ‘pencil’ icon near the variable
3. Make changes for Default value/ Description fields
4. Press on ‘check’ icon, and on Save button

Note. The key value is not editable. In case, you require to change it, delete variable and add a new one.

In case, the key is added to system instruction, but not added previously to Manage Prompt Vars, the system will warn you.

**Assistant with dynamic prompt variables was published on Marketplace**

Prompt variables are displaying on assistant details page under the system instruction.  
In case, the description was added, it will be available by hovering on a tooltip near the key.

You’re able to **customize prompt variable** by editing the value:

- Click on ‘pencil’ icon
- Make changes to the value field
- Click on ‘check’ icon

After edit the blue icon will appear near the key, it means that the **prompt variable** was changed from the initial version.  
Customized changes will be applied only for you, other users will see the initial **prompt variable** value.  
If you want to return to the initial version – click the round arrow icon.

## Sources

- [Plugin](https://docs.codemie.ai/user-guide/tools_integrations/tools/plugin)
