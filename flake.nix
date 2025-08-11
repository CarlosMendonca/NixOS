{
  description = "CarlosMendonca's NixOS configuration";

  inputs = {    
    nixpkgs-2205.url = "github:nixos/nixpkgs/nixos-22.05";
    nixpkgs-2305.url = "github:nixos/nixpkgs/nixos-23.05";
    nixpkgs-2405.url = "github:nixos/nixpkgs/nixos-24.05";
    nixpkgs-2505.url = "github:nixos/nixpkgs/nixos-25.05";
    
    nixpkgs-latest-stable.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
    };

  };

  outputs = { self, nixpkgs, home-manager, ... }: {
    nixosConfigurations = {
      X299-NixOS = nixpkgs-2505.lib.nixosSystem {
        modules = [
          home-manager.nixosModules.home-manager
          { home-manager.inputs.nixpkgs.follows = "nixpkgs-2505"; }
          ./hosts/X299-NixOS/configuration.nix
        ];
      };

      X13-NixOS = nixpkgs-2305.lib.nixosSystem {
        modules = [
          home-manager.nixosModules.home-manager
          { home-manager.inputs.nixpkgs.follows = "nixpkgs-2305"; }
          ./hosts/X13-NixOS/configuration.nix
        ];
      };

      HyperV-NixOS = nixpkgs-2205.lib.nixosSystem {
        modules = [
          home-manager.nixosModules.home-manager
          { home-manager.inputs.nixpkgs.follows = "nixpkgs-2205"; }
          ./hosts/HyperV-NixOS/configuration.nix
        ];
      };
    };
  };
}
