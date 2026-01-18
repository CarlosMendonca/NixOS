{ config, lib, pkgs, ... }: {
  options.roles.sound = {
    enable = lib.mkEnableOption "Sound role configuration";
  };

  config = lib.mkIf config.roles.sound.enable {
    # Sound -- see https://nixos.wiki/wiki/ALSA, https://nixos.wiki/wiki/PulseAudio, https://nixos.wiki/wiki/PipeWire
    hardware.pulseaudio.enable = false;
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;

      # jack.enable = true; # for JACK applications
    };
  };
}
