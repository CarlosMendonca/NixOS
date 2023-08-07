{ lib, pkgs, ... }: {
  imports = [
    ../../../users/carlos.nix
  ];

  home-manager.users.carlos = {
    imports = [
      # CLI programs
    ];
    
    home.stateVersion = "23.05";
  };
}
