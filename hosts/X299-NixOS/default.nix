{
  # Flake level parameters for this host
  system = "x86_64-linux";
  module = ./configuration.nix;
  allowUnfree = true; # allow unfree packages for this host
}