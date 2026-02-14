# Get Brave Search API Key

> **📘 See [brave-api-quickstart.md](brave-api-quickstart.md) for the complete Brave Search API setup guide** with detailed steps, troubleshooting, and testing instructions.

## Alternative: Use Perplexity via OpenRouter

If you prefer AI-synthesized answers instead of search results:

1. Go to: https://openrouter.ai/
2. Add credits (crypto/prepaid accepted, no credit card required)
3. Generate API key
4. Add to bashrc:
   ```bash
   echo 'export OPENROUTER_API_KEY="sk-or-v1-..."' >> ~/.bashrc
   ```
5. Update openclaw.json:
   ```json
   "tools": {
     "web": {
       "search": {
         "provider": "perplexity"
       }
     }
   }
   ```

