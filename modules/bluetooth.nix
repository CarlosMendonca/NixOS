{ config, lib, pkgs, ... }: {
  options.roles.bluetooth = {
    enable = lib.mkEnableOption "Bluetooth role configuration";
  };

  config = lib.mkIf config.roles.bluetooth.enable {
    # Bluetooth -- see https://nixos.wiki/wiki/Bluetooth
    hardware.bluetooth.enable = true;
    services.blueman.enable = true;
  };
}