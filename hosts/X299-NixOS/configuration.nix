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
  roles.external-monitor.enable = true;

  roles.development.enable = true;
  roles.remoting.enable = true;
  
  roles.containers.enable = true;
  # roles.virtualization.enable = true;

  # Enable users
  users.carlos = {
    enable = true;
    trusted = true;
    canUseDesktop = true;
    canUseContainers = true;
    canUseVirtualization = true; # won't matter unless Virtualization role is enabled
  };

  # boot.plymouth.enable = true; # see https://wiki.nixos.org/wiki/Plymouth

  nixpkgs.config.allowUnfree = true;

  # Use solaar from nixpkgs-unstable for newer version
  nixpkgs.overlays = [
    (final: prev: {
      solaar = pkgs-unstable.solaar;
    })
  ];

  hardware.logitech.wireless.enable = true;
  hardware.logitech.wireless.enableGraphical = config.roles.desktop.enable;

  # System-specific settings
  networking.hostName = "X299-NixOS";
  time.timeZone = "America/New_York";
  system.stateVersion = stateVersion;

  # System-wide packages specific to this system
  environment.systemPackages = [
    pkgs-unstable.solaar
  ];

  # Home-Manager settings
  home-manager = {
    extraSpecialArgs = {
      inherit pkgs-unstable;
      systemConfig = config;
    };
    useGlobalPkgs = true;
    useUserPackages = true;
  };
}
