# Defines sound configuration
# Doc: https://nixos.wiki/wiki/ALSA
#      https://nixos.wiki/wiki/PulseAudio
#      https://nixos.wiki/wiki/PipeWire

{
  sound.enable = true; # saves sound state in alsamixer
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
};
}