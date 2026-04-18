{ config, lib, pkgs, ... }: {
  options.roles.development = {
    enable = lib.mkEnableOption "Development role configuration";
    androidStudio.enable = lib.mkEnableOption "Android Studio support";
  };

  config = lib.mkMerge [
    (lib.mkIf config.roles.development.enable {
      # Development role requires desktop role
      roles.desktop.enable = lib.mkDefault true;

      programs.nix-ld.enable = true;
    })
    (lib.mkIf (config.roles.development.enable && config.roles.development.androidStudio.enable) {
      environment.systemPackages = [ pkgs.android-studio-full ];
      programs.adb.enable = true;
      nixpkgs.config.android_sdk.accept_license = true;
    })
  ];
}