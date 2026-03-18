# How can I find information on the internet with codemie ? Tolls to find information on the internet in request? What research tools are available in codemie ?

## Research Toolkit Documentation

The Research toolkit enables your CodeMie assistants to access real-time information from the internet and perform location-based searches. This comprehensive toolkit includes **six powerful tools** designed to gather fresh, accurate data and location information for your AI assistant.

## Available Research Tools

## **Web Search Tools**

Google Search Tool  
**Purpose:** Perform real-time Google searches to access current web information  
**Input:** Search query  
**Best for:** General web searches, current events, factual information  
**Configuration:** No additional setup required  
**Example usage:**

```
"Search for the latest Python 3.12 features and updates"
"Find current stock price for NVIDIA"
"What are the recent developments in AI technology?"
```

Tavily Search Results  
**Purpose:** Comprehensive, accurate search results optimized for current events and AI applications  
**Input:** Search query  
**Best for:** Research-focused queries, current events, comprehensive analysis  
**Configuration:** No additional setup required  
**Example usage:**

```
"Research the environmental impact of electric vehicles in 2024"
"Find comprehensive information about quantum computing developments"
"Get up-to-date information about recent policy changes"
```

Wikipedia Tool  
**Purpose:** Access Wikipedia's vast knowledge base for encyclopedic information  
**Input:** Search query  
**Best for:** Background information, historical data, general knowledge, biographical information  
**Configuration:** No additional setup required  
**Example usage:**

```
"Get information about the history of artificial intelligence"
"Explain the concept of blockchain technology"
"Tell me about Marie Curie's scientific contributions"
```

Web Scraper Tool  
**Purpose:** Extract specific content from websites and convert HTML to markdown format  
**Input:** URL (required), plus optional settings for images and links  
**Best for:** Extracting content from specific URLs, parsing structured data, reading documentation  
**Configuration:** No additional setup required  
**Example usage:**

```
"Scrape content from https://example.com/documentation"
"Extract text content from this specific webpage URL"
"Get the main content from this blog post URL"
```

## **Location-Based Tools**

Google Places Tool  
**Purpose:** Validate or discover addresses from ambiguous location text  
**Input:** Location search query  
**Best for:** Address validation, location verification, finding specific places  
**Configuration:** No additional setup required  
**Example usage:**

```
"Validate this address: 123 Main St, New York"
"Find the correct address for Central Park, NYC"
"Verify if this location exists: Golden Gate Bridge, San Francisco"
```

Google Places Find Near Tool  
**Purpose:** Find places near a specific location using Google Places API  
**Input:** Current location query (required), Target location/query (required), Search radius (optional)  
**Best for:** Finding businesses, landmarks, or services near a particular location  
**Configuration:** No additional setup required  
**Example usage:**

```
"Find coffee shops near Times Square, New York"
"Locate gas stations within 5 miles of downtown Chicago"
"Find restaurants near my current location"
```

## How to Enable Research Tools

1. Navigate to **Create Assistant** or **Edit Assistant**
2. In the **Available tools** section, find **Research**
3. Select the specific research tools you want to enable for your assistant
4. All tools are immediately available - no additional configuration needed

## Tool Categories and Use Cases

**Information Gathering Workflow**

1. **Start with Google Search or Tavily** for current information
2. **Use Wikipedia** for background and historical context
3. **Apply Web Scraper** for specific website content
4. **Leverage Google Places tools** for location-specific information

**Location Research Workflow**

1. **Use Google Places** to validate addresses or find specific locations
2. **Apply Google Places Find Near** to discover nearby businesses or services
3. **Combine with other tools** for comprehensive location-based research

## Best Practices

- **Combine tools strategically**: Use multiple research tools together for comprehensive information gathering
- **Specify tool preferences**: Ask the assistant to use specific tools when you need particular types of information
- **Location precision**: Be specific with location queries for better Google Places results
- **Verify information**: Cross-reference important information using multiple sources
- **Use appropriate radius**: For "Find Near" searches, specify reasonable search radius for better results

## Common Use Cases by Tool Combination

**Market Research**

- Google Search + Tavily Search: Current market trends and competitor information
- Web Scraper: Extract data from competitor websites
- Google Places Find Near: Local market analysis and competitor locations

  **Travel Planning**

- Google Places: Validate destination addresses
- Google Places Find Near: Find hotels, restaurants, attractions near destinations
- Wikipedia: Research historical and cultural information about destinations

  **Academic Research**

- Wikipedia: Background and encyclopedic information
- Tavily Search: Current research and developments
- Web Scraper: Access specific academic papers or documentation

  **Business Intelligence**

- Google Search: Industry trends and news
- Google Places: Verify business locations and information
- Google Places Find Near: Analyze local competition and market presence

## Sources

- [Create Assistant](https://docs.codemie.ai/user-guide/assistants/create-assistant)
