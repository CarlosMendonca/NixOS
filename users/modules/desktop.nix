{ systemConfig, lib, pkgs, ... }: {
  config = lib.mkIf systemConfig.roles.desktop.enable {
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
      pkgs.rustdesk-flutter # consider moving this to system-wide, since it's also a remoting server
      pkgs.spotify-player
    ];
  };
}