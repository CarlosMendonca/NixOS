{ pkgs, ... }: {
    fonts = {
        fonts = with pkgs; [
            iosevka
            ubuntu_font_family
            (nerdfonts.override { fonts = [ "Iosevka" "Ubuntu" ]; })
        ];
        
        fontconfig.defaultFonts = {
            monospace = [
                "Iosevka Nerd Font"
                "Iosevka"
            ];
            sansSerif = [ "Ubuntu" ];
        };

        fontDir.enable = true;
    };
}