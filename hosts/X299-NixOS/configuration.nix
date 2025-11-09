{ config, lib, pkgs, pkgs-unstable, ... }:
let
  stateVersion = "25.05";
in
{
  imports = [
    ./hardware-configuration.nix
    ../../modules # system roles and functions
    ../../users
  ];

  # Enable roles
  roles.development.enable = true;
  roles.remoting.enable = true;

  # Enable users
  users.carlos.enable = true;
  nix.settings.trusted-users = [ "carlos" ]; # TODO figure out if there's a better way to declare this

  # boot.plymouth.enable = true; # see https://wiki.nixos.org/wiki/Plymouth

  nixpkgs.config.allowUnfree = true;

  # System-specific settings
  networking.hostName = "X299-NixOS";
  time.timeZone = "America/New_York";
  system.stateVersion = stateVersion;

  # System-wide packages specific to this system
  environment.systemPackages = [ ];

  # Home-Manager settings
  home-manager = {
    extraSpecialArgs = { inherit pkgs-unstable; };
    useGlobalPkgs = true;
    useUserPackages = true;
  };
}
