---
id: add-file-datasource
title: Add and Index File DataSource
sidebar_label: Add and Index File DataSource
---

# Add and Index File DataSource

Upload and index files as data sources.

File data sources enable you to upload documents directly to AI/Run CodeMie, making their content accessible to assistants. This guide walks you through the process of adding and indexing various file types.

## Prerequisites

Before adding a File data source, ensure you have:

- Files prepared in supported formats
- Files within the size limit (50MB maximum)
- Understanding of your file structure for optimal configuration

## Supported File Formats

AI/Run CodeMie supports the following file formats:

- **PDF** (`.pdf`) - Portable Document Format
- **Text** (`.txt`) - Plain text files
- **CSV** (`.csv`) - Comma-separated values with advanced configuration options
- **PowerPoint** (`.pptx`) - Microsoft PowerPoint presentations
- **XML** (`.xml`) - Extensible Markup Language files
- **JSON** (`.json`) - JavaScript Object Notation files
- **YAML** (`.yaml`, `.yml`) - YAML Ain't Markup Language files
- **Word** (`.docx`) - Microsoft Word documents
- **Excel** (`.xlsx`) - Microsoft Excel spreadsheets

### File Size Limitations

**Maximum file size**: 50MB per file

:::warning Size Limit
Files larger than 50MB cannot be uploaded. If you need to index larger files, consider splitting them into smaller chunks or using alternative data source types (e.g., Git repositories for code, Confluence for documentation).
:::

## Adding a File Data Source

To add a File as a Data Source with AI/Run CodeMie platform, follow these detailed steps:

![File Data Source Form](./add-file-datasource/file-datasource-form.png)

### Step-by-Step Process

#### 1. Preparation

Prepare the file(s) that will be used. Make sure the file(s) corresponds to the requirements:

**Requirements checklist:**
- Max size: 50MB per file
- File format is one of the supported types listed above
- File content is relevant to your assistant's purpose
- File is not corrupted or password-protected

#### 2. Navigate to Data Sources

Navigate to the **Data Sources** section in AI/Run CodeMie.

#### 3. Create New Data Source

Click the **+ Create Datasource** button and add all required data according to recommendations.

#### 4. Select File Source Type

Select **File** source type in the add new data source window.

#### 5. Configure File-Specific Fields

##### Project
Select the name of the project with which you want to associate that DataSource.

**Purpose**: Organizes data sources by project for better management and team collaboration.

##### Select File

Press on **Select File** and choose the file on your local machine. This field is required.

**Adding multiple files:**
- To add more than one file, click on the **+** icon below the Select file button
- You can upload multiple files to the same data source
- All files will be indexed together as a single data source

##### Data Source Name

Specify a relevant and distinctive name for your file data source.

**Naming best practices:**
- Use descriptive names that indicate the file content
- Follow lowercase naming conventions
- Use hyphens or underscores for word separation
- Examples: `product-specs`, `user-manual`, `financial-report-2024`

##### Description

Provide a brief description that outlines the file's content and purpose.

**Description best practices:**
- Explain what information the file contains
- Note any special formatting or structure
- Mention the intended use case
- Example: "Product specifications for Q1 2024 release"

##### Model Used for Embeddings

Specify the assistant's LLM model for processing file content.

**Purpose**: Determines which AI model processes the file content for indexing.

**Common options:**
- Standard models for general purposes
- Follow your organization's model selection guidelines

#### 6. Configure Format-Specific Options

Some file formats have additional configuration options:

##### CSV File Configuration

For `.csv` file format, you have the ability to configure additional options:

![CSV Configuration](./add-file-datasource/csv-configuration.png)

**CSV Separator**
Choose the delimiter used in your CSV file:
- **`;` (semicolon)** - Common in European locales
- **`,` (comma)** - Standard CSV separator
- **`\t` (tab)** - Tab-separated values

**CSV Start Row #**
Specify the row number where data begins:
- Use `1` if your CSV has no header row
- Use `2` if your CSV has a header row (most common)
- Use higher numbers if your CSV has multiple header rows or metadata

**CSV Rows Per Document #**
Define how many rows should be grouped together for search:
- **`1`** - Search row by row (fine-grained search)
- **Higher numbers** - Group multiple rows together (e.g., `15` to search all 15 rows as one unit)
- Consider your use case: individual records vs. grouped data

**Example scenarios:**
- Employee directory with 100 rows, search individually → use `1`
- Product catalog with 50 items, search all together → use `50`
- Transaction log with 1000 entries, search by batches of 100 → use `100`

##### JSON File Configuration

For `.json` file format, we recommend structuring your data with content and metadata fields:

![JSON Structure](./add-file-datasource/json-structure.png)

**Recommended JSON structure:**

```json
{
  "content": "Your main text content here",
  "metadata": {
    "title": "Document Title",
    "author": "Author Name",
    "date": "2024-01-01",
    "tags": ["tag1", "tag2"]
  }
}
```

**Benefits of this structure:**
- Better semantic search results
- Improved metadata filtering
- Enhanced context for AI responses
- Easier content organization

**Alternative structures:**
```json
[
  {
    "content": "First document content",
    "metadata": {"type": "documentation"}
  },
  {
    "content": "Second document content",
    "metadata": {"type": "tutorial"}
  }
]
```

#### 7. Create the Data Source

Click the **+ Create** button and wait for the process to finish.

**What happens next:**
1. AI/Run CodeMie validates the file format and size
2. File is uploaded to the platform
3. Indexing process begins automatically
4. Progress can be monitored in the data source list

## Error Handling for File Data Sources

### Common Errors

#### Incorrect File Format

**Symptom**: Error message appears below the file browse area of the Add data source window

![File Format Error](./add-file-datasource/file-format-error.png)

