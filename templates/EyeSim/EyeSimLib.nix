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
  outputs = [
    "out"
    "doc"
  ];
  installPhase = ''
    mkdir -p $out/{bin,include,lib}

    runHook preInstall
    cp -a install/include/. $out/include/    #Used by gccsim and python
    cp -a install/lib/. $out/lib/

    mkdir -p "$doc/share/doc/EyeSimLib"
    cp -a eyesimX/doc/. $doc/share/doc/EyeSimLib
  '';

})
