{
  pkgs,
  version,
  hash,
  ...
}:
let
  EyeSimLib = pkgs.callPackage ./EyeSimLib.nix {
    inherit version hash;
  };

in
pkgs.stdenv.mkDerivation (finalAttrs: {
  pname = "Eyepy";
  version = "1.0";

  src = pkgs.fetchFromGitHub {
    owner = "Sebagabones";
    repo = "eyepy";
    rev = "0dc4a74ddf45aab0a2deb1baecc6efd7333522e5";
    hash = "sha256-Gmggs5N5P54+Qdm8hQVBi5enh6+6thoPfSXIwdKIGNY=";
  };

  outputs = [
    "out"
  ];
  installPhase = ''
    mkdir -p $out/eyepy

    runHook preInstall
    cp *.py $out/eyepy
    cp ${EyeSimLib}/lib/eye.py $out/eyepy/eye.py
  '';

})
