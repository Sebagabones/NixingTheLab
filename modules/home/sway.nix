{ config, pkgs, lib, ... }: {

  # enable Sway window manager

  wayland.windowManager.sway = {
    enable = true;
    wrapperFeatures.gtk = true; # Fixes common issues with GTK 3 apps
    config = rec {
      modifier = "Mod4";
      # Use kitty as default terminal
      terminal = "ghostty";
      defaultWorkspace = "workspace number 1";
      startup = [
        # Launch Firefox on start
        # { command = "firefox"; }
      ];
    };
  };
}
