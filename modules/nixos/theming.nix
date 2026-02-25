{
  inputs,
  pkgs,
  ...
}:
let
  BerkeleyMono = pkgs.callPackage ../../packages/BerkeleyMono { inherit pkgs; };
  # NOTE: If building this without access to berkeley mono, change this to something like pkgs.fira-code;
in
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
        package = BerkeleyMono;
        name = "Berkeley Mono";
      };
      sansSerif = {
        package = BerkeleyMono;
        name = "Berkeley Mono";
      };
      monospace = {
        package = BerkeleyMono;
        name = "Berkeley Mono";
      };
      emoji = {
        package = pkgs.noto-fonts-color-emoji;
        name = "Noto Emoji";
      };
    };
  };
}
