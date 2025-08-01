{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ./theming.nix
  ];
  environment.systemPackages = with pkgs; [ lightdm ];
  # programs.niri = {
  #   enable = true;
  # };
  stylix = {
    cursor = {
      package = pkgs.banana-cursor;
      name = "Banana";
      size = 32;
    };
  };
}
