{ pkgs, ... }: {
    imports = [
        ./hardware-configuration.nix
        ../../modules
        ../../modules/fonts.nix
        ../../modules/sound.nix
        
        ../../services/openssh.nix

        ./configuration.gui.gnome.nix

        ./users/carlos.gui.gnome.nix
    ];

    nixpkgs.config.permittedInsecurePackages = [
      "openssl-1.1.1v"
    ];

    boot.loader = {
        systemd-boot.enable = true;
        efi.canTouchEfiVariables = true;
    };

    networking.hostName = "X299-NixOS";
    time.timeZone = "America/New_York";

    environment.systemPackages = with pkgs; [

    ];

    system.stateVersion = "23.05";
}