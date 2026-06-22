#!/bin/bash
# install.sh — Coolify install on fresh Ubuntu 22.04/24.04
# HITL: 🔴 BLOCK — Human runs this. Agent must not execute remotely.
# Idempotent: safe to re-run.

set -euo pipefail

echo "=== [1/5] System update ==="
sudo apt-get update -qq && sudo apt-get upgrade -y -qq

echo "=== [2/5] Install dependencies ==="
sudo apt-get install -y curl wget git ufw ca-certificates gnupg lsb-release

echo "=== [3/5] Configure swap (2GB) ==="
if [ ! -f /swapfile ]; then
  sudo fallocate -l 2G /swapfile
  sudo chmod 600 /swapfile
  sudo mkswap /swapfile
  sudo swapon /swapfile
  echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab
  echo "vm.swappiness=10" | sudo tee -a /etc/sysctl.conf
  sudo sysctl -p
  echo "Swap created."
else
  echo "Swap already exists — skipping."
fi

echo "=== [4/5] Configure UFW firewall ==="
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow 22/tcp comment 'SSH'
sudo ufw allow 80/tcp comment 'HTTP'
sudo ufw allow 443/tcp comment 'HTTPS'
sudo ufw allow 8000/tcp comment 'Coolify'
# Allow only if needed — comment out otherwise:
# sudo ufw allow 5432/tcp comment 'PostgreSQL — internal only, remove after setup'
sudo ufw --force enable
sudo ufw status verbose

echo "=== [5/5] Install Coolify ==="
curl -fsSL https://cdn.coollabs.io/coolify/install.sh | sudo bash

echo ""
echo "=== DONE ==="
echo "Coolify is running. Access at: http://$(curl -s ifconfig.me):8000"
echo "Next: complete setup wizard, connect GitHub OAuth (see plugins/github-oauth/)"
echo "Then: harden with Traefik SSL + domain (see docs/runbooks/ssl-setup.md)"
