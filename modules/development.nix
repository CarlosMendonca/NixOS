{ ... }: {
  imports = [
    ./. # default.nix
    ./desktop.nix # development role is necessarily desktop role too (GUI)
  ];

  programs.nix-ld.enable = true;
}