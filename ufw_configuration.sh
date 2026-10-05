#!/bin/bash
# ufw_configuration.sh
# Security Analyst Task 2 — Basic Firewall Configuration with UFW
# Author: Dhrumit Asari
# Description: Applies a set of UFW rules for a hardened lab environment.
# Usage: sudo ./ufw_configuration.sh
# WARNING: Run only on systems you own. Ensure you have console access before enabling.

set -e

echo "=============================================="
echo " UFW Configuration Script — Dhrumit Asari"
echo " Security Analyst Track — Task 2"
echo "=============================================="

# Check if running as root
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root (sudo ./ufw_configuration.sh)"
  exit 1
fi

# Install UFW if not present
if ! command -v ufw &> /dev/null; then
  echo "[*] Installing UFW..."
  apt update && apt install -y ufw
else
  echo "[*] UFW is already installed."
fi

echo "[*] Resetting UFW to default state (optional — comment out if not desired)..."
# ufw --force reset   # Uncomment only if you want a clean slate

echo "[*] Setting default policies..."
ufw default deny incoming
ufw default allow outgoing

echo "[*] Allowing SSH (port 22)..."
ufw allow ssh comment 'Allow SSH for remote administration'

echo "[*] Denying HTTP (port 80)..."
ufw deny http comment 'Deny unencrypted HTTP traffic'

echo "[*] Allowing HTTPS (port 443)..."
ufw allow 443/tcp comment 'Allow encrypted HTTPS traffic'

echo "[*] Denying traffic from example TEST-NET range 203.0.113.0/24..."
ufw deny from 203.0.113.0/24 comment 'Block traffic from documentation/TEST-NET range'

echo "[*] Enabling UFW..."
ufw --force enable

echo "[*] Current UFW status:"
ufw status verbose

echo ""
echo "=============================================="
echo " Configuration complete."
echo " Verify with: sudo ufw status verbose"
echo " Test denied HTTP and allowed HTTPS/SSH as documented."
echo "=============================================="
