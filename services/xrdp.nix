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
        || action.id == "org.freedesktop.color-manager.modify-profile")
        && subject.isInGroup("{users}")) {
          return polkit.Result.YES;
      }
    });
  '';
}
