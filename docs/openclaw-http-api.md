# OpenClaw HTTP API Reference

## Quick Start

OpenClaw gateway exposes an OpenAI-compatible HTTP API at `/v1/chat/completions`.

### Configuration

Enable the endpoint in `~/.openclaw/openclaw.json`:

```json
{
  "gateway": {
    "http": {
      "endpoints": {
        "chatCompletions": {
          "enabled": true
        }
      }
    }
  }
}
```

Restart gateway: `openclaw gateway restart`

### Authentication

Use the gateway token from `gateway.auth.token` in openclaw.json:

```bash
OPENCLAW_GATEWAY_TOKEN="08594b0c0a25e880680c874df473521ac37320a865620725"
```

### Usage

**Basic curl command:**

```bash
curl -X POST http://127.0.0.1:18789/v1/chat/completions \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer 08594b0c0a25e880680c874df473521ac37320a865620725" \
  -H "x-openclaw-agent-id: main" \
  -d '{
    "model": "openclaw",
    "messages": [
      {"role": "user", "content": "YOUR MESSAGE HERE"}
    ]
  }'
```

**Streaming (SSE):**

```bash
curl -N http://127.0.0.1:18789/v1/chat/completions \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $OPENCLAW_GATEWAY_TOKEN" \
  -H "x-openclaw-agent-id: main" \
  -d '{
    "model": "openclaw",
    "stream": true,
    "messages": [
      {"role": "user", "content": "YOUR MESSAGE HERE"}
    ]
  }'
```

### Python Example

```python
import urllib.request
import json

GATEWAY_URL = 'http://127.0.0.1:18789'
GATEWAY_TOKEN = '08594b0c0a25e880680c874df473521ac37320a865620725'

def call_openclaw(message):
    url = f'{GATEWAY_URL}/v1/chat/completions'
    payload = {
        'model': 'openclaw',
        'messages': [{'role': 'user', 'content': message}]
    }
    headers = {
        'Content-Type': 'application/json',
        'Authorization': f'Bearer {GATEWAY_TOKEN}',
        'x-openclaw-agent-id': 'main'
    }

    request = urllib.request.Request(
        url,
        data=json.dumps(payload).encode('utf-8'),
        headers=headers,
        method='POST'
    )

    with urllib.request.urlopen(request) as response:
        result = json.loads(response.read().decode('utf-8'))
        return result['choices'][0]['message']['content']

# Usage
response = call_openclaw("Search for 2+2 on the web")
print(response)
```

### MCP Integration

The `openclaw-mcp` package uses this API:

```bash
npx openclaw-mcp \
  --openclaw-url http://127.0.0.1:18789 \
  --gateway-token 08594b0c0a25e880680c874df473521ac37320a865620725
```

Configure in `~/.config/claude/mcp_settings.json`:

```json
{
  "mcpServers": {
    "openclaw": {
      "command": "npx",
      "args": [
        "openclaw-mcp",
        "--openclaw-url", "http://127.0.0.1:18789",
        "--gateway-token", "08594b0c0a25e880680c874df473521ac37320a865620725"
      ]
    }
  }
}
```

## References

- [OpenClaw Gateway Docs](https://github.com/openclaw/openclaw/blob/main/docs/gateway/openai-http-api.md)
- [MCP Integration](https://github.com/freema/openclaw-mcp)
