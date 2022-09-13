{ config, pkgs, ... }: {
  services.xrdp = {
    enable = true;
    openFirewall = true;
  };

  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
       if ((action.id == "org.freedesktop.color-manager.create-device"
        || action.id == "org.freedesktop.color-manager.create-profile"
        || action.id == "org.freedesktop.color-manager.delete-device"
        || action.id == "org.freedesktop.color-manager.delete-profile"
        || action.id == "org.freedesktop.color-manager.modify-device"
        || action.id == "org.freedesktop.color-manager.modify-profile"
        || action.id == "org.freedesktop.login1.hibernate"
        || action.id == "org.freedesktop.login1.power-off"
        || action.id == "org.freedesktop.login1.reboot"
        || action.id == "org.freedesktop.login1.suspend")
        && subject.isInGroup("users")) {
          return polkit.Result.YES;
      }
    });
  '';
}
