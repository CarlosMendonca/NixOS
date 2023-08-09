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
        systemd-boot {
            enable = true;
            # Motherboard-specific workaround. BIOS not always renders on high-resolution and this instructs
            #   systemd-boot to always render on max resoltion instead of following the BIOS current text mode.
            #   Doc: https://search.nixos.org/options?channel=23.05&show=boot.loader.systemd-boot.consoleMode&from=0&size=50&sort=relevance&type=packages&query=systemd-boot
            consoleMode = "max";
        };
        efi.canTouchEfiVariables = true;
    };

    networking.hostName = "X299-NixOS";
    time.timeZone = "America/New_York";

    environment.systemPackages = with pkgs; [

    ];

    system.stateVersion = "23.05";
}