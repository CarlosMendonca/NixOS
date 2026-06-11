{ systemConfig, lib, pkgs, pkgs-unstable, pkgs-llm-agents, ... }: {
  config = lib.mkIf systemConfig.roles.development.enable {
    home.packages = [
      pkgs-unstable.devenv
      pkgs.github-desktop
      pkgs.gh
      pkgs.lazygit
      # pkgs.starship # TODO enable with "programs.starship.enable = true" instead
      pkgs.tree

      pkgs-llm-agents.antigravity-cli
      pkgs-llm-agents.claude-code

      pkgs-unstable.antigravity
      # pkgs-unstable.code-cursor
    ];
  };
}