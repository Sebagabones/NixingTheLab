{ pkgs, config, lib, perSystem, ... }:

let
  wmenu = with config.lib.stylix.colors;
    pkgs.writeShellScriptBin "wmenu" ''
      ${pkgs.wmenu}/bin/wmenu -N ${base00} -M ${base01} -S ${base02} -n ${base05} -m ${base05} -s ${base0D} -f "monospace 13" -b "$@"
    '';
  dmenu = pkgs.stdenv.mkDerivation {
    name = "dmenu";
    buildCommand = ''
      mkdir -p $out/bin
      ln -s ${lib.getExe wmenu} $out/bin/dmenu
    '';
    meta.mainProgram = "dmenu";
  };
  menu-d = pkgs.writeShellScriptBin "menu-d.sh" ''
    sock="$XDG_RUNTIME_DIR/j4dmenu"
    if pgrep j4-dmenu-deskto >/dev/null; then
      echo q > "$sock"
      rm -f "$sock"
      while pgrep j4-dmenu-deskto; do
        sleep 0.1
        pkill -QUIT j4-dmenu-deskto
      done
    fi
    ${pkgs.j4-dmenu-desktop}/bin/j4-dmenu-desktop \
      --i3-ipc \
      --dmenu "${lib.getExe wmenu} -i" \
      --term "${terminal}" \
      --usage-log ~/.cache/j4dmenu \
      --no-generic \
      --use-xdg-de \
      --wait-on "$sock"
  '';
  terminal = pkgs.writeShellScript "terminal.sh" ''
    ${lib.getExe config.programs.ghostty.package}
  '';
  modifier = "Mod4"; # Super
in {
  home.packages = [ wmenu dmenu menu-d pkgs.gtklock ];

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
      menu = ''pkill -QUIT wmenu || echo > "$XDG_RUNTIME_DIR/j4dmenu"'';
      startup = [
        {
          always = true;
          command = lib.getExe menu-d;
        }
        {
          always = true;
          command = lib.getExe pkgs.albert;
        }
        {
          always = true;
          command = "pgrep solaar || solaar --window hide";
        }
        {
          always = true;
          command = "kanshictl reload";
        }
      ];
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
      bars = [{
        statusCommand =
          "${pkgs.i3status-rust}/bin/i3status-rs config-bottom.toml";
        trayOutput = "none";
        fonts = {
          names = [ "monospace" ];
          size = 10.0;
        };
        colors = with config.lib.stylix.colors.withHashtag; {
          background = base00;
          separator = base01;
          statusline = base04;
          focusedWorkspace = {
            border = base02;
            background = base02;
            text = base0D;
          };
          activeWorkspace = {
            border = base00;
            background = base00;
            text = base0D;
          };
          inactiveWorkspace = {
            border = base00;
            background = base00;
            text = base05;
          };
          urgentWorkspace = {
            border = base00;
            background = base00;
            text = base09;
          };
          bindingMode = {
            border = base00;
            background = base00;
            text = base09;
          };
        };
      }];
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
        "${modifier}+alt+l" =
          "exec ${lib.getExe pkgs.gtklock} -d && systemctl suspend";
        "${modifier}+alt+shift+l" = "exec ${lib.getExe pkgs.gtklock} -d";
        "${modifier}+alt+v" = exec {
          name = "clipboard-picker";
          runtimeInputs = [ pkgs.cliphist wmenu ];
          text =
            "cliphist list | wmenu -l5 -pclipboard -i | cliphist decode | wl-copy";
        };
        "${modifier}+alt+shift+v" = exec {
          name = "clipboard-delete-picker";
          runtimeInputs = [ pkgs.cliphist wmenu ];
          text = ''
            cliphist list | wmenu -l5 -p"clipboard delete" -i | cliphist-delete'';
        };
        "${modifier}+alt+w" = "exec ${lib.getExe pkgs.networkmanager_dmenu}";
        "${modifier}+space" = "exec ${lib.getExe pkgs.albert} toggle";

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

  # swayidle w/ chayang
  # rbw menu?
  # gestures? via libinput-gestures
  # workstyle for icons
}
