# How to create a request by OpenAPi? How to integrate OpenApi supported service with CodeMie?

To integrate OpenAPI with CodeMie.

1. In the CodeMie main menu, click the Integrations button.
2. Select Integration Type: User or Project and click Create.
3. Select the Project Name.
4. Select the Credential Type: OpenAPI.
5. Alias: Enter the name of the integration.
6. OpenAPI Spec: (optional)
7. Radio button: If a username and password are required, you can provide them here.
8. API Key: Select this option if authorization via API key is needed.
9. Click Create Integration.
10. Create or edit assistant.
11. Click Explore Assistant, Click Create Assistant fill in the following parameters:

- Project Name: Select the name of your project.
- Name: Specify the assistant name.
- Description: Specify description.
- System Instructions: Specify system instructions.
- Available tools: Open API and select from drop down list OpenAPI check Invoke external API , Get Open API spec is turned on.

12. Click Create.

Example: get response from api https://fakerestapi.azurewebsites.net/api/v1/Activities.

## Sources

- [Openapi Tool](https://docs.codemie.ai/user-guide/tools_integrations/tools/openapi-tool)
