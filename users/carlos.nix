{ config, lib, pkgs, ... }:
let
  verticalResolution = config.hardware.primaryDisplay.verticalResolution;
  wallpaperAvailable = verticalResolution != null;
in
{
  options.users.carlos = {
    enable = lib.mkEnableOption "Carlos' user configuration";
    trusted = lib.mkEnableOption "trusted user for Nix operations";
    canUseDesktop = lib.mkEnableOption "desktop access (adds video group)";
    canUseVirtualization = lib.mkEnableOption "virtualization access (adds libvirtd group)";
    canUseContainers = lib.mkEnableOption "container access (adds podman group)";
  };

  config = lib.mkIf config.users.carlos.enable {
    nix.settings.trusted-users = lib.mkIf config.users.carlos.trusted [ "carlos" ];

    users.users.carlos = {
      isNormalUser = true;
      extraGroups = [
          "wheel"
          "networkmanager" # doesn't need to be conditional because we assume every host has networking
      ] ++ lib.optionals (config.users.carlos.canUseDesktop && config.roles.desktop.enable) [
          "video"
      ] ++ lib.optionals (config.users.carlos.canUseVirtualization && config.roles.virtualization.enable) [
          "libvirtd"
      ] ++ lib.optionals (config.users.carlos.canUseContainers && config.roles.containers.enable) [
          "podman"
      ];
      initialPassword = "pass@word1";

      openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHuPS+6cOVy3XmxL/xmec0xSj1JKUmvFeT3OAb0XIH1c" ];

      # environment.systemPackages = []; # packages that are exclusive to this user
    };

    home-manager.users.carlos = {
      imports = [
        ./modules
      ];

      # Match home-manager stateVersion to system stateVersion
      home.stateVersion = config.system.stateVersion;

      # Wallpapers for primary displays
      dconf.settings = lib.mkIf wallpaperAvailable {
        "org/gnome/desktop/background" = {
          picture-uri = "file://${../assets/Rancho_day_${toString verticalResolution}.png}";
          picture-uri-dark = "file://${../assets/Rancho_night_${toString verticalResolution}.png}";
        };

        "org/gnome/desktop/screensaver" = {
          picture-uri = "file://${../assets/Rancho_day_${toString verticalResolution}.png}";
        };
      };

      home.file."Pictures/carlos.jpg".source = ../assets/carlos.jpg; # TODO change to a configuration once it gets implemented; see https://github.com/NixOS/nixpkgs/issues/163080

      # Wallpapers for secondary displays
      home.file."Pictures/Wallpapers/Rancho_day_1600.png".source = ../assets/Rancho_day_1600.png;
      home.file."Pictures/Wallpapers/Rancho_night_1600.png".source = ../assets/Rancho_night_1600.png;
      home.file."Pictures/Wallpapers/Rancho_day_2160.png".source = ../assets/Rancho_day_2160.png;
      home.file."Pictures/Wallpapers/Rancho_night_2160.png".source = ../assets/Rancho_night_2160.png;

      home.file.".config/ibus/Compose".source = ./dotfiles/ibus-Compose;

      programs.git.settings.user = {
        name = "Carlos Mendonça";
        email = "CarlosMendonca@users.noreply.github.com";
      };

      home.language.base = "en_US.UTF-8";

      programs.bash.shellAliases = {
        pbcopy = "wl-copy";
        pbpaste = "wl-paste";
      };

      # home.packages = []; # packages that are exclusive to this user
    };
  };
}