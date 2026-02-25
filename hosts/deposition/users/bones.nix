{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [ inputs.self.homeModules.bones ];
  home.packages = with pkgs; [ qutebrowser ];
  wayland.windowManager.sway = {
    enable = true;
    wrapperFeatures.gtk = true; # Fixes common issues with GTK 3 apps
    config =
      let
        mod = config.wayland.windowManager.sway.config.modifier;
      in
      {
        modifier = "Mod4";
        # Use kitty as default terminal
        terminal = "xterm";
        startup = [
          # Launch Firefox on start
          { command = "exec ${pkgs.qutebrowser}/bin/qutebrowser http://127.0.0.1/"; }
        ];
        keybindings = lib.mkOptionDefault {
          "${mod}+Return" = "exec ${pkgs.foot}/bin/foot";

          # Kill focused window
          "${mod}+q" = "kill";

          # Reload the configuration file
          "${mod}+Shift+c" = "reload";
          "${mod}+s" = "exec ${pkgs.super-slicer}/bin/superslicer";

          # Exit sway (logs you out of your Wayland session)
          "${mod}+Shift+e" =
            "exec swaynag -t warning -m 'You pressed the exit shortcut. Do you really want to exit sway? This will end your Wayland session.' -b 'Yes, exit sway' 'swaymsg exit'";

          # Make the current focus fullscreen
          "${mod}+f" = "fullscreen";
        };
        bars = [ ];
        window = {
          border = 0;
          titlebar = false;
          hideEdgeBorders = "none";
        };

      };
    # extraConfig = ''
    #   exec ${pkgs.qutebrowser}/bin/qutebrowser http://127.0.0.1/
    # '';
  };

}
