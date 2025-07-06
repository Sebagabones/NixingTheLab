{ flake, pkgs, ... }:

{
  imports = [ flake.homeModules.niri flake.nixosModules.theming ];

  stylix = {

    image = ../../assests/background.png;

    cursor = {
      package = pkgs.banana-cursor;
      name = "banana-cursor";
      size = 24;
    };
  };
  programs.niri = { enable = true; };

  programs.bemenu = { enable = true; };
  programs.ghostty = {
    enable = true;
    enableFishIntegration = true;
    settings = {
      unfocused-split-opacity = 0.95;

      window-padding-x = 4;
      window-padding-y = 4;
      window-padding-balance = true;
      window-padding-color = "extend";

      gtk-tabs-location = "hidden";
      gtk-single-instance = true;
    };
  };

  programs.firefox = { enable = true; };
  programs.spotify-player = { enable = true; };
  programs.autorandr = { enable = true; };

  home.packages = with pkgs; [ discord networkmanagerapplet wlr-randr ];
}
