{ config, lib, pkgs, ... }:

{
  home.stateVersion = "24.11";
  imports = [ ./sway.nix ./wezterm.nix ];
  home.packages = [ pkgs.atool pkgs.httpie pkgs.wezterm ];

}
