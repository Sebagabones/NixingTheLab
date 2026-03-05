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
    rev = "5b9cd1fce89aa211515ed350430c37eb49823c3f";
    hash = "sha256-Hl6Ftg+fn299H5MGXrql29sa7dpic5qZpfUSXwAJOU8=";
  };

  outputs = [
    "out"
  ];
  installPhase = ''
    mkdir -p $out/eyepy

    runHook preInstall
    cp -r . $out/eyepy/
    cp ${EyeSimLib}/lib/eye.py $out/eyepy/eye.py
  '';

})
