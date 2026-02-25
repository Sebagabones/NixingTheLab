{
  pkgs,
  ...
}:
{
  home.stateVersion = "25.11";
  home.packages = with pkgs; [
    nixd
    lsd
    clang-tools
    procs
    cmatrix
    clang
    unzip
    go
    godef
    zip
    zsh-autosuggestions
    zsh-syntax-highlighting
    nix-update
    uv
    ruff
    ghc
    cabal-install
    starship
  ];

  stylix = {
    enable = true;
    autoEnable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/tokyodark-terminal.yaml";
  };

  programs = {
    home-manager.enable = true;

    fd.enable = true;
    direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };
    ripgrep.enable = true;
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
    };
  };
}
