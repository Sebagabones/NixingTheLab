{ pkgs, ... }:

{

  stylix = {
    enable = true;
    # polarity = "dark";
    base16Scheme = "${pkgs.base16-schemes}/share/themes/tokyo-night-dark.yaml";

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
