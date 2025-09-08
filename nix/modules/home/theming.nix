{ pkgs, ... }:

{
  stylix = {
    enable = true;
    autoEnable = true;
    # polarity = "dark";
    base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
    # base16Scheme = "${pkgs.base16-schemes}/share/themes/da-one-ocean.yaml";
    # base16Scheme =
    #   "${pkgs.base16-schemes}/share/themes/tokyo-night-terminal-dark.yaml";
    # base16Scheme =
    #   "${pkgs.base16-schemes}/share/themes/tokyodark-terminal.yaml";

    targets = {
      bat.enable = false;
      starship.enable = false;
      lazygit.enable = false;
      btop.enable = false;
    };
    # fonts = {
    #
    #   monospace = {
    #     # package = pkgs.commit-mono;
    #     # name = "Commit Mono";
    #     package = pkgs.nerd-fonts.jetbrains-mono;
    #     name = "JetBrains Mono NF";
    #   };
    # };
  };
}
