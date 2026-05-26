{ config, lib, ... }:
let
  cfg = config.roles.nvidia;
in
{
  options.roles.nvidia = {
    enable  = lib.mkEnableOption "nvidia";
    package = lib.mkOption { type = lib.types.package; };
    powerManagement.finegrained = lib.mkOption {
      type    = lib.types.bool;
      default = false;
    };
    prime = lib.mkOption {
      type    = lib.types.attrs;
      default = {};
    };
  };

  config = lib.mkIf cfg.enable {
    hardware.nvidia = {
      package                     = cfg.package;
      modesetting.enable          = true;
      nvidiaSettings              = true;
      open                        = true;
      dynamicBoost.enable         = true;
      powerManagement.enable      = true;
      powerManagement.finegrained = cfg.powerManagement.finegrained;
      prime                       = cfg.prime;
    };
    services.xserver.videoDrivers = [ "nvidia" ];
  };
}
