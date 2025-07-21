{ flake, pkgs, perSystem, ... }:

{

  programs.git = {
    enable = true;
    userName = "Sebgabones";
    userEmail = "133339614+Sebagabones@users.noreply.github.com";
    extraConfig = {
      push = { autoSetupRemote = true; };
      pull = { rebase = false; };
    };
    # delta = {
    #   enable = true;
    #   options = { };
    # };
    difftastic = {
      enable = true;
      enableAsDifftool = true;
      color = "auto";
      display = "side-by-side";
    };

  };
}
