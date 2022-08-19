# Defines baseline configuration common to all system
{ config, pkgs, lib, ... }: {
    nix.settings.experimental-features = [ "nix-command" "flakes" ];

    nixpkgs.config.allowUnfree = true;
    
}