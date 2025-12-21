{ ... }: {
  imports = [
    ./desktop.nix
    ./development.nix
  ];

  programs = {
    git = {
      enable = true;
      settings.init.defaultBranch = "main";
    };
  };

  home.packages = [ ];
}