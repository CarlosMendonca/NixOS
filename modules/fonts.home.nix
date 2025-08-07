{ lib, pkgs, ... }: {
    home.packages = [
        pkgs.nerd-fonts.iosevka
        pkgs.nerd-fonts.iosevka-term
    ];
}