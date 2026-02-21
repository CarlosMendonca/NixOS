{ config, lib, pkgs, pkgs-unstable, ... }: {
  options.roles.containers = {
    enable = lib.mkEnableOption "Container support with Podman";
  };

  config = lib.mkIf config.roles.containers.enable {
    virtualisation.podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true;
    };

    environment.systemPackages = [
      pkgs.podman-compose
      # pkgs.podman-tui
      pkgs.podman-desktop

      pkgs-unstable.distrobox
    ];
  };
}
