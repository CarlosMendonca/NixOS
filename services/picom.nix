{ ... }: {
  services.picom = {
    enable = true;
    shadow = true;
    # shadowOffsets = [ -40 -40 ];
    shadowOpacity = 0.35;

    settings = {
      shadow-radius = 40;
      shadow-offset-x = -40;
      shadow-offset-y = -40;
    };
  };
}
