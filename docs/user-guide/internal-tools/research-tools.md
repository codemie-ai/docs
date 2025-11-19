---
id: research-tools
title: Research tools
sidebar_label: Research tools
---

# Research tools

Access real-time information and perform location-based searches.

The Research toolkit enables your CodeMie assistants to access real-time information from the internet and perform location-based searches. This comprehensive toolkit includes six powerful tools designed to gather fresh, accurate data and location information for your AI assistant.

## Available Research Tools

### Web Search Tools

#### Google Search Tool

**Purpose**: Perform real-time Google searches to access current web information

**Input**: Search query

**Best for**: General web searches, current events, factual information

**Configuration**: No additional setup required

**Example usage**:

```
"Search for the latest Python 3.12 features and updates"
"Find current stock price for NVIDIA"
"What are the recent developments in AI technology?"
```

#### Tavily Search Results

**Purpose**: Comprehensive, accurate search results optimized for current events and AI applications

**Input**: Search query

**Best for**: Research-focused queries, current events, comprehensive analysis

**Configuration**: No additional setup required

**Example usage**:

```
"Research the environmental impact of electric vehicles in 2024"
"Find comprehensive information about quantum computing developments"
"Get up-to-date information about recent policy changes"
```

#### Wikipedia Tool

**Purpose**: Access Wikipedia's vast knowledge base for encyclopedic information

**Input**: Search query

**Best for**: Background information, historical data, general knowledge, biographical information

**Configuration**: No additional setup required

**Example usage**:

```
"Get information about the history of artificial intelligence"
"Explain the concept of blockchain technology"
"Tell me about Marie Curie's scientific contributions"
```

#### Web Scraper Tool

**Purpose**: Extract specific content from websites and convert HTML to markdown format

**Input**: URL (required), plus optional settings for images and links

**Best for**: Extracting content from specific URLs, parsing structured data, reading documentation

**Configuration**: No additional setup required

**Example usage**:

```
"Scrape content from https://example.com/documentation"
"Extract text content from this specific webpage URL"
"Get the main content from this blog post URL"
```

### Location-Based Tools

#### Google Places Tool

**Purpose**: Validate or discover addresses from ambiguous location text

**Input**: Location search query

**Best for**: Address validation, location verification, finding specific places

**Configuration**: No additional setup required

**Example usage**:

```
"Validate this address: 123 Main St, New York"
"Find the correct address for Central Park, NYC"
"Verify if this location exists: Golden Gate Bridge, San Francisco"
```

#### Google Places Find Near Tool

**Purpose**: Find places near a specific location using Google Places API

**Input**: Current location query (required), Target location/query (required), Search radius (optional)

**Best for**: Finding businesses, landmarks, or services near a particular location

**Configuration**: No additional setup required

**Example usage**:

```
"Find coffee shops near Times Square, New York"
"Locate gas stations within 5 miles of downtown Chicago"
"Find restaurants near my current location"
```

## How to Enable Research Tools

To enable research tools for your assistant:

1. Navigate to **Create Assistant** or **Edit Assistant**
2. In the **Available tools** section, find **Research**

![Research Tools Selection](./images/research-tools-enable.png)

3. Select the specific research tools you want to enable for your assistant
4. Click **Save** button
5. All tools are immediately available - no additional configuration needed

## Use Cases

Research tools are ideal for:

- **Current Events**: Get up-to-date information about news and recent developments
- **Fact-Checking**: Verify information using multiple sources
- **Location Services**: Find and validate addresses or nearby businesses
- **Data Gathering**: Collect information from various web sources
- **Market Research**: Gather competitive intelligence and market data
- **Academic Research**: Access encyclopedic and scholarly information
- **Content Analysis**: Extract and analyze content from specific websites

## Best Practices

### Search Queries

- **Be Specific**: Use clear, specific search terms for better results
- **Include Context**: Provide context when searching for ambiguous terms
- **Use Keywords**: Focus on important keywords rather than full sentences
- **Refine Results**: If initial results aren't helpful, refine your query

### Web Scraping

- **Verify URLs**: Ensure URLs are accessible and valid before scraping
- **Respect Robots.txt**: Be aware that some sites may restrict scraping
- **Handle Errors**: Be prepared for cases where scraping may fail
- **Review Content**: Always review scraped content for accuracy

### Location Searches

- **Provide Clear Locations**: Use specific addresses or well-known landmarks
- **Specify Radius**: When searching nearby, specify a reasonable search radius
- **Validate Addresses**: Use Google Places to verify addresses before using them
- **Include City/State**: For better accuracy, include city and state information

## Integration with Other Tools

Research tools work seamlessly with other AI/Run CodeMie capabilities:

- **Project Management**: Research information to populate Jira issues or Confluence pages
- **Code Development**: Look up API documentation or technical specifications
- **Quality Assurance**: Research known issues or best practices for testing
- **Documentation**: Gather information for creating comprehensive documentation

## Limitations

- **API Rate Limits**: Some research tools may have rate limits based on the underlying services
- **Real-Time Data**: Information is only as current as what's available online
- **Location Services**: Google Places tools require valid locations and may have geographic restrictions
- **Web Scraping**: Some websites may block automated scraping or have restrictions
- **Search Accuracy**: Results depend on the quality and specificity of search queries

## Troubleshooting

### Common Issues

**Search Returns No Results**:
- Make search queries more specific or less restrictive
- Try different keywords or phrasing
- Verify internet connectivity

**Web Scraping Fails**:
- Verify the URL is accessible in a browser
- Check if the website allows automated access
- Ensure the URL format is correct

**Location Not Found**:
- Verify location name spelling
- Include more specific location details (city, state, country)
- Use well-known landmarks or full addresses

**Outdated Information**:
- Try different search tools for comparison
- Specify date ranges in search queries when possible
- Use multiple sources to verify information

:::tip
Combine multiple research tools for comprehensive information gathering. For example, use Google Search for current events, Wikipedia for background information, and Web Scraper for specific documentation.
:::

Now your assistant can access real-time information and perform comprehensive research tasks to support your workflows effectively.
