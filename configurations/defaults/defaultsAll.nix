{ config, lib, pkgs, ... }:

{
    # Packages
  config = {
      environment.systemPackages = with pkgs; [
    curl
    wget
    git
    lm_sensors
    dhcpcd
    fishPlugins.done
    fishPlugins.fzf-fish
    fishPlugins.forgit
    fishPlugins.hydro
    fzf
    fishPlugins.grc
    grc
    gcc
    btop
    screen
    bat
    zellij
    bat-extras
    sapling
    rg
    fd
    delta
      ];

  programs.fish.enable = true;
  programs.fish.useBabelfish = true;

  # System
  nixpkgs.hostPlatform = "x86_64-linux";
  system.stateVersion = "24.11";

  # Nix Settings
  nix.settings = {
    download-buffer-size = 671088640;
  };
  };
}
