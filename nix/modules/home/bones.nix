{ config, lib, pkgs, ... }:

{
  home.stateVersion = "24.11";
  imports = [ ./i3setup.nix ];
  home.packages = [ pkgs.atool pkgs.httpie ];

}
