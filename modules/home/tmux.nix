{
  inputs,
  config,
  lib,
  pkgs,
  flake,
  ...
}:
let
  rtpPath = "share/tmux-plugins";

  addRtp =
    path: rtpFilePath: attrs: derivation:
    derivation
    // {
      rtp = "${derivation}/${path}/${rtpFilePath}";
    }
    // {
      overrideAttrs = f: mkTmuxPlugin (attrs // (if lib.isFunction f then f attrs else f));
    };

  mkTmuxPlugin =
    a@{
      pluginName,
      rtpFilePath ? (builtins.replaceStrings [ "-" ] [ "_" ] pluginName) + ".tmux",
      namePrefix ? "tmuxplugin-",
      src,
      unpackPhase ? "",
      configurePhase ? ":",
      buildPhase ? ":",
      addonInfo ? null,
      preInstall ? "",
      postInstall ? "",
      path ? lib.getName pluginName,
      ...
    }:
    if lib.hasAttr "dependencies" a then
      throw "dependencies attribute is obselete. see NixOS/nixpkgs#118034" # added 2021-04-01
    else
      addRtp "${rtpPath}/${path}" rtpFilePath a (
        pkgs.stdenv.mkDerivation (
          a
          // {
            pname = namePrefix + pluginName;

            strictDeps = true;
            __structuredAttrs = true;

            inherit
              pluginName
              unpackPhase
              configurePhase
              buildPhase
              addonInfo
              preInstall
              postInstall
              ;

            installPhase = ''
              runHook preInstall

              target=$out/${rtpPath}/${path}
              mkdir -p $out/${rtpPath}
              cp -r . $target
              if [ -n "$addonInfo" ]; then
                echo "$addonInfo" > $target/addon-info.json
              fi

              runHook postInstall
            '';
          }
        )
      );

