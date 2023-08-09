# Defines sound configuration
# Doc: https://nixos.wiki/wiki/ALSA
#      https://nixos.wiki/wiki/PulseAudio
#      https://nixos.wiki/wiki/PipeWire

{
  hardware.pulseaudio.enable = false;
  sound.enable = false; # conflicts with PipeWire
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;

    # jack.enable = true # for JACK applications

  }; 
}