{ inputs, flake, pkgs, perSystem, ... }:

let

  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.system};
in {
  programs.spicetify = {
    enable = true;
    enabledExtensions = with spicePkgs.extensions; [ hidePodcasts ];
    # theme = spicePkgs.themes.catppuccin;
    # colorScheme = "mocha";
  };
}
