{ pkgs, ... } : {
    imports = [
        ../../services/picom.nix
        ../../services/xserver.i3.nix
        ../../services/xrdp.nix
    ];
}