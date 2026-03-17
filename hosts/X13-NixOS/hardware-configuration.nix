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
        # "wl" # Broadcom wireless network -- not needed for this config
      ];

      # Check available kernel versions with: nix repl, :l <nixpkgs>, pkgs.linuxPackages_ <TAB>
      kernelPackages = pkgs.linuxPackages_6_18; # alternative to linuxPackages_latest; TODO consider trying Zen kernel and its variations

      kernelParams = [
        "mem_sleep_default=deep"
        "pcie_aspm.policy=powersupersave"
        "amdgpu.sg_display=0" # can help solve flickering/glitching display issues since Scatter/Gather code was reenabled
        # "amdgpu.dcdebugmask=0x10" # same as above; disabling PANEL SELF REFRESH
        "amdgpu.dcdebugmask=0x400" # trying out a disabling PANEL REPLAY, but not PANEL SELF REFRESH; see https://community.frame.work/t/screen-flickering-on-linux-kernel-6-12/62632/39
        "amdgpu.gpu_recovery=1" # attempting to recover the GPU when it times out; see https://github.com/ROCm/amdgpu/blob/roc-2.0.0/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c#L493
      ];

      loader = {
        systemd-boot.enable = true;
        systemd-boot.configurationLimit = 25;
        efi.canTouchEfiVariables = true;
      };
      
      resumeDevice = "/dev/disk/by-label/swap";
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
    primaryDisplay.verticalResolution = 1600;

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
        version = "590.44.01"; # beta driver for 6.18 kernel for now; from https://www.nvidia.com/en-us/drivers/unix
        
        sha256_64bit = "sha256-VbkVaKwElaazojfxkHnz/nN/5olk13ezkw/EQjhKPms=";
        sha256_aarch64 = lib.fakeHash;
        openSha256 = "sha256-ft8FEnBotC9Bl+o4vQA1rWFuRe7gviD/j1B8t0MRL/o=";
        settingsSha256 = "sha256-wVf1hku1l5OACiBeIePUMeZTWDQ4ueNvIk6BsW/RmF4=";
        persistencedSha256 = "sha256-nHzD32EN77PG75hH9W8ArjKNY/7KY6kPKSAhxAWcuS4=";
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
