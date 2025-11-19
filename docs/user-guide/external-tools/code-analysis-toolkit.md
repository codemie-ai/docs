---
id: code-analysis-toolkit
title: Research Tools
sidebar_label: Research Tools
---

# Research Tools

Access real-time internet information and perform location-based searches with AI assistants.

The Research toolkit enables your CodeMie assistants to access real-time information from the internet and perform location-based searches. This comprehensive toolkit includes six powerful tools designed to gather fresh, accurate data and location information for your AI assistant.

## Overview

Research tools extend your assistants' capabilities beyond their training data, enabling them to:

- Search the web for current information
- Access encyclopedic knowledge from Wikipedia
- Extract content from specific websites
- Find and validate physical locations
- Discover nearby places and services

These tools require no additional integration setup and are immediately available once enabled for your assistant.

## Available Research Tools

### Web Search Tools

#### 1. Google Search Tool

Perform real-time Google searches to access current web information.

**Purpose:** Access the latest information from the web using Google's search engine

**Input:** Search query

**Best for:**
- General web searches
- Current events and news
- Factual information
- Real-time data queries

**Configuration:** No additional setup required

**Example usage:**

![Google Search Example](./code-analysis-toolkit/google-search-example.png)

```
"Search for the latest Python 3.12 features and updates"
"Find current stock price for NVIDIA"
"What are the recent developments in AI technology?"
```

![Google Search Response](./code-analysis-toolkit/google-search-response.png)

**What you get:**
- Search result snippets
- Links to relevant pages
- Publication dates
- Source information

**Use cases:**
- Checking current prices or statistics
- Finding recent news articles
- Discovering trending topics
- Verifying up-to-date facts

#### 2. Tavily Search Results

Comprehensive, accurate search results optimized for current events and AI applications.

**Purpose:** Advanced search tool designed specifically for AI-powered research and analysis

**Input:** Search query

**Best for:**
- Research-focused queries
- Current events analysis
- Comprehensive information gathering
- In-depth topic exploration

**Configuration:** No additional setup required

**Example usage:**

![Tavily Example](./code-analysis-toolkit/tavily-example.png)

```
"Research the environmental impact of electric vehicles in 2024"
"Find comprehensive information about quantum computing developments"
"Get up-to-date information about recent policy changes"
```

![Tavily Response](./code-analysis-toolkit/tavily-response.png)

**What you get:**
- Comprehensive search results
- Relevant context and summaries
- High-quality sources
- Structured information

**Advantages over Google Search:**
- Optimized for AI consumption
- Better context extraction
- More structured responses
- Focused on accuracy

#### 3. Wikipedia Tool

Access Wikipedia's vast knowledge base for encyclopedic information.

**Purpose:** Retrieve factual, encyclopedic information from Wikipedia

**Input:** Search query or topic name

**Best for:**
- Background information
- Historical data
- General knowledge
- Biographical information
- Scientific concepts
- Geographic information

**Configuration:** No additional setup required

**Example usage:**

![Wikipedia Example](./code-analysis-toolkit/wikipedia-example.png)

```
"Get information about the history of artificial intelligence"
"Explain the concept of blockchain technology"
"Tell me about Marie Curie's scientific contributions"
```

![Wikipedia Response](./code-analysis-toolkit/wikipedia-response.png)

**What you get:**
- Detailed article content
- Structured information
- Referenced facts
- Historical context

**Best for:**
- Educational queries
- Fact-checking
- Historical research
- Concept explanations

#### 4. Web Scraper Tool

Extract specific content from websites and convert HTML to markdown format.

**Purpose:** Extract and parse content from specific URLs

**Input:**
- URL (required)
- Optional settings for images and links

**Best for:**
- Extracting content from specific URLs
- Parsing structured data
- Reading documentation pages
- Converting web content to text

**Configuration:** No additional setup required

**Example usage:**

![Web Scraper Example](./code-analysis-toolkit/web-scraper-example.png)

```
"Scrape content from https://example.com/documentation"
"Extract text content from this specific webpage URL"
"Get the main content from this blog post URL"
```

![Web Scraper Response](./code-analysis-toolkit/web-scraper-response.png)

**What you get:**
- Clean text content
- Markdown-formatted output
- Main article content
- Structured data extraction

**Use cases:**
- Documentation extraction
- Article content retrieval
- Data collection
- Content analysis

