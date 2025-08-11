{ }: {
    imports = [ 
      ../../modules/. # default.nix
      ../../modules/bluetooth.nix
      ../../modules/sound.nix
      ../../modules/wifi.nix
    ];

    boot = {
        blacklistedKernelModules = [
            "k10temp" # AMD temperature sensor?
            "nouveau"
        ];
        
        extraModulePackages = [ config.boot.kernelPackages.zenpower ]; # TODO clarify what this is referring to

        initrd = {
            availableKernelModules = [
              "nvme"
              "xhci_pci"
              "thunderbolt"
              "usbhid"
              "usb_storage"
              "sd_mod"
              "sdhci_pci"
            ];

            kernelModules = [ ];
        };

        kernelModules = [
          "kvm-amd"
          "zenpower"
          "amd_pstate=active"
          "wl" # wireless network
        ];
        
        # kernelPackages = pkgs.linuxPackages_latest; # TODO define whether to use this or not
        
        kernelParams = [
          "mem_sleep_default=deep"
          "pcie_aspm.policy=powersupersave"          
        ];
         
        loader = {
            systemd-boot.enable = true;
            efi.canTouchEfiVariables = true;
        };
    };

    hardware = {
        amdgpu.initrd.enable = true;

        cpu.amd.updateMicrocode = true;

        enableAllFirmware = true; # required for AX210, amdgpu, and potentially others

        graphics = {
            enable = true;
            enable32Bit = true;
        };

        nvidia = {
            dynamicBoost.enable = true;

            modesetting.enable = true;
            nvidiaSettings = true;
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

        sensor.iio.enable = true; # enable 2-in-1 sensors (orientation)
    };
    
    nixpkgs = {
        config.allowUnfree = true;
        hostPlatform = "x86_64-linux";
    };

    services = {
        asusd = {
            enable = true;
            enableUserService = true;
        }; # Asus control software

        fstrim.enable = true;

        supergfxd.enable = true; # Asus control software

        tlp.enable = false; # TODO clarify what this is

        udev = {
            extraHwdb = ''
                evdev:name:*:dmi:bvn*:bvr*:bd*:svnASUS*:pn*:*
                KEYBOARD_KEY_ff31007c=f20
            ''; # fixes mic mute button
        };

        # xserver.videoDrivers = ["nvidia"]; # TODO determine whether it needs to be specified and what value should be used
    };

    # Disable power auto-suspend for the ASUS N-KEY device, i.e. USB Keyboard
    # Disable power wakeup for the 8295 ITE device
    # Mediatek fine tuning -- not necessary since I'm running AX210

    fileSystems."/" = {
        device = "/dev/disk/by-label/nixos";
        fsType = "ext4";
    };

    fileSystems."/boot" = {
        device = "/dev/disk/by-label/SYSTEM"; # assume the Windows boot partition manually created with 512MB
        fsType = "vfat";
    };

    swapDevices = [
        { device = "/dev/disk/by-label/swap"; } # not sure if 32 or 64GB
    ];
}