{ pkgs, ... }: {
    imports = [
        ./hardware-configuration.nix
        ../../modules
        ../../modules/networking.nix
        # ../../modules/wifi.nix

        ./configuration.gui.gnome.nix

        ./users/carlos.gui.gnome.nix
    ];

    networking.hostName = "X13-NixOS";
    time.timeZone = "America/New_York";

    environment.systemPackages = with pkgs; [

    ];

    # Do never change -- this is not where you update the system
    system.stateVersion = "25.05";
}
