# New Machine Onboarding

Use this repository as a portable NixOS template on a second computer by
editing the per-machine manifest and hardware config.

## Edit These Files

1. `hosts/<host>/machine.nix`
2. `hosts/<host>/hardware-configuration.nix`

## Keep Reused

- `flake.nix`
- `users/common/home.nix`
- `.ai/` memory files
- the reusable docs and runbooks

## Flow

1. Clone the repo.
2. Copy or generate the hardware configuration for the new machine.
3. Update `hostName`, `userName`, `homeDirectory`, and `userFilesDir` in the
   machine manifest.
4. Build the system.
5. Switch if the build passes.

The current machine manifest lives at `hosts/nixos/machine.nix`.
