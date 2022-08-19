{
  description = "CarlosMendonca's NixOS configuration";

  inputs = {
    
    nixpkgs.url = "github:nixos/nixpkgs/nixos-22.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-22.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs = { self, nixpkgs, home-manager, ... }: {
    nixosConfigurations = {
      X299-NixOS = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/X299-NixOS/configuration.nix
          home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true; # doc: https://nix-community.github.io/home-manager/nixos-options.html#nixos-opt-home-manager.useGlobalPkgs
            home-manager.useUserPackages = true;
          }
        ];
      };
    };

    HyperV-NixOS = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/HyperV-NixOS/configuration.nix
          home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true; # doc: https://nix-community.github.io/home-manager/nixos-options.html#nixos-opt-home-manager.useGlobalPkgs
            home-manager.useUserPackages = true;
          }
        ];
      };
    };
  };
}
