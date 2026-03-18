# How to send notifications to Telegram? How to integrate Telegram with CodeMie?

To integrate Telegram with CodeMie, follow the steps below:

1. Open Telegram:  
   1.1. Search for BotFather: In the Telegram search bar, type "BotFather" and select the verified BotFather bot.  
   1.2. Start a Chat with BotFather: Click on the "Start" button or type /start to begin the interaction with BotFather.  
   1.3. Create a New Bot: Type /newbot and send the message. BotFather will guide you through the process of creating your bot.  
   1.4. Set the Name for Your Bot: BotFather will ask you to choose a name for your bot. This can be anything you like, such as "My Sample Bot".  
   1.5. Set the Username for Your Bot: BotFather will then ask you to choose a username for your bot. The username must end with "bot". For example, my_codemie_bot or sample_codemie_bot.  
   1.6 Receive the Bot Token: After you have chosen a unique username, BotFather will provide you with an API Token. This token is essential and will be used to interact with the Telegram API to manage and control your bot.

2. In the CodeMie main menu, click the integrations button.
3. Select Integration Type: User or Project and click Create
4. Select the Project Name.
5. Select the Credential Type: Telegram.
6. Fill in the Alias is a representation of the user setting.
7. Fill in the Telegram Bot Token field with the API Token from step 1.6.
8. Click Create Integration.
9. Click Explore Assistant, Click Create Assistant fill in the following parameters::

- Project Name: Select the name of your project.
- Name: Specify the assistant name.
- Description: Specify description.
- System Instructions: Specify system instructions.
- Available tools: Notification - Telegram and select from drop down list Alias of credentials from step 6.

10. Click Create.
11. Add the Telegram BOT to the group.

12. Message your bot in the group. E.g. If your bot is called ExampleBot, send a message from your personal account @ExampleBot /start to the group. Prior to this your bot does not have access to the messages in the chat.

13. Get the list of updates for your BOT:

[https://api.telegram.org/bot](https://api.telegram.org/bot)\<YourBOTToken>/getUpdates

Example: https://api.telegram.org/bot123456789:jbd78sadvbdy63d37gda37bd8/getUpdates

13. Look for the "chat" object:

{ "update_id": 8393, "message": { "message_id": 3, "from": { "id": 7474, "first_name": "AAA" }, "chat": { "id": \<group_ID>, "title": "\<Group name>" }, "date": 25497, "new_chat_participant": { "id": 71, "first_name": "NAME", "username": "YOUR_BOT_NAME" } } }  
This is a sample of the response when you add your BOT into a group.

14. Use the "id" of the "chat" object to send your messages (always negative?).
15. (If you created the new group with the bot and you only get {"ok":true,"result":[]}, remove and add the bot again to the group)

Query Example: Answer me in telegram in chat chat_id.

## Sources

- [Telegram](https://docs.codemie.ai/user-guide/tools_integrations/tools/telegram)
