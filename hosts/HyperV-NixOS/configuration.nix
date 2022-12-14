{ pkgs, ... }: {
    imports = [
        ./hardware-configuration.nix
        ../../modules
        ../../modules/fonts.nix

        ../../services/openssh.nix
        ../../services/picom.nix
        ../../services/xserver.i3.nix
        ../../services/xrdp.nix

        ./users/carlos.nix
    ];

    boot.loader = {
        systemd-boot.enable = true;
        efi.canTouchEfiVariables = true;
    };

    networking.hostName = "HyperV-NixOS";
    time.timeZone = "America/New_York";

    environment.systemPackages = with pkgs; [

    ];

    # Xserver-specific workarounds
    services.xserver = {
      modules = [ pkgs.xorg.xf86videofbdev ];
      videoDrivers = [ "hyperv_fb" ];
    };

    system.stateVersion = "22.05";
}
