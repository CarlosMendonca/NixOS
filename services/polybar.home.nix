{ pkgs, lib, ... }:
let
    polybar-launcher = pkgs.writeShellScriptBin "polybar-launcher.sh" ''
        ${pkgs.rofi}/bin/rofi -no-config -no-lazy-grab -show drun -modi drun
    '';
in {

    # Start polybar with xserver, as determined by home-manager's hm-graphical-session.target sync point
    systemd.user.services.polybar = {
         # The following two are necessary because of https://github.com/nix-community/home-manager/issues/1616#issuecomment-1236428053
        Service.Environment = lib.mkForce "";
        Service.PassEnvironment = "PATH";
        
        Unit.After = [ "hm-graphical-session.target" ];
        Install.WantedBy = lib.mkForce [ "hm-graphical-session.target" ];
    };

    home.packages = [ polybar-launcher ];

    services.polybar = {
        enable = true;
        package = pkgs.polybarFull;

        # Script to start polybar in all displays. Documentation: https://github.com/Zabot/nixconfig/blob/master/home/desktop/polybar/default.nix
        script = "polybar bottom &";

        settings = 
        let
            color = {
                background = "#ffffff";
                foreground = "#2e2e2e";
                foreground-alt = "#656565";
                module-fg = "#ffffff";
                primary = "#3949ab";
                secondary = "#e53935";
                alternate = "#7cb342";
            };
        in {
            # Inspired by 'material' polybar theme. Documentation: https://github.com/adi1090x/polybar-themes/blob/master/simple/material

            "global/wm" = {
                margin-bottom = 0;
                margin-top = 0;
            };

            "settings" = {
                # throttle-output = 5;
                # throttle-output-for = 10;
                # These have been deprecated: https://github.com/polybar/polybar/blob/d817080ee8e7934e52424af21e25105cb3ec33ea/CHANGELOG.md#deprecated-1

                screenchange-reload = true;

                compositing-background = "source";
                compositing-foreground = "over";
                compositing-overline = "over";
                compositing-underline = "over";
                compositing-border = "over";

                pseudo-transparency = false;
            };

            "bar" = {
                fill = "";
                empty = "";
                indicator = "⏽";
            };

            "bar/base" = {
                # monitor = "default"; # undefined is better, as it picks up from the DISPLAY env var (can be :0 on local xserver session or :10 through xrdp)

                monitor-strict = false; # XRandR may report monitor being disconnected when in fact it is not; setting this to false allows polybar to show up on disconnected displays
                override-redirect = true;
                bottom = true; 
                fixed-center = true;

                width = "100%:-20";
                height = 30;

                offset-x = 10;
                offset-y = 10;

                background = color.background;
                foreground = color.foreground;

                # For rounded corners; currently not compatible with border-size
                radius-top = 0;
                radius-bottom = 0;

                line-size = 2;
                line-color = color.primary;

                border-size = 0;
                border-color = color.background;

                padding = 0;

                module-margin-left = 1;
                module-margin-right = 1;

                font-0 = "Ubuntu Nerd Font:pixelsize=10;4";
                font-1 = "Ubuntu Nerd Font:pixelsize=13;5";
            };

            "bar/bottom" = {
                "inherit" = "bar/base";
                bottom = true;
                modules-left = "launcher workspaces cpu memory";
                modules-center = "";
                modules-right = "date powermenu";
                enable-ipc = true;
            };

            "module/cpu" = {
                type = "internal/cpu";
                interval = 1;
                format = "<label>";
                format-prefix = "";
                format-prefix-font = 2;
                format-padding = 2;
                label = "\" %percentage%%\"";
            };

            "module/date" = {
                type = "internal/date";
                interval = 1;
                time = "\" %I:%M %p\"";
                time-alt = "\" %a, %d %b %Y\"";
                format = "<label>";
                format-prefix = "";
                format-prefix-font = 2;
                format-padding = 2;
                label = "%time%";
            };

            "module/filesytem" = {
                type = "internal/fs";
                mount-0 = "/";
                interval = 30;
                fixed-values = true;
                format-mounted = "<label-mounted>";
                format-mounted-prefix = "";
                format-mounted-prefix-font = 2;
                format-mounted-padding = 2;
                label = "\" %percentage%%\"";
            };

            "module/launcher" = {
                    type = "custom/text";
                    content = "";
                    content-padding = 2;
                    click-left = "polybar-launcher.sh &";
            };

            "module/memory" = {
                type = "internal/memory";
                interval = 1;
                format = "<label>";
                format-prefix = "";
                format-prefix-font = 2;
                format-padding = 2;
                label = "\" %mb_used%\"";
            };

            "module/powermenu" = {
                type = "custom/menu";
                expand-right = true;

                menu-0-0 = "\" Reboot \"";
                menu-0-0-background = color.background;
                menu-0-0-foreground = color.foreground;
                menu-0-0-exec = "systemctl reboot";

                menu-0-1 = "\" Shutdown  \"";
                menu-0-1-background = color.background;
                menu-0-1-foreground = color.foreground;
                menu-0-1-exec = "systemctl poweroff";
                
                format = "<label-toggle><menu>";
                format-background = color.background;
                format-foreground = color.foreground;

                label-open = "";
                label-open-background = color.background;
                label-open-padding = 2;
                label-open-font = 1;

                label-close = "";
                label-close-background = color.background;
                label-close-padding = 2;
                label-close-font = 2;

                label-separator = "\" | \"";
                label-separator-background = color.background;
            };
        };
    };
}
