{ config, lib, pkgs, ... }:
let
  nvidiaDriver590_44_01_kernel6_18 = import ../../modules/nvidia/590_44_01.nix pkgs.linuxPackages_6_18;
  nvidiaDriver595_99_02_kernel7_2 = import ../../modules/nvidia/595_99_02.nix pkgs.linuxPackages_7_2;
in
{
  imports = [
  ];

  boot = lib.mkMerge [
    {
      blacklistedKernelModules = [ "nouveau" ];

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
      ];

      kernelPackages = pkgs.linuxPackages_7_2;

      kernelParams = [ ];

      loader = {
        systemd-boot.enable          = true;
        systemd-boot.configurationLimit = 5;
        efi.canTouchEfiVariables     = true;
      };
    }
  ];

  hardware = {
    primaryDisplay.verticalResolution = 2160;

    cpu.intel.updateMicrocode = true;
    enableAllFirmware         = true;

    graphics = {
      enable    = true;
      enable32Bit = true;
    };
  };

  roles.nvidia = {
    enable  = true;
    package = nvidiaDriver595_99_02_kernel7_2;
  };

  services = {
    fstrim.enable = true;
    tlp.enable    = false;
  };

  fileSystems."/"     = { device = "/dev/disk/by-label/nixos";  fsType = "ext4"; };
  fileSystems."/boot" = { device = "/dev/disk/by-label/SYSTEM"; fsType = "vfat"; };

  swapDevices = [ { device = "/dev/disk/by-label/swap"; } ];

  #specialisation.experimental.configuration = {
  #  boot.kernelPackages  = lib.mkForce pkgs.linuxPackages_7_0;
  #  roles.nvidia.package = lib.mkForce (import ../../modules/nvidia/590_44_01.nix pkgs.linuxPackages_7_0);
  #};
}
