{ config, lib, pkgs, ... }:
let
  kernelVersion = config.boot.kernelPackages.kernel.version;
in
{
  imports = [
    # ../../modules/bluetooth.nix # Bluetooth seems to work without needing to include this -- may be enabled elsewhere
    # ../../modules/sound.nix # sounds like sound works without needing to enable this
  ];

  boot = lib.mkMerge [
    {
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
        "wl" # wireless network
      ];

      kernelPackages = pkgs.linuxPackages_6_16; # alternative to linuxPackages_latest

      kernelParams = [
        "mem_sleep_default=deep"
        "pcie_aspm.policy=powersupersave"
        "amdgpu.sg_display=0" # can help solve flickering/glitching display issues since Scatter/Gather code was reenabled
        "amdgpu.dcdebugmask=0x10" # same as above
      ];

      loader = {
        systemd-boot.enable = true;
        systemd-boot.configurationLimit = 5;
        efi.canTouchEfiVariables = true;
      };
    }

    # AMD P-State optimiizations from https://github.com/NixOS/nixos-hardware/blob/master/common/cpu/amd/pstate.nix; see https://www.kernel.org/doc/html/latest/admin-guide/pm/amd-pstate.html
    (lib.mkIf ((lib.versionAtLeast kernelVersion "5.17") && (lib.versionOlder kernelVersion "6.1")) {
      kernelParams = [ "initcall_blacklist=acpi_cpufreq_init" ];
      kernelModules = [ "amd-pstate" ];
    })
    (lib.mkIf ((lib.versionAtLeast kernelVersion "6.1") && (lib.versionOlder kernelVersion "6.3")) {
      kernelParams = [ "amd_pstate=passive" ];
    })
    (lib.mkIf (lib.versionAtLeast kernelVersion "6.3") {
      kernelParams = [ "amd_pstate=active" ];
    })
  ];

  hardware = {
    amdgpu.initrd.enable = true;

    cpu.amd.updateMicrocode = true;

    enableAllFirmware = true; # required for AX210, amdgpu, and potentially others

    graphics = {
      enable = true;
      enable32Bit = true;
    };

    sensor.iio.enable = true; # enable 2-in-1 sensors (orientation)
  };

  services = {
    asusd = {
      enable = true;
      enableUserService = true;
    }; # Asus control software

    fstrim.enable = true;

    supergfxd.enable = true; # Asus control software

    tlp.enable = false; # avoid conflicts with Gnome 40+; see https://github.com/NixOS/nixos-hardware/issues/260

    udev = {
      extraHwdb = ''
        evdev:name:*:dmi:bvn*:bvr*:bd*:svnASUS*:pn*:*
        KEYBOARD_KEY_ff31007c=f20
      ''; # fixes mic mute button
    };

    xserver.videoDrivers = [ "modesetting" ]; # TODO determine whether it needs to be specified and what value should be used
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

  # Specialisation for enabling the RTX 4070 GPU
  specialisation.nvidia.configuration = {
    hardware.nvidia = {
      package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
        version = "580.76.05";
        
        sha256_64bit = "sha256-IZvmNrYJMbAhsujB4O/4hzY8cx+KlAyqh7zAVNBdl/0=";
        sha256_aarch64 = lib.fakeHash;
        openSha256 = "sha256-xEPJ9nskN1kISnSbfBigVaO6Mw03wyHebqQOQmUg/eQ=";
        settingsSha256 = "sha256-ll7HD7dVPHKUyp5+zvLeNqAb6hCpxfwuSyi+SAXapoQ=";
        persistencedSha256 = "sha256-IZvmNrYJMbAhsujB4O/4hzY8cx+KlAyqh7zAVNBdl/0=";
      };

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

    services.xserver.videoDrivers = [ "nvidia" ]; # adds to the list of video drivers
  };
}
