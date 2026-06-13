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
      hostName = "nixos";
      userName = "qrbao";
      homeDirectory = "/home/${userName}";
    in {
      nixosConfigurations.${hostName} = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit hostName userName homeDirectory;
        };
        modules = [
          ./hosts/nixos/configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = {
              inherit userName homeDirectory;
            };
            home-manager.users.${userName} = import ./users/qrbao/home.nix;
          }
        ];
      };
    };
}
