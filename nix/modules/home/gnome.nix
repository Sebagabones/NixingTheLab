{ config, lib, pkgs, inputs, ... }: {
  imports = [ ./dconf.nix ];
  home.packages = with pkgs; [
    gnomeExtensions.blur-my-shell
    gnomeExtensions.space-bar
    gnomeExtensions.pop-shell
    gnomeExtensions.spotify-controls
    gnomeExtensions.weather-or-not
  ];

}
