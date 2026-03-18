# How to start working with my Elastic? How to integrate Elastic with CodeMie?

To integrate Elastic with CodeMie, you can use two different flow described in step 1 and 2 follow the steps below:

1. For create Elastic api_token with curl:  
   1.1. Use command for curl below:

curl -X POST "https://\<elasticsearch_url>:9200/\_security/api_key" \  
-H "Content-Type: application/json" \  
-H "Authorization: Basic \<base64-encoded-username-password>" \  
-d '{  
 "name": "my-api-key",  
 "role_descriptors": {  
 "my-role": {  
 "cluster": ["all"],  
 "index": [  
 {  
 "names": ["*"],  
 "privileges": ["read"]  
 }  
 ]  
 }  
 }  
}'  
1.2. In answer you receive the response:  
 {  
 "id": "id-of-the-api-key",  
 "name": "my-api-key",  
 "api_key": "your-api-key-value"  
}  
 1.3. Copy id and api_key.  
 \* Or you can use the web kibana interface from step 2.  
2. For create api_token from Kibana UI:  
 2.1. Navigate Management and Stack Management.  
 2.2. Navigate Security and click API keys.  
 2.3. Click Create API key, fill the Name field and click Create API key.  
 2.4. Click on the format key, mandatory key type displayed in Base64 format, and choose JSON:  
{"id":"example-id","name":"elastic_api_token","api_key":"example-key","encoded":"example-encoded-value"}  
 2.5. Copy id and api_key.  
3. In the CodeMie main menu, click the Integrations button.  
4. Select Integration Type: User or Project and click Create  
5. Select the Project Name.  
6. Select the Credential Type: Elastic.  
7. Fill in the Alias is a representation of the user setting.  
8. Fill in the Elastic URL.  
9. Fill in the API key ID field id value from step 1.2 or 2.5.  
10. Fill in the API Key field api_key value form step 1.2 or 2.5.  
11. Click Create Integration.  
12. Create or edit assistant.  
13. Click Explore Assistant, Click Create Assistant fill in the following parameters:

- Project Name: Select the name of your project.
- Name: Specify the assistant name.
- Description: Specify description.
- System Instructions: Specify system instructions.
- Available tools: Data management and select from drop down list Elastic of credentials from step 6.

14. Click Create.

## Sources

- [Elastic](https://docs.codemie.ai/user-guide/tools_integrations/tools/elastic)
