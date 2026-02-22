{ lib, pkgs, ... }: {
  imports = [
    ./bluetooth.nix
    ./containers.nix
    ./desktop.nix
    ./development.nix
    ./remoting.nix
    ./retro-gaming.nix
    ./sound.nix
    ./virtualization.nix
  ];

  options.hardware.primaryDisplay.verticalResolution = lib.mkOption {
    type = lib.types.nullOr (lib.types.enum [ 1600 2160 ]);
    default = null;
    description = "Vertical resolution of the primary display for wallpaper selection";
  };

  config = {
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
  };
}