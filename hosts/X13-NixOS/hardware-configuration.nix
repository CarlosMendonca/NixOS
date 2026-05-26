{ config, lib, pkgs, ... }:
let
  kernelVersion = config.boot.kernelPackages.kernel.version;

  nvidiaDriver580_142_kernel6_12 = import ../../modules/nvidia/580_142.nix pkgs.linuxPackages_6_12;
in
{
  imports = [
  ];

  boot = lib.mkMerge [
    {
      blacklistedKernelModules = [
        "k10temp" # AMD temperature sensor?
        "nouveau"
      ];

      extraModulePackages = [ config.boot.kernelPackages.zenpower ];

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
      ];

      kernelPackages = pkgs.linuxPackages_7_0;

      kernelParams = [
        "mem_sleep_default=deep"
        "pcie_aspm.policy=powersupersave"
        "amdgpu.sg_display=0"
        "amdgpu.dcdebugmask=0x10"
        "amdgpu.gpu_recovery=1"
      ];

      loader = {
        systemd-boot.enable             = true;
        systemd-boot.configurationLimit = 20;
        efi.canTouchEfiVariables        = true;
      };

      resumeDevice = "/dev/disk/by-label/swap";
    }

    # AMD P-State optimisations
    (lib.mkIf ((lib.versionAtLeast kernelVersion "5.17") && (lib.versionOlder kernelVersion "6.1")) {
      kernelParams  = [ "initcall_blacklist=acpi_cpufreq_init" ];
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
    primaryDisplay.verticalResolution = 1600;

    amdgpu.initrd.enable    = true;
    cpu.amd.updateMicrocode = true;
    enableAllFirmware       = true;

    graphics = {
      enable      = true;
      enable32Bit = true;
    };

    sensor.iio.enable = true;
  };

  services = {
    asusd = {
      enable            = true;
      enableUserService = true;
    };

    fstrim.enable = true;

    supergfxd.enable = true;

    tlp.enable = false;

    udev.extraHwdb = ''
      evdev:name:*:dmi:bvn*:bvr*:bd*:svnASUS*:pn*:*
      KEYBOARD_KEY_ff31007c=f20
    '';
  };

  fileSystems."/"     = { device = "/dev/disk/by-label/nixos";  fsType = "ext4"; };
  fileSystems."/boot" = { device = "/dev/disk/by-label/SYSTEM"; fsType = "vfat"; };

  swapDevices = [ { device = "/dev/disk/by-label/swap"; } ];

  specialisation.nvidia.configuration = {
    boot.kernelPackages = lib.mkForce pkgs.linuxPackages_6_12;
    roles.nvidia = {
      enable                      = true;
      package                     = nvidiaDriver580_142_kernel6_12;
      powerManagement.finegrained = true;
      prime = {
        offload = {
          enable           = true;
          enableOffloadCmd = true;
        };
        amdgpuBusId = "PCI:69:0:0";
        nvidiaBusId  = "PCI:1:0:0";
      };
    };
  };
}
