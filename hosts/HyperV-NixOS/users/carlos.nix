{ lib, pkgs, ... }: {
  imports = [
    ../../../users/carlos.nix
  ];

  home-manager.users.carlos = {
    imports = [
      # CLI programs

      # GUI programs
      ../../../modules/programs/terminal.home.nix

      # Graphical environment
      ../../../modules/programs/rofi.home.nix
      ../../../services/polybar.home.nix
      ../../../services/xserver.i3.home.nix
    ];
  };
}
