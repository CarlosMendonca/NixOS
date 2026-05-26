{ config, lib, pkgs, ... }:
let
  kernelVersion = config.boot.kernelPackages.kernel.version;
in
{
  imports = [
  ];

  boot = lib.mkMerge [
    {
      blacklistedKernelModules = [
        "nouveau"
      ];

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
        "wl" # wireless network -- not sure if really needed for this host
      ];

      kernelPackages = pkgs.linuxPackages_6_18; # alternative to linuxPackages_latest

      kernelParams = [
      ];

      loader = {
        systemd-boot.enable = true;
        systemd-boot.configurationLimit = 5;
        efi.canTouchEfiVariables = true;
      };
    }
  ];

  hardware = {
    primaryDisplay.verticalResolution = 2160;

    cpu.intel.updateMicrocode = true;

    enableAllFirmware = true; # required for AX210, amdgpu, and potentially others

    graphics = {
      enable = true;
      enable32Bit = true;
    };

    # Enabling the RTX 2080 Ti GPU
    nvidia = {
      package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
        version = "590.44.01";
        
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
        # finegrained = true; # finegrained power management requires offload to be enabled, which is not necessary in this host
      };
    };
  };

  services = {
    fstrim.enable = true;

    tlp.enable = false; # avoid conflicts with Gnome 40+; see https://github.com/NixOS/nixos-hardware/issues/260

    xserver.videoDrivers = [ "nvidia" ];
  };

  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/SYSTEM"; # assume the Windows boot partition manually created with 512MB
    fsType = "vfat";
  };

  swapDevices = [
    { device = "/dev/disk/by-label/swap"; } # 64GB
  ];
}
