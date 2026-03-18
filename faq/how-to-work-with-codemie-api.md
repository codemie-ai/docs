# How to work with codemie api? How to get codemie api token ?

## 1. Requesting API Credentials

To access the CodeMie API, request your API credentials via:  
 [https://epa.ms/codemie-support](https://epa.ms/codemie-support)

After review, you'll receive:

- client_id

- client_secret

Note: Please note that the assistant you'll be working with via the API only has project integrations. User integrations will not work and will simply be ignored, as these integrations are personal, and the clientSecret works under its own service-account-user.

## 2. Authentication (JWT Token Request)

### Base URL:

arduino
https://auth.examle.com/auth/

### Token Endpoint:

swift
POST /realms/codemie-prod/protocol/openid-connect/token

### Authorization Header:

http
Content-Type: application/x-www-form-urlencoded

### Body Parameters:

bash
client_id=\<your-client-id>
client_secret=\<your-client-secret>
grant_type=client_credentials

### Sample cURL Command:

bash  
curl --location 'https://auth.example.com/realms/codemie-prod/protocol/openid-connect/token' \  
--header 'Content-Type: application/x-www-form-urlencoded' \  
--data-urlencode 'client_id=\<client-id>' \  
--data-urlencode 'client_secret=\<client-secret>' \  
--data-urlencode 'grant_type=client_credentials'

### Response Example:

json  
{  
 "access_token": "example-token",  
 "expires_in": 28500,  
 "token_type": "Bearer"  
}

---

## 3. Making API Requests

### Authorization Header:

http  
Authorization: Bearer \<access_token>

---

## 4. Example: Calling an Assistant

### Endpoint:

bash
POST /v1/assistants/{assistant_id}/model

### Body Parameters:

json  
{  
 "text": "hi",  
 "llmModel": "gpt-4o",  
 "stream": true  
}

### Streamed Response:

You'll receive incremental JSON chunks like:

json  
{  
 "message": "Hello",  
 "in_progress": true,  
 ...  
}  
{  
 "message": "!",  
 ...  
}

Or if stream: false, you’ll get:

json  
{  
 "generated": "Hello! How can I assist you today?",  
 "timeElapsed": 1.1  
}

More info you can find in our knowledge base: https://kb.epam.com/display/EPMCDME/CodeMie+API+Integration

## Sources

- [Client Secret Access](https://docs.codemie.ai/user-guide/api/client-secret-access)
- [User Password Access](https://docs.codemie.ai/user-guide/api/user-password-access)
