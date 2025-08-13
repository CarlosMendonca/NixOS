{ pkgs, ... }: {
  imports = [
    ./. # default.nix
    ./desktop.nix # development role is necessarily desktop role too (GUI)
  ];
  
  home.packages = [
    pkgs.devenv
    pkgs.github-desktop
  ];
}