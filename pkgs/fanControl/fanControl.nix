# default.nix
{ pkgs, config, lib, ... }:
# let
#   nixpkgs = fetchTarball {
#     url = "https://github.com/NixOS/nixpkgs/tarball/nixos-24.11";
#     sha256 = "sha256:02cpqb4zdirzxfj210viim1lknpp0flvwcc1a2knmrmhl1f9dgz8";
#   };
#   system = "x86_64-linux";
#   pkgs = import nixpkgs {inherit system; config = {}; overlays = []; };
# in
let fanControl = pkgs.callPackage ./package.nix { inherit pkgs lib; };
in rec {

  environment.systemPackages = [ fanControl ];
  systemd.services."fanControl" = {
    enable = true;
    after = ["network.target"]
  };
}
