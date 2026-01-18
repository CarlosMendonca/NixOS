{ lib, pkgs, ... }: {
  imports = [
    ./bluetooth.nix
    ./desktop.nix
    ./development.nix
    ./remoting.nix
    ./sound.nix
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.trusted-users = [ "root" ];

  # Automatic garbage collection
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  # Automatic store optimization (deduplication)
  nix.optimise = {
    automatic = true;
    dates = [ "weekly" ];
  };

  # Networking -- common to all configurations
  networking = {
    # useNetworkd = true; # conflicts with Network Manager
    networkmanager.enable = true;
    useDHCP = lib.mkForce true; # can also define this per-interface
  };

  environment.systemPackages = [
    pkgs.pciutils
    pkgs.usbutils

    pkgs.git

    pkgs.unzip
    pkgs.zip
  ];
}