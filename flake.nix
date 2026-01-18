{
  description = "CarlosMendonca's NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  
  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, ... } @inputs:
    let
      X13-NixOS-host = import ./hosts/X13-NixOS;
      X299-NixOS-host = import ./hosts/X299-NixOS;
    in {
      nixosConfigurations = {
        X13-NixOS = nixpkgs.lib.nixosSystem {
          system = X13-NixOS-host.system;
          specialArgs = {
            pkgs-unstable = import nixpkgs-unstable {
              system = X13-NixOS-host.system;
              config.allowUnfree = X13-NixOS-host.allowUnfree;
            };
          };
          modules = [
            X13-NixOS-host.module
            ({ ... }: { nixpkgs.config.allowUnfree = X13-NixOS-host.allowUnfree; }) # extracting the allowUnfree setting to the flake level
            home-manager.nixosModules.home-manager
          ];
        };

        X299-NixOS = nixpkgs.lib.nixosSystem {
          system = X299-NixOS-host.system;
          specialArgs = {
            pkgs-unstable = import nixpkgs-unstable {
              system = X299-NixOS-host.system;
              config.allowUnfree = X299-NixOS-host.allowUnfree;
            };
          };
          modules = [
            X299-NixOS-host.module
            ({ ... }: { nixpkgs.config.allowUnfree = X299-NixOS-host.allowUnfree; }) # extracting the allowUnfree setting to the flake level
            home-manager.nixosModules.home-manager
          ];
        };
    };
  };
}
