# How do I configure my plugin key with the codemie-plugins CLI? How do I configure my plugin key with the codemie-plugins CLI?

You can configure your plugin key for the codemie-plugins CLI in several ways:

Using the config command  
codemie-plugins config set PLUGIN_KEY your-plugin-key

Using environment variables:

On MacOS/Linux:  
export PLUGIN_KEY=your-plugin-key

On Windows:  
$env:PLUGIN_KEY="your-plugin-key"

Verifying your configuration:

To verify that your plugin key is correctly set:

codemie-plugins config get PLUGIN_KEY  
 or see all configuration  
codemie-plugins config show

## Sources

- [Plugin](https://docs.codemie.ai/user-guide/tools_integrations/tools/plugin)
