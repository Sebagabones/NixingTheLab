{ config, lib, pkgs, flake, ... }:

{
  home.stateVersion = "24.11";
  programs.home-manager.enable = true;
  imports = [ flake.homeModules.niri ./wezterm.nix ./themeing.nix ];
  home.packages = [ pkgs.atool pkgs.httpie pkgs.wezterm ];

}
