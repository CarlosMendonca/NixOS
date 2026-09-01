{ lib, pkgs, ... }: {
  imports = [
    ./nvidia
    ./bluetooth.nix
    ./containers.nix
    ./desktop.nix
    ./external-monitor.nix
    ./development.nix
    ./laptop.nix
    ./remoting.nix
    ./retro-gaming.nix
    ./sound.nix
    ./virtualization.nix
  ];

  options.hardware.primaryDisplay.verticalResolution = lib.mkOption {
    type = lib.types.nullOr (lib.types.enum [ 1600 2160 ]);
    default = null;
    description = "Vertical resolution of the primary display for wallpaper selection";
  };

  config = {
    nix.settings.experimental-features = [ "nix-command" "flakes" ];
    nix.settings.trusted-users = [ "root" ];

    # Automatic garbage collection
    nix.gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };

    # Automatic store optimization (deduplication)
    nix.optimise = {
      automatic = true;
      dates = [ "weekly" ];
    };

    # Networking -- common to all configurations
    networking = {
      # useNetworkd = true; # conflicts with Network Manager
      networkmanager.enable = true;
    };

    environment.systemPackages = [
      pkgs.pciutils # lspci: inspect PCI devices (GPUs, NICs, controllers)
      pkgs.usbutils # lsusb: inspect connected USB devices

      pkgs.git # version control; expected by every dev tool and AI coding agent

      pkgs.unzip # extract .zip archives
      pkgs.zip # create .zip archives
      pkgs.killall # kill processes by name (from psmisc); common muscle-memory tool absent from the NixOS base

      # Common Unix tools that ship on most distros and macOS but are not in the NixOS base
      pkgs.file # identify a file's type by its contents rather than its extension
      pkgs.dnsutils # dig / nslookup / host: DNS lookups and debugging
      pkgs.lsof # list open files/sockets; find what holds a port or a mountpoint busy
      pkgs.rsync # incremental file copy/sync (also in environment.defaultPackages; pinned here explicitly)
      pkgs.traceroute # trace the network path to a host
      pkgs.tree # recursive directory listing rendered as a tree
      pkgs.vim # modal terminal editor; fuller alternative to the default nano
      pkgs.wget # file downloader; NixOS ships only curl, but scripts and READMEs routinely assume wget
      pkgs.whois # domain and IP registration lookups

      # Fast search tools that AI coding agents (Claude Code, Codex, Antigravity, opencode) shell out to
      pkgs.fd # fast, user-friendly find replacement
      pkgs.jq # command-line JSON processor; heavily used in shell glue and by AI agents
      pkgs.ripgrep # rg: fast recursive source search

      # Runtimes for MCP servers and agent-run project commands; uncomment if npx/uvx servers fail to start
      # pkgs.nodejs # node/npx: launches `npx -y @scope/mcp-server` style MCP servers
      # pkgs.uv # uvx: launches Python MCP servers; also a fast Python package manager
      # pkgs.python3 # general scripting; many agent test/build steps assume it is present
    ];
  };
}