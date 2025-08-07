{ lib, pkgs, ... }: {
  imports = [
    ./carlos.gui.nix
  ];
  home-manager.users.carlos = {
    imports = [
      # CLI programs

      # GUI programs
      # ../../../modules/programs/terminal.home.nix
      ../../../modules/fonts.home.nix
      
      # ../../../modules/programs/github-desktop.home.nix
      # ../../../modules/programs/gitkraken.home.nix
      ../../../modules/programs/vscode.home.nix

      # ../../../modules/programs/chromium.home.nix
      ../../../modules/programs/firefox.home.nix

      # Graphical environment
      ../../../services/xserver.gnome.home.nix
    ];
  };

  environment.systemPackages = [
        pkgs.devenv
        pkgs.google-chrome
    ];

  programs.nix-ld.enable = true;
}
