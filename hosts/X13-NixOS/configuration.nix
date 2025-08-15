{ config, lib, pkgs, pkgs-unstable, ... }:
let
  stateVersion = "25.05";
in
{
  imports = [
    #Hardware configuration
    ./hardware-configuration.nix

    # System roles and functions
    ../../modules/development.nix
    ../../modules/remoting.nix

    # Users
    ../../users/carlos.nix
  ];

  nixpkgs.config.allowUnfree = true;

  # System-specific settings
  networking.hostName = "X13-NixOS";
  time.timeZone = "America/New_York";
  system.stateVersion = stateVersion;

  # System-wide packages specific to this system
  environment.systemPackages = [ ];

  # User system settings
  nix.settings.trusted-users = [ "carlos" ]; # TODO figure out if there's a better way to declare this

  # Home-Manager settings
  home-manager = {
    extraSpecialArgs = { inherit pkgs-unstable; };

    # User home settings
    users.carlos = {
        imports = [
          ../../users/modules/development.nix
        ];

        home.stateVersion = stateVersion; # done this way to extract Home-Manager's stateVersion to the system level and make sure it matches system.stateVersion
      };
    
    useGlobalPkgs = true;
    useUserPackages = true;
  };
}