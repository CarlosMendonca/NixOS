{ }: {
  imports = [
    ./. # default.nix
  ];
  programs = {
    # chromium.enable = true; # using Chrome instead
    firefox.enable = true;
    vscode.enable = true;
  };

  home.packages = [
    # Fonts
    pkgs.nerd-fonts.iosevka
    pkgs.nerd-fonts.iosevka-term
  ];

  home.xsession.enable = true;
}