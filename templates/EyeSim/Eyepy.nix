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
    rev = "aad5d7f44b3bd1e1c1b867e2fda0dd69fb4f63fe";
    hash = "sha256-+JYMkEVpqkgAAivIU6tg5K5q0lH5XDGYRGy2z26QS3Q=";
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
