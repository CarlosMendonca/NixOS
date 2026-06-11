{ config, lib, pkgs, pkgs-unstable, pkgs-llm-agents, ... }:
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
  roles.development.androidStudio.enable = false;
  roles.remoting.enable = true;
  roles.retro-gaming.enable = true;

  roles.containers.enable = true;
  # roles.virtualization.enable = true;

  users.carlos = {
    enable = true;
    trusted = true;
    canUseDesktop = true;

    canUseAndroidStudio = true;
    canUseContainers = true;
    canUseVirtualization = true; # won't matter unless Virtualization role is enabled
  };
  
  # boot.plymouth.enable = true; # see https://wiki.nixos.org/wiki/Plymouth

  nixpkgs.config.allowUnfree = true;

  # System-specific settings
  networking.hostName = "X13-NixOS";
  # time.timeZone = "America/New_York"; # defining time zone stactically doesn't work well for laptops, since they need to change often
  time.timeZone = lib.mkDefault null;
  # services.automatic-timezoned.enable = true; # this is not needed if you're running Gnome

  services.geoclue2 = {
    enable = true;
    geoProviderUrl = "https://api.beacondb.net/v1/geolocate";
    appConfig."gnome-datetime-panel" = { # pre-grant Gnome permission to use location without prompts; TODO make this modular and conditional based on Gnome enablement (desktop role)
      isAllowed = true;
      isSystem = true;
    };
  };

  system.stateVersion = stateVersion;

  # System-wide packages specific to this system
  environment.systemPackages = [ ];

  # Home-Manager settings
  home-manager = {
    extraSpecialArgs = {
      inherit pkgs-unstable;
      inherit pkgs-llm-agents;
      systemConfig = config; # passing the system level config to inside home-manager, so we can enable system roles inside home-manager
    };
    useGlobalPkgs = true;
    useUserPackages = true;
  };
}