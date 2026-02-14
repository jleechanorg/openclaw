# Get Brave Search API Key

## Quick Setup (5 minutes)

1. **Sign up for Brave Search API**
   - Go to: https://brave.com/search/api/
   - Click "Get Started" or "Sign Up"
   - Create account with email

2. **Choose Free Plan**
   - Select "Data for Search" plan (NOT "Data for AI")
   - Free tier: 2,000 queries/month
   - No credit card required for free tier

3. **Generate API Key**
   - Go to dashboard
   - Click "Generate API Key"
   - Copy the key (starts with `BSA...`)

4. **Add to OpenClaw**
   ```bash
   # Add to bashrc (already configured to load)
   echo 'export BRAVE_API_KEY="YOUR_KEY_HERE"' >> ~/.bashrc
   source ~/.bashrc
   
   # Restart OpenClaw gateway
   openclaw gateway restart
   ```

5. **Test it**
   ```bash
   # Via HTTP API
   curl -X POST http://127.0.0.1:18789/v1/chat/completions \
     -H "Content-Type: application/json" \
     -H "Authorization: Bearer $OPENCLAW_GATEWAY_TOKEN" \
     -H "x-openclaw-agent-id: main" \
     -d '{"model": "openclaw", "messages": [{"role": "user", "content": "Search the web for current weather in San Francisco"}]}'
   ```

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

