# Manual adjustments in workflows? Adjusting generated text in workflows.How to manually adjust generated content in a workflow? Examples of manual adjustments in workflows? How do I edit content during a workflow execution?

###

During a workflow step that generates an output draft, users can manually edit the generated content before giving final approval. This is particularly useful when the generated text needs adjustments to better fit the context or correct any inaccuracies.

## How to Edit Workflow Outputs

When a workflow reaches a step with `wait_for_user_confirmation: true`, you'll see three action buttons:

1. **Edit** - Opens the editing interface
2. **Cancel** - Cancels the current workflow state
3. **Continue** - Proceeds with the workflow using the current output

## Using the Edit Feature

1. Click the **Edit** button to open the editing popup interface
2. The popup will display:
   - **Edit output** (header)
   - An editable text area containing the generated content
   - **Cancel** button to discard changes
   - **Apply** button to save changes
   - **Current version** section showing the original generated output (read-only with copy functionality)

3. Make your desired changes in the editable text area
4. After editing, you'll see:
   - Your edited content with changes highlighted
   - **Cancel** button
   - **Save** button

5. Click **Save** to apply your changes
6. A confirmation message will appear: "Workflow execution Output has been edited successfully"
7. The workflow will continue with your edited version of the content

## Example Use Cases

- Refining AI-generated newsletter content
- Adjusting JIRA ticket descriptions before submission
- Correcting technical documentation details
- Customizing email responses before sending

## Example Workflow Configuration

assistants:

- id: content_editor Unique identifier for the assistant in this configuration  
  assistant_id: 12345678-9abc-def0-1234-56789abcdef0 CodeMie assistant ID  
  model: 'gpt-4o' Optional model override
- id: reviewer  
  assistant_id: 87654321-fedc-ba09-8765-4321fedcba09  
  model: 'gpt-4o' Optional model override

states:

- id: content_editing Unique identifier for the state in this configuration  
  assistant_id: content_editor  
  task: |  
   Generate a draft of the content based on the provided requirements.  
  output_schema: |  
   {  
   "draft": "String. The generated content draft."  
   }  
  next:  
   state_id: review_and_edit Unique identifier for the next state

- id: review_and_edit Unique identifier for the state in this configuration  
  assistant_id: reviewer  
  task: |  
   Review the generated draft and make any necessary manual adjustments.  
  output_schema: |  
   {  
   "final_content": "String. The manually adjusted content."  
   }  
  wait_for_user_confirmation: true  
  next:  
   state_id: finalize

- id: finalize Unique identifier for the state in this configuration  
  assistant_id: reviewer  
  task: |  
   Finalize the content for publication.  
  output_schema: |  
   {  
   "success": "Boolean. If the content was finalized successfully return true, otherwise false."  
   }  
  next:  
   condition:  
   expression: "success == True"  
   then: end  
   otherwise: review_and_edit

This example scenario demonstrates how users can manually adjust generated text within a workflow. By following the steps outlined, users can ensure the content meets their needs and is accurate before finalizing it. This enhances the flexibility and functionality of the workflow system.

### **1.2.52. Workflow Example with condition?**

assistants:

- id: business_analyst Unique identifier for the assistant in this configuration  
  assistant_id: 196ede41-e7f0-4658-ae99-1dc0d83c8347 CodeMie assistant ID  
  model: 'gpt-4o' Optional model override
- id: onboarder  
  assistant_id: d09ec675-16db-4aba-901d-1fff17d84692  
  model: 'gpt-4o' Optional model override

states:

- id: onboarder Unique identifier for the state in this configuration  
  assistant_id: onboarder  
  task: |  
   Find all relevant information about workflow implementation and describe it as a requirements description for a business analyst.  
  next:  
   state_id: business_analyst Unique identifier for the next state
- id: business_analyst Unique identifier for the state in this configuration  
  assistant_id: business_analyst  
  task: |  
   You must analyze all provided requirements about workflows functionality and put a comprehensive description for QA  
   engineers, support team, and users on how to use this functionality with key points into a comment for Jira ticket EPMCDME-1350.  
  output_schema: |  
   {  
   "success": "Boolean true | false. If you created the Jira comment successfully return true, otherwise false",  
   "comment_body": "Return the comment body which you left in Jira"  
   }  
  next:  
   condition:  
   expression: "success == True"  
   then: end  
   otherwise: business_analyst

## Sources

- [Advanced Features](https://docs.codemie.ai/user-guide/workflows/configuration/advanced-features)
- [Examples](https://docs.codemie.ai/user-guide/workflows/configuration/examples)
