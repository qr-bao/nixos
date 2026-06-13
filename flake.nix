{
  description = "qrbao reproducible NixOS desktop";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }:
    let
      system = "x86_64-linux";
      machine = import ./hosts/nixos/machine.nix;
    in {
      nixosConfigurations.${machine.hostName} = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit (machine) hostName userName homeDirectory userFilesDir;
        };
        modules = [
          ./hosts/nixos/configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = {
              inherit (machine) userName homeDirectory userFilesDir;
            };
            home-manager.users.${machine.userName} = import ./users/common/home.nix;
          }
        ];
      };
    };
}
