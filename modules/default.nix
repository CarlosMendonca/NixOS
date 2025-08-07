# Defines baseline configuration common to all system
{ config, pkgs, lib, ... }: {
    nix.settings.experimental-features = [ "nix-command" "flakes" ];
    nix.settings.trusted-users = [ "root" ];

    nixpkgs.config.allowUnfree = true;
    
}