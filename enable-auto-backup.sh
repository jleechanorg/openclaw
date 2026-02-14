#!/usr/bin/env bash

set -euo pipefail

# Installs a cron job that creates a daily backup tarball of
# ~/.openclaw and LaunchAgent config at 2:00 AM.
#
# Usage:
#   ./enable-auto-backup.sh
#
# The job calls ~/.openclaw/backup-content.sh (created lazily below).

OPENCLAW_DIR="$HOME/.openclaw"
BACKUP_DIR="$OPENCLAW_DIR/backups"
SCRIPT_PATH="$OPENCLAW_DIR/backup-content.sh"
LAUNCHAGENT="$HOME/Library/LaunchAgents/ai.openclaw.gateway.plist"
CRON_CMD='$(printf "%s" "$SCRIPT_PATH") > /dev/null 2>&1'
CRON_EXPR='0 2 * * *'

mkdir -p "$BACKUP_DIR"

cat > "$SCRIPT_PATH" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail

a=$(date +%Y%m%d)
BACKUP_DIR="$HOME/.openclaw/backups"
mkdir -p "$BACKUP_DIR"

tar --exclude "$BACKUP_DIR" \
  --exclude '*.bak' \
  -czf "$BACKUP_DIR/backup-${a}.tar.gz" \
  "$HOME/.openclaw" \
  "$HOME/Library/LaunchAgents/ai.openclaw.gateway.plist"

# Keep 30-day retention
find "$BACKUP_DIR" -name 'backup-*.tar.gz' -type f -mtime +30 -delete || true
EOF
chmod +x "$SCRIPT_PATH"

# Install/update cron entry
CRON_MARK="# OpenClaw daily backup"
CRON_LINE="$CRON_EXPR $HOME/.openclaw/backup-content.sh"

tmp=$(mktemp)
crontab -l 2>/dev/null | grep -v "$CRON_MARK" > "$tmp" || true
printf "%s\n%s\n" "$CRON_MARK" "$CRON_LINE" >> "$tmp"
crontab "$tmp"
rm -f "$tmp"

echo "Installed cron job: $CRON_EXPR -> $SCRIPT_PATH"
echo "Backups will be written to: $BACKUP_DIR"
echo "Current crontab entry includes:"
crontab -l | grep -F "$CRON_MARK" -A1 || true

