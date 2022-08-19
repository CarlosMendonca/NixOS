{
    home-manager.users.carlos = {
        imports = [
            ../modules/home.nix
        ];

        programs.git = {
          userName = "Carlos Mendonca";
          userEmail = "CarlosMendonca@users.noreply.github.com";
        };
    };

    users.users.carlos = {
        isNormalUser = true;
        extraGroups = [ "wheel" ];

        openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHuPS+6cOVy3XmxL/xmec0xSj1JKUmvFeT3OAb0XIH1c" ];
    };
}
