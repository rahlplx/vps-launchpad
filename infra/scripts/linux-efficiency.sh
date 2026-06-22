#!/bin/bash
# infra/scripts/linux-efficiency.sh
# HITL: 🔴 BLOCK — Human runs this on VPS. Never agent-executed remotely.
# Purpose: Kernel + system tuning for Docker/Coolify workloads

set -euo pipefail

echo "=== Linux Efficiency Hardening for vps-launchpad ==="
echo "VPS: Contabo EU (13.140.188.74) | Target: Ubuntu 22.04/24.04"

# --- Docker daemon resource defaults ---
echo "=== [1] Docker daemon config ==="
sudo mkdir -p /etc/docker
sudo tee /etc/docker/daemon.json > /dev/null <<EOF
{
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "10m",
    "max-file": "3"
  },
  "default-ulimits": {
    "nofile": {
      "Name": "nofile",
      "Hard": 64000,
      "Soft": 64000
    }
  },
  "live-restore": true,
  "userland-proxy": false
}
EOF
sudo systemctl reload docker || sudo systemctl restart docker
echo "Docker daemon config applied."

# --- Kernel tuning for DB + network workloads ---
echo "=== [2] Kernel sysctl tuning ==="
sudo tee /etc/sysctl.d/99-vps-launchpad.conf > /dev/null <<EOF
# Network
net.core.somaxconn = 65535
net.ipv4.tcp_max_syn_backlog = 65535
net.ipv4.ip_local_port_range = 1024 65535
net.ipv4.tcp_fin_timeout = 15
net.ipv4.tcp_tw_reuse = 1

# Memory
vm.swappiness = 10
vm.dirty_ratio = 15
vm.dirty_background_ratio = 5
vm.overcommit_memory = 1    # Required for Redis/KeyDB

# File handles
fs.file-max = 2097152
fs.inotify.max_user_watches = 524288
EOF
sudo sysctl -p /etc/sysctl.d/99-vps-launchpad.conf
echo "Kernel tuning applied."

# --- Disable unnecessary services ---
echo "=== [3] Disable unused services ==="
for svc in snapd.service ModemManager.service avahi-daemon.service; do
  if systemctl is-active --quiet "$svc" 2>/dev/null; then
    sudo systemctl disable --now "$svc"
    echo "Disabled: $svc"
  fi
done

# --- Automatic security updates ---
echo "=== [4] Unattended security upgrades ==="
sudo apt-get install -y unattended-upgrades
sudo dpkg-reconfigure -plow unattended-upgrades

# --- Timezone ---
echo "=== [5] Set timezone to UTC ==="
sudo timedatectl set-timezone UTC

echo ""
echo "=== DONE — Reboot recommended ==="
echo "Run: sudo reboot"
