{
  flake,
  pkgs,
  perSystem,
  ...
}:

{

  programs.git = {
    enable = true;
    userName = "Sebgabones";
    userEmail = "133339614+Sebagabones@users.noreply.github.com";
    delta = {
      enable = true;
      options = {
      };
    };
    difftastic = {
      enableAsDiffTool = true;
      color = "auto";
    };

  };
}
