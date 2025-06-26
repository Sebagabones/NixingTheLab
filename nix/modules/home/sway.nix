{ pkgs, config, lib, perSystem, ... }:

let
  terminal = "wezterm";
  modifier = "Mod4"; # Super
in {
  home.packages = [ pkgs.bemenu pkgs.wezterm ];

  wayland.windowManager.sway = {
    enable = true;
    wrapperFeatures = {
      base = true;
      gtk = true;
    };
    systemd = {
      enable = true;
      xdgAutostart = true;
    };
    extraSessionCommands = let
      path = "${config.home.profileDirectory}/etc/profile.d/hm-session-vars.sh";
    in "test -f ${path} && source ${path}";
    config = {
      inherit modifier;
      terminal = toString terminal;
      defaultWorkspace = "workspace number 1";

      window = {
        border = 0;
        titlebar = false;
      };
      floating = {
        border = 0;
        titlebar = false;
      };
      gaps = {
        smartGaps = true;
        inner = 4;
        outer = 0;
      };
      input = {
        "type:touchpad" = {
          tap = "enabled";
          natural_scroll = "enabled";
        };
        "type:keyboard" = { xkb_options = "caps:swapescape"; };
        "1:1:solaar-keyboard" = { scroll_factor = "0.04"; };
      };
      keybindings = let
        exec = args: "exec ${lib.getExe (pkgs.writeShellApplication args)}";
        swayosd = cmd:
          exec {
            name = "swayosd-${lib.strings.sanitizeDerivationName cmd}";
            runtimeInputs = [ pkgs.swayosd ];
            text = "swayosd-client --${cmd}";
          };
        playerctl = cmd:
          exec {
            name = "playerctl-${lib.strings.sanitizeDerivationName cmd}";
            runtimeInputs = [ pkgs.playerctl ];
            text = "playerctl ${cmd}";
          };
      in lib.mkOptionDefault {
        # "${modifier}+shift+Right" = "move right";
        # "${modifier}+shift+l" = "exec ${lib.getExe pkgs.swaylock} -d";
        "${modifier}+alt+v" = exec {
          name = "clipboard-picker";
          runtimeInputs = [ pkgs.cliphist pkgs.wmenu ];
          text =
            "cliphist list | wmenu -l5 -pclipboard -i | cliphist decode | wl-copy";
        };
        "${modifier}+alt+shift+v" = exec {
          name = "clipboard-delete-picker";
          runtimeInputs = [ pkgs.cliphist pkgs.wmenu ];
          text = ''
            cliphist list | wmenu -l5 -p"clipboard delete" -i | cliphist-delete'';
        };
        "${modifier}+w" = "exec ${lib.getExe pkgs.firefox}";

        XF86AudioRaiseVolume = swayosd "output-volume raise";
        XF86AudioLowerVolume = swayosd "output-volume lower";
        XF86AudioMute = swayosd "output-volume mute-toggle";
        XF86AudioMicMute = swayosd "input-volume mute-toggle";
        XF86MonBrightnessDown = swayosd "brightness lower";
        XF86MonBrightnessUp = swayosd "brightness raise";
        "--release Caps_Lock" = swayosd "caps-lock";

        XF86AudioPlay = playerctl "play-pause";
        XF86AudioNext = playerctl "next";
        XF86AudioPrev = playerctl "previous";

        Print = exec {
          name = "screenshot";
          runtimeInputs = with pkgs; [ swappy grim slurp ];
          text = ''
            grim -g "$(slurp)" - | swappy -f -
          '';
        };
      };
    };
  };

}