**Features:**
- Removes navigation and ads
- Converts to readable format
- Preserves content structure
- Handles various webpage types

### Location-Based Tools

#### 5. Google Places Tool

Validate or discover addresses from ambiguous location text.

**Purpose:** Find and validate physical locations and addresses

**Input:** Location search query

**Best for:**
- Address validation
- Location verification
- Finding specific places
- Geographic coordinates
- Place disambiguation

**Configuration:** No additional setup required

**Example usage:**

![Google Places Example](./code-analysis-toolkit/google-places-example.png)

```
"Validate this address: 123 Main St, New York"
"Find the correct address for Central Park, NYC"
"Verify if this location exists: Golden Gate Bridge, San Francisco"
```

![Google Places Response](./code-analysis-toolkit/google-places-response.png)

**What you get:**
- Validated addresses
- Geographic coordinates
- Place details
- Alternative suggestions

**Use cases:**
- Address verification
- Location standardization
- Finding landmarks
- Geocoding queries

#### 6. Google Places Find Near Tool

Find places near a specific location using Google Places API.

**Purpose:** Discover businesses, landmarks, and services near a particular location

**Input:**
- Current location query (required)
- Target location/query (required)
- Search radius (optional)

**Best for:**
- Finding businesses nearby
- Locating services
- Discovering landmarks
- Proximity searches

**Configuration:** No additional setup required

**Example usage:**

![Places Near Example](./code-analysis-toolkit/places-near-example.png)

```
"Find coffee shops near Times Square, New York"
"Locate gas stations within 5 miles of downtown Chicago"
"Find restaurants near my current location"
```

![Places Near Response](./code-analysis-toolkit/places-near-response.png)

**What you get:**
- List of nearby places
- Distance information
- Address details
- Business ratings (when available)
- Operating hours (when available)

![Places Find Near Example](./code-analysis-toolkit/places-find-near-example.png)

**Advanced features:**
- Radius specification
- Category filtering
- Distance-based sorting
- Detailed place information

![Places Find Near Response](./code-analysis-toolkit/places-find-near-response.png)

**Use cases:**
- Travel planning
- Local business discovery
- Service location
- Route planning

## How to Enable Research Tools

Research tools are easy to enable and require no additional configuration or integration setup.

### Step-by-Step Enablement

**Step 1: Navigate to Assistant Configuration**

1. Go to **Assistants** section
2. Click **Create Assistant** or **Edit** existing assistant

**Step 2: Find Research Tools**

In the **Available tools** section, locate **Research**

![Research Tools Enable](./code-analysis-toolkit/research-tools-enable.png)

**Step 3: Select Tools**

Select the specific research tools you want to enable for your assistant:
- Google Search
- Tavily Search Results
- Wikipedia
- Web Scraper
- Google Places
- Google Places Find Near

**Step 4: Save Configuration**

Click **Save** button to apply changes

:::tip Instant Availability
All research tools are immediately available after enabling - no additional configuration, API keys, or integration setup needed!
:::

## Tool Selection Guide

### Choosing the Right Research Tool

Different research tools excel at different tasks. Here's a guide to help you choose:

**For Current Information:**
- ✅ Google Search - General current information
- ✅ Tavily Search - Comprehensive research
- ❌ Wikipedia - Historical information only

**For Encyclopedic Knowledge:**
- ✅ Wikipedia - Best choice
- ⚠️ Google Search - May require verification
- ⚠️ Tavily Search - Good but may be overkill

**For Specific Websites:**
- ✅ Web Scraper - Perfect for this
- ❌ Google Search - Finds pages but doesn't extract content
- ❌ Other tools - Not designed for this

**For Location Information:**
- ✅ Google Places - Address validation
- ✅ Google Places Find Near - Nearby searches
- ❌ Search tools - Less reliable for addresses

### Enabling Multiple Tools

You can enable multiple research tools for a single assistant to provide comprehensive capabilities:

**Recommended combinations:**

**General Research Assistant:**
- Google Search
- Tavily Search Results
- Wikipedia
- Web Scraper

**Location-Aware Assistant:**
- Google Places
- Google Places Find Near
- Google Search (for context)

**Comprehensive Assistant:**
- All six research tools (maximum flexibility)

## Use Cases

### Real-Time Information Gathering

**Scenario:** Need current data for decision-making

**Tools to use:**
- Google Search for quick facts
- Tavily Search for comprehensive analysis

