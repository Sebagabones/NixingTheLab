{ flake, pkgs, perSystem, ... }:

{

  programs = {
    git = {
      enable = true;
      userName = "Sebgabones";
      userEmail = "133339614+Sebagabones@users.noreply.github.com";
      extraConfig = {
        user = { signingkey = "~/.ssh/id_ed25519.pub"; };
        push = { autoSetupRemote = true; };
        pull = { rebase = false; };
        commit = { gpgsign = true; };
        gpg = { format = "ssh"; };
        delta = {
          features = "side-by-side";
          syntax-theme = "tokyoNightNight";
          minus-style = "syntax '#37222c'";
          minus-non-emph-style = "syntax '#37222c'";
          minus-emph-style = "syntax '#713137'";
          minus-empty-line-marker-style = ''syntax "#37222c"'';
          line-numbers-minus-style = "#914c54";
          plus-style = ''syntax "#20303b"'';
          plus-non-emph-style = ''syntax "#20303b"'';
          plus-emph-style = ''syntax "#2c5a66"'';
          plus-empty-line-marker-style = ''syntax "#20303b"'';
          line-numbers-plus-style = "#449dab";
          line-numbers-zero-style = "#3b4261";
        };
        github = { user = "Sebagabones"; };
      };

      # delta = {
      # enable = true;
      # options = { features = {  }; };
      # };
      difftastic = {
        enable = true;
        # enable = false;
        enableAsDifftool = true;
        color = "auto";
        display = "side-by-side";
      };
    };
    mergiraf = { enable = true; };
  };
}
