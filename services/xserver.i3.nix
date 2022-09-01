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
        dmenu
        i3status
      ];

      # Make sure DISPLAY and XAUTHORITY are available for systemd by executing what https://github.com/systemd/systemd/blob/main/xorg/50-systemd-user.sh would. Source: https://git.0xee.eu/0xee/nix-home/src/branch/master/home.nix
      #extraSessionCommands = ''
      #  export DISPLAY XAUTHORITY
      #  systemctl --user import-environment DISPLAY XAUTHORITY

      #  if command -v dbus-update-activation-environment >/dev/null 2>&1; then
      #      dbus-update-activation-environment DISPLAY XAUTHORITY
      #  fi
      #'';
    };
  };
}
