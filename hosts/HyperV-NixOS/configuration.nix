{ pkgs, ... }: {
    imports = [
        ./hardware-configuration.nix
        ../../modules
        ../../modules/fonts.nix
        
        ../../services/openssh.nix

        ./configuration.gui.gnome.nix

        ./users/carlos.gui.gnome.nix
    ];

    boot.loader = {
        systemd-boot.enable = true;
        efi.canTouchEfiVariables = true;
    };
    
    boot.kernelPackages = pkgs.linuxPackages_latest;

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
