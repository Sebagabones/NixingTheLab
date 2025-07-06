{ config, lib, pkgs, inputs, ... }:

let
  terminal = lib.getExe config.programs.ghostty.package;
  bemenu = lib.getExe config.programs.bemenu.package;
  firefox = lib.getExe config.programs.firefox.package;
in {
  imports = [ inputs.niri.homeModules.niri ];

  programs.niri = {
    enable = true;
    # use the nixpkgs version because it's more up to date, and it's cached
    package = pkgs.niri;
    settings = {
      binds = let
        spawn = args: { spawn = lib.getExe (pkgs.writeShellApplication args); };
      in {
        # Terminal and basic window management
        "Mod+Return".action.spawn = [ terminal ];
        "Mod+Q".action.close-window = { };
        "Mod+W".action.spawn = [ firefox ];

        # System actions
        "Mod+Shift+Slash".action.show-hotkey-overlay = { };
        "Mod+O" = {
          repeat = false;
          action.toggle-overview = { };
        };
        "Mod+Escape" = {
          allow-inhibiting = false;
          action.toggle-keyboard-shortcuts-inhibit = { };
        };
        "Mod+Shift+E".action.quit = { };

        # Focus movement
        "Mod+H".action.focus-column-left = { };
        "Mod+J".action.focus-window-down = { };
        "Mod+K".action.focus-window-up = { };
        "Mod+L".action.focus-column-right = { };
        "Mod+Left".action.focus-column-left = { };
        "Mod+Down".action.focus-window-down = { };
        "Mod+Up".action.focus-window-up = { };
        "Mod+Right".action.focus-column-right = { };
        "Mod+Home".action.focus-column-first = { };
        "Mod+End".action.focus-column-last = { };
        "Mod+I".action.focus-workspace-up = { };
        "Mod+U".action.focus-workspace-down = { };

        # Monitor focus
        "Mod+Shift+H".action.focus-monitor-left = { };
        "Mod+Shift+J".action.focus-monitor-down = { };
        "Mod+Shift+K".action.focus-monitor-up = { };
        "Mod+Shift+L".action.focus-monitor-right = { };
        "Mod+Shift+Left".action.focus-monitor-left = { };
        "Mod+Shift+Down".action.focus-monitor-down = { };
        "Mod+Shift+Up".action.focus-monitor-up = { };
        "Mod+Shift+Right".action.focus-monitor-right = { };

        # Move windows (using Ctrl variants to avoid conflict)
        "Mod+Ctrl+H".action.move-column-left = { };
        "Mod+Ctrl+J".action.move-window-down = { };
        "Mod+Ctrl+K".action.move-window-up = { };
        "Mod+Ctrl+L".action.move-column-right = { };
        "Mod+Ctrl+Left".action.move-column-left = { };
        "Mod+Ctrl+Down".action.move-window-down = { };
        "Mod+Ctrl+Up".action.move-window-up = { };
        "Mod+Ctrl+Right".action.move-column-right = { };
        "Mod+Ctrl+Home".action.move-column-to-first = { };
        "Mod+Ctrl+End".action.move-column-to-last = { };
        "Mod+Ctrl+I".action.move-column-to-workspace-up = { };
        "Mod+Ctrl+U".action.move-column-to-workspace-down = { };
        "Mod+Ctrl+R".action.reset-window-height = { };
        "Mod+Ctrl+F".action.expand-column-to-available-width = { };
        "Mod+Ctrl+C".action.center-visible-columns = { };

        # Window management
        "Mod+F".action.maximize-column = { };
        "Mod+Shift+F".action.fullscreen-window = { };
        "Mod+V".action.toggle-window-floating = { };
        "Mod+Shift+V".action.switch-focus-between-floating-and-tiling = { };
        "Mod+Comma".action.consume-window-into-column = { };
        "Mod+Period".action.expel-window-from-column = { };
        "Mod+BracketLeft".action.consume-or-expel-window-left = { };
        "Mod+BracketRight".action.consume-or-expel-window-right = { };
        "Mod+C".action.center-column = { };

        # "Mod+W".action.toggle-column-tabbed-display = { }; Need to rebind this to something else

        # Window sizing
        "Mod+R".action.switch-preset-column-width = { };
        "Mod+Shift+R".action.switch-preset-window-height = { };
        "Mod+Minus".action.set-column-width = "-10%";
        "Mod+Equal".action.set-column-width = "+10%";
        "Mod+Shift+Minus".action.set-window-height = "-10%";
        "Mod+Shift+Equal".action.set-window-height = "+10%";

        # Workspaces
        "Mod+1".action.focus-workspace = 1;
        "Mod+2".action.focus-workspace = 2;
        "Mod+3".action.focus-workspace = 3;
        "Mod+4".action.focus-workspace = 4;
        "Mod+5".action.focus-workspace = 5;
        "Mod+6".action.focus-workspace = 6;
        "Mod+7".action.focus-workspace = 7;
        "Mod+8".action.focus-workspace = 8;
        "Mod+9".action.focus-workspace = 9;
        "Mod+Page_Up".action.focus-workspace-up = { };
        "Mod+Page_Down".action.focus-workspace-down = { };

        "Mod+WheelScrollDown" = {
          cooldown-ms = 150;
          action.focus-workspace-down = { };
        };
        "Mod+WheelScrollUp" = {
          cooldown-ms = 150;
          action.focus-workspace-up = { };
        };
        "Mod+Ctrl+WheelScrollDown" = {
          cooldown-ms = 150;
          action.move-column-to-workspace-down = { };
        };
        "Mod+Ctrl+WheelScrollUp" = {
          cooldown-ms = 150;
          action.move-column-to-workspace-up = { };
        };

        "Mod+WheelScrollRight" = {
          cooldown-ms = 150;
          action.focus-column-right = { };
        };
        "Mod+WheelScrollLeft" = {
          cooldown-ms = 150;
          action.focus-column-left = { };
        };
        "Mod+Ctrl+WheelScrollRight" = {
          cooldown-ms = 150;
          action.move-column-right = { };
        };
        "Mod+Ctrl+WheelScrollLeft" = {
          cooldown-ms = 150;
          action.move-column-left = { };
        };

        # Shift wheel scroll for column navigation
        "Mod+Shift+WheelScrollDown" = {
          cooldown-ms = 150;
          action.focus-column-right = { };
        };
        "Mod+Shift+WheelScrollUp" = {
          cooldown-ms = 150;
          action.focus-column-left = { };
        };
        "Mod+Ctrl+Shift+WheelScrollDown" = {
          cooldown-ms = 150;
          action.move-column-right = { };
        };
        "Mod+Ctrl+Shift+WheelScrollUp" = {
          cooldown-ms = 150;
          action.move-column-left = { };
        };

        # Monitor movement commands
        "Mod+Shift+Ctrl+H".action.move-column-to-monitor-left = { };
        "Mod+Shift+Ctrl+J".action.move-column-to-monitor-down = { };
        "Mod+Shift+Ctrl+K".action.move-column-to-monitor-up = { };
        "Mod+Shift+Ctrl+L".action.move-column-to-monitor-right = { };
        "Mod+Shift+Ctrl+Left".action.move-column-to-monitor-left = { };
        "Mod+Shift+Ctrl+Down".action.move-column-to-monitor-down = { };
        "Mod+Shift+Ctrl+Up".action.move-column-to-monitor-up = { };
        "Mod+Shift+Ctrl+Right".action.move-column-to-monitor-right = { };

        # Move to workspaces
        "Mod+Ctrl+1".action.move-column-to-workspace = 1;
        "Mod+Ctrl+2".action.move-column-to-workspace = 2;
        "Mod+Ctrl+3".action.move-column-to-workspace = 3;
        "Mod+Ctrl+4".action.move-column-to-workspace = 4;
        "Mod+Ctrl+5".action.move-column-to-workspace = 5;
        "Mod+Ctrl+6".action.move-column-to-workspace = 6;
        "Mod+Ctrl+7".action.move-column-to-workspace = 7;
        "Mod+Ctrl+8".action.move-column-to-workspace = 8;
        "Mod+Ctrl+9".action.move-column-to-workspace = 9;
        "Mod+Ctrl+Page_Up".action.move-column-to-workspace-up = { };
        "Mod+Ctrl+Page_Down".action.move-column-to-workspace-down = { };
        "Mod+Shift+Page_Up".action.move-workspace-up = { };
        "Mod+Shift+Page_Down".action.move-workspace-down = { };
        "Mod+Shift+I".action.move-workspace-up = { };
        "Mod+Shift+U".action.move-workspace-down = { };

        "Mod+Alt+L".action.spawn = [ "loginctl" "lock-session" ];
        # "Mod+Alt+v".action = spawn {
        #   name = "clipboard-picker";
        #   runtimeInputs = [
        #     pkgs.cliphist
        #     wmenu
        #   ];

        #   text = ''cliphist list | wmenu -l5 -pclipboard -i | cliphist decode | wl-copy'';
        # };
        # "Mod+Alt+Shift+v".action = spawn {
        #   name = "clipboard-delete-picker";
        #   runtimeInputs = [
        #     pkgs.cliphist
        #     wmenu
        #   ];
        #   text = ''cliphist list | wmenu -l5 -p"clipboard delete" -i | cliphist-delete'';
        # };
        "Mod+D".action.spawn = [ bemenu ];

        "XF86AudioRaiseVolume" = {
          allow-when-locked = true;
          action = spawn {
            name = "volume-up";
            runtimeInputs = [ pkgs.swayosd ];
            text = "swayosd-client --output-volume raise";
          };
        };
        "XF86AudioLowerVolume" = {
          allow-when-locked = true;
          action = spawn {
            name = "volume-down";
            runtimeInputs = [ pkgs.swayosd ];
            text = "swayosd-client --output-volume lower";
          };
        };
        "XF86AudioMute" = {
          allow-when-locked = true;
          action = spawn {
            name = "volume-mute";
            runtimeInputs = [ pkgs.swayosd ];
            text = "swayosd-client --output-volume mute-toggle";
          };
        };
        "XF86AudioMicMute" = {
          allow-when-locked = true;
          action = spawn {
            name = "mic-mute";
            runtimeInputs = [ pkgs.swayosd ];
            text = "swayosd-client --input-volume mute-toggle";
          };
        };
        "XF86MonBrightnessDown" = {
          allow-when-locked = true;
          action = spawn {
            name = "brightness-down";
            runtimeInputs = [ pkgs.swayosd ];
            text = "swayosd-client --brightness lower";
          };
        };
        "XF86MonBrightnessUp" = {
          allow-when-locked = true;
          action = spawn {
            name = "brightness-up";
            runtimeInputs = [ pkgs.swayosd ];
            text = "swayosd-client --brightness raise";
          };
        };
        "XF86AudioPlay" = {
          allow-when-locked = true;
          action = spawn {
            name = "media-play-pause";
            runtimeInputs = [ pkgs.playerctl ];
            text = "playerctl play-pause";
          };
        };
        "XF86AudioNext" = {
          allow-when-locked = true;
          action = spawn {
            name = "media-next";
            runtimeInputs = [ pkgs.playerctl ];
            text = "playerctl next";
          };
        };
        "XF86AudioPrev" = {
          allow-when-locked = true;
          action = spawn {
            name = "media-prev";
            runtimeInputs = [ pkgs.playerctl ];
            text = "playerctl previous";
          };
        };
        "Print".action.screenshot = { };
        "Ctrl+Print".action.screenshot-screen = { };
        "Alt+Print".action.screenshot-window = { };

      };

      # spawn-at-startup = [
      #   {
      #     command = [
      #       "sh"
      #       "-c"
      #       "${pkgs.dbus}/bin/dbus-update-activation-environment --systemd DISPLAY WAYLAND_DISPLAY XDG_CURRENT_DESKTOP XDG_SESSION_TYPE NIXOS_OXONE_WL XCURSOR_THEME XCURSOR_SIZE && systemctl --user reset-failed"
      #     ];
      #   }
      # ];
      window-rule = { open-maximized = true; };

      screenshot-path = "~/tmp/Screenshot from %Y-%m-%d %H-%M-%S.png";
      hotkey-overlay.skip-at-startup = true;
      clipboard.disable-primary = true;
      overview.backdrop-color = config.lib.stylix.colors.withHashtag.base00;
      layout.border = with config.lib.stylix.colors.withHashtag; {
        enable = true;
        active = { color = base0D; };
        inactive = { color = base03; };
      };

      layout.gaps = 5;
    };
  };
  systemd.user.services.swaybg = {
    Unit = {
      Description = "Background image for Wayland";
      After = [ "niri.service" ];
    };
    Service = {
      Type = "simple";
      ExecStart =
        "${lib.getExe pkgs.swaybg} --image ${config.stylix.image} --mode fill";
      Restart = "on-failure";
    };
    Install.WantedBy = [ "niri.service" ];
  };
}
