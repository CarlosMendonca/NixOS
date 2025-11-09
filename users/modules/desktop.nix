{ config, lib, pkgs, ... }: {
  config = lib.mkIf config.roles.desktop.enable {
    programs = {
      # chromium.enable = true; # using Google Chrome instead
      firefox.enable = true;
      vscode.enable = true;
    };

    home.packages = [
      # Fonts
      pkgs.nerd-fonts.iosevka
      pkgs.nerd-fonts.iosevka-term

      pkgs.google-chrome
      # pkgs.pinta # simple photo editor
      pkgs.rustdesk-flutter # consider moving this to system-wide, since it's also a remoting servers
      pkgs.spotify-player
    ];
  };
}