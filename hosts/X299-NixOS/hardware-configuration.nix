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
        # "wl" # wireless network -- not really needed for this host
      ];

      kernelPackages = pkgs.linuxPackages_6_16; # alternative to linuxPackages_latest

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
  };

  services = {
    fstrim.enable = true;

    tlp.enable = false; # avoid conflicts with Gnome 40+; see https://github.com/NixOS/nixos-hardware/issues/260

    xserver.videoDrivers = [ "modesetting" ]; # TODO determine whether it needs to be specified and what value should be used
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

  # Specialisation for enabling the RTX 2080 Ti GPU
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
    };

    services.xserver.videoDrivers = [ "nvidia" ]; # adds to the list of video drivers
  };
}
