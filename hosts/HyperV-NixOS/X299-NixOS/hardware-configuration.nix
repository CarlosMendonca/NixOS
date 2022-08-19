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
}