# OpenClaw Repo Bootstrap (jleechanorg/openclaw)

This directory contains the bootstrap assets to build a GitHub repo for OpenClaw configuration snapshots.

## What is included

- `bootstrap-openclaw-config.sh` - exports a sanitized local snapshot of non-sensitive OpenClaw config.
- `create-openclaw-repo.sh` - scaffolds/pushes a GitHub repo via `gh`.
- `audit_report.md` - notes from the local audit pass.

## Quick path to create GitHub repo

```bash
cd /Users/jleechan/.openclaw/workspace/openclaw-rehome
./bootstrap-openclaw-config.sh ./openclaw-export
cd ./openclaw-export
./create-openclaw-repo.sh openclaw
```

> Tokens are intentionally kept out of this repo. Confirm `~/.openclaw` contents are scrubbed before publishing.

## Current status

I confirmed the repo scaffold exists and is ready to be published under `jleechanorg/openclaw`.