**Cause**: The file format is not supported by AI/Run CodeMie

**Solutions:**
1. Convert the file to a supported format
2. Verify the file extension matches the actual file type
3. Check if the file is corrupted
4. Ensure the file extension is spelled correctly

**Common format conversion suggestions:**
- `.doc` → Convert to `.docx` or `.pdf`
- `.xls` → Convert to `.xlsx` or `.csv`
- `.rtf` → Convert to `.docx` or `.txt`
- `.pages` → Export to `.pdf` or `.docx`

#### File Size Too Large

**Symptom**: Error message appears below the file browse area indicating size limit exceeded

![File Size Error](./add-file-datasource/file-size-error.png)

**Cause**: File exceeds the 50MB size limit

**Solutions:**
1. **Compress the file**: Use file compression to reduce size
2. **Split the file**: Divide into multiple smaller files
3. **Remove unnecessary content**: Delete images, embedded media, or redundant sections
4. **Use alternative data source**: Consider Git for code repositories, Confluence for large documents
5. **Optimize file format**:
   - For PDFs: Reduce image quality, remove embedded fonts
   - For Excel: Remove unused sheets, compress images
   - For PowerPoint: Compress media, reduce image resolution

#### Upload Failed

**Cause**: Network issues or server problems during upload

**Solutions:**
- Check your internet connection
- Retry the upload
- Try uploading during off-peak hours
- Ensure your browser is up to date
- Try a different browser

#### Corrupted File

**Cause**: File is damaged or incomplete

**Solutions:**
- Try opening the file locally to verify it works
- Re-download or re-create the file
- Check the original source for a valid copy
- Use file repair tools if available

## Best Practices

### File Preparation

- **Clean content**: Remove unnecessary formatting, images, or metadata
- **Consistent structure**: Use consistent formatting throughout the document
- **Clear naming**: Use descriptive file names
- **Remove sensitive data**: Ensure files don't contain confidential information

### File Organization

- **Group related files**: Upload related files to the same data source
- **Logical naming**: Use naming conventions that make files easy to identify
- **Version control**: Include version numbers or dates in file names when relevant
- **Documentation**: Add clear descriptions to each data source

### CSV Best Practices

- **Include headers**: Always include a header row with column names
- **Consistent delimiters**: Use the same separator throughout the file
- **Clean data**: Remove special characters that might interfere with parsing
- **Test configurations**: Try different row grouping options to find optimal search performance

### JSON Best Practices

- **Use content/metadata structure**: Follow the recommended JSON structure
- **Validate JSON**: Ensure JSON is valid before uploading
- **Consistent schema**: Use the same structure across multiple JSON files
- **Meaningful keys**: Use descriptive key names

### Performance Optimization

- **Right-size files**: Upload files at appropriate sizes (not too large, not too fragmented)
- **Optimize formats**: Use appropriate formats for your content type
- **Remove redundancy**: Eliminate duplicate information across files
- **Index strategically**: Only upload files that assistants actually need

## Use Cases

### Documentation Management

- Upload user manuals, guides, and technical documentation
- Index product specifications and requirements
- Make policy documents and procedures accessible
- Store training materials and handbooks

### Data Analysis

- Upload CSV files with datasets for analysis
- Index financial reports and spreadsheets
- Store research data and findings
- Make survey results accessible

### Knowledge Base

- Upload FAQ documents
- Index best practices and guidelines
- Store reference materials
- Make templates and examples accessible

### Project Documentation

- Upload project plans and roadmaps
- Index meeting notes and decisions
- Store design documents and specifications
- Make project reports accessible

## Maintenance

### Regular Tasks

- **Update files**: Re-upload files when content changes significantly
- **Remove outdated files**: Delete or replace obsolete documents
- **Monitor file size**: Keep files within size limits
- **Verify indexing**: Check that files are properly indexed

### Content Updates

**When to reindex:**
- File content has changed significantly
- New versions of documents are available
- Errors were found in the original file
- File structure has been reorganized

**How to update:**
1. Delete the old data source or create a new version
2. Upload the updated file(s)
3. Wait for reindexing to complete
4. Verify the updated content is accessible

## Troubleshooting Tips

### File Won't Upload

1. Check file size (must be under 50MB)
2. Verify file format is supported
3. Ensure stable internet connection
4. Try different browser
5. Check browser console for errors

### Indexing Takes Long Time

1. Check file size and complexity
2. Verify server load
3. Wait for completion (can take several minutes)
4. Check indexing status in data source list

### Content Not Searchable

**Common causes:**
- File contains images of text (not searchable text)
- PDF is scanned (use OCR first)
- File format not properly parsed
- Indexing not completed

**Solutions:**
1. Convert scanned PDFs to text-searchable PDFs
2. Extract text from images before uploading
3. Verify file format is correct
4. Wait for indexing to complete
5. Check data source status

### CSV Not Parsing Correctly

1. Verify correct separator is selected
2. Check CSV start row configuration
3. Ensure CSV has consistent formatting
4. Validate CSV structure
5. Try different rows per document setting

### JSON Not Indexing Properly

1. Validate JSON syntax
2. Check for proper content/metadata structure
3. Ensure consistent schema
4. Verify file encoding (should be UTF-8)
5. Test with simplified JSON first

## Next Steps

After adding your File data source:

- [Monitor indexing progress](../data-source-overview/indexing-data-sources)
- [Configure assistants](../../assistants/) to use the indexed files
- [Set up workflows](../../workflows/) that leverage file content
- Review [indexing duration](../data-source-overview/indexing-duration) estimates

:::tip Performance Tip
For large document sets, consider organizing files by topic or project rather than uploading everything to a single data source. This improves search performance and makes content more manageable.
:::

Now your files are configured as data sources and ready to enhance your assistants with document knowledge.