in
{
  programs.tmux = {
    enable = true;
    clock24 = true;
    plugins =
      let
        tmux-smooth-scroll = mkTmuxPlugin {
          pluginName = "smooth-scroll";
          rtpFilePath = "smooth-scroll.tmux";
          version = "0.0.0";
          src = pkgs.fetchFromGitHub {
            owner = "azorng";
            repo = "tmux-smooth-scroll";
            rev = "e7f0b489d28f85e5a4e90d1aae335ac390159657";
            hash = "sha256-2oDwVMuuu6gnaKqaqUjTdJ4nMuvOIt04W5SipxHBxQY=";
          };
        };
      in
      [
        pkgs.tmuxPlugins.tokyo-night-tmux
        tmux-smooth-scroll
      ];
    extraConfig = ''
      # Custom bindings
      set -g prefix C-x
      set -g mouse on
      bind C-x send-prefix
      bind r source-file ~/.config/tmux/tmux.conf \; display "~/.config/tmux/tmux.conf reloaded"
      set -g base-index 1
      setw -g pane-base-index 1
      bind -r M-Up resize-pane -U 5
      bind -r M-Down resize-pane -D 5
      bind -r M-Left resize-pane -L 5
      bind -r M-Right resize-pane -R 5

      bind -n S-PageUp copy-mode -u
      bind -T copy-mode S-PageUp send-keys -X page-up
      bind -T copy-mode S-PageDown send-keys -X page-down
      bind -n S-PageDown send-keys PageDown

      bind -n M-T new-window -n tmux-conf -c ~/.tmux.d/
      bind Y setw synchronize-panes \; if-shell "tmux showw -v synchronize-panes | grep on"\
                                                "display 'synchronize-panes on'" \
                                                "display 'synchronize-panes off'"
      bind a setw monitor-activity \; if-shell "tmux showw -v monitor-activity | grep on"\
                                               "display 'monitor-activity on'" \
                                               "display 'monitor-activity off'"
      bind W command-prompt "rename-window '%%'"
      bind M-y choose-buffer

      # Emacs bindings
      set -g status-keys emacs
      setw -g mode-keys emacs
      bind -n M-x command-prompt
      bind -n M-: command-prompt
      # bind M-x send-keys "M-x" # Send M-x to emacs
      # bind M-: send-keys "M-:" # Send M-: to emacs
      bind g if-shell "cd #{pane_current_path} && git diff" \
                      "new-window -n git-diff -c '#{pane_current_path}' '( git diff --color=always --ignore-space-change --ignore-all-space && echo && git -c status.color=always status ) | less -r'"\
                      "display 'Not a git repository.'"
      bind 0 if-shell "tmux display-message -p '#{window_panes}' | grep -v '^1$'"\
                      "kill-pane"\
                      "display 'Attempt to delete sole ordinary panel'"
      bind 1 run-shell "tmux list-panes | grep -o '%[[:digit:]]\\+' | xargs -I{} sh -c \
                       'if [ #D != {} ]; then tmux kill-pane -t {}; fi'"
      bind 2 split-window -v -c "#{pane_current_path}" \; select-pane -l
      bind 3 split-window -h -c "#{pane_current_path}" \; select-pane -l
      bind 4 split-window -h -c "#{pane_current_path}" \; select-pane -l # TODO: at some point add fzf to choose path here

      bind k confirm-before -p "kill-pane '#W:#P'? (y/n)" kill-pane
      bind b choose-tree

      # Copy shenanigans
      bind-key c copy-mode

      bind-key -n C-Space copy-mode \; send-keys -X begin-selection
      bind -T copy-mode C-Left send-keys -X previous-word
      bind -T copy-mode C-Right send-keys -X next-word-end
      bind -n C-y paste-buffer

      # Emacs tabs
      bind-key t switch-client -T emacs-style-tabs-table
      bind-key -T emacs-style-tabs-table 2 new-window
      bind-key -T emacs-style-tabs-table f new-window # TODO: at some point add in fzf to pick dir to open in
      bind-key -T emacs-style-tabs-table 0 if-shell "tmux display-message -p '#{session_windows}' | grep -v '^1$'"\
                      "kill-window"\
                      "display 'Attempt to delete sole window'"
      bind-key -T emacs-style-tabs-table 1 run-shell "tmux list-windows | grep -o '%[[:digit:]]\\+' | xargs -I{} sh -c \
                       'if [ #D != {} ]; then tmux kill-window -t {}; fi'"
      bind-key -T emacs-style-tabs-table Enter choose-window

      bind -T prefix q display-panes -d 0

      bind o if-shell -F "#{e|>=:#{window_panes},3}" "display-panes -d 0" "select-pane -t :.+"

      bind-key -n C-g if-shell -F '#{pane_in_mode}' 'send-keys q' 'send-keys Escape'
      bind-key -T copy-mode C-g send-keys -X cancel
      bind-key -T prefix C-g send-keys Escape
      bind-key -T HELP C-g send-keys Escape
      bind-key -T emacs-style-tabs-table C-g send-keys Escape
      bind-key -T SWITCHWINDOW C-g send-keys Escape
      bind-key -n C-g send-keys Escape

      bind C-b switch-client -T SWITCHWINDOW
      bind -T SWITCHWINDOW 0 select-window -t :=0
      bind -T SWITCHWINDOW 1 select-window -t :=1
      bind -T SWITCHWINDOW 2 select-window -t :=2
      bind -T SWITCHWINDOW 3 select-window -t :=3
      bind -T SWITCHWINDOW 4 select-window -t :=4
      bind -T SWITCHWINDOW 5 select-window -t :=5
      bind -T SWITCHWINDOW 6 select-window -t :=6
      bind -T SWITCHWINDOW 7 select-window -t :=7
      bind -T SWITCHWINDOW 8 select-window -t :=8
      bind -T SWITCHWINDOW 9 select-window -t :=9

      # Help mode
      bind -n C-h switch-client -T HELP \; display "C-h (Type ? for further options)-"

      bind -N "Display all key bindings." -T HELP k list-keys
      bind -N "Show the Commands tmux man page section." -T HELP c new-window -n 'Commands' "${pkgs.bat-extras.batman}/bin/batman -P 'less -p ^COMMANDS' tmux"
      bind -N "Show the Variables tmux man page section." -T HELP v new-window -n 'Variables' "${pkgs.bat-extras.batman}/bin/batman -P 'less -p \"Variable name\"' tmux"
      bind -N "Show the Formats tmux man page section." -T HELP F new-window -n 'Formats' "BAT_PAGER='less -p ^FORMATS' ${pkgs.bat-extras.batman}/bin/batman tmux"
      bind -N "Show the Hooks tmux man page section." -T HELP h new-window -n 'Hooks' "BAT_PAGER='less -p ^HOOKS' ${pkgs.bat-extras.batman}/bin/batman tmux"
      bind -N "Display all active global hooks." -T HELP H show-hooks -g
      bind -N "Show the Environment tmux man page section." -T HELP e new-window -n 'Environment' "BAT_PAGER='less -p ^ENVIRONMENT' ${pkgs.bat-extras.batman}/bin/batman tmux"
      bind -N "Display the active local tmux environment." -T HELP E showenv
      bind -N "Display the active global tmux environment." -T HELP g showenv -g
      bind -N "Display the active local tmux options." -T HELP o show-options
      bind -N "Display the active global tmux options." -T HELP O show-options -g
      bind -N "Display the active local tmux window options." -T HELP w show-window-options
      bind -N "Display the active global tmux window options." -T HELP W show-window-options -g
      bind -N "Show the tmux man page from the start." -T HELP m new-window -n 'tmux man page' "${pkgs.bat-extras.batman}/bin/batman tmux"

      bind -N "Show this help menu summary popup." -T HELP ? display-popup -w 80% -h 80% -E "sh -c 'tmux list-keys -N -T HELP | pr -t -o 25| less -S'"
      bind -T HELP q if-shell "echo #W | grep 'Help Page'" "send-keys q"

      # Shtyle
      set -g status-left-length 20
      set-window-option -g xterm-keys on
      set -g default-terminal "xterm-256color"

      set -g history-limit 20000
      # Settings
      set -g pane-border-lines simple
      set -g pane-active-border-style "fg=#565f89"
      set -g destroy-unattached on
      set -g display-time 2000
      set -g @tokyo-night-tmux_window_id_style digital   # window tab numbers
      set -g @tokyo-night-tmux_pane_id_style hsquare     # pane number shown in status bar
      set -g @tokyo-night-tmux_zoom_id_style dsquare     # pane number shown when zoomed
      set -g @tokyo-night-tmux_window_tidy_icons 0   # 1 = no extra space | 0 = add space (default)
      set -g @tokyo-night-tmux_zoom_id_style dsquare
      set -g @tokyo-night-tmux_theme night   # night (default) | storm | moon | day
      set -g @tokyo-night-tmux_transparent 1 # transparent background
      set -g @tokyo-night-tmux_show_git 1             # local git status
      set -g @tokyo-night-tmux_show_wbg 1             # GitHub / GitLab stats
      set -g @tokyo-night-tmux_show_netspeed 1        # network speed
      set -g @tokyo-night-tmux_netspeed_showip 1       # show IPv4 address (default: 0)
      set -g @tokyo-night-tmux_netspeed_refresh 1      # update interval in seconds (default: 1)
      set -g @tokyo-night-tmux_show_battery_widget 1  # battery level
      set -g @tokyo-night-tmux_show_music 1           # now playing
      set -g @tokyo-night-tmux_show_path 1            # current path
      set -g @tokyo-night-tmux_path_format relative   # 'relative' or 'full'
      set -g @tokyo-night-tmux_show_hostname 1        # machine hostname
    '';
  };
}
