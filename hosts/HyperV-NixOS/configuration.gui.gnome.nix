{ pkgs, ... } : {
    imports = [
        ../../services/xserver.gnome.nix
        ../../services/xrdp.nix
    ];
}