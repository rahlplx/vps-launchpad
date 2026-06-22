# GitHub OAuth — Setup Guide

> Human-executed steps. Agent drafted this runbook.

## Step 1 — Create GitHub OAuth App

1. Go to: https://github.com/settings/developers → "OAuth Apps" → "New OAuth App"
2. Fill in:
   - Application name: `vps-launchpad-coolify`
   - Homepage URL: `https://{your-domain}` or `http://13.140.188.74:8000`
   - Authorization callback URL: `http://13.140.188.74:8000/auth/github/callback`
     _(update to HTTPS once SSL is configured)_
3. Click "Register application"
4. Copy **Client ID** and generate **Client Secret** — store these in Coolify only

## Step 2 — Add to Coolify

1. In Coolify UI → Settings → Source Control → GitHub
2. Paste Client ID and Client Secret
3. Click "Connect GitHub"
4. Authorize the OAuth App in GitHub

## Step 3 — Connect a repo

1. Coolify UI → Projects → New Resource → GitHub Repository
2. Select your org/repo
3. Set branch, build command, port

## config.example.yml

```yaml
# DO NOT commit real values — reference only
github_oauth:
  client_id: "GITHUB_CLIENT_ID"          # From GitHub OAuth App
  client_secret: "GITHUB_CLIENT_SECRET"  # From GitHub OAuth App — never commit
  callback_url: "https://{domain}/auth/github/callback"
  scopes:
    - repo
    - read:org
```

## Security notes

- Rotate client secret every 90 days
- Restrict OAuth App to specific repos if possible
- If VPS IP changes: update callback URL immediately
