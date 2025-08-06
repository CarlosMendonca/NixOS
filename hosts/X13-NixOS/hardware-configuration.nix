{ config, lib, pkgs, modulesPath, ... }: {
    imports = [ ];

    boot = {
        blacklistedKernelModules = [ "k10temp" "nouveau" ];

        initrd = {
            availableKernelModules = [ "nvme" "xhci_pci" "thunderbolt" "usbhid" "usb_storage" "sd_mod" "sdhci_pci" ];
            kernelModules = [ ];
        };
        kernelModules = [ "kvm-amd" "zenpower" "amd_pstate=active" ];
        kernelParams = [
          "mem_sleep_default=deep"
          "pcie_aspm.policy=powersupersave",
          
        ];
        extraModulePackages = [ config.boot.kernelPackages.zenpower ];
         
        loader = {
            systemd-boot.enable = true;
            efi.canTouchEfiVariables = true;
    }};

    hardware = {
        amdgpu.initrd.enable = true;

        cpu.amd.updateMicrocode = true;

        nvidia = {
            dynamicBoost.enable = true;

            graphics = {
                enable = true;
                enable32Bit = true;
            };

            modesetting.enable = true;
            nvidiaSetting = true;
            open = true;

            powerManagement = {
                enable = true;
                finegrained = true;
            };

            prime = {
                offload = {
                    enable = true;
                    enableOffloadCmd = true;
                };
            
                amdgpuBusId = "PCI:69:0:0";
                nvidiaBusId = "PCI:1:0:0";
            };
        };

        # Enable 2-in-1 sensors (orientation)
        sensor.iio.enable = true;
    };

    networking.useDHCP = true;
    
    nixpkgs = {
        allowUnfree = true;
        hostPlatform = "x86_64-linux";
    };

    services = {
        asusd = {
            enable = true;
            enableUserService = true;
        };

        fstrim.enable = true;

        supergfxd.enable = true;

        tlp.enable = false;

        udev = {
            extraHwdb = ''
                # Fixes mic mute button
                evdev:name:*:dmi:bvn*:bvr*:bd*:svnASUS*:pn*:*
                KEYBOARD_KEY_ff31007c=f20
            '';
        };
    };

    # Configuration not applied
    # - Disable power auto-suspend for the ASUS N-KEY device, i.e. USB Keyboard
    # - Disable power wakeup for the 8295 ITE device
    # - Mediatek fine tuning 

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