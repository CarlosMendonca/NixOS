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
    cpu.intel.updateMicrocode = true;

    enableAllFirmware = true; # required for AX210, amdgpu, and potentially others

    graphics = {
      enable = true;
      enable32Bit = true;
    };

    # Enabling the RTX 2080 Ti GPU
    nvidia = {
      package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
        version = "570.195.03";
        
        sha256_64bit = "sha256-1H3oHZpRNJamCtyc+nL+nhYsZfJyL7lgxPUxvXrF3B4=";
        sha256_aarch64 = lib.fakeHash;
        openSha256 = "sha256-vCBB/UJgVKHlSEWdgoF45lODr3YJmR6JwjrwWgWszBw=";
        settingsSha256 = "sha256-mjKkMEPV6W69PO8jKAKxAS861B82CtCpwVTeNr5CqUY=";
        persistencedSha256 = "sha256-1H3oHZpRNJamCtyc+nL+nhYsZfJyL7lgxPUxvXrF3B4=";
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
