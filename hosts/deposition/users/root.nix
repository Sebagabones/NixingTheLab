{
  ...
}:

{
  home.stateVersion = "25.11";
  programs.home-manager.enable = true;

  # for remote builds
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks = {
      pandemonium = {
        hostname = "pandemonium.lab.mahoosively.gay";
        port = 7656;
      };
    };
  };

}
