{ pkgs, ... }:

{
  stylix = {
    enable = true;

    # polarity = "dark";
    # base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
    base16Scheme = "${pkgs.base16-schemes}/share/themes/da-one-ocean.yaml";
    targets.bat.enable = false;
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
