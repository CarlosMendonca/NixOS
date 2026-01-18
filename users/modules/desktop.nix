{ systemConfig, lib, pkgs, ... }: {
  config = lib.mkIf systemConfig.roles.desktop.enable {
    programs = {
      # chromium.enable = true; # using Google Chrome instead
      firefox.enable = true;
      vscode.enable = true;
    };

    dconf.settings = lib.mkMerge [
      (lib.mkIf systemConfig.services.geoclue2.enable {
        "org/gnome/system/location" = {
          enabled = true;
        };
      })
      (lib.mkIf (systemConfig.services.geoclue2.enable && systemConfig.time.timeZone == null) {
        "org/gnome/desktop/datetime" = {
          automatic-timezone = true;
        };
      })
    ];

    home.packages = [
      # Fonts
      pkgs.nerd-fonts.iosevka
      pkgs.nerd-fonts.iosevka-term

      pkgs.google-chrome
      # pkgs.pinta # simple photo editor
      pkgs.rustdesk-flutter # consider moving this to system-wide, since it's also a remoting server
      pkgs.spotify-player

      pkgs.wl-clipboard # pkgs.wl-clipboard-rs doesn't work with GNOME
    ];
  };
}