# How does the backend Mermaid rendering API work in CodeMie? What API endpoint should I use to render Mermaid diagrams on the backend? How can I programmatically generate and embed Mermaid diagrams in CodeMie? Where are rendered Mermaid diagrams stored in the CodeMie system? How is the file naming handled for backend-rendered Mermaid diagrams?

CodeMie provides a dedicated API endpoint for rendering Mermaid diagrams on the backend:

/v1/files/diagram/mermaid

How to Use the API:

1. Send a POST request to the endpoint with Mermaid markdown in the request body
2. The endpoint renders the Mermaid markdown into an SVG image
3. The SVG image is stored in the file repository with a unique generated name
4. The endpoint returns the generated name, which can be used to embed the image

## Sources

- [Html Preview](https://docs.codemie.ai/user-guide/assistants/html-preview)
