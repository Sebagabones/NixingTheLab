{ flake, ...}:

{
    imports = [
      flake.homeModules.niri
    ];
  programs.niri = {
      enable = true;
  };

  programs.bemenu = {
      enable = true;
  };
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

}
