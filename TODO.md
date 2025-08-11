# TODO

Main structure:
- flake.nix
- hosts/
- modules/                  # roles that the machine can assume; maybe I should call it that
-        /default.nix       # common
-        /desktop.nix
-        /development.nix
-        /remote-desktop.nix
-        /gaming.nix
- overlays/                 # modifications to nixpkgs packages
- pkgs/                     # my own packages
- users/carlos.nix
- users/modules