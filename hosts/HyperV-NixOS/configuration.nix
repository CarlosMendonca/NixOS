{ pkgs, ... }: {
    imports = [
        ./hardware-configuration.nix
        ../../modules

        ../../services/openssh.nix

        ../../users/carlos.nix
    ];

    boot.loader = {
        systemd-boot.enable = true;
        efi.canTouchEfiVariables = true;
    };

    networking.hostName = "HyperV-NixOS";
    time.timeZone = "America/New_York";

    environment.systemPackages = with pkgs; [

    ];

    system.stateVersion = "22.05";
}
