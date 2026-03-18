# How do I create a Mermaid diagram in chat conversations? What types of diagrams can I create with Mermaid in CodeMie? How do I edit a Mermaid diagram I've already sent in chat? How do I download a mermaid diagram from a chat conversation? What file formats are available for exporting mermaid diagrams?

## Using Mermaid Diagrams in Chat

## Overview

CodeMie supports creating and visualizing Mermaid diagrams directly within chat conversations. Mermaid is a simple markdown-like syntax that lets you create and render diagrams from text, improving communication about processes, workflows, structures, and relationships.

## Supported Diagram Types

You can create various types of diagrams including:

- Flowcharts
- Sequence diagrams
- Class diagrams
- Entity-Relationship diagrams
- State diagrams
- Gantt charts
- Pie charts
- User Journey diagrams

## Creating Mermaid Diagrams in Chat

1. Start a message in any chat conversation
2. Insert your Mermaid diagram code using the following syntax:

````
```mermaid
graph TD
    A[Start] --> B{Is it working?}
    B -->|Yes| C[Great!]
    B -->|No| D[Debug]
    D --> B
````

````

3. Send your message
4. The Mermaid code will automatically render as a visual diagram

## How Mermaid Rendering Works

When you send a message containing Mermaid code:

1. The backend server receives your Mermaid markdown
2. The markdown is processed and rendered into an SVG image
3. The SVG image is stored in our secure file repository
4. The image is automatically embedded in your chat message

This backend rendering ensures:
- Consistent diagram appearance for all users
- Reduced processing load on users' devices
- Reliable rendering of complex diagrams

## Editing Mermaid Diagrams

1. Find the message containing your Mermaid diagram
2. Select the message to edit
3. Modify the Mermaid code as needed
4. Save the changes
5. The diagram will re-render with your updates

Note: When you edit a Mermaid diagram, the backend re-renders the diagram and creates a new SVG image in the file repository.

## Downloading Mermaid Diagrams

You can now download your mermaid diagrams in multiple formats for use outside of CodeMie:

1. Create or navigate to a mermaid diagram in your chat
2. Click the "Download" button that appears when viewing the diagram
3. Select your preferred format:
   - **PNG format**: Best for general use and inserting into documents
   - **SVG format**: Ideal for scalable graphics and further editing
4. The diagram will be downloaded to your device in the selected format

 Benefits of Different Formats
- **PNG**: Creates a raster image that works well in most applications
- **SVG**: Produces a vector file that maintains quality at any size and can be edited with vector graphics software

## Example Diagrams

## Simple Flowchart

```mermaid
graph TD
    A[Start] --> B{Is it working?}
    B -->|Yes| C[Great!]
    B -->|No| D[Debug]
    D --> B
````

## Sequence Diagram

```mermaid
sequenceDiagram
    participant User
    participant System
    User->>System: Request data
    System->>Database: Query
    Database-->>System: Return results
    System-->>User: Display data
```

## Class Diagram

```mermaid
classDiagram
    Class01 \<|-- AveryLongClass : Cool
    Class03 *-- Class04
    Class05 o-- Class06
    Class07 .. Class08
    Class09 --> C2 : Where am I?
    Class09 --* C3
    Class09 --|> Class07
    Class07 : equals()
    Class07 : Object[] elementData
    Class01 : size()
    Class01 : int chimp
    Class01 : int gorilla
```

## Tips for Using Mermaid Diagrams

- Keep diagrams simple and focused for better readability
- Use consistent naming conventions for nodes and connections
- Add comments within your Mermaid code for complex diagrams
- Test complex diagrams with the Mermaid Live Editor before posting in chat
- Remember that all standard Mermaid syntax is supported

## Sources

- [Html Preview](https://docs.codemie.ai/user-guide/assistants/html-preview)
