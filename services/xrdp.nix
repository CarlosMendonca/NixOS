{ config, pkgs, ... }: {
  services.xrdp = {
    enable = true;
    defaultWindowManager = "i3";
    openFirewall = true;
  };
}
