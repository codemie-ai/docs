---
id: llm-model-name-in-workflow
title: 4.8 LLM Model Name in Workflow
sidebar_label: LLM Model Name
sidebar_position: 8
---

# 4.8 LLM Model Name in Workflow

To find the LLM model name used in a workflow:

1. Open the Codemie web page: Go to https://epa.ms/codemie

2. Open DevTools (Developer Tools): Press the **F12** key or right-click on the page and select **Inspect**.

3. Go to the **Network** tab: This tab shows all network requests made by the page.

4. Refresh the page (**F5**): This will load all the network activity, including the LLM request.

5. Find the request named **llm_models**: In the "Name" column filter or search for llm_models. Double-click on the request or select it.

   ![Network tab showing llm_models request](../images/image110.png)

6. Click on the **Response** tab: You will see a JSON response from the server.

7. Locate the **base_name** field: Inside the JSON object, you'll find model information. The base_name field indicates the model name used in the workflow.
