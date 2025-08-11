{ }: {
  imports = [
    ./. # default.nix
    ./desktop.nix # development role is necessarily desktop role too (GUI)
  ];
  
  home.packages = [
    pkgs.devenv # TODO determine whether this is a system or a Home Manager package -- still confused about this
    pkgs.github-desktop
  ];

  programs.nix-ld.enable = true; # TODO determine whether this needs to be inside Home Manager's scope
}