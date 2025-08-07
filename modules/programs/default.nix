{ lib, pkgs, ... }: {
    environment.systemPackages = [
        pkgs.pciutils
        pkgs.usbutils

        pkgs.git
        
        pkgs.unzip
        pkgs.zip
    ];
}