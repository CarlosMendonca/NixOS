{ pkgs, ... }: {
    home.file."startwm.sh" = {
        text = ''
          #!/usr/bin/env bash
          . /etc/gdm/Xsession ${pkgs.gnome.gnome-session}/bin/gnome-session
        '';
        executable = true;
    };
}
