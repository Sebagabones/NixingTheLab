{ modulesPath, lib, pkgs, nixpkgs, home-manager, ... }: {
  # Home Manager
  home-manager.useGlobalPkgs = true;

  home-manager.users.bones = { pkgs, ... }: {
    home.packages = [ pkgs.atool pkgs.httpie ];

    # The state version is required and should stay at the version you
    # originally installed.
    home.stateVersion = "24.11";
  };
}
