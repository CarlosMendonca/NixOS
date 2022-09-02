{ pkgs, lib, ... }: {
    # .xinitrc is supposed to be set manually. Copying the .xsession configuration with modifications.
    home.file.".xinitrc".text = ''
        if [ -z "$HM_XPROFILE_SOURCED" ]; then
            . "/home/carlos/.xprofile"
        fi
        unset HM_XPROFILE_SOURCED

        systemctl --user start hm-graphical-session.target

        exec ${pkgs.i3-gaps}/bin/i3
    '';

    home.file."shutdown-xserver.sh".text = ''
        #!/usr/bin/env bash
        systemctl --user stop graphical-session-pre.target
        systemctl --user stop graphical-session.target
    '';

    xsession = {
        enable = true;

        windowManager.i3 = {
            enable = true;
            package = pkgs.i3-gaps;

            config =
            let
                modifier = "Mod4";
            in {
                bars = [ ]; # clear this to use polybar instead

                focus.followMouse = false;

                gaps = {
                    inner = 10;
                    outer = 15;

                    smartBorders = "on";
                };

                keybindings = lib.mkOptionDefault {
                    # "${modifier}+Return" = "exec ${pkgs.alacritty}/bin/allacrity";
                    "${modifier}+d" = "exec ${pkgs.rofi}/bin/rofi -show combi";
                };

                startup = [
                ];

                terminal = "alacritty";

                window = {
                    border = 1;
                    titlebar = false;
                };

                defaultWorkspace = "workspace number 1";
            };
        };
    };
}