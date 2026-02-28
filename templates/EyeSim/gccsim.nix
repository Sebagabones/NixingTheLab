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
pkgs.writeShellScriptBin "gccsim" ''
  #!/usr/bin/env bash
  exec ${pkgs.gcc}/bin/gcc \
    -Wall\
    -I${EyeSimLib}/include \
    -L${EyeSimLib}/lib -leyesim \
    -lm \
    "$@"
''
