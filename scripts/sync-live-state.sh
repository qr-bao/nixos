#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

mkdir -p \
  "$repo_root/hosts/nixos" \
  "$repo_root/system/current" \
  "$repo_root/users/qrbao/files/fcitx5/conf" \
  "$repo_root/users/qrbao/files/autostart" \
  "$repo_root/users/qrbao/files/copyq" \
  "$repo_root/user/current/fcitx5/conf" \
  "$repo_root/user/current/autostart" \
  "$repo_root/user/current/copyq" \
  "$repo_root/user/current/gnome" \
  "$repo_root/trace"

cp /etc/nixos/configuration.nix "$repo_root/system/current/configuration.nix"
sed -E 's#"?/etc/nixos/hardware-configuration\.nix"?#./hardware-configuration.nix#' \
  /etc/nixos/configuration.nix > "$repo_root/hosts/nixos/configuration.nix"
cp /etc/nixos/hardware-configuration.nix "$repo_root/hosts/nixos/hardware-configuration.nix"

cp /home/qrbao/.config/fcitx5/profile "$repo_root/user/current/fcitx5/profile"
cp /home/qrbao/.config/fcitx5/profile "$repo_root/users/qrbao/files/fcitx5/profile"

cp /home/qrbao/.config/autostart/copyq.desktop "$repo_root/user/current/autostart/copyq.desktop"
cp /home/qrbao/.config/autostart/copyq.desktop "$repo_root/users/qrbao/files/autostart/copyq.desktop"

cp /home/qrbao/.config/fcitx5/conf/chttrans.conf \
  /home/qrbao/.config/fcitx5/conf/notifications.conf \
  /home/qrbao/.config/fcitx5/conf/pinyin.conf \
  /home/qrbao/.config/fcitx5/conf/punctuation.conf \
  "$repo_root/user/current/fcitx5/conf/"
cp /home/qrbao/.config/fcitx5/conf/chttrans.conf \
  /home/qrbao/.config/fcitx5/conf/notifications.conf \
  /home/qrbao/.config/fcitx5/conf/pinyin.conf \
  /home/qrbao/.config/fcitx5/conf/punctuation.conf \
  "$repo_root/users/qrbao/files/fcitx5/conf/"

cp /home/qrbao/.config/copyq/copyq.conf \
  /home/qrbao/.config/copyq/copyq-commands.ini \
  /home/qrbao/.config/copyq/copyq-filter.ini \
  /home/qrbao/.config/copyq/copyq-monitor.ini \
  /home/qrbao/.config/copyq/copyq_tabs.ini \
  "$repo_root/user/current/copyq/"
cp /home/qrbao/.config/copyq/copyq.conf \
  /home/qrbao/.config/copyq/copyq-commands.ini \
  /home/qrbao/.config/copyq/copyq-filter.ini \
  /home/qrbao/.config/copyq/copyq-monitor.ini \
  /home/qrbao/.config/copyq/copyq_tabs.ini \
  "$repo_root/users/qrbao/files/copyq/"

gsettings list-recursively org.gnome.shell.keybindings \
  > "$repo_root/user/current/gnome/org.gnome.shell.keybindings.txt"
gsettings list-recursively org.gnome.settings-daemon.plugins.media-keys \
  > "$repo_root/user/current/gnome/org.gnome.settings-daemon.plugins.media-keys.txt"
gsettings list-recursively org.gnome.desktop.wm.keybindings \
  > "$repo_root/user/current/gnome/org.gnome.desktop.wm.keybindings.txt"

if [[ -f /home/qrbao/.codex/history.jsonl ]]; then
  sed -E \
    -e 's/sudo password is [^,"]+/sudo password is [REDACTED]/g' \
    -e 's/password is four space \[[^]]*\]/password is [REDACTED]/g' \
    /home/qrbao/.codex/history.jsonl > "$repo_root/trace/raw-history.jsonl"
fi

echo "Synced live state into $repo_root"
