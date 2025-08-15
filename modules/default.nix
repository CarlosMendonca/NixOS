{ lib, pkgs, ... }: {
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.trusted-users = [ "root" ];

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