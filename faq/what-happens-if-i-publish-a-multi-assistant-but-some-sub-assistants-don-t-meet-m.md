# What happens if I publish a multi-assistant but some sub-assistants don't meet marketplace eligibility criteria? Can I edit integration mappings for my published multi-assistant after it's in the marketplace? Publishing assistants with sub-assistants (orchestrators) to the Marketplace involves additional validation and configuration steps to ensure all components work seamlessly for end users.

## Publishing:

Step 1: Initiate Publishing

1. Navigate to your **Project Assistants** section
2. Select the multi-assistant you want to publish
3. Click **"Publish to Marketplace"**

Step 2: Integration Analysis  
The system automatically analyzes:

- Required integrations for the main assistant and all sub-assistants
- Prompt variable mappings across the entire assistant tree
- Missing configurations that could prevent proper functionality

Step 3: Integration and Variable Mapping  
If missing configurations are detected:

- A modal will appear prompting you to resolve missing requirements
- **Select existing integrations** from your personal list or create new ones
- **Map prompt variables** for both main assistant and sub-assistants
- Ensure all dependencies are satisfied before proceeding

Step 4: Sub-Assistant Category Selection

- Select categories for each sub-assistant that will be published
- Use the **Select All** option for bulk category assignment
- If no categories are selected for sub-assistants, a confirmation modal appears:
  - **Option 1**: Cancel and return to category selection
  - **Option 2**: Confirm and apply parent assistant categories to sub-assistants

Step 5: Final Validation and Publishing

- System performs final validation of all configurations
- Publishing is blocked if any requirements are unmet
- Once validated, your multi-assistant is published to the Marketplace

## Features:

**Comprehensive Validation**

- Prevents incomplete publishing by validating entire assistant tree
- Ensures all integrations and variables are properly configured
- Provides clear feedback on missing requirements

**Interactive Configuration**

- User-friendly modals guide through integration selection
- Seamless prompt variable mapping interface
- Intuitive category assignment for sub-assistants

**Marketplace Navigation**

- Proper back navigation from sub-assistant details to parent assistant
- Clear marketplace indicators for published sub-assistants
- Consistent UI/UX aligned with marketplace design standards

## Sources

- [Marketplace Publishing](https://docs.codemie.ai/user-guide/assistants/marketplace-publishing)
- [Sub Assistants Multi Assistant Orchestrator](https://docs.codemie.ai/user-guide/assistants/sub-assistants-multi-assistant-orchestrator)
