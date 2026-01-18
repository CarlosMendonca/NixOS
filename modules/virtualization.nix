{ config, lib, pkgs, ... }: {
  options.roles.virtualization = {
    enable = lib.mkEnableOption "Virtualization role configuration for QEMU/KVM virtualization";
  };

  config = lib.mkIf config.roles.virtualization.enable {
    # Virtualization role requires desktop role
    roles.desktop.enable = lib.mkDefault true;

    # Enable libvirt for virtualization
    virtualisation.libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu_kvm; # instead of pkgs.qemu_full, which would include other architectures which we don't need
        runAsRoot = false;
        swtpm.enable = true;
        vhostUserPackages = [ pkgs.virtiofsd ];
      };
    };

    # Enable spice USB redirection
    virtualisation.spiceUSBRedirection.enable = true;

    # Enable spice vdagent daemon for clipboard sharing and other features
    services.spice-vdagentd.enable = true;

    programs.virt-manager.enable = true;

    # Install Gnome Boxes
    environment.systemPackages = [
      # pkgs.gnome-boxes  # gnome-boxes wasn't stable at all
      # pkgs.virt-manager # virt-manager is not simply installed as a package
    ];
  };
}
