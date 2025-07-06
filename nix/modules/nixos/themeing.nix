{ inputs, config, lib, pkgs, ... }:

{
  imports = [ inputs.stylix.nixosModules.stylix ];

  stylix = {
    homeManagerIntegration.followSystem = true;
    homeManagerIntegration.autoImport = true;
    autoEnable = true;
    # image = wallpaper;
    # base16Scheme = theme;

    enable = true;
    polarity = "dark";
    base16Scheme = "${pkgs.base16-schemes}/share/themes/tokyo-night-dark.yaml";

    image = ../../assests/background.png;

    cursor = {
      package = pkgs.banana-cursor;
      name = "banana-cursor";
      size = 24;
    };
    fonts = {
      monospace = {
        # package = pkgs.commit-mono;
        # name = "Commit Mono";
        package = pkgs.nerd-fonts.jetbrains-mono;
        name = "JetBrains Mono NF";
      };
    };
  };
}
