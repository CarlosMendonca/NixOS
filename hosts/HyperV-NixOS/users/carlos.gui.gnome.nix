{ lib, pkgs, ... }: {
  imports = [
    ./carlos.gui.nix
  ];
  home-manager.users.carlos = {
    imports = [
      # CLI programs

      # GUI programs
      # ../../../modules/programs/terminal.home.nix
      ../../../modules/programs/vscode.home.nix

      # Graphical environment
      # ../../../services/xrdp.gnome.home.nix
      # ../../../services/xserver.gnome.home.nix
    ];
  };
}
