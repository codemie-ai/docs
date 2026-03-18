# What authentication types does A2A support in CodeMie?

CodeMie supports four authentication types for A2A agents:

1. AWS Signature (AWS Signature Version 4):
   - For agents deployed on AWS
   - Required fields: AWS Region, AWS Access Key, AWS Secret Key
   - Optional fields: AWS Session Token, AWS Service Name

2. Bearer Token:
   - Token-based authentication
   - Required field: Bearer Token value

3. Basic Auth:
   - Username/password authentication
   - Required fields: Username, Password

4. API Key:
   - Custom header-based authentication
   - Required fields: API Key Value, Header Name

Most A2A agents are publicly accessible and don't require authentication. Only configure authentication if your external agent requires credentials.

## Sources

- [A2A](https://docs.codemie.ai/user-guide/tools_integrations/tools/a2a)
