{ config, pkgs, ... }: {
  services.xrdp = {
    enable = true;
    # defaultWindowManager = "i3"; # doesn't matter because we write our own ~/startwm.sh script
    openFirewall = true;
  };
}
