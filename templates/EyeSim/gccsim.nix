{
  pkgs,
  lib,
  version,
  hash,
  ...
}:
let
  EyeSimLibs = pkgs.callPackage ./EyeSimLib.nix {
    inherit version hash;
  };
in
pkgs.writeShellScriptBin "gccsim" ''
  #!/usr/bin/env bash
  exec ${pkgs.gcc}/bin/gcc \
    -Wall\
    -I${EyeSimLibs}/include \
    -L${EyeSimLibs}/lib -leyesim \
    -lm \
    "$@"
''
