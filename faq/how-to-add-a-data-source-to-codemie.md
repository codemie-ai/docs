# How to add a Data Source to CodeMie? How to add project specific data? how to index project specific data? How to add File? How to add Json? How to

To add new Data Source to the CodeMie platform, please follow these steps:

1. Click on the Data Sources section.
2. Click create Datasource
3. Enter a name for your Data Source(Confluence, Text File, Json or Google), adhering to the following restrictions:
   - All letters must be lowercase.
   - Avoid starting the name with an underscore (\_) or a hyphen (-).
   - The name cannot contain spaces, commas, or special characters such as: :, ", \*, +, /, , |, ?, , >, \<.
4. Type Description.
5. Choose Datasource Type: Git, Confluence, Text File, Json or Google docs link files.
6. Provide the data for your Data Source:
   - For Links: Enter a list of URLs in the provided text field.
   - For JSON: Input a raw JSON object in the appropriate text field.
   - For Text/PDF: Use the selection widget to choose multiple files as needed.
   - Max size of file: 50Mb
7. (Optional) Specify index-specific prompts settings. Here you can add specific instructions relevant to the Data Source, which can later assist in generating accurate responses. Define the name associated with these instructions and the template for them. An index can contain multiple prompts, accessible to everyone in the project.

## Sources

- [Add File Datasource](https://docs.codemie.ai/user-guide/data-source/datasources-types/add-file-datasource)
