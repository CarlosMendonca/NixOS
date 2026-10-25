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

    hibernateDelaySec = lib.mkOption {
      type = lib.types.int;
      default = 6 * 60 * 60; # 6h
      description = ''
        How long (in seconds) the system stays suspended before automatically
        hibernating. Implemented by redirecting systemd's plain `suspend`
        operation to `suspend-then-hibernate`, since GNOME itself has no
        suspend-then-hibernate concept and always requests a plain suspend
        (whether triggered by its idle timer, its Suspend menu item, or
        `systemctl suspend`); this redirect makes every one of those paths
        honor the delay below via `HibernateDelaySec`.
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
    {
      systemd.sleep.settings.Sleep.HibernateDelaySec = config.roles.laptop.hibernateDelaySec;
      systemd.services.systemd-suspend.serviceConfig.ExecStart =
        lib.mkForce "${config.systemd.package}/lib/systemd/systemd-sleep suspend-then-hibernate";
    }
  ]);
}
