# Brave Search API - Quick Setup (5 minutes)

## Why Brave API?

✅ **No sandbox issues** - Native OpenClaw integration
✅ **Free tier** - 2,000 searches/month
✅ **No credit card** - Email signup only
✅ **Works with MCP** - Full compatibility

## Steps

### 1. Get API Key

1. Open: https://brave.com/search/api/
2. Click "Get Started" or "Sign Up"
3. Create account with email
4. Choose **"Data for Search"** plan (NOT "Data for AI")
5. Generate API key (starts with `BSA...`)

### 2. Add to Environment

```bash
# Add to bashrc
echo 'export BRAVE_API_KEY="BSA_YOUR_KEY_HERE"' >> ~/.bashrc
source ~/.bashrc

# Verify it's set
echo $BRAVE_API_KEY
```

### 3. Enable in OpenClaw

**Option A: Use the script**
```bash
python3 /tmp/enable_brave_search.py
openclaw gateway restart
```

**Option B: Manual edit**

Edit `~/.openclaw/openclaw.json`:

```json
{
  "tools": {
    "web": {
      "search": {
        "enabled": true,
        "provider": "brave",
        "apiKey": "${BRAVE_API_KEY}",
        "maxResults": 5
      }
    }
  }
}
```

Then restart:
```bash
openclaw gateway restart
```

### 4. Test It!

**Via MCP:**
```bash
cat << 'EOF' | mcp-cli call openclaw/openclaw_chat -
{"message": "Search the web for Python tutorials"}
EOF
```

**Via HTTP API:**
```bash
curl -X POST http://127.0.0.1:18789/v1/chat/completions \
  -H "Authorization: Bearer $OPENCLAW_GATEWAY_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"model": "openclaw", "messages": [{"role": "user", "content": "Search the web for 2+2"}]}'
```

**Via WhatsApp/Slack:**
Just message: "Search the web for 2+2"

## Troubleshooting

**Error: Missing env var "BRAVE_API_KEY"**
```bash
# Make sure it's exported
echo 'export BRAVE_API_KEY="your-key"' >> ~/.bashrc
source ~/.bashrc

# Restart gateway
openclaw gateway restart
```

**Still not working?**
```bash
# Check if web search is enabled
grep -A 5 '"web"' ~/.openclaw/openclaw.json

# Check if API key is loaded
env | grep BRAVE

# Check gateway logs
openclaw gateway status
```

## Why Not Playwright?

The sandbox is blocking because:
- OpenClaw HTTP/MCP API uses **container isolation**
- Even with `safeBins` configured, Docker sandbox blocks execution
- WhatsApp/Slack commands might work (different execution path)
- Brave API is the **supported, native way** - no sandbox issues!

## Free Tier Limits

- **2,000 queries/month**
- Reset monthly
- Upgrade to paid plans for more

That's **~65 searches per day** - plenty for testing and personal use!
