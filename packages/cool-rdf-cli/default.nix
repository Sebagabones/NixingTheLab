{ pkgs, ... }:
let
  lib = pkgs.lib;
in
pkgs.stdenvNoCC.mkDerivation {
  pname = "cool-rdf-cli";
  version = "2.0.0";
  src = pkgs.fetchurl {
    url = "https://github.com/cool-rdf/cool-rdf/releases/download/v2.0.0/cool-rdf-cli-2.0.0.jar";
    hash = "sha256-SrnrTYlLlRnL++4SqJxgDVjC1FuipFj59a1ZfznhUbs=";
  };

  dontUnpack = true;
  nativeBuildInputs = [ pkgs.makeWrapper ];

  installPhase = ''
    install -Dm444 "$src" "$out/share/cool-rdf/cool-rdf-cli.jar"
    makeWrapper ${pkgs.jdk25}/bin/java "$out/bin/cool-rdf" \
      --add-flags "-jar $out/share/cool-rdf/cool-rdf-cli.jar"
  '';
}
