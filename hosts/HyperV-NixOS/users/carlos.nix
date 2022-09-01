{ lib, pkgs, ... }: {
  imports = [
    ../../../users/carlos.nix
  ];

  home-manager.users.carlos = {
    programs.alacritty.enable = true;
    
    # TODO move to its own file
    programs.rofi = {
      enable = true;
      extraConfig.combi-modi = "window,run";
    };

    home.packages = with pkgs; [
      alacritty
    ];

    imports = [
      ../../../services/polybar.home.nix
      ../../../services/xserver.i3.home.nix
    ];
  };
}
