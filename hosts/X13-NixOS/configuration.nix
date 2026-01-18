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

  # Enable users -- ideally we declare which roles this user, on this host have, but since we have only one user so far, we assume all system roles also apply at the home-manager level
  users.carlos.enable = true;
  nix.settings.trusted-users = [ "carlos" ];
  
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
      systemConfig = config; # passing the system level config to inside home-manager, so we can enable system roles inside home-manager
    };
    useGlobalPkgs = true;
    useUserPackages = true;
  };
}