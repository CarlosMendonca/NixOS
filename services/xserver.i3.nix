{ config, pkgs, ... }: {
  services.xserver = {
    enable = true;
    exportConfiguration = true;
    displayManager.startx.enable = true;
    
    windowManager.i3 = {
      enable = true;
      package = pkgs.i3-gaps;
      extraPackages = with pkgs; [
        # TODO check whether these are still necessary
        # dmenu
        # i3status
      ];
    };
  };
}
