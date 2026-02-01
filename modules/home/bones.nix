{
  inputs,
  config,
  lib,
  pkgs,
  flake,
  perSystem,
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
  home.preferXdgDirectories = true;
  home.packages = with pkgs; [
    ghostty.terminfo
    atool
    httpie
    nixd
    lsd
    clang-tools
    procs
    (python3.withPackages (
      python-pkgs: with python-pkgs; [
        pygments
        git
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
    TERM = "xterm-direct";
  };

  programs = {
    fzf.enable = true;
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
      matchBlocks = {
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
          hostname = "mahoosively.gay";
          port = 7656;
        };
        bonesboundhome = {
          hostname = "mahoosively.gay";
          port = 8909;
        };
        bonesrunhome = {
          hostname = "mahoosively.gay";
          port = 7856;
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
        # batgrep
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
      initContent = "cd";
    };
    starship = {
      enable = true;
      settings = {
        palette = "catppuccin_mocha";
        format = ''
          [╭─ $shell$character$memory_usage ──╌╌ $python$nim$cpp $fill  ╌╌─╮](overlay0)
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
          disabled = true;
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
          style = "bold red";
        };
        git_metrics = {
          disabled = false;
          format = " [+$added](bold teal)[-$deleted](bold pink)";
        };
        git_branch = {
          format = "[$branch(:$remote_branch)]($style)";
          style = "bold pink";
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
              style = "teal";
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
