{ config, lib, pkgs, ... }: {
  # TODO consider separating hardware roles from software roles

  options.roles.desktop = {
    enable = lib.mkEnableOption "Desktop role configuration";
  };

  config = lib.mkIf config.roles.desktop.enable {
    # Fonts -- specific fonts are configured by Home Manager
    fonts = {
      fontconfig.enable = true;
      fontDir.enable = true;
    };

    services.xserver = {
      enable = true;
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;

      desktopManager.gnome.extraGSettingsOverrides = ''
        [org.gnome.mutter]
        experimental-features=['scale-monitor-framebuffer', 'xwayland-native-scaling']

        [org.gnome.shell.keybindings]
        show-screenshot-ui=['<Shift><Super>s']
      ''; # TODO consider moving the screenshot keybinding to the host config level, since this is keyboard-specific

      # desktopManager.xterm.enable = false; # see line below
      excludePackages = [ pkgs.xterm ];

      xkb = {
        layout = "us,us";
        variant = "intl,"; # will assume every keyboard is US International
        options = "grp:alt_shift_toggle";
      };
    };

    console.useXkbConfig = true;
    i18n = {
      defaultLocale = "en_US.UTF-8"; # already the default, just making explicit
      defaultCharset = "UTF-8"; # already the default, just making explicit
      supportedLocales = [ "en_US.UTF-8/UTF-8" "pt_BR.UTF-8/UTF-8" ];
      extraLocaleSettings = { LC_CTYPE = "pt_BR.UTF-8"; }; # will assume every leyboard is US International; this fixes ' + c for cedilla
    };

    users.users.gdm.extraGroups = [ "video" ];

    environment.sessionVariables.NIXOS_OZONE_WL = "1"; # enable Ozone support for Electron apps -- see https://nixos.wiki/wiki/Visual_Studio_Code

    environment.gnome.excludePackages = [
      # pkgs.gnome-photos
      # pkgs.gnome-tour

      # pkgs.gnome.atomix
      # pkgs.gnome.cheese
      # pkgs.gnome.geary
      # pkgs.gnome.gedit

      # pkgs.gnome.gnome-calculator
      # pkgs.gnome.gnome-characters
      # pkgs.gnome.gnome-clocks
      # pkgs.gnome.gnome-contacts
      # pkgs.gnome.gnome-maps
      # pkgs.gnome.gnome-music
      # pkgs.gnome.gnome-terminal
      # pkgs.gnome.gnome-weather

      # pkgs.gnome.hitori
      # pkgs.gnome.iagno
      # pkgs.gnome.tali
      # pkgs.gnome.totem

      # pkgs.epiphany
      # pkgs.evince
    ];

    environment.systemPackages = [
      pkgs.gnome-tweaks # a few Gnome extras
      # pkgs.dconf-editor

      pkgs.easyeffects # GTk4 PipeWire audio mixer
    ];

    programs.localsend.enable = true;
  };
}