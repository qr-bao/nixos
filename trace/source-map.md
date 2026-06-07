# Source Map

## System

- `/etc/nixos/configuration.nix` -> `system/current/configuration.nix`

## User

- `/home/qrbao/.config/fcitx5/profile` -> `user/current/fcitx5/profile`
- `/home/qrbao/.config/autostart/copyq.desktop` -> `user/current/autostart/copyq.desktop`
- `/home/qrbao/.config/fcitx5/conf/*.conf` -> `user/current/fcitx5/conf/`
- `/home/qrbao/.config/copyq/*.ini` -> `user/current/copyq/`
- `gsettings` exports -> `user/current/gnome/`

## Trace

- `/home/qrbao/.codex/history.jsonl` -> `trace/raw-history.jsonl`

## Restore rule

- Restore a snapshot file from Git, copy it back to the live source path, then restart the related service or rebuild NixOS.
