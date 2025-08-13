{ lib, pkgs, home-manager, ... }:
let
  carlosUserSettings = import ../../users/carlos.nix { inherit pkgs; };
  stateVersion = "25.05";
in
{
  imports = [
    #Hardware configuration
    ./hardware-configuration.nix

    # System roles and functions
    ../../modules/development.nix
  ];

  # System-specific settings
  networking.hostName = "X13-NixOS";
  time.timeZone = "America/New_York";
  system.stateVersion = stateVersion;

  # System-wide packages specific to this system
  environment.systemPackages = [ ];

  # User system settings
  users.users.carlos = carlosUserSettings.system;
  nix.settings.trusted-users = [ "carlos" ]; # TODO figure out if there's a better way to declare this

  # Home-Manager settings
  home-manager = {

    # User home settings
    users.carlos = lib.mkMerge [
      carlosUserSettings.home
      {
        imports = [
          ../../users/modules/development.nix
        ];

        home.stateVersion = stateVersion; # done this way to extract Home-Manager's stateVersion to the system level and make sure it matches system.stateVersion
      }
    ];
    
    useGlobalPkgs = true;
    useUserPackages = true;
  };
}