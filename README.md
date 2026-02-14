# OpenClaw Repo Bootstrap (jleechanorg/openclaw)

This directory contains the bootstrap assets to build a GitHub repo for OpenClaw configuration snapshots.

## What is included

- `bootstrap-openclaw-config.sh` - exports a sanitized local snapshot of non-sensitive OpenClaw config.
- `create-openclaw-repo.sh` - scaffolds/pushes a GitHub repo via `gh`.
- `audit_report.md` - notes from the local audit pass.

## Recommended flow (blank first, then PR)

```bash
cd /Users/jleechan/.openclaw/workspace/openclaw-rehome

# 1) create blank repo base + feature branch commit for PR
./blank-to-pr.sh openclaw jleechanorg

# 2) open PR from the feature branch `config-snapshot`
# (script prints a ready-to-run command)
```

## Quick legacy path (not recommended)

The legacy one-shot flow is still present for reference:

```bash
cd /Users/jleechan/.openclaw/workspace/openclaw-rehome
./bootstrap-openclaw-config.sh ./openclaw-export
cd ./openclaw-export
./create-openclaw-repo.sh openclaw
```

> Tokens are intentionally kept out of this repo. Scrub scripts are included in `bootstrap-openclaw-config.sh` to redact `token`, `secret`, `password`, and Slack token patterns (xox*).

## Current status

Repo scaffold is prepared for a blank-first PR workflow targeting `jleechanorg/openclaw`. Sensitive tokens should be scrubbed before publish.

