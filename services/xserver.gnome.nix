{ pkgs, ... }: {
  services.xserver = {
    enable = true;
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
    
    # desktopManager.xterm.enable = false;
    excludePackages = [ pkgs.xterm ];

    layout = "us";
  };

  # Is this necessary? It's declared already within the scope of the user.
  users.users.gdm = {
    extraGroups = [ "video" ];
  };

  # Enable Ozone support for Electron apps. Doc: https://nixos.wiki/wiki/Visual_Studio_Code
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  
  # environment.gnome.excludePackages = [
    # pkgs.gnome-photos
    # pkgs.gnome-tour

    # pkgs.gnome.atomix
    # pkgs.gnome.cheese
    # pkgs.gnome.geary
    # pkgs.gnome.gedit

    # pkgs.gnome.gnome-calculator
    # pkgs.gnome.gnome-characters
    # pkgs.gnome.gnome-clocks
    # pkgs.gnome.gnome-contacts
    # pkgs.gnome.gnome-maps
    # pkgs.gnome.gnome-music
    # pkgs.gnome.gnome-terminal
    # pkgs.gnome.gnome-weather

    # pkgs.gnome.hitori
    # pkgs.gnome.iagno
    # pkgs.gnome.tali
    # pkgs.gnome.totem

    # pkgs.epiphany
    # pkgs.evince
  # ];

  # environment.systemPackages = [
    # pkgs.gnome.gnome-tweaks
    # pkgs.gnome.gnome-shell-extensions
    # pkgs.gnome.dconf-editor
  # ];
}
