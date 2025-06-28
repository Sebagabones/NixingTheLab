{ inputs, config, lib, pkgs, flake, ... }:

{
  home.stateVersion = "24.11";
  programs.home-manager.enable = true;

  imports = [
    flake.homeModules.niri
    ./wezterm.nix
    # ./themeing.nix
    # flake.nixos.themeing
  ];
  home.packages = [ pkgs.atool pkgs.httpie ];

}
