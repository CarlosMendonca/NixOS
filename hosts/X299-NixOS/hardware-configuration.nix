{ }: {
    imports = [ 
      ../../modules/. # default.nix
      ../../modules/bluetooth.nix
      ../../modules/sound.nix
      ../../modules/wifi.nix
    ];

    boot = {
        blacklistedKernelModules = [ "nouveau" ];
        
        extraModulePackages = [ ];

        initrd = {
            availableKernelModules = [
              "xhci_pci"
              "ahci"
              "nvme"
              "usbhid"
              "usb_storage"
              "sd_mod"
            ];

            kernelModules = [ ];
        };

        kernelModules = [
          "kvm-intel"
          # "wl" # wireless network; not using Wi-Fi on this host, even though it supports it
        ];
        
        # kernelPackages = pkgs.linuxPackages_latest; # TODO define whether to use this or not
        
        kernelParams = [
          # "mem_sleep_default=deep"
          # "pcie_aspm.policy=powersupersave"
        ];
         
        loader = {
            systemd-boot.enable = true;
            efi.canTouchEfiVariables = true;
        };
    };

    hardware = {
        cpu.intel.updateMicrocode = true;

        enableAllFirmware = true; # required by some hardware

        graphics = {
            enable = true;
            enable32Bit = true;
        };

        nvidia = {
            # dynamicBoost.enable = true;

            modesetting.enable = true;
            nvidiaSettings = true;
            open = true;

            # powerManagement = {
            #     enable = true;
            #     finegrained = true;
            # };

            # package = config.boot.kernelPackages.nvidiaPackages.stable; # TODO determine whether this should be specified

            # prime = { }; # single GPU host
        };
    };

    services = {
      fstrim.enable = true;
      
      # xserver.videoDrivers = ["nvidia"]; # TODO check wether this is still necessary to specify
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
        { device = "/dev/disk/by-label/swap"; } # 64GB for this host
    ];
}