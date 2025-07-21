{ config, lib, pkgs, inputs, ... }:

{
  config = {

    xdg.configFile."miracle-wm.config".text = ''
      translucent=on
      touchpad-vertical-scroll-speed-override=-1
    '';

    xdg.configFile."miracle-wm.yaml".source =
      (pkgs.formats.yaml { }).generate "miracle-wm.yaml" {
        action_key = "meta";

        custom_actions = [
          {
            command = "fuzzel";
            action = "down";
            modifiers = [ "primary" ];
            key = "KEY_D";
          }
          {
            command = "firefox";
            action = "down";
            modifiers = [ "primary" ];
            key = "KEY_W";
          }
          {
            command = "discord";
            action = "down";
            modifiers = [ "primary" ];
            key = "KEY_B";
          }
        ];

        startup_apps = [
          {
            command = "waybar";
            restart_on_death = true;
          }
          {
            command = "swaybg -i  ${../../assests/background.png}";
            restart_on_death = true;
            in_systemd_scope = true;
          }
        ];
        border = {
          size = 2;
          color = {
            r = "${config.lib.stylix.colors.base03-rgb-r}";
            g = "${config.lib.stylix.colors.base03-rgb-g}";
            b = "${config.lib.stylix.colors.base03-rgb-b}";
            a = "255";
          };
          focus_color = {
            r = "${config.lib.stylix.colors.base0D-rgb-r}";
            g = "${config.lib.stylix.colors.base0D-rgb-g}";
            b = "${config.lib.stylix.colors.base0D-rgb-b}";
            a = "255";
          };
        };
        enable_animations = true;

        animations = [
          {
            event = "window_open";
            type = "grow";
            function = "ease_out_back";
            duration = 0.5;
          }
          {
            event = "window_move";
            type = "slide";
            function = "ease_in_out_back";
            duration = 0.25;
          }
          {
            event = "window_close";
            type = "shrink";
            function = "ease_out_back";
            duration = 0.25;
          }
          {
            event = "workspace_switch";
            type = "slide";
            function = "ease_in_out_circ";
            duration = 0.175;
          }
        ];

        terminal = "ghostty";

        default_action_overrides = [{
          name = "quit_active_window";
          action = "down";
          modifiers = [ "primary" ];
          key = "KEY_Q";
        }];

      };
  };
}
