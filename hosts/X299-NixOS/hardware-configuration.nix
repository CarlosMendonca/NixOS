{ config, lib, pkgs, modulesPath, ... }: {
    imports = [ ];

    fileSystems."/" = {
        device = "/dev/disk/by-uuid/00000000-0000-0000-0000-000000000000";
        fsType = "ext4";
    };

    fileSystems."/boot" = {
        device = "/dev/disk/by-uuid/00000000-0000-0000-0000-000000000000";
        fsType = "vfat";
    };

    swapDevices = [
        { device = "/dev/disk/by-uuid/00000000-0000-0000-0000-000000000000"; }
    ];

    hardware.opengl = {
        enable = true;
        driSupport = true;
        driSupport32Bit = true;
    };

    services.xserver.videoDrivers = ["nvidia"];

    hardware.nvidia = {
        modesetting.enable = true;
        open = true;
        nvidiaSetting = true;
        # pacakge = config.boot.kernelPackages.nvidiaPackages.stable;
    };

    nixpkgs.config.allowUnfree = true;
}