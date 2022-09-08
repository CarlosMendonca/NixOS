{ pkgs, ... }: {
  imports = [
    ./carlos.nix
  ];

  users.users.carlos = {
    extraGroups = [ "video" ];
  };
}
