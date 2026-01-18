{ config, lib, ... }: {
  options.roles.development = {
    enable = lib.mkEnableOption "Development role configuration";
  };

  config = lib.mkIf config.roles.development.enable {
    # Development role requires desktop role
    roles.desktop.enable = lib.mkDefault true;

    programs.nix-ld.enable = true;
  };
}