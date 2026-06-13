# Runbook: New Machine Onboarding

Updated: 2026-06-13

## Purpose

Bring a second computer into this NixOS setup with the smallest possible edit
surface.

## Files To Change

1. `hosts/<new-host>/machine.nix`
2. `hosts/<new-host>/hardware-configuration.nix`
3. Any account-specific snapshot directory referenced by `userFilesDir`

## Steps

1. Clone the repo on the new machine.
2. Copy or generate a hardware configuration for the new machine.
3. Update the machine manifest:
   - `hostName`
   - `userName`
   - `homeDirectory`
   - `userFilesDir`
4. Make sure the shared module import in `flake.nix` points at the shared
   Home Manager module.
5. Build:

```bash
nix build .#nixosConfigurations.<host>.config.system.build.toplevel --no-link
```

6. If the build succeeds, switch:

```bash
sudo nixos-rebuild switch --flake .#<host>
```

## Notes

- Keep machine-specific hardware and boot settings in the host directory.
- Keep reusable app and workflow behavior in `users/common/home.nix`.
- Keep account snapshots in the directory named by `userFilesDir`.
