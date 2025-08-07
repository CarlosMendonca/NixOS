{ pkgs, ... } : {
    imports = [
        ../../services/xserver.gnome.nix
        ../../modules/fonts.nix
    ];
}
