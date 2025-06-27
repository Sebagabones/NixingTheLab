{ inputs, config, lib, pkgs, ... }:

let
  theme = "${pkgs.base16-schemes}/share/themes/tokyo-night-dark.yaml";
  wallpaper = pkgs.runCommand "image.png" { } ''
    COLOR=$(${lib.getExe pkgs.yq} -r .palette.base00 ${theme})
    ${lib.getExe pkgs.imagemagick} -size 1920x1080 xc:$COLOR $out
  '';
in {
  imports = [ inputs.stylix.nixosModules.stylix ];

  stylix = {
    autoEnable = true;
    image = wallpaper;
    base16Scheme = theme;

    enable = true;
    polarity = "dark";
    # base16Scheme = "${pkgs.base16-schemes}/share/themes/tokyo-night-dark.yaml";

    # image = ../../assests/background.png;

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
        name = "nerd-fonts-jetbrains-mono";
      };
    };
  };
}
