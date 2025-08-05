{ inputs, config, lib, pkgs, flake, perSystem, ... }:
let
  tex = (pkgs.texlive.combine {
    inherit (pkgs.texlive)
      scheme-basic dvisvgm dvipng # for preview and export as html
      wrapfig amsmath ulem hyperref capt-of;
    #(setq org-latex-compiler "lualatex")
    #(setq org-preview-latex-default-process 'dvisvgm)
  });
in {
  home.stateVersion = "24.11";
  programs.home-manager.enable = true;

  imports = [
    ./mutable-files.nix
    flake.homeModules.git
    flake.homeModules.theming
    flake.homeModules.emacs

    # flake.homeModules.gui
  ];
  home.packages = with pkgs; [
    ghostty.terminfo
    atool
    httpie
    nixd
    # difftastic
    procs
    python3
    cmatrix
    clang
    (aspellWithDicts (dicts: with dicts; [ en en-computers en-science ]))
    hunspellDicts.en-au
    hunspellDicts.en_GB-large
    gnupg
    unzip
    zip
    tex
    multimarkdown # used for emacs export markdown
    python311Packages.weasyprint
    pandoc
    direnv
    starship
    zsh-autosuggestions
    zsh-syntax-highlighting
    # perSystem.self.delta
    delta
    nix-update

    uv
    ruff
    ty
    python312Packages.mypy

    jre8 # For RETRO - ELEC3020
  ];

  home.sessionVariables = { TERM = "xterm-direct"; };

  programs = {
    fzf.enable = true;
    btop = {
      enable = true;
      settings = {
        update_ms = 100;
        theme-background = false;
      };
    };
    fastfetch.enable = true;
    lazygit.enable = true;
    fd.enable = true;
    ripgrep.enable = true;
    emacs = { enable = true; };
    ssh = {
      enable = true;
      matchBlocks = {
        bonesboundhome = {
          hostname = "mahoosively.gay";
          port = 8909;
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
      config = { theme = "tokyoNightNight"; };
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
        ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE =
          "fg=#${config.lib.stylix.colors.base03-hex},underline"; # can't be arsed trying to convert hex to xterm, so this is hopefully good enough
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
        add_newline = true;
        command_timeout = 1300;
        scan_timeout = 50;
        # format = ''
        #   $all$nix_shell$c$golang$rust$python$nim$git_branch$git_commit$git_state$git_status
        #   $username$hostname$directory
        # '';
        character = {
          success_symbol = "[](bold green) ";
          error_symbol = "[✗](bold red) ";
        };
      };
    };

  };
  services.lorri = {
    enable = true;
    enableNotifications = true;
  };
}
