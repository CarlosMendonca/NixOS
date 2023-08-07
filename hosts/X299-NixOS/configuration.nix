{ pkgs, ... }: {
    imports = [
        ./hardware-configuration.nix
        ../../modules
        ../../modules/networking.nix
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