{ pkgs, ... }: {
    fonts = {
        fonts = with pkgs; [
            roboto
            (nerdfonts.override { fonts = [ "Iosevka" "Ubuntu" ]; })
        ];
        
        fontconfig.defaultFonts = {
            monospace = [ "Iosevka Nerd Font" ];
            sansSerif = [ "Ubuntu Nerd Font" ];
        };
    };
}