{ pkgs, ... }: {
    home.file."startwm.sh" = {
        text = ''
            #!/usr/bin/env bash

            userresources=$HOME/.Xresources
            usermodmap=$HOME/.Xmodmap
            sysresources=${pkgs.xorg.xinit}/etc/X11/xinit/.Xresources
            sysmodmap=${pkgs.xorg.xinit}/etc/X11/xinit/.Xmodmap

            if [ -f $sysresources ]; then
                xrdb -merge $sysresources
            fi

            if [ -f $sysmodmap ]; then
                xmodmap $sysmodmap
            fi

            if [ -f "$userresources" ]; then
                xrdb -merge "$userresources"
            fi

            if [ -f "$usermodmap" ]; then
                xmodmap "$usermodmap"
            fi

            export XDG_SESSION_TYPE=x11
            export GDK_BACKEND=x11

            if [ -z "$HM_XPROFILE_SOURCED" ]; then
                . "$HOME/.xprofile"
            fi
            unset HM_XPROFILE_SOURCED

            systemctl --user start hm-graphical-session.target

            ${pkgs.gnome.gnome-session}/bin/gnome-session --session=gnome-classic
        '';
        executable = true;
    };
}