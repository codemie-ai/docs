# How can I process Microsoft Word (.docx) documents? What DOCX processing capabilities are available in CodeMie? How do I extract text and images from Word documents? What document metadata can I extract from Microsoft Word files? Does CodeMie support automated analysis of Word document structure and sections?

CodeMie provides comprehensive processing of Microsoft Word documents (.docx files) through a robust DOCX Processing Tool, offering flexible extraction and analysis capabilities.

## Supported Query Types

Basic Text Extraction

- **text**: Extract plain text content from the document
- **text_with_metadata**: Retrieve document content along with properties (author, title, creation date, etc.)

Advanced Content Extraction

- **text_with_images**: Include OCR text from embedded images
- **structure_only**: Extract document hierarchy (headers, sections, styles)
- **image_extraction**: Export embedded images from the document
- **table_extraction**: Extract tables with preserved formatting

Analysis Features

- **summary**: Generate concise document overviews
- **analyze**: Perform custom analysis with user-provided instructions

## How to Use

Via Chat Interface

1. Click the paperclip button (📎) in the chat interface
2. Upload your .docx file (up to 50MB)
3. Specify your desired query type or analysis request
4. Optionally specify page ranges (e.g., "1-4" or "1,3,5")

Example Queries  
`"Extract the text from pages 1-3 of this document" "Get the document metadata and structure" "Analyze this document and identify key arguments" "Extract all tables from this Word document" "Generate a summary of the document's main points"`

## Advanced Features

Custom Analysis  
Use the "analyze" query with specific instructions:

- "Identify key arguments and supporting evidence"
- "Extract action items and deadlines"
- "Summarize technical specifications"

Selective Processing  
Process specific sections by specifying:

- Page ranges: "1-4", "5-10"
- Individual pages: "1,3,5,7"
- Sections based on document structure

File Requirements

- **Format**: Microsoft Word (.docx) files
- **Size Limit**: 50MB maximum
- **Compatibility**: Supports modern Word document formats
- **Error Handling**: Gracefully handles corrupted or unsupported files

## Sources

- [Supported File Formats And Csv Handling In Chat Assistant](https://docs.codemie.ai/user-guide/assistants/supported-file-formats-and-csv-handling-in-chat-assistant)
