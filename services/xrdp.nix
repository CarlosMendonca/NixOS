{ config, pkgs, ... }: {
  services.xrdp = {
    enable = true;
    defaultWindowManager = "gnome-session"; # doesn't matter because we write our own ~/startwm.sh script
    openFirewall = true;
  };
}
