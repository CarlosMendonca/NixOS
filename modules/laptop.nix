{ config, lib, pkgs, ... }: {
  options.roles.laptop = {
    enable = lib.mkEnableOption "Laptop-specific hardware and power management";

    batteryIdleTimeoutSec = lib.mkOption {
      type = lib.types.int;
      default = 900; # 15min
      description = ''
        Idle duration (in seconds) before GNOME suspends while on battery
        power (see users/modules/desktop.nix). logind has no separate
        battery idle action, so this only affects GNOME's own idle handling
        once a session is running; see `roles.desktop.acIdleTimeoutSec` for
        the AC/pre-login equivalent.
      '';
    };
  };

  config = lib.mkIf config.roles.laptop.enable (lib.mkMerge [
    (lib.mkIf config.roles.nvidia.enable {
      # Dynamic Boost shifts the power budget between CPU and NVIDIA GPU on
      # Optimus laptops. On a desktop it has nothing to balance and only spawns
      # a failing nvidia-powerd, so it belongs here rather than in the nvidia module.
      hardware.nvidia.dynamicBoost.enable = lib.mkDefault true;
    })
  ]);
}
