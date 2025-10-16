{ config, pkgs, pkgs-unstable, ... }: {
  imports = [
    ./. # default.nix
    ./desktop.nix # development role is necessarily desktop role too (GUI)
  ];
  
  home.packages = [
    pkgs.devenv
    pkgs.github-desktop
    pkgs.lazygit
    # pkgs.starship # TODO enable with "programs.starship.enable = true" instead
    
    pkgs-unstable.code-cursor
  ];
}