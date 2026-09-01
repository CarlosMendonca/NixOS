{ config, lib, pkgs, ... }: {
  options.roles.laptop = {
    enable = lib.mkEnableOption "Laptop-specific hardware and power management";
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
