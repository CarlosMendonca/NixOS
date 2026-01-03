{ ... }: {
  imports = [
    ./desktop.nix
    ./development.nix
  ];

  programs = {
    bash = {
      enable = true;
      historySize = -1;
      historyFileSize = -1;
      historyControl = [ "ignoredups" "ignorespace" ];
      historyIgnore = [ "ls" "exit" ];
    };

    git = {
      enable = true;
      settings.init.defaultBranch = "main";
    };
  };

  home.packages = [ ];
}