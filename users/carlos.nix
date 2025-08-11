{ }: {
    home-manager.users.carlos = {
        imports = [
            ./modules/. # default.nix
        ];

        programs.git = {
          userName = "Carlos Mendonça";
          userEmail = "CarlosMendonca@users.noreply.github.com";
        };

        useGlobalPkgs = true; # see manual on https://nix-community.github.io/home-manager

        home.stateVersion = "25.05"; # probably should NOT change
    };

    users.users.carlos = {
        isNormalUser = true;
        extraGroups = [
            "wheel"
            "networkmanager" # doesn't need to be conditional because we assume every host is has networking
            "video" # TODO make this conditional to the desktop role
        ];
        initialPassword = "pass@word1";

        openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHuPS+6cOVy3XmxL/xmec0xSj1JKUmvFeT3OAb0XIH1c" ];
    };
    
    nix.settings.trusted-users = [ "carlos" ];
}
