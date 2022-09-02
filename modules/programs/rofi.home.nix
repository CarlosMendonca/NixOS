{ lib, pkgs, ... }: {
    programs.rofi = {
        enable = true;
        extraConfig.combi-modi = "window,run";
    };
}