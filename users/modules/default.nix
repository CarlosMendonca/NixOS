{ ... }: {
  imports = [
    ./desktop.nix
    ./development.nix
  ];

  programs = {
    git = {
      enable = true;
      extraConfig.init.defaultBranch = "main";
    };
  };

  home.packages = [ ];
}