# Rebuild

Build the host without switching:

```bash
nix build .#nixosConfigurations.nixos.config.system.build.toplevel
```

Apply the host configuration:

```bash
sudo nixos-rebuild switch --flake .#nixos
```

Rollback the system generation:

```bash
sudo nixos-rebuild switch --rollback
```

Apply only the tracked user configuration through the NixOS flake:

```bash
sudo nixos-rebuild switch --flake .#nixos
```

Home Manager is integrated as a NixOS module, so user config is applied during the system switch.
