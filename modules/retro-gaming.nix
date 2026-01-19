{ config, lib, pkgs, ... }: {
  options.roles.retro-gaming = {
    enable = lib.mkEnableOption "Retro gaming role configuration";
  };

  config = lib.mkIf config.roles.retro-gaming.enable {
    environment.systemPackages = [
      (pkgs.retroarch.withCores (cores: with cores; [
        dosbox-pure
        scummvm
      ]))
    ];
  };
}