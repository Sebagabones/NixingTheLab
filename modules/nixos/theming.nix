{ inputs, config, lib, pkgs, ... }:

{
  imports = [ inputs.stylix.nixosModules.stylix ];

  stylix = {

    homeManagerIntegration.followSystem = true;
    homeManagerIntegration.autoImport = true;
    autoEnable = true;

    # base16Scheme = theme;

    enable = true;
    polarity = "dark";
    base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
    # base16Scheme =
    #   "${pkgs.base16-schemes}/share/themes/tokyo-night-terminal-dark.yaml";
    # base16Scheme =      "${pkgs.base16-schemes}/share/themes/tokyodark-terminal.yaml";
    # try:
    # heetch

    # tokyodark-terminal

    # image = ../../assests/background.png;
    #
    # cursor = {
    #   package = pkgs.banana-cursor;
    #   name = "banana-cursor";
    #   size = 24;
    # };
    fonts = {
      serif = {
        package = pkgs.fira-code;
        name = "FiraCode";
      };
      sansSerif = {
        package = pkgs.fira-code;
        name = "FiraCode";
      };
      monospace = {
        package = pkgs.fira-code;
        name = "FiraCode";
      };
      emoji = {
        package = pkgs.noto-fonts-monochrome-emoji;
        name = "Noto Emoji";
      };
    };
  };
}
