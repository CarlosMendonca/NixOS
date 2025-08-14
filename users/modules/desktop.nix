{ pkgs, ... }: {
  imports = [
    ./. # default.nix
  ];
  programs = {
    # chromium.enable = true; # using Google Chrome instead
    firefox.enable = true;
    vscode.enable = true;
  };

  home.packages = [
    # Fonts
    pkgs.nerd-fonts.iosevka
    pkgs.nerd-fonts.iosevka-term
    
    pkgs.google-chrome
    pkgs.spotify-player
  ];
}