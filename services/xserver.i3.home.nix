{ pkgs, lib, ... }: {

    # Adding a systemd target which is marked as started when i3 starts, so we can determine when i3 is running. Source: https://github.com/Zabot/nixconfig/blob/master/home/desktop/i3/target.nix
    systemd.user.targets.i3-session = {
        Unit = {
            Description = "i3 X session";
            BindsTo = [ "hm-graphical-session.target" ];
            Requisite = [ "hm-graphical-session.target" ];
        };
    };

    # .xinitrc is supposed to be set manually. Copying the .xsession configuration with modifications.
    home.file.".xinitrc".text = ''
        if [ -z "$HM_XPROFILE_SOURCED" ]; then
            . "/home/carlos/.xprofile"
        fi
        unset HM_XPROFILE_SOURCED

        systemctl --user start hm-graphical-session.target

        exec ${pkgs.i3}/bin/i3

        systemctl --user stop graphical-session.target
        systemctl --user stop graphical-session-pre.target

        # Wait until the units actually stop.
        while [ -n "$(systemctl --user --no-legend --state=deactivating list-units)" ]; do
            sleep 0.5
        done
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
                    {
                        command = "${pkgs.systemd}/bin/systemctl --user start i3-session.target";
                        notification = false;
                    }
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