{
  config,
  pkgs,
  ...
}:

{
  config = {

    xdg.configFile."miracle-wm.config".text = ''
      translucent=on
      touchpad-vertical-scroll-speed-override=-1.0
      touchpad-horizontal-scroll-speed-override=-1.0
    '';

    xdg.configFile."miracle-wm.yaml".source = (pkgs.formats.yaml { }).generate "miracle-wm.yaml" {
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

      default_action_overrides = [
        {
          name = "quit_active_window";
          action = "down";
          modifiers = [ "primary" ];
          key = "KEY_Q";
        }
      ];

    };
    programs = {
      waybar = {
        enable = true;
        settings = {
          mainBar = {
            layer = "top";
            # position = "left";
            modules-left = [
              "sway/workspaces"
              "sway/mode"
            ];
            modules-center = [ ];
            modules-right = [
              # "mpd"
              # "idle_inhibitor"
              "pulseaudio"
              "network"
              "cpu"
              "memory"
              "temperature"
              "backlight"
              "battery"
              "battery#bat2"
              "clock"
            ];

            "sway/mode" = {
              format = ''<span style="italic">{}</span>'';
            };

            pulseaudio = {
              format = "{volume}% {icon} {format_source}";
              format-bluetooth = "{volume}% {icon} {format_source}";
              format-bluetooth-muted = " {icon} {format_source}";
              format-muted = " {format_source}";
              format-source = "{volume}% ";
              format-source-muted = "";
              format-icons = {
                headphone = "";
                phone = "";
                portable = "";
                car = "";
                default = [
                  ""
                  ""
                  ""
                ];
              };
              on-click = "pavucontrol";
              # scroll-step = 1;
            };
            network = {
              format-wifi = "{essid} ({signalStrength}%) ";
              format-disconnected = "󰖪";
              format-ethernet = "󰈀";
              tooltip = true;
              tooltip-format = "{signalStrength}%";
            };

            cpu = {
              format = "{usage}% ";
              tooltip = false;
            };

            memory = {
              format = "{}% ";
            };

            temperature = {
              critical-threshold = 80;
              format = "{temperatureC}°C {icon}";
              format-icons = [
                ""
                ""
                ""
              ];
              # thermal-zone = 2;
              # hwmon-path = "/sys/class/hwmon/hwmon2/temp1_input";
            };

            backlight = {
              format = "{percent}% {icon}";
              format-icons = [
                ""
                ""
                ""
                ""
                ""
                ""
                ""
                ""
                ""
              ];
              # device = "acpi_video1";
            };

            battery = {
              states = {
                warning = 45;
                critical = 20;
                # good = 95;
              };
              format = "{capacity}% {icon}";
              format-full = "{capacity}% {icon}";
              format-charging = "{capacity}% 󱊦";
              format-plugged = "{capacity}% ";
              format-alt = "{time} {icon}";
              format-icons = [
                ""
                ""
                ""
                ""
                ""
              ];
              # format-good = "";
              # format-full = "";
            };

            "battery#bat2" = {
              bat = "BAT2";
            };

            clock = {
              tooltip-format = ''
                <big>{:%Y %B}</big>
                <tt><small>{calendar}</small></tt>'';
              format-alt = "{:%Y-%m-%d}";
              # timezone = "America/New_York";
            };

          };
        };
      };
      wofi = {
        enable = true;
      };
    };
  };
}
