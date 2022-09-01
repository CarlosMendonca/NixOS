{ pkgs, lib, ... }: {

    # Make sure that the i3 socket is open before trying to start polybar. Documentation: https://github.com/Zabot/nixconfig/blob/master/home/desktop/polybar/default.nix
    systemd.user.services.polybar = {
        Unit.After = [ "i3-session.target" ];
        Install.WantedBy = lib.mkForce [ "i3-session.target" ];
    };

    services.polybar = {
        enable = true;
        package = pkgs.polybarFull;

        # Script to start polybar in all displays. Documentation: https://github.com/Zabot/nixconfig/blob/master/home/desktop/polybar/default.nix
        script = "polybar top &";

        settings = 
        let
            color = {
                background = "#1f1f1f";
                foreground = "#ffffff";
                foreground-alt = "#8f8f8f";
                module-fg = "#1f1f1f";
                primary = "#ffb300";
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
                # monitor = "default"; # hard-coded for now

                monitor-strict = false;
                override-redirect = false;
                bottom = true; 
                fixed-center = true;

                width = "80%";
                height = 40;

                offset-x = "10%";
                offset-y = "2%";

                background = color.background;
                foreground = color.foreground;

                radius-top = 0;
                radius-bottom = 0;

                line-size = 2;
                line-color = color.primary;

                border-size = 3;
                border-color = color.background;

                padding = 0;

                module-margin-left = 2;
                module-margin-right = 2;

                font-0 = "Iosevka Nerd Font:pixelsize=10;3";
                font-1 = "Iosevka Nerd Font:pixelsize=12;4";
            };

            "bar/top" = {
                "inherit" = "bar/base";
                bottom = true;
                offset-y = 140;
                modules-left = "cpu";
                modules-center = "memory";
                modules-right = "date";
                enable-ipc = true;
            };

            "module/cpu" = {
                type = "internal/cpu";
                interval = 1;
                format = "<label>";
                format-prefix = "";
                label = "%percentage%%";
            };

            "module/date" = {
                type = "internal/date";
                interval = 1;
                time = " %I:%M %p";
                time-alt = " %a, %d %b %Y";
                format = "<label>";
                label = "%time%";
            };

            "module/memory" = {
                type = "internal/memory";
                interval = 1;
                format = "<label>";
                format-prefix = "";
                label = " %mb_used%";
            };
        };
    };
}