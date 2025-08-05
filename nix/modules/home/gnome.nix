{ config, lib, pkgs, inputs, ... }: {

  home.packages = with pkgs; [
    gnomeExtensions.blur-my-shell
    gnomeExtensions.space-bar

    # gnomeExtensions.just-perfection
    # gnomeExtensions.arc-menu
  ];

}
