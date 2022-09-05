{ pkgs, ... }: {
    home.file."startwm.sh" = {
        text = ''
            #!/usr/bin/env bash

            # Startup script for xrdp
            if [ -z "$HM_XPROFILE_SOURCED" ]; then
                . "/home/carlos/.xprofile"
            fi
            unset HM_XPROFILE_SOURCED

            systemctl --user start hm-graphical-session.target

            ${pkgs.i3-gaps}/bin/i3
        '';
        executable = true;
    };
}