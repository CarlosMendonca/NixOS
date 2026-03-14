{ config, lib, pkgs, ... }: {
  options.roles.external-monitor = {
    enable = lib.mkEnableOption "External monitor support with ddcutil";
  };

  config = lib.mkIf config.roles.external-monitor.enable {
    environment.systemPackages = [
      pkgs.ddcutil
    ];

    boot.kernelModules = [ "i2c-dev" ];

    services.udev.extraRules = ''
      KERNEL=="i2c-[0-9]*", GROUP="video", MODE="0660"
    '';
  };
}
