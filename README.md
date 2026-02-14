# OpenClaw HTTP API + Full-Permission Configuration

This repository documents the OpenClaw HTTP API setup and the permission settings used for full execution mode.

## OpenClaw HTTP API configuration

Recent local configuration in `~/.openclaw/openclaw.json` has the HTTP API enabled:

- `gateway.port: 18789`
- `gateway.http.endpoints.chatCompletions.enabled: true`
- `gateway.auth.mode: token`
- `gateway.auth.token` configured

### Curl command

```bash
export OPENCLAW_TOKEN="<YOUR_OPENCLAW_TOKEN>"

curl -sS \
  -X POST "http://127.0.0.1:18789/v1/chat/completions" \
  -H "Authorization: Bearer $OPENCLAW_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"agent":"main","messages":[{"role":"user","content":"Hello from OpenClaw HTTP API"}]}'
```

> Replace `<YOUR_OPENCLAW_TOKEN>` with the token from your local `gateway.auth.token`.

## Config that enables full permissions

`~/.openclaw/openclaw.json` (relevant sections):

```json
{
  "tools": {
    "exec": {
      "host": "gateway",
      "ask": "off",
      "safeBins": [
        "git", "gh", "python", "python3", "vpython", "npm", "npx", "node", "pip",
        "ls", "cat", "grep", "find", "head", "tail", "sed", "awk", "sort", "uniq", "wc",
        "file", "stat", "dirname", "basename", "playwright", "which", "curl", "wget"
      ]
    }
  },
  "gateway": {
    "http": {
      "endpoints": {
        "chatCompletions": { "enabled": true }
      }
    }
  }
}
```

`~/.openclaw/exec-approvals.json`:

```json
{
  "defaults": {
    "security": "full",
    "ask": "off",
    "askFallback": "full",
    "autoAllowSkills": true
  },
  "agents": {
    "main": {
      "security": "full",
      "ask": "off"
    }
  }
}
```

These settings combine to allow the `main` agent to execute commands without confirmation (full permissions) and keep approvals off.
