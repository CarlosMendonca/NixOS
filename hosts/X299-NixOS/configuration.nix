{  }: {
    imports = [
      ../../users/carlos.nix

      ../../modules/development.nix
      ../../users/modules/development.nix # TODO determine whether the above should already import this internally

      ../../modules/remoting.nix
    ];

    networking.hostName = "X299-NixOS";
    time.timeZone = "America/New_York";

    environment.systemPackages = [ ];

    system.stateVersion = "25.05"; # Nix database version; do NOT change; this is not where you update the system
}
