#!/usr/bin/env bash
set -euo pipefail

cd /home/qrbao/nixos-setup

stamp="$(date +%Y%m%d-%H%M%S)"

echo "Requesting sudo once..."
sudo -v

echo "Backing up current /etc/nixos/configuration.nix..."
sudo cp /etc/nixos/configuration.nix "/etc/nixos/configuration.nix.backup-before-basic-nvidia-${stamp}"

echo "Installing generation 1: basic coding and daily-work setup..."
sudo install -m 0644 configuration-gen1-basic.nix /etc/nixos/configuration.nix
sudo nixos-rebuild build
sudo nixos-rebuild boot

echo "Installing generation 2: NVIDIA setup with no-nvidia fallback specialisation..."
sudo install -m 0644 configuration-gen2-nvidia.nix /etc/nixos/configuration.nix
sudo nixos-rebuild build
sudo nixos-rebuild boot

echo "Done. New boot generations:"
nixos-rebuild list-generations

echo
echo "Reboot and choose the newest generation. If NVIDIA causes a black screen,"
echo "choose the newest generation's 'no-nvidia-fallback' specialisation from the boot menu."
