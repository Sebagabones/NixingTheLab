{ config, lib, pkgs, inputs, ... }: {
  imports = [ ./dconf.nix ];
  home.packages = with pkgs; [
    gnomeExtensions.blur-my-shell
    gnomeExtensions.space-bar
    gnomeExtensions.pop-shell
    gnomeExtensions.spotify-controls
    gnomeExtensions.weather-or-not
    # gnomeExtensions.notification-configurator ADD AFTER TEST OR LAUREN WILL MURDER YOU
  ];

}
