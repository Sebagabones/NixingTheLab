{
  description = "Mahoosively Gay";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    bun2nix.url = "github:baileyluTCD/bun2nix";
    bun2nix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, bun2nix }:
    let
      system = "x86_64-linux"; # no website for arm ig
      pkgs = nixpkgs.legacyPackages.${system};
      nodejs = pkgs.nodejs_24;
      bun = pkgs.bun;
      mkBunDerivation = bun2nix.lib.${system}.mkBunDerivation;
    in {
      packages.${system}.default = mkBunDerivation {
        pname = "MahoosivelyGay";
        packageJson = ./package.json;
        index = "src/pages/index.astro";
        src = ./.;
        bunNix = ./bun.nix;
        buildPhase = ''
          ${bun} run build
        '';
        installPhase = ''
          cp -r dist $out
        '';
      };
    };
}
