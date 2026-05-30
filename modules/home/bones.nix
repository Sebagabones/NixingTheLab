{
  inputs,
  config,
  pkgs,
  flake,
  ...
}:
{
  home.stateVersion = "24.11";
  programs.home-manager.enable = true;

  imports = [
    ./mutable-files.nix
    # flake.homeModules.gpg
    flake.homeModules.git
    flake.homeModules.theming
    inputs.catppuccin.homeModules.catppuccin
    # flake.homeModules.gui
  ];
  catppuccin = {
    enable = false; # not globally
    flavor = "mocha";
    accent = "mauve";
    cache.enable = true;
    bat.enable = false;
    starship.enable = false;
    btop.enable = true;
    gh-dash.enable = true;
  };
  services.playerctld.enable = true;

  # home.preferXdgDirectories = true;
  home.packages = with pkgs; [
    ghostty.terminfo
    atool
    nix-output-monitor
    httpie
    nixd
    lsd
    clang-tools
    procs
    ttl
    playerctl
    antlr4_11
    (python3.withPackages (
      python-pkgs: with python-pkgs; [
        pygments

        sympy
        git
        numpy
        pandas
        matplotlib
        latexminted
        catppuccin
        mypy
        rich
      ]
    ))
    cmatrix
    clang
    unzip
    go
    godef
    zip
    pandoc
    starship
    zsh-autosuggestions
    zsh-syntax-highlighting
    libqalculate
    nix-update
    uv
    ruff
    gh
    cmake
    fastmod
    sops
    age
    bitwarden-cli
    nix-fast-build
    expect
  ];
  programs.gpg = {
    enable = true;
  };
  home.sessionVariables = {
    # TERM = "xterm-direct";
  };

  programs = {
    tmux = {
      enable = true;
      clock24 = true;
      plugins = with pkgs.tmuxPlugins; [ tokyo-night-tmux ];
      extraConfig = ''
        # Custom bindings
        set -g prefix C-x
        set -g mouse on
        unbind -n MouseDrag1Pane
        unbind -Tcopy-mode MouseDrag1Pane
        bind C-x send-prefix
        bind r source-file ~/.tmux.conf \; display "~/.tmux.conf reloaded"
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
        bind-key -n C-c switch-client -T emacs-style-copy-table
        bind-key -T emacs-style-copy-table C-t copy-mode
        bind-key -T emacs-style-copy-table C-c send-keys "C-c"
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

        bind-key -n C-g if-shell -F '#{pane_in_mode}' 'send-keys q' 'send-keys C-c'
        bind-key -T copy-mode C-g send-keys -X cancel
        bind-key -T prefix C-g send-keys C-c
        bind-key -T HELP C-g send-keys C-c
        bind-key -T emacs-style-copy-table C-g send-keys C-c
        bind-key -T emacs-style-tabs-table C-g send-keys C-c
        bind-key -T SWITCHWINDOW C-g send-keys C-c

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
    # fzf.enable = true;
    btop = {
      enable = true;
      settings = {
        update_ms = 100;
        theme_background = false;
        truecolor = true;
      };
    };

    fastfetch.enable = true;

    lazygit = {
      enable = true;
      settings = {
        gui = {
          # Wanted catppuccin, however nix catppuccin module just made a new config file with other settings missing, so instead:
          theme = {
            activeBorderColor = [
              "#cba6f7"
              "bold"
            ];
            inactiveBorderColor = [ "#a6adc8" ];
            optionsTextColor = [ "#89b4fa" ];
            selectedLineBgColor = [ "#313244" ];
            cherryPickedCommitBgColor = [ "#45475a" ];
            cherryPickedCommitFgColor = [ "#cba6f7" ];
            unstagedChangesColor = [ "#f38ba8" ];
            defaultFgColor = [ "#cdd6f4" ];
            searchingActiveBorderColor = [ "#f9e2af" ];
          };
          authorColors = {
            "*" = "#b4befe";
          };
        };
        git = {
          paging = {
            externalDiffCommand = "difft --color=always";
          };
        };
      };
    };

    fd.enable = true;
    direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };
    ripgrep.enable = true;

    ssh = {
      enable = true;
      enableDefaultConfig = false;
      matchBlocks =
        let
          domain = "lab.mahoosively.gay";
        in
        {
          "*" = {
            forwardAgent = false;
            addKeysToAgent = "no";
            compression = true;
            serverAliveInterval = 0;
            serverAliveCountMax = 3;
            hashKnownHosts = false;
            userKnownHostsFile = "~/.ssh/known_hosts";
            controlMaster = "no";
            controlPath = "~/.ssh/master-%r@%n:%p";
            controlPersist = "no";
          };
          pandemonium = {
            hostname = "pandemonium.${domain}";
            port = 7656;
          };
          insanity = {
            hostname = "insanity.${domain}";
            port = 22;
          };
          deposition = {
            hostname = "deposition.${domain}";
            port = 5876;
          };
          ucc = {
            hostname = "ssh.ucc.asn.au";
          };
        };

    };
    bat = {
      enable = true;
      extraPackages = with pkgs.bat-extras; [
        batdiff
        batman
        prettybat
        batpipe
        batgrep
        batwatch
      ];
      config = {
        theme = "tokyoNightNight";
      };
      themes = {
        tokyoNightNight = {
          src = pkgs.fetchFromGitHub {
            owner = "folke";
            repo = "tokyonight.nvim"; # Bat uses sublime syntax for its themes
            rev = "76d5d5d71a7211549aed84807ec2ea9c07ad192a";
            sha256 = "sha256-ADXEPqCNlWZ0sO2K0b0E0bMDsfoL2QXfufOYjv+mtzY=";
            # sha256 = lib.fakeSha256;
          };
          file = "extras/sublime/tokyonight_night.tmTheme";
        };
      };
    };
    zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      # syntaxhighlighting.enable = true;
      syntaxHighlighting.enable = true;
      shellAliases = {
        ll = "ls -l";
        update = "sudo nixos-rebuild switch";
      };
      history.size = 10000;
      sessionVariables = {
        EDITOR = "emacs";
        ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE = "fg=#${config.lib.stylix.colors.base03-hex},underline"; # can't be arsed trying to convert hex to xterm, so this is hopefully good enough
      };

      oh-my-zsh = {
        enable = true;
        plugins = [
          "git"
          "direnv"
          "starship"
          "zsh-navigation-tools"
          # "zsh-autosuggestions"
          # "zsh-syntax-highlighting"
          # "fast-syntax-highlighting"
        ];
        # theme = "robbyrussell";
      };
      initContent = ''
        if [[ -n "$PS1" && ! "$TERM" =~ screen && ! "$TERM" =~ tmux && "$INSIDE_EMACS" != 'vterm' && -z "$TMUX" ]]; then
            exec tmux
        fi
        cd'';
    };
    starship = {
      enable = true;
      settings = {
        palette = "tokyo_night";
        format = ''
          [╭─ $shell$character$memory_usage ──╌╌ $python$nim$nix$cpp$rust $fill  ╌╌─╮](overlay0)
          [│ ](overlay0)$sudo$username$hostname$localip$directory$read_only$git_state$git_branch$git_metrics [$fill$cmd_duration ╯ ](overlay0)
          [╰─ ](overlay0)'';
        scan_timeout = 10;
        command_timeout = 500;
        add_newline = true;
        palettes = {
          catppuccin_mocha = {
            rosewater = "#f5e0dc";
            flamingo = "#f2cdcd";
            pink = "#f5c2e7";
            mauve = "#cba6f7";
            red = "#f38ba8";
            maroon = "#eba0ac";
            peach = "#fab387";
            yellow = "#f9e2af";
            green = "#a6e3a1";
            teal = "#94e2d5";
            sky = "#89dceb";
            sapphire = "#74c7ec";
            blue = "#89b4fa";
            lavender = "#b4befe";
            text = "#cdd6f4";
            subtext1 = "#bac2de";
            subtext0 = "#a6adc8";
            overlay2 = "#9399b2";
            overlay1 = "#7f849c";
            overlay0 = "#6c7086";
            surface2 = "#585b70";
            surface1 = "#45475a";
            surface0 = "#313244";
            base = "#1e1e2e";
            mantle = "#181825";
            crust = "#11111b";
          };

          tokyo_night = {
            flamingo = "#cfc9c2";
            pink = "#bb9af7";
            mauve = "#bb9af7";
            red = "#f7768e";
            maroon = "#f7768e";
            peach = "#ff9e64";
            yellow = "#e0af68";
            green = "#9ece6a";
            teal = "#73dacb";
            sky = "#2ac3de";
            sapphire = "#7dcfff";
            blue = "#7aa2f7";
            lavender = "#7aa2f7";
            text = "#c0caf5";
            subtext1 = "#a9b1d6";
            subtext0 = "#a9b1d6";
            overlay2 = "#9aa5ce";
            overlay1 = "#9aa5ce";
            overlay0 = "#565f89";
            surface2 = "#565f89";
            surface1 = "#414868";
            surface0 = "#414868";
            base = "#1a1b26";
            mantle = "#1a1b26";
            crust = "#1a1b26";
          };
        };
        shell = {
          fish_indicator = "fish";
          bash_indicator = "bash";
          zsh_indicator = "zsh";
          unknown_indicator = "unknwn";
          style = "teal";
          disabled = false;
        };
        username = {
          style_user = "teal bold";
          format = " [$user@]($style)";
          disabled = false;
          show_always = true;
        };
        sudo = {
          format = " [sudo](bold red)";
          disabled = false;
        };
        python = {
          symbol = "";
          format = "[Python](bold mauve) [$version [($virtualenv)](dimmed mauve)](dimmed mauve)";
          pyenv_version_name = true;
          detect_extensions = [ "py" ];
          detect_folders = [ ];
        };
        nix_shell = {
          disabled = false;
          heuristic = true;
          format = "[Nix Shell](bold lavender) [$state](bold dimmed lavender) ";
        };
        nim = {
          format = "[Nim](bold lavender) [$version](bold dimmed lavender) ";
        };
        cpp = {
          format = "[C++ ($name)](bold pink) [$version](bold dimmed pink) ";
        };
        memory_usage = {
          disabled = false;
          threshold = -1;
          format = "[$ram_pct]($style)";
          symbol = "";
          style = "dimmed blue";
        };
        localip = {
          ssh_only = false;
          format = "[@$localipv4](bold dimmed blue) ";
          disabled = false;
        };
        hostname = {
          ssh_only = false;
          ssh_symbol = "ssh:";
          format = "[$ssh_symbol](bold red )[$hostname](bold dimmed sapphire)";
          trim_at = "";
          disabled = false;
        };
        git_state = {
          format = "[($state( $progress_current of $progress_total))]($style) ";
          style = "bold peach";
        };
        git_metrics = {
          disabled = false;
          format = " [+$added](bold green)[-$deleted](bold red)";
        };
        git_branch = {
          format = "[$branch(:$remote_branch)]($style)";
          style = "bold sky";
        };
        fill = {
          symbol = " ";
          style = "bold base";
        };
        cmd_duration = {
          min_time = 500;
          format = " [$duration](bold dimmed flamingo)";
        };
        directory = {
          fish_style_pwd_dir_length = 9;
          disabled = false;
          truncation_length = 5;
          truncation_symbol = "…/";
          read_only = " read-only";
          read_only_style = "bold dimmed mauve";
          style = "bold mauve";
        };
        character = {
          success_symbol = "[───────────────](overlay0)";
          error_symbol = "[───────────────](red)";
        };
        package = {
          disabled = true;
        };
        battery = {
          full_symbol = "● ";
          charging_symbol = "◉ ";
          discharging_symbol = "◯ ";
          display = [
            {
              threshold = 20;
              style = "red";
            }
            {
              threshold = 100;
              style = "sky";
            }
          ];
        };
      };
    };
    gh-dash = {
      enable = true;
    };
  };
}
