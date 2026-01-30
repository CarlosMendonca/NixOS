{ config, lib, pkgs, ... }: {
  options.roles.retro-gaming = {
    enable = lib.mkEnableOption "Retro gaming role configuration";
  };

  config = lib.mkIf config.roles.retro-gaming.enable {
    # Retro gaming role requires desktop role
    roles.desktop.enable = lib.mkDefault true;

    environment.systemPackages = [
      (pkgs.retroarch.withCores (cores: with cores; [
        dosbox-pure
        scummvm
      ]))
    ];
  };
}