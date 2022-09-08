{ lib, pkgs, ... }: {
  imports = [
    ./carlos.gui.nix
  ];

  home-manager.users.carlos = {
    imports = [
      # CLI programs

      # GUI programs
      ../../../modules/programs/terminal.home.nix
      ../../../modules/programs/vscode.home.nix

      # Graphical environment
      ../../../modules/programs/rofi.home.nix
      ../../../services/polybar.home.nix
      ../../../services/xrdp.i3.home.nix
      ../../../services/xserver.i3.home.nix
    ];
  };
}
