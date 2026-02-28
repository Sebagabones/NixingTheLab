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
    rev = "7714989f3770f4a7f833fc5857bcf7908d5577d5";
    hash = "sha256-938yEonLTxUchGAkSplgRwQjEXarSBEwSHH1mxpk3SM=";
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
