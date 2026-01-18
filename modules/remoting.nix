{ config, lib, pkgs, ... }: {
  options.roles.remoting = {
    enable = lib.mkEnableOption "Remote access role configuration";
  };

  config = lib.mkIf config.roles.remoting.enable {
    services.openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
        PermitRootLogin = "no";
      };
      openFirewall = true;
    };
  };
}
