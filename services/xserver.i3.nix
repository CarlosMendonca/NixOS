{ config, pkgs, ... }: {
  services.xserver = {
    enable = true;
    exportConfiguration = true;
    displayManager.startx.enable = true;
    
    windowManager.i3 = {
      enable = true;
      package = pkgs.i3-gaps;
      extraPackages = with pkgs; [
        dmenu
        i3status
      ];
    };
  };
}