**Example queries:**
- "What are the current interest rates for mortgages?"
- "Find the latest market trends for electric vehicles"
- "Get recent news about renewable energy developments"

### Research and Analysis

**Scenario:** Deep dive into a topic

**Tools to use:**
- Wikipedia for background
- Tavily Search for current research
- Web Scraper for specific sources

**Example queries:**
- "Research the history and current state of quantum computing"
- "Analyze recent developments in machine learning algorithms"
- "Provide comprehensive information about climate change impacts"

### Content Extraction

**Scenario:** Extract information from specific websites

**Tools to use:**
- Web Scraper for content extraction
- Google Search to find relevant pages

**Example queries:**
- "Extract the main content from this documentation page"
- "Scrape product specifications from this URL"
- "Get the text content from this blog article"

### Location Discovery

**Scenario:** Find places and validate addresses

**Tools to use:**
- Google Places for verification
- Google Places Find Near for discovery

**Example queries:**
- "Find all hospitals within 10 miles of downtown Seattle"
- "Validate and format this address for mailing"
- "Locate coffee shops near the convention center"

### Knowledge Queries

**Scenario:** Answer factual questions

**Tools to use:**
- Wikipedia for encyclopedic facts
- Google Search for verification

**Example queries:**
- "Who invented the telephone and when?"
- "Explain the water cycle"
- "What is the capital of Australia?"

## Best Practices

### Effective Query Formulation

**Be specific with search queries:**
- Good: "Python 3.12 new features"
- Better: "Python 3.12 new syntax features and improvements"

**Use appropriate tools for the task:**
- Current events → Google Search or Tavily
- Historical facts → Wikipedia
- Specific URLs → Web Scraper
- Addresses → Google Places

**Combine tools for comprehensive research:**
1. Start with Wikipedia for background
2. Use Tavily Search for current developments
3. Use Web Scraper for specific sources
4. Verify facts with Google Search

### Optimizing Search Results

**For better Google Search results:**
- Use specific keywords
- Include year for time-sensitive queries
- Add context terms for disambiguation

**For better Tavily Search results:**
- Frame as research questions
- Request comprehensive analysis
- Specify topic depth needed

**For better Wikipedia results:**
- Use proper names and terms
- Request specific sections when needed
- Ask for summaries of long articles

**For better Web Scraper results:**
- Provide exact URLs
- Specify what content to extract
- Indicate if you need the full page or summary

**For better location searches:**
- Include city and state/country
- Specify search radius when needed
- Mention business type or category

### Performance Considerations

**To get faster responses:**
- Use specific, focused queries
- Choose the most appropriate tool
- Avoid overly broad searches
- Request specific information types

**To improve accuracy:**
- Verify critical information across multiple tools
- Use Wikipedia for verified facts
- Cross-reference search results
- Validate addresses before using

## Common Use Cases by Industry

### Education

**Tools**: Wikipedia, Tavily Search, Google Search

**Use cases:**
- Research historical events
- Explain scientific concepts
- Find current educational resources
- Provide encyclopedic knowledge

**Example:**
"Explain photosynthesis with current research on its efficiency"

### Real Estate

**Tools**: Google Places, Google Places Find Near, Google Search

**Use cases:**
- Validate property addresses
- Find nearby amenities
- Research neighborhood information
- Locate comparable properties

**Example:**
"Find schools, hospitals, and grocery stores within 2 miles of 123 Oak Street, Boston"

### Content Creation

**Tools**: Web Scraper, Google Search, Tavily Search, Wikipedia

**Use cases:**
- Research topics thoroughly
- Extract information from sources
- Verify facts and figures
- Find current trends and data

**Example:**
"Research current AI trends and scrape content from top 3 AI research blogs"

### Customer Service

**Tools**: Google Search, Wikipedia, Google Places

**Use cases:**
- Find product information
- Locate service centers
- Verify business hours
- Research company policies

**Example:**
"Find the nearest authorized service center for this product model"

### Travel and Hospitality

**Tools**: Google Places, Google Places Find Near, Google Search

**Use cases:**
- Find restaurants and attractions
- Validate hotel addresses
- Locate transportation options
- Discover points of interest

**Example:**
"Find top-rated Italian restaurants within walking distance of Times Square"

## Troubleshooting

### Search Returning No Results

**Common causes:**
- Query too specific or obscure
- Spelling errors
- Location doesn't exist

