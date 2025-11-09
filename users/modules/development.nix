{ systemConfig, lib, pkgs, pkgs-unstable, ... }: {
  config = lib.mkIf systemConfig.roles.development.enable {
    home.packages = [
      pkgs.devenv
      pkgs.github-desktop
      pkgs.lazygit
      # pkgs.starship # TODO enable with "programs.starship.enable = true" instead
      pkgs.tree

      pkgs-unstable.code-cursor
      pkgs-unstable.claude-code
    ];
  };
}