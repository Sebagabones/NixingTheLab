{
  pkgs,
  lib,
  version,
  hash,
  ...
}:
pkgs.stdenv.mkDerivation (finalAttrs: {
  pname = "EyeSimLib";
  version = "${version}";

  src = pkgs.fetchzip {
    url = "https://roblab.org/eyesim/ftp/EyeSim-${version}-Linux.tar.gz";
    hash = "${hash}";
  };
  # src = ./EyeSim;

  buildInputs = [
    # Some of these are almost definitely not necessary
  ];
  outputs = [
    "out"
    "doc"
  ];
  installPhase = ''
    mkdir -p $out/bin $out/include $out/lib

    runHook preInstall
    cp -a install/include/. $out/include/    #Used by gccsim and python
    cp -a install/lib/. $out/lib/

    mkdir -p "$doc/share/doc/EyeSimLib"
    cp -a eyesimX/doc/. $doc/share/doc/EyeSimLib
  '';

})