**Solutions:**
1. Broaden the search query
2. Check spelling and terminology
3. Try alternative phrasing
4. Use different search terms
5. Switch to a different tool

### Web Scraper Not Working

**Common causes:**
- Invalid URL
- Website blocks scrapers
- Page requires authentication
- Dynamic content not loaded

**Solutions:**
1. Verify URL is correct and accessible
2. Check if site allows scraping
3. Try accessing public pages only
4. Consider alternative sources
5. Use Google Search to find content instead

### Location Not Found

**Common causes:**
- Ambiguous location description
- Incorrect address format
- Place doesn't exist
- Insufficient detail

**Solutions:**
1. Add more location details (city, state, country)
2. Use standard address format
3. Try alternative names or spellings
4. Verify location exists
5. Use Google Search to find correct address first

### Outdated Information

**Common causes:**
- Wikipedia article not updated
- Search results cached
- Old sources indexed

**Solutions:**
1. Use Google Search or Tavily for current info
2. Specify date range in query
3. Look for recent publications
4. Cross-reference multiple sources
5. Request "latest" or "current" information explicitly

## Integration with Other Features

### Combining with Data Sources

Research tools complement data sources by providing external information:

**With internal data:**
- Use data sources for company knowledge
- Use research tools for external context
- Combine both for comprehensive answers

**Example workflow:**
1. Query internal data source for company policy
2. Use Google Search for industry standards
3. Provide comprehensive answer with both contexts

### Combining with Other Tools

Research tools work well with other assistant capabilities:

**With code tools:**
- Research latest library versions
- Find documentation
- Get code examples

**With workflow tools:**
- Gather information
- Make informed decisions
- Trigger actions based on findings

**With communication tools:**
- Research topic
- Draft informed messages
- Send with verified facts

## Advanced Tips

### Chaining Multiple Research Tools

Use multiple tools in sequence for better results:

**Research workflow example:**
1. Wikipedia for background: "Explain machine learning basics"
2. Tavily Search for current state: "Latest machine learning breakthroughs 2024"
3. Web Scraper for specific research: "Scrape [specific research paper URL]"
4. Google Search for verification: "Verify statistics about ML adoption"

### Using Context from Previous Searches

Assistants can use information from earlier research:

**Example conversation:**
```
User: "Research quantum computing fundamentals"
Assistant: [Uses Wikipedia and Tavily Search]

User: "Now find companies working on this"
Assistant: [Uses Google Search with context from previous research]

User: "Locate quantum computing research centers near MIT"
Assistant: [Uses Google Places Find Near with combined context]
```

### Optimizing for Speed

**For faster research:**
- Use single, specific tools rather than multiple
- Provide clear, focused queries
- Request only needed information
- Use Google Search for quick facts
- Use Web Scraper only when URL is known

### Handling Sensitive Queries

**Privacy considerations:**
- Research tools access public internet
- Queries may be logged by external services
- Use for publicly available information only
- Avoid sending confidential data in queries

## Limitations

### Information Currency

**Wikipedia:**
- May not have latest updates
- Editorial lag for recent events
- Best for established facts

**Google Search:**
- Results depend on indexing
- May include misinformation
- Requires verification for critical facts

**Tavily Search:**
- Limited to internet sources
- May not cover niche topics
- Dependent on source availability

### Geographic Coverage

**Google Places:**
- Coverage varies by region
- More complete in urban areas
- May lack data for rural locations
- International address formats vary

### Content Access

**Web Scraper:**
- Cannot access paywalled content
- Blocked by some websites
- Requires authentication for private pages
- May miss dynamic content

### Rate Limits

All tools have usage limits:
- Excessive queries may be throttled
- Use responsibly to maintain access
- Implement delays for bulk operations

## Next Steps

After enabling Research Tools:

- [Configure assistants](../../assistants/) to leverage research capabilities
- [Create workflows](../../workflows/) that use external information
- Combine research with [internal data sources](../../data-source/) for comprehensive knowledge
- Test different tool combinations for your use cases

:::tip Pro Tip
Enable all six research tools for maximum flexibility, then let your assistant automatically choose the best tool for each query. The tools work together seamlessly to provide comprehensive information gathering capabilities.
:::

Now your assistants are equipped with powerful Research Tools to access real-time information, encyclopedic knowledge, and location-based data from across the internet!
