{ flake, pkgs, perSystem, ... }:

{

  programs.git = {
    enable = true;
    userName = "Sebgabones";
    userEmail = "133339614+Sebagabones@users.noreply.github.com";
    extraConfig = {
      user = { signingkey = "~/.ssh/id_ed25519.pub"; };
      push = { autoSetupRemote = true; };
      pull = { rebase = false; };
      commit = { gpgsign = true; };
      gpg = { format = "ssh"; };
    };
    delta = {
      enable = false;
      options = { };
    };
    difftastic = {
      enable = true;
      enableAsDifftool = true;
      color = "auto";
      display = "side-by-side";
    };
  };
}
