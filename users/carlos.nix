{ ... }:

{
  system = {
    isNormalUser = true;
    extraGroups = [
        "wheel"
        "networkmanager" # doesn't need to be conditional because we assume every host is has networking
        "video" # TODO make this conditional to the desktop role
    ];
    initialPassword = "pass@word1";

    openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHuPS+6cOVy3XmxL/xmec0xSj1JKUmvFeT3OAb0XIH1c" ];
  };

  home = {
    programs.git = {
      userName = "Carlos Mendonça";
      userEmail = "CarlosMendonca@users.noreply.github.com";
    };

    home.language.base = "en_US.UTF-8";

    home.packages = [];
  };
}