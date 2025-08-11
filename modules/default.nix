{ }: {
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.trusted-users = [ "root" ];

  nixpkgs.config.allowUnfree = true;

  # Networking -- common to all configurations
  networking = {
    # useNetworkd = true; # conflicts with Network Manager 
    networkmanager.enable = true;
    useDHCP = true; # can also define this per-interface
  };

  environment.systemPackages = [
    pkgs.pciutils
    pkgs.usbutils

    pkgs.git

    pkgs.unzip
    pkgs.zip
  ];
}