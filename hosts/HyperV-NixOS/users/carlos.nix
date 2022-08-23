{ lib, ... }: {
  imports = [
    ../../../users/carlos.nix
  ];

  home-manager.users.carlos = {
    home.file.".xinitrc".text = ''
      exec i3
    '';
  };
}
