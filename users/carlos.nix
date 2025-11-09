{ config, lib, pkgs, ... }:
{
  options.users.carlos = {
    enable = lib.mkEnableOption "Carlos' user configuration";
  };

  config = lib.mkIf config.users.carlos.enable {
    users.users.carlos = {
      isNormalUser = true;
      extraGroups = [
          "wheel"
          "networkmanager" # doesn't need to be conditional because we assume every host has networking
          "video" # TODO make this conditional to the desktop role
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
      dconf.settings = {
        "org/gnome/desktop/background" = {
          picture-uri = "file://${../assets/Rancho_day_1600.png}";
          picture-uri-dark = "file://${../assets/Rancho_night_1600.png}";
        };

        "org/gnome/desktop/screensaver" = {
          picture-uri = "file://${../assets/Rancho_day_1600.png}";
        };
      };

      home.file."Pictures/carlos.jpg".source = ../assets/carlos.jpg; # TODO change to a configuration once it gets implemented; see https://github.com/NixOS/nixpkgs/issues/163080

      programs.git = {
        userName = "Carlos Mendonça";
        userEmail = "CarlosMendonca@users.noreply.github.com";
      };

      home.language.base = "en_US.UTF-8";

      # home.packages = []; # packages that are exclusive to this user
    };
  };
}