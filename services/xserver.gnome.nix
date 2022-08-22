{ ... }: {
  services.xserver = {
    enable = true;
    exportConfiguration = true;
    
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
  };
}
