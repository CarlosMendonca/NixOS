{ config, lib, pkgs, ... }: {
  # TODO consider separating hardware roles from software roles

  options.roles.desktop = {
    enable = lib.mkEnableOption "Desktop role configuration";

    acIdleTimeoutSec = lib.mkOption {
      type = lib.types.int;
      default = 7200; # 2h
      description = ''
        Idle duration (in seconds) before the system suspends while on AC
        power. Drives `services.logind.settings.Login.IdleActionSec` (the
        fallback that applies even before login, e.g. at the GDM greeter)
        and is also read by the GNOME dconf settings for user `carlos`
        (see users/modules/desktop.nix), so the two stay in sync.

        There is no separate on-battery equivalent here since logind itself
        doesn't distinguish AC/battery; see `roles.laptop.batteryIdleTimeoutSec`
        for the GNOME-only battery timeout on laptop hosts.
      '';
    };
  };

  config = lib.mkIf config.roles.desktop.enable {
    services.logind.settings.Login = {
      IdleAction = "suspend";
      IdleActionSec = config.roles.desktop.acIdleTimeoutSec;
    };

    # Fonts -- specific fonts are configured by Home Manager
    fonts = {
      fontconfig.enable = true;
      fontDir.enable = true;
    };

    services = {
      printing.enable = true; # Enable CUPS for printer support

      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;

      desktopManager.gnome.extraGSettingsOverrides = ''
        [org.gnome.mutter]
        experimental-features=['scale-monitor-framebuffer', 'xwayland-native-scaling']

        [org.gnome.shell.keybindings]
        show-screenshot-ui=['<Shift><Super>s']
      ''; # TODO consider moving the screenshot keybinding to the host config level, since this is keyboard-specific

      xserver = {
        # enable = true;
        
        # desktopManager.xterm.enable = false; # see line below
        excludePackages = [ pkgs.xterm ]; # no longer necessary since we're no longer enabling xserver?

        xkb = {
          layout = "us,us";
          variant = "intl,"; # will assume every keyboard is US International
          options = "grp:alt_shift_toggle";
        };
      };
    };

    console.useXkbConfig = true;
    i18n = {
      defaultLocale = "en_US.UTF-8"; # already the default, just making explicit
      defaultCharset = "UTF-8"; # already the default, just making explicit
      supportedLocales = [ "en_US.UTF-8/UTF-8" "pt_BR.UTF-8/UTF-8" ];
      # extraLocaleSettings = { LC_CTYPE = "pt_BR.UTF-8"; }; # will assume every leyboard is US International; this fixes ' + c for cedilla; no longer necessary since we've started using ibus with custom Compose rules

      inputMethod = {
        enable = true;
        type = "ibus";
      };
    };

    users.users.gdm.extraGroups = [ "video" ];

    environment.sessionVariables.NIXOS_OZONE_WL = "1"; # enable Ozone support for Electron apps -- see https://nixos.wiki/wiki/Visual_Studio_Code

    # The following seems to be incompatible with ibus
    # environment.variables = {
    #   GTK_IM_MODULE = "cedilla";
    #   QT_IM_MODULE = "cedilla";
    # };

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
    ] ++ lib.optionals config.roles.external-monitor.enable [
      pkgs.gnomeExtensions.brightness-control-using-ddcutil
      # pkgs.gnomeExtensions.control-monitor-brightness-and-volume-with-ddcutil # Not as configurable as the other extension, but supports volume control
    ];

    programs.localsend.enable = true;
  };
}