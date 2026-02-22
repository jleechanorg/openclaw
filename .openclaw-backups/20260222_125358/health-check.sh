#!/bin/bash
# OpenClaw Health Check & Auto-Recovery Script
# Purpose: Monitors OpenClaw gateway and restarts if needed

HOME_DIR=${HOME:-"$(eval echo "~$(id -un)")"}
LOG_FILE="$HOME_DIR/.openclaw/logs/health-check.log"
mkdir -p "$HOME_DIR/.openclaw/logs"
TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")

if ! OPENCLAW_BIN=$(command -v openclaw 2>/dev/null); then
    OPENCLAW_BIN=""
fi

if [ -z "${OPENCLAW_BIN:-}" ] && [ -x "$HOME_DIR/.nvm/versions/node/v22.22.0/bin/openclaw" ]; then
    OPENCLAW_BIN="$HOME_DIR/.nvm/versions/node/v22.22.0/bin/openclaw"
fi

if [ -z "${OPENCLAW_BIN:-}" ] && [ -x "$HOME_DIR/.local/bin/openclaw" ]; then
    OPENCLAW_BIN="$HOME_DIR/.local/bin/openclaw"
fi

if [ ! -x "$OPENCLAW_BIN" ]; then
    echo "[$TIMESTAMP] ❌ openclaw executable not found ($OPENCLAW_BIN)" >> "$LOG_FILE"
    exit 1
fi

# Function to log messages
log_message() {
    echo "[$TIMESTAMP] $1" >> "$LOG_FILE"
}

# Check if gateway is running
if ! launchctl list | grep -q "ai.openclaw.gateway"; then
    log_message "❌ Gateway not loaded in launchctl. Installing..."
    "$OPENCLAW_BIN" gateway install >> "$LOG_FILE" 2>&1
    log_message "✅ Gateway installed"
    exit 0
fi

# Check if process is actually running
PID=$(launchctl list | grep "ai.openclaw.gateway" | awk '{print $1}')
if [ "$PID" = "-" ] || [ -z "$PID" ]; then
    log_message "⚠️  Gateway loaded but not running. Restarting..."
    launchctl kickstart gui/$(id -u)/ai.openclaw.gateway >> "$LOG_FILE" 2>&1
    log_message "✅ Gateway kickstarted"
    exit 0
fi

# Check if gateway is responding
if ! "$OPENCLAW_BIN" gateway status | grep -q "Runtime: running"; then
    log_message "⚠️  Gateway not responding. Restarting..."
    "$OPENCLAW_BIN" gateway stop >> "$LOG_FILE" 2>&1
    sleep 2
    "$OPENCLAW_BIN" gateway install >> "$LOG_FILE" 2>&1
    log_message "✅ Gateway restarted"
    exit 0
fi

# Check WhatsApp connection
if ! "$OPENCLAW_BIN" channels list | grep -q "WhatsApp default: linked, enabled"; then
    log_message "⚠️  WhatsApp not linked. Attempting recovery..."
    # Note: Auto-relink requires QR scan, so just log the issue
    log_message "❌ WhatsApp disconnected - manual intervention required"
    exit 1
fi

log_message "✅ All health checks passed (PID: $PID)"
exit 0
