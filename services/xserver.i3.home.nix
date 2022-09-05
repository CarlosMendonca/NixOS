{ pkgs, lib, ... }:
let
    terminate-xserver-deps = pkgs.writeShellScriptBin "terminate-xserver-deps.sh" ''
        systemctl --user stop graphical-session-pre.target
        systemctl --user stop graphical-session.target
    '';
in {
    # .xinitrc is supposed to be set manually. Copying the .xsession configuration with modifications.
    home.file.".xinitrc" = {
        text = ''
            if [ -z "$HM_XPROFILE_SOURCED" ]; then
                . "/home/carlos/.xprofile"
            fi
            unset HM_XPROFILE_SOURCED

            systemctl --user start hm-graphical-session.target

            exec ${pkgs.i3-gaps}/bin/i3
        '';
        executable = true;
    };

    # Script to terminate xserver dependencies manually and gracefully
    home.packages = [ terminate-xserver-deps ];

    xsession = {
        enable = true;

        # This was a failed attempt to fix polybar's inability to find programs due to insufficient path when running as a service
        # profileExtra = ''
        #     systemctl --user import-environment PATH
        # '';

        windowManager.i3 = {
            enable = true;
            package = pkgs.i3-gaps;

            config =
            let
                modifierKey = "Mod4";
            in {
                bars = [ ]; # clear this to use polybar instead

                focus.followMouse = false;

                gaps = {
                    bottom = 40;
                    inner = 10;
                    outer = 10;

                    smartBorders = "on";
                };

                modifier = modifierKey;

                keybindings = lib.mkOptionDefault {
                    # "${modifierKey}+Return" = "exec ${pkgs.alacritty}/bin/allacrity";
                    "${modifierKey}+d" = "exec polybar-launcher.sh";
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