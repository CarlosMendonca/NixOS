{ lib, pkgs, ... }: {
    home.packages = with pkgs; [
        github-desktop
    ];
}